using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms.Ragdoll
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class PlayerRagdoll : MonoBehaviour
	{
		[Header("Bones")]
		public Transform lowerTorso;

		[Header("Bones")]
		public Transform upperTorso;

		[Header("Bones")]
		public Transform neck;

		[Header("Bones")]
		public Transform head;

		public Transform leftUpperArm;

		public Transform leftLowerArm;

		public Transform leftHand;

		public Transform rightUpperArm;

		public Transform rightLowerArm;

		public Transform rightHand;

		[Header("Physics tuning")]
		public float totalMass = 22f;

		public float jointSwingLimit = 48f;

		public float jointTwistLimit = 28f;

		public float headRadius = 0.16f;

		public float torsoRadius = 0.2f;

		public float neckRadius = 0.1f;

		public float limbRadius = 0.07f;

		public float handRadius = 0.07f;

		[Tooltip("Initial shove (m/s) so the corpse flings and tumbles like a real dead body.")]
		public float flingForce = 3.2f;

		[Tooltip("Initial random spin so the limbs separate and settle naturally.")]
		public float flingTorque = 7f;

		public int ragdollLayer;

		[Header("FX (created at runtime)")]
		public RagdollBleedoutRing ring;

		public RagdollBloodPool blood;

		public Transform deathCamAnchor;

		public RagdollDeathCam deathCam;

		public List<SkinnedMeshRenderer> bodyRenderers = new List<SkinnedMeshRenderer>();

		public int VictimActor = -1;

		private static readonly int ColorID = Shader.PropertyToID("_Color");

		private MonkeDevNetworkingPlayer _avatar;

		private Transform _searchRoot;

		private bool _isLocalVictim;

		private bool _built;

		private float _spawnTime;

		private float _bleedSeconds = 30f;

		private List<Transform> _bones;

		private List<Rigidbody> _bodies;

		private Transform _bodyRootBone;

		private Transform[] _bodyArmature;

		private readonly List<Renderer> _hiddenAvatarRenderers = new List<Renderer>();

		private readonly List<Behaviour> _disabledChaseTargets = new List<Behaviour>();

		private Transform SearchRoot => (_searchRoot != null) ? _searchRoot : base.transform;

		public void BuildAtRuntime(MonkeDevNetworkingPlayer avatar, Transform activeModelRoot, bool isLocalVictim, int victimActor, float bleedSeconds)
		{
			_avatar = avatar;
			_searchRoot = activeModelRoot;
			_isLocalVictim = isLocalVictim;
			VictimActor = victimActor;
			_bleedSeconds = (bleedSeconds > 0.01f) ? bleedSeconds : 30f;
			_spawnTime = Time.time;
			if (ragdollLayer <= 0)
			{
				ragdollLayer = LayerMask.NameToLayer("Ragdoll");
			}
			try
			{
				AutoAssignBones(avatar);
				Debug.Log("[PlayerRagdoll] Bones found under '" + SearchRoot.name + "': lowerTorso=" + N(lowerTorso) + " upperTorso=" + N(upperTorso) + " neck=" + N(neck) + " head=" + N(head) + " | L: " + N(leftUpperArm) + "/" + N(leftLowerArm) + "/" + N(leftHand) + " | R: " + N(rightUpperArm) + "/" + N(rightLowerArm) + "/" + N(rightHand));
				GenerateRagdoll();
				try
				{
					DisableSelfCollision();
				}
				catch (System.Exception arg)
				{
					Debug.LogError(string.Format("[PlayerRagdoll] DisableSelfCollision failed: {0}", arg));
				}
				RebindRenderersToArmature(_bodyArmature);
				BuildOrderedBones();
				CacheBodies();
				SkinnedMeshRenderer[] componentsInChildren = SearchRoot.GetComponentsInChildren<SkinnedMeshRenderer>(true);
				foreach (SkinnedMeshRenderer skinnedMeshRenderer in componentsInChildren)
				{
					skinnedMeshRenderer.updateWhenOffscreen = true;
				}
				ReapplyBodyColor(avatar);
				SetSimulated(true);
				ConfigureLayerCollisions();
				FlingForDeath();
				CreateFx(isLocalVictim);
				_built = true;
				Debug.Log(string.Format("[PlayerRagdoll] Built corpse for actor {0}: bones={1} bodies={2} local={3}.", victimActor, _bones.Count, (_bodies != null) ? _bodies.Count : 0, isLocalVictim));
			}
			catch (System.Exception arg2)
			{
				Debug.LogError(string.Format("[PlayerRagdoll] BuildAtRuntime failed: {0}", arg2));
			}
			if (_isLocalVictim)
			{
				BackroomsEvents.OnLocalDied += OnLocalDiedRelease;
			}
			try
			{
				HideAvatar(avatar);
			}
			catch (System.Exception arg3)
			{
				Debug.LogError(string.Format("[PlayerRagdoll] hide avatar failed: {0}", arg3));
			}
		}

		private void CreateFx(bool isLocal)
		{
			GameObject gameObject = new GameObject("BleedoutRing");
			gameObject.transform.SetParent(base.transform, false);
			ring = gameObject.AddComponent<RagdollBleedoutRing>();
			ring.Bind(this);
			GameObject gameObject2 = new GameObject("BloodPool");
			gameObject2.transform.SetParent(base.transform, false);
			blood = gameObject2.AddComponent<RagdollBloodPool>();
			blood.Bind(this);
			deathCam = base.gameObject.AddComponent<RagdollDeathCam>();
			deathCam.SetActiveForOwner(isLocal, this);
		}

		private void LateUpdate()
		{
			if (_built)
			{
				float num = Mathf.Max(0f, _bleedSeconds - (Time.time - _spawnTime));
				float num2 = (_bleedSeconds > 0.01f) ? (num / _bleedSeconds) : 0f;
				if (ring != null)
				{
					ring.SetFill(num2);
				}
				if (blood != null)
				{
					blood.SetGrow(1f - num2);
				}
			}
		}

		private void OnLocalDiedRelease()
		{
			if (deathCam != null)
			{
				deathCam.ReleaseForDeath();
			}
		}

		private void OnDestroy()
		{
			if (_isLocalVictim)
			{
				BackroomsEvents.OnLocalDied -= OnLocalDiedRelease;
			}
			for (int i = 0; i < _hiddenAvatarRenderers.Count; i++)
			{
				if (_hiddenAvatarRenderers[i] != null)
				{
					_hiddenAvatarRenderers[i].enabled = true;
				}
			}
			_hiddenAvatarRenderers.Clear();
			for (int j = 0; j < _disabledChaseTargets.Count; j++)
			{
				if (_disabledChaseTargets[j] != null)
				{
					_disabledChaseTargets[j].enabled = true;
				}
			}
			_disabledChaseTargets.Clear();
			try
			{
				if (_avatar != null)
				{
					_avatar.RefreshPlayerValuesLocal();
				}
			}
			catch (System.Exception arg)
			{
				Debug.LogError(string.Format("[PlayerRagdoll] avatar refresh on destroy failed: {0}", arg));
			}
			if (deathCam != null)
			{
				deathCam.Deactivate();
			}
		}

		private void ReapplyBodyColor(MonkeDevNetworkingPlayer avatar)
		{
			HashSet<string> hashSet = new HashSet<string>();
			if (avatar.playerRenderers != null)
			{
				foreach (Renderer playerRenderer in avatar.playerRenderers)
				{
					if (playerRenderer != null)
					{
						hashSet.Add(playerRenderer.name);
					}
				}
			}
			MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();
			materialPropertyBlock.SetColor(ColorID, avatar.currentPlayerColor);
			SkinnedMeshRenderer[] componentsInChildren = SearchRoot.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			foreach (SkinnedMeshRenderer skinnedMeshRenderer in componentsInChildren)
			{
				if (hashSet.Count == 0 || hashSet.Contains(skinnedMeshRenderer.name))
				{
					skinnedMeshRenderer.SetPropertyBlock(materialPropertyBlock);
				}
			}
		}

		private void HideAvatar(MonkeDevNetworkingPlayer avatar)
		{
			if (avatar == null)
			{
				return;
			}
			_hiddenAvatarRenderers.Clear();
			Renderer[] componentsInChildren = avatar.GetComponentsInChildren<Renderer>(true);
			foreach (Renderer renderer in componentsInChildren)
			{
				if (!(renderer == null) && renderer.enabled && !(renderer.GetComponent<TMPro.TextMeshPro>() != null))
				{
					renderer.enabled = false;
					_hiddenAvatarRenderers.Add(renderer);
				}
			}
			_disabledChaseTargets.Clear();
			MonoBehaviour[] componentsInChildren2 = avatar.GetComponentsInChildren<MonoBehaviour>(true);
			foreach (MonoBehaviour monoBehaviour in componentsInChildren2)
			{
				if (!(monoBehaviour == null) && monoBehaviour.GetType().Name == "ChaseTarget" && monoBehaviour.enabled)
				{
					monoBehaviour.enabled = false;
					_disabledChaseTargets.Add(monoBehaviour);
				}
			}
		}

		public List<Transform> BuildOrderedBones()
		{
			_bones = new List<Transform>(9);
			Add(lowerTorso);
			Add(upperTorso);
			Add(neck);
			Add(head);
			Add(leftUpperArm);
			Add(leftLowerArm);
			Add(leftHand);
			Add(rightUpperArm);
			Add(rightLowerArm);
			Add(rightHand);
			return _bones;
			void Add(Transform t)
			{
				if (t != null)
				{
					_bones.Add(t);
				}
			}
		}

		private void CacheBodies()
		{
			_bodies = new List<Rigidbody>(_bones.Count);
			for (int i = 0; i < _bones.Count; i++)
			{
				Rigidbody rigidbody = (_bones[i] != null) ? _bones[i].GetComponent<Rigidbody>() : null;
				if (rigidbody != null)
				{
					_bodies.Add(rigidbody);
				}
			}
		}

		private void SetSimulated(bool simulate)
		{
			for (int i = 0; i < _bodies.Count; i++)
			{
				Rigidbody rigidbody = _bodies[i];
				if (!(rigidbody == null))
				{
					rigidbody.isKinematic = !simulate;
					rigidbody.useGravity = simulate;
					rigidbody.interpolation = (simulate ? RigidbodyInterpolation.Interpolate : RigidbodyInterpolation.None);
					if (simulate)
					{
						rigidbody.WakeUp();
					}
				}
			}
		}

		private void DisableSelfCollision()
		{
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				for (int j = i + 1; j < componentsInChildren.Length; j++)
				{
					if (componentsInChildren[i] != null && componentsInChildren[j] != null)
					{
						Physics.IgnoreCollision(componentsInChildren[i], componentsInChildren[j], true);
					}
				}
			}
		}

		private void RebindRenderersToArmature(Transform[] armature)
		{
			if (armature == null || armature.Length == 0)
			{
				return;
			}
			Dictionary<string, Transform> dictionary = new Dictionary<string, Transform>();
			foreach (Transform transform in armature)
			{
				if (transform != null && !dictionary.ContainsKey(transform.name))
				{
					dictionary[transform.name] = transform;
				}
			}
			foreach (Transform transform2 in armature)
			{
				if (!(transform2 != null))
				{
					continue;
				}
				Transform[] componentsInChildren = transform2.GetComponentsInChildren<Transform>(true);
				foreach (Transform transform3 in componentsInChildren)
				{
					if (transform3 != null && !dictionary.ContainsKey(transform3.name))
					{
						dictionary[transform3.name] = transform3;
					}
				}
			}
			int num = 0;
			int num2 = 0;
			Renderer[] componentsInChildren2 = GetComponentsInChildren<Renderer>(false);
			foreach (Renderer renderer in componentsInChildren2)
			{
				if (renderer is SkinnedMeshRenderer skinnedMeshRenderer)
				{
					Transform[] bones = skinnedMeshRenderer.bones;
					int num3 = 0;
					if (bones != null && bones.Length != 0)
					{
						Transform[] array = new Transform[bones.Length];
						for (int l = 0; l < bones.Length; l++)
						{
							if (bones[l] != null && dictionary.TryGetValue(bones[l].name, out var value))
							{
								array[l] = value;
								num3++;
							}
							else
							{
								array[l] = bones[l];
							}
						}
						skinnedMeshRenderer.bones = array;
					}
					if (skinnedMeshRenderer.rootBone != null && dictionary.TryGetValue(skinnedMeshRenderer.rootBone.name, out var value2))
					{
						skinnedMeshRenderer.rootBone = value2;
					}
					if (num3 > 0)
					{
						num++;
					}
					else
					{
						if (!(head != null))
						{
							continue;
						}
						if (bones == null || bones.Length == 0 || skinnedMeshRenderer.rootBone == null)
						{
							if (skinnedMeshRenderer.transform.parent != head && skinnedMeshRenderer.transform != head)
							{
								skinnedMeshRenderer.transform.SetParent(head, true);
								num2++;
							}
							continue;
						}
						Transform transform4 = (skinnedMeshRenderer.rootBone != null) ? skinnedMeshRenderer.rootBone : bones[0];
						if (transform4 != null && transform4.parent != head && transform4 != head)
						{
							transform4.SetParent(head, true);
							num2++;
						}
					}
				}
				else
				{
					if (!(renderer is MeshRenderer))
					{
						continue;
					}
					Transform parent = renderer.transform.parent;
					if (parent != null && dictionary.TryGetValue(parent.name, out var value3) && value3 != parent)
					{
						renderer.transform.SetParent(value3, false);
						num2++;
					}
					else if (head != null && (parent == null || !dictionary.ContainsKey(parent.name)))
					{
						renderer.transform.SetParent(head, true);
						num2++;
					}
				}
			}
			Debug.Log(string.Format("[PlayerRagdoll] Head/eye follow: rebound {0} SMR(s), reparented {1} renderer(s) onto the physics armature/head.", num, num2));
		}

		private void ConfigureLayerCollisions()
		{
			if (ragdollLayer <= 0)
			{
				return;
			}
			Physics.IgnoreLayerCollision(ragdollLayer, ragdollLayer, true);
			string[] array = new string[5] { "Player", "ChaseMe", "Hand", "Finger", "RivalsHitbox" };
			foreach (string layerName in array)
			{
				int num = LayerMask.NameToLayer(layerName);
				if (num >= 0)
				{
					Physics.IgnoreLayerCollision(ragdollLayer, num, true);
				}
			}
		}

		private void FlingForDeath()
		{
			if (_bodies == null)
			{
				return;
			}
			Vector3 vector = (Vector3.up * 0.6f + Random.insideUnitSphere * 0.6f).normalized * flingForce;
			for (int i = 0; i < _bodies.Count; i++)
			{
				Rigidbody rigidbody = _bodies[i];
				if (!(rigidbody == null) && !rigidbody.isKinematic)
				{
					rigidbody.AddForce(vector, ForceMode.VelocityChange);
					rigidbody.AddTorque(Random.insideUnitSphere * flingTorque, ForceMode.VelocityChange);
					rigidbody.WakeUp();
				}
			}
		}

		public void AutoAssignBones(MonkeDevNetworkingPlayer avatar = null)
		{
			SkinnedMeshRenderer[] componentsInChildren = SearchRoot.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			HashSet<string> hashSet = new HashSet<string>();
			if (avatar != null && avatar.playerRenderers != null)
			{
				foreach (Renderer playerRenderer in avatar.playerRenderers)
				{
					if (playerRenderer != null)
					{
						hashSet.Add(playerRenderer.name);
					}
				}
			}
			SkinnedMeshRenderer skinnedMeshRenderer = null;
			foreach (SkinnedMeshRenderer skinnedMeshRenderer2 in componentsInChildren)
			{
				if (skinnedMeshRenderer2 != null && skinnedMeshRenderer2.bones != null && skinnedMeshRenderer2.bones.Length != 0 && hashSet.Contains(skinnedMeshRenderer2.name))
				{
					skinnedMeshRenderer = skinnedMeshRenderer2;
					break;
				}
			}
			if (skinnedMeshRenderer == null)
			{
				int num = 0;
				foreach (SkinnedMeshRenderer skinnedMeshRenderer3 in componentsInChildren)
				{
					if (skinnedMeshRenderer3 != null && skinnedMeshRenderer3.bones != null && skinnedMeshRenderer3.bones.Length > num)
					{
						num = skinnedMeshRenderer3.bones.Length;
						skinnedMeshRenderer = skinnedMeshRenderer3;
					}
				}
			}
			Transform[] array = (skinnedMeshRenderer != null) ? skinnedMeshRenderer.bones : null;
			_bodyRootBone = (skinnedMeshRenderer != null) ? skinnedMeshRenderer.rootBone : null;
			_bodyArmature = array;
			Debug.Log(string.Format("[PlayerRagdoll] Body SMR = {0} ({1} skin bones), rootBone={2}", (skinnedMeshRenderer != null) ? skinnedMeshRenderer.name : "NULL", (array != null) ? array.Length : 0, N(_bodyRootBone)));
			lowerTorso = PickBone(array, "LowerHalfTorso", "lowertorso", "hips", "pelvis", "spine", "Twist");
			upperTorso = PickBone(array, "UpperHalfTorso", "uppertorso", "chest", "spine1");
			neck = PickBone(array, "Neck", "neck", "neck.01", "spine2");
			head = PickBone(array, "head", "Head");
			leftUpperArm = PickBone(array, "upperarm.L", "upperarm_L", "UpperArm.L", "Left Upper Arm", "left_arm_upper", "shoulder.L", "Shoulder.L");
			leftLowerArm = PickBone(array, "lowerarm.L", "lowerarm_L", "LowerArm.L", "left_arm_lower", "forearm.L");
			leftHand = PickBone(array, "hand.L", "Hand.L", "wrist_left", "hand_L");
			rightUpperArm = PickBone(array, "upperarm.R", "upperarm_R", "UpperArm.R", "Right Upper Arm", "right_arm_upper", "shoulder.R", "Shoulder.R");
			rightLowerArm = PickBone(array, "lowerarm.R", "lowerarm_R", "LowerArm.R", "right_arm_lower", "forearm.R");
			rightHand = PickBone(array, "hand.R", "Hand.R", "wrist_right", "hand_R");
			bodyRenderers.Clear();
			SkinnedMeshRenderer[] componentsInChildren2 = SearchRoot.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			foreach (SkinnedMeshRenderer item in componentsInChildren2)
			{
				bodyRenderers.Add(item);
			}
		}

		private Transform PickBone(Transform[] skinBones, params string[] aliases)
		{
			if (skinBones != null)
			{
				foreach (string alias in aliases)
				{
					string a = alias.ToLowerInvariant();
					foreach (Transform b in skinBones)
					{
						if (b != null && b.name.ToLowerInvariant() == a)
						{
							return b;
						}
					}
				}
				foreach (string alias2 in aliases)
				{
					string a2 = alias2.ToLowerInvariant();
					foreach (Transform b2 in skinBones)
					{
						if (b2 != null && b2.name.ToLowerInvariant().Contains(a2) && !b2.name.ToLowerInvariant().Contains("_end"))
						{
							return b2;
						}
					}
				}
			}
			return FindBoneIn(SearchRoot, aliases) ?? ((SearchRoot != transform) ? FindBoneIn(transform, aliases) : null);
		}

		private static Transform FindBoneIn(Transform root, string[] aliases)
		{
			if (root == null)
			{
				return null;
			}
			foreach (string name in aliases)
			{
				Transform found = FindDeepByName(root, name);
				if (found != null)
				{
					return found;
				}
			}
			Transform[] all = root.GetComponentsInChildren<Transform>(true);
			foreach (string alias in aliases)
			{
				string a = alias.ToLowerInvariant();
				foreach (Transform t in all)
				{
					if (t != root && t.name.ToLowerInvariant() == a)
					{
						return t;
					}
				}
				foreach (Transform t2 in all)
				{
					if (t2 != root && t2.name.ToLowerInvariant().Contains(a) && !t2.name.ToLowerInvariant().Contains("_end"))
					{
						return t2;
					}
				}
			}
			return null;
		}

		public void GenerateRagdoll()
		{
			ClearRagdoll();
			if (lowerTorso == null)
			{
				lowerTorso = _bodyRootBone;
			}
			if (upperTorso == null)
			{
				upperTorso = (_bodyRootBone != null && _bodyRootBone != lowerTorso) ? _bodyRootBone : upperTorso;
			}
			BuildOrderedBones();
			if (lowerTorso == null)
			{
				Debug.LogError("[PlayerRagdoll] Generate: no torso/root bone found — corpse will be static. Check the bone log above.");
				return;
			}
			float units = lowerTorso ? 2.6f : 0f;
			if ((bool)upperTorso)
			{
				units += 2.4f;
			}
			if ((bool)head)
			{
				units += 1.3f;
			}
			if ((bool)leftUpperArm)
			{
				units += 1f;
			}
			if ((bool)rightUpperArm)
			{
				units += 1f;
			}
			if ((bool)leftLowerArm)
			{
				units += 0.7f;
			}
			if ((bool)rightLowerArm)
			{
				units += 0.7f;
			}
			if ((bool)leftHand)
			{
				units += 0.3f;
			}
			if ((bool)rightHand)
			{
				units += 0.3f;
			}
			float unit = totalMass / ((units > 0f) ? units : 1f);
			Rigidbody pelvis = BuildBody(lowerTorso, upperTorso, torsoRadius, unit * 2.6f, false, null, 0.1f);
			BuildBody(upperTorso, (neck != null) ? neck : head, torsoRadius, unit * 2.4f, false, pelvis, 0.1f);
			Rigidbody chest = pelvis;
			if (upperTorso != null)
			{
				chest = upperTorso.GetComponent<Rigidbody>();
			}
			Transform armParent = (upperTorso != null) ? upperTorso : lowerTorso;
			if (neck != null)
			{
				Rigidbody neckBody = BuildBody(neck, head, neckRadius, unit * 0.65f, false, chest, neckRadius * 1.6f);
				TightenJoint(neck, 22f, 15f);
				if (neckBody != null)
				{
					chest = neckBody;
				}
			}
			BuildBody(head, null, headRadius, unit * 1.3f, true, chest, headRadius * 1.6f);
			TightenJoint(head, 15f, 12f);
			BuildLimb(leftUpperArm, leftLowerArm, unit, limbRadius, armParent);
			BuildLimb(leftLowerArm, leftHand, unit * 0.7f, limbRadius, leftUpperArm);
			BuildLimb(leftHand, null, unit * 0.3f, handRadius, leftLowerArm, true);
			BuildLimb(rightUpperArm, rightLowerArm, unit, limbRadius, armParent);
			BuildLimb(rightLowerArm, rightHand, unit * 0.7f, limbRadius, rightUpperArm);
			BuildLimb(rightHand, null, unit * 0.3f, handRadius, rightLowerArm, true);
			if (ragdollLayer <= 0)
			{
				return;
			}
			foreach (Transform bone in _bones)
			{
				if (bone != null)
				{
					bone.gameObject.layer = ragdollLayer;
				}
			}
		}

		private void TightenJoint(Transform bone, float swing, float twist)
		{
			if (bone == null)
			{
				return;
			}
			CharacterJoint joint = bone.GetComponent<CharacterJoint>();
			if (!(joint == null))
			{
				SoftJointLimit lowTwistLimit = joint.lowTwistLimit;
				lowTwistLimit.limit = 0f - twist;
				joint.lowTwistLimit = lowTwistLimit;
				SoftJointLimit highTwistLimit = joint.highTwistLimit;
				highTwistLimit.limit = twist;
				joint.highTwistLimit = highTwistLimit;
				SoftJointLimit swing1Limit = joint.swing1Limit;
				swing1Limit.limit = swing;
				joint.swing1Limit = swing1Limit;
				SoftJointLimit swing2Limit = joint.swing2Limit;
				swing2Limit.limit = swing;
				joint.swing2Limit = swing2Limit;
			}
		}

		private Rigidbody BuildLimb(Transform bone, Transform child, float mass, float radius, Transform connectBone, bool leaf = false)
		{
			if (bone == null)
			{
				return null;
			}
			Rigidbody connectTo = (connectBone != null) ? connectBone.GetComponent<Rigidbody>() : null;
			return BuildBody(bone, child, radius, mass, leaf, connectTo, radius * 2f);
		}

		private Rigidbody BuildBody(Transform bone, Transform child, float radius, float mass, bool leaf, Rigidbody connectTo = null, float leafLen = 0.1f)
		{
			if (bone == null)
			{
				return null;
			}
			Rigidbody rb = bone.GetComponent<Rigidbody>();
			if (rb == null)
			{
				rb = bone.gameObject.AddComponent<Rigidbody>();
			}
			rb.mass = Mathf.Max(mass, 0.05f);
			rb.interpolation = RigidbodyInterpolation.Interpolate;
			rb.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative;
			Collider existing = bone.GetComponent<Collider>();
			if (existing != null)
			{
				DestroySafe(existing);
			}
			if (leaf || child == null)
			{
				bone.gameObject.AddComponent<SphereCollider>().radius = radius;
			}
			else
			{
				float len = Vector3.Distance(bone.position, child.position);
				if (len < 0.02f)
				{
					len = leafLen;
				}
				CapsuleCollider capsule = bone.gameObject.AddComponent<CapsuleCollider>();
				capsule.radius = radius;
				capsule.height = radius * 2f + len;
				Vector3 dir = bone.InverseTransformPoint(child.position).normalized;
				float ax = Mathf.Abs(dir.x);
				float ay = Mathf.Abs(dir.y);
				float az = Mathf.Abs(dir.z);
				capsule.direction = (az > Mathf.Max(ax, ay)) ? 2 : ((ay > ax) ? 1 : 0);
				capsule.center = dir * (len * 0.5f);
			}
			if (connectTo != null)
			{
				CharacterJoint joint = bone.gameObject.AddComponent<CharacterJoint>();
				joint.connectedBody = connectTo;
				joint.enableProjection = true;
				SoftJointLimit lowTwistLimit = joint.lowTwistLimit;
				lowTwistLimit.limit = 0f - jointTwistLimit;
				joint.lowTwistLimit = lowTwistLimit;
				SoftJointLimit highTwistLimit = joint.highTwistLimit;
				highTwistLimit.limit = jointTwistLimit;
				joint.highTwistLimit = highTwistLimit;
				SoftJointLimit swing1Limit = joint.swing1Limit;
				swing1Limit.limit = jointSwingLimit;
				joint.swing1Limit = swing1Limit;
				SoftJointLimit swing2Limit = joint.swing2Limit;
				swing2Limit.limit = jointSwingLimit;
				joint.swing2Limit = swing2Limit;
			}
			return rb;
		}

		public void ClearRagdoll()
		{
			BuildOrderedBones();
			foreach (Transform bone in _bones)
			{
				if (bone == null)
				{
					continue;
				}
				CharacterJoint joint = bone.GetComponent<CharacterJoint>();
				if (joint != null)
				{
					DestroySafe(joint);
				}
				Collider collider = bone.GetComponent<Collider>();
				if (collider != null)
				{
					DestroySafe(collider);
				}
				Rigidbody rb = bone.GetComponent<Rigidbody>();
				if (rb != null)
				{
					DestroySafe(rb);
				}
			}
		}

		private static string N(Transform t)
		{
			if (!(t != null))
			{
				return "NULL";
			}
			return t.name;
		}

		public static Transform FindDeepByName(Transform root, string name)
		{
			if (root == null)
			{
				return null;
			}
			if (root.name == name)
			{
				return root;
			}
			for (int i = 0; i < root.childCount; i++)
			{
				Transform found = FindDeepByName(root.GetChild(i), name);
				if (found != null)
				{
					return found;
				}
			}
			return null;
		}

		private static void DestroySafe(Object o)
		{
			Object.Destroy(o);
		}
	}
}
