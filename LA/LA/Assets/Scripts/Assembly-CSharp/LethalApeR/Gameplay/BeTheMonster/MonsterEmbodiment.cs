using System.Reflection;
using GorillaLocomotion;
using RootMotion.FinalIK;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class MonsterEmbodiment
	{
		private Player _player;

		private MonsterDefinition _def;

		private GameObject _body;

		private GameObject _hiddenApe;

		private VRIK _vrik;

		private Transform _pelvisTarget;

		private bool _calibrated;

		private Transform _rig;

		private readonly Transform[] _thigh = new Transform[2];

		private readonly Transform[] _calf = new Transform[2];

		private readonly Transform[] _foot = new Transform[2];

		private readonly Vector3[] _homeLocal = new Vector3[2];

		private readonly Vector3[] _planted = new Vector3[2];

		private readonly Vector3[] _stepStart = new Vector3[2];

		private readonly bool[] _stepping = new bool[2];

		private readonly float[] _stepT = new float[2];

		private bool _legsReady;

		private static FieldInfo _fiBodyHeight;

		private static bool _fiResolved;

		private float _origBodyHeight;

		private float _colliderStand;

		private float _colliderCrouch;

		private bool _colliderHooked;

		public GameObject Body => _body;

		public VRIK Vrik => _vrik;

		public bool IsEmbodied => _body != null;

		public bool NeedsCalibration => _body != null && _vrik != null && !_calibrated;

		public void Equip(MonsterDefinition def, Player player)
		{
			if (player == null)
			{
				return;
			}
			Unequip();
			_player = player;
			_def = def;
			_calibrated = false;
			HideApe(player, true);
			if (def == null || def.bodyPrefab == null)
			{
				Debug.LogWarning("[BTM] No bodyPrefab on this MonsterDefinition — run Tools ▸ Be The Monster ▸ Build Gus Body Prefab.");
				return;
			}
			Transform anchor = (player.turnParent != null) ? player.turnParent.transform : player.transform;
			_body = Object.Instantiate(def.bodyPrefab);
			_body.transform.SetParent(anchor, false);
			_body.transform.localPosition = Vector3.zero;
			_body.transform.localRotation = Quaternion.identity;
			_vrik = _body.GetComponentInChildren<VRIK>(true);
			if (_vrik == null)
			{
				Debug.LogWarning("[BTM] Body prefab has no VRIK — re-bake with Build Gus Body Prefab.");
				return;
			}
			Animator[] animators = _body.GetComponentsInChildren<Animator>(true);
			foreach (Animator animator in animators)
			{
				animator.runtimeAnimatorController = null;
				animator.enabled = false;
			}
			IKSolverVR solver = _vrik.solver;
			solver.spine.headClampWeight = 0.6f;
			solver.spine.maintainPelvisPosition = 0f;
			solver.spine.maxRootAngle = 25f;
			solver.spine.positionWeight = 1f;
			solver.spine.rotationWeight = 1f;
			solver.spine.bodyPosStiffness = 1f;
			solver.spine.bodyRotStiffness = 0.1f;
			solver.spine.neckStiffness = 0.2f;
			solver.spine.rotateChestByHands = 0.5f;
			solver.locomotion.weight = 0f;
			solver.plantFeet = false;
			_pelvisTarget = new GameObject("BTM_PelvisTarget").transform;
			_pelvisTarget.SetParent(anchor, false);
			solver.spine.pelvisTarget = _pelvisTarget;
			solver.spine.pelvisPositionWeight = 0f;
			solver.spine.pelvisRotationWeight = 0f;
			HookCollider(player);
		}

		public bool TryCalibrate()
		{
			if (_vrik == null)
			{
				return _calibrated;
			}
			if (_calibrated)
			{
				return true;
			}
			if (!_vrik.solver.initiated || _player == null)
			{
				return false;
			}
			Transform eye = (_player.headCollider != null) ? _player.headCollider.transform : _player.transform;
			Transform leftHand = _player.leftHandTransform;
			Transform rightHand = _player.rightHandTransform;
			if (eye == null || leftHand == null || rightHand == null)
			{
				return false;
			}
			ScaleToEyeHeight(eye);
			Vector3 headPositionOffset = (_def != null) ? _def.headPositionOffset : Vector3.zero;
			Vector3 headRotationOffset = (_def != null) ? _def.headRotationOffset : Vector3.zero;
			VRIKCalibrator.CalibrateHead(_vrik, eye, Vector3.zero, headRotationOffset);
			VRIKCalibrator.CalibrateHands(_vrik, leftHand, rightHand, Vector3.zero, Vector3.zero);
			if (_vrik.solver.spine.headTarget != null)
			{
				_vrik.solver.spine.headTarget.localPosition = headPositionOffset;
			}
			SetupLegs();
			_vrik.solver.OnPostUpdate -= OnVrikPostSolve;
			_vrik.solver.OnPostUpdate += OnVrikPostSolve;
			Vector3 localScale = _body.transform.localScale;
			if (localScale.x < 0.001f || float.IsNaN(localScale.x))
			{
				_body.transform.localScale = Vector3.one * 0.3f;
			}
			_calibrated = true;
			return true;
		}

		private void OnVrikPostSolve()
		{
			SnapHeadToCamera();
			StepAndSolveLegs();
		}

		private void SnapHeadToCamera()
		{
			if (_vrik == null)
			{
				return;
			}
			Transform headTarget = _vrik.solver.spine.headTarget;
			Transform head = _vrik.references.head;
			if (headTarget == null || head == null)
			{
				return;
			}
			head.position = headTarget.position;
			head.rotation = headTarget.rotation;
		}

		private void SetupLegs()
		{
			_rig = (_body != null) ? _body.transform.parent : null;
			VRIK.References references = _vrik.references;
			_thigh[0] = references.leftThigh;
			_calf[0] = references.leftCalf;
			_foot[0] = references.leftFoot;
			_thigh[1] = references.rightThigh;
			_calf[1] = references.rightCalf;
			_foot[1] = references.rightFoot;
			_legsReady = _rig != null;
			for (int i = 0; i < 2; i++)
			{
				if (_thigh[i] == null || _calf[i] == null || _foot[i] == null)
				{
					_legsReady = false;
					continue;
				}
				_planted[i] = RaycastFoot(_foot[i].position);
				_homeLocal[i] = _rig.InverseTransformPoint(_planted[i]);
				_stepping[i] = false;
				_stepT[i] = 0f;
			}
			if (!_legsReady)
			{
				Debug.LogWarning("[BTM] Leg bones missing (leftThigh/Calf/Foot) — procedural legs off.");
			}
		}

		private Vector3 RaycastFoot(Vector3 footPos)
		{
			int layerMask = (_player != null) ? _player.locomotionEnabledLayers.value : (-1);
			if (Physics.Raycast(footPos + Vector3.up * 0.8f, Vector3.down, out var hitInfo, 2.5f, layerMask, QueryTriggerInteraction.Ignore))
			{
				return hitInfo.point;
			}
			return footPos;
		}

		private void StepAndSolveLegs()
		{
			if (!_legsReady || _rig == null)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			Vector3 forward = _rig.forward;
			float scale = (_body != null) ? _body.transform.localScale.x : 1f;
			float stepTrigger = ((_def != null) ? _def.stepTriggerDistance : 0.35f) * scale;
			float stepDuration = (_def != null) ? Mathf.Max(_def.stepDuration, 0.05f) : 0.18f;
			float stepHeight = ((_def != null) ? _def.stepHeight : 0.18f) * scale;
			float stepRate = Mathf.Max(deltaTime, 0.0001f) / stepDuration;
			for (int i = 0; i < 2; i++)
			{
				Vector3 home = RaycastFoot(_rig.TransformPoint(_homeLocal[i]));
				if (!_stepping[i] && !_stepping[i ^ 1] && Vector3.Distance(_planted[i], home) > stepTrigger)
				{
					_stepping[i] = true;
					_stepStart[i] = _planted[i];
					_stepT[i] = 0f;
				}
				if (_stepping[i])
				{
					_stepT[i] += stepRate;
					float t = Mathf.Clamp01(_stepT[i]);
					Vector3 position = Vector3.Lerp(_stepStart[i], home, t);
					position.y += stepHeight * Mathf.Sin(t * Mathf.PI);
					_planted[i] = position;
					if (t >= 1f)
					{
						_stepping[i] = false;
						_planted[i] = home;
					}
				}
				SolveLeg(_thigh[i], _calf[i], _foot[i], _planted[i], forward);
			}
		}

		private static void SolveLeg(Transform thigh, Transform calf, Transform foot, Vector3 target, Vector3 pole)
		{
			if (thigh == null || calf == null || foot == null)
			{
				return;
			}
			Vector3 position = thigh.position;
			float upperLength = Vector3.Distance(thigh.position, calf.position);
			float lowerLength = Vector3.Distance(calf.position, foot.position);
			Vector3 toTarget = target - position;
			float distance = Mathf.Clamp(toTarget.magnitude, 0.01f, (upperLength + lowerLength) * 0.999f);
			Vector3 direction = (toTarget.sqrMagnitude > 1E-08f) ? toTarget.normalized : Vector3.down;
			float along = (upperLength * upperLength - lowerLength * lowerLength + distance * distance) / (2f * distance);
			float height = Mathf.Sqrt(Mathf.Max(0f, upperLength * upperLength - along * along));
			Vector3 bend = pole - direction * Vector3.Dot(pole, direction);
			if (bend.sqrMagnitude < 1E-06f)
			{
				bend = Vector3.Cross(direction, Vector3.right);
				if (bend.sqrMagnitude < 1E-06f)
				{
					bend = Vector3.Cross(direction, Vector3.forward);
				}
			}
			bend = bend.normalized;
			Vector3 knee = position + direction * along + bend * height;
			AlignBone(thigh, calf, knee);
			AlignBone(calf, foot, target);
		}

		private static void AlignBone(Transform bone, Transform child, Vector3 childTarget)
		{
			Vector3 current = child.position - bone.position;
			Vector3 desired = childTarget - bone.position;
			if (current.sqrMagnitude < 1E-08f || desired.sqrMagnitude < 1E-08f)
			{
				return;
			}
			bone.rotation = Quaternion.FromToRotation(current, desired) * bone.rotation;
		}

		private void ScaleToEyeHeight(Transform eye)
		{
			if (_body == null || _vrik == null || eye == null)
			{
				return;
			}
			Transform parent = _body.transform.parent;
			Transform reference = (parent != null) ? parent : _body.transform;
			float eyeHeight = eye.position.y - reference.position.y;
			if (eyeHeight < 0.5f)
			{
				eyeHeight = (_def != null) ? _def.bodyHeightMeters : 1.6f;
			}
			Transform head = _vrik.references.head;
			Transform foot = (_vrik.references.leftFoot != null) ? _vrik.references.leftFoot : _vrik.references.rightFoot;
			if (head == null || foot == null)
			{
				Debug.LogWarning("[BTM] ScaleToEyeHeight: head/foot ref null — no scale.");
				return;
			}
			float span = head.position.y - foot.position.y;
			float factor = (span > 0.01f) ? (eyeHeight / span) : 0f;
			Debug.Log(string.Format("[BTM] ScaleToEyeHeight: eyeHeight={0:F3}  headBoneY={1:F3}  footBoneY={2:F3}  span={3:F3}  factor={4:F3}  prevScale={5:F4}", eyeHeight, head.position.y, foot.position.y, span, factor, _body.transform.localScale.x));
			if (span > 0.01f)
			{
				_body.transform.localScale = _body.transform.localScale * factor;
			}
		}

		private void SetupGrounder(Player player)
		{
			GrounderVRIK grounder = _body.GetComponent<GrounderVRIK>();
			if (grounder == null)
			{
				grounder = _body.AddComponent<GrounderVRIK>();
			}
			grounder.ik = _vrik;
			grounder.weight = 1f;
			grounder.solver.layers = player.locomotionEnabledLayers;
			grounder.solver.liftPelvisWeight = 0f;
			grounder.solver.maxStep = 0.6f;
			grounder.solver.footRadius = 0.15f;
			grounder.solver.quality = Grounding.Quality.Best;
			grounder.solver.pelvisDamper = 0f;
			grounder.solver.lowerPelvisWeight = 0f;
		}

		private void HookCollider(Player player)
		{
			if (!_fiResolved)
			{
				_fiBodyHeight = typeof(Player).GetField("bodyInitialHeight", BindingFlags.Instance | BindingFlags.NonPublic);
				_fiResolved = true;
				if (_fiBodyHeight == null)
				{
					Debug.LogWarning("[BTM] Player.bodyInitialHeight not found — the monster body collider won't resize.");
				}
			}
			if (_fiBodyHeight == null)
			{
				return;
			}
			_origBodyHeight = ToFloat(_fiBodyHeight.GetValue(player));
			_colliderStand = (_def != null) ? _def.colliderStandHeight : 1.6f;
			_colliderCrouch = (_def != null) ? _def.colliderCrouchHeight : 0.8f;
			_fiBodyHeight.SetValue(player, _colliderStand);
			_colliderHooked = true;
		}

		public void UpdateBody(float crouch)
		{
			float t = Mathf.Clamp01(crouch);
			if (_colliderHooked && _fiBodyHeight != null && _player != null)
			{
				_fiBodyHeight.SetValue(_player, Mathf.Lerp(_colliderStand, _colliderCrouch, t));
			}
			if (_vrik == null || _pelvisTarget == null || _player == null)
			{
				return;
			}
			if (_vrik.solver.spine.headTarget != null)
			{
				_vrik.solver.spine.headTarget.localPosition = (_def != null) ? _def.headPositionOffset : Vector3.zero;
			}
			if (t > 0.001f)
			{
				Transform head = (_player.headCollider != null) ? _player.headCollider.transform : _player.transform;
				if (head == null)
				{
					return;
				}
				Vector3 back = -head.forward;
				back.y = 0f;
				back = (back.sqrMagnitude < 0.0001f) ? Vector3.back : back.normalized;
				_pelvisTarget.position = head.position + back * (t * 0.7f) + Vector3.down * (t * 0.5f + 0.5f);
				_vrik.solver.spine.pelvisPositionWeight = t * 0.85f;
			}
			else
			{
				_vrik.solver.spine.pelvisPositionWeight = 0f;
			}
		}

		private void UnhookCollider()
		{
			if (_colliderHooked && _player != null && _fiBodyHeight != null)
			{
				_fiBodyHeight.SetValue(_player, _origBodyHeight);
			}
			_colliderHooked = false;
		}

		private static float ToFloat(object o)
		{
			if (o is float result)
			{
				return result;
			}
			return 0f;
		}

		public void Unequip()
		{
			if (_vrik != null)
			{
				_vrik.solver.OnPostUpdate -= OnVrikPostSolve;
			}
			if (_body != null)
			{
				Object.Destroy(_body);
				_body = null;
				_vrik = null;
			}
			_calibrated = false;
			UnhookCollider();
			if (_pelvisTarget != null)
			{
				Object.Destroy(_pelvisTarget.gameObject);
				_pelvisTarget = null;
			}
			if (_player != null)
			{
				HideApe(_player, false);
			}
			_player = null;
			_def = null;
		}

		private void HideApe(Player player, bool hide)
		{
			if (hide && _hiddenApe == null)
			{
				Transform head = (player.headCollider != null) ? player.headCollider.transform : null;
				Transform ape = (head != null) ? head.Find("Player/LAR_Ape") : null;
				if (ape == null)
				{
					ape = FindDeep(player.transform, "LAR_Ape");
				}
				_hiddenApe = (ape != null) ? ape.gameObject : null;
			}
			if (_hiddenApe != null)
			{
				_hiddenApe.SetActive(!hide);
			}
			if (!hide)
			{
				_hiddenApe = null;
			}
		}

		private static Transform FindDeep(Transform root, string targetName)
		{
			if (root.name == targetName)
			{
				return root;
			}
			for (int i = 0; i < root.childCount; i++)
			{
				Transform found = FindDeep(root.GetChild(i), targetName);
				if (found != null)
				{
					return found;
				}
			}
			return null;
		}
	}
}
