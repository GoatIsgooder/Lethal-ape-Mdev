using System.Collections.Generic;
using Locomotion.Scripts;
using UnityEngine;

[DisallowMultipleComponent]
public class RagdollManager : MonoBehaviour, INoReparentOnGrab
{
	[Header("Grab release")]
	[Tooltip("Seconds to fade a limb's pose-tracking OUT when one of its bones is grabbed. Keep short — just enough to avoid a force discontinuity.")]
	public float releaseBlendSeconds = 0.08f;

	[Tooltip("Seconds to fade tracking back IN after the last hand lets go. Longer = softer recovery, no snap-back.")]
	public float recoverSeconds = 0.6f;

	[Tooltip("Grabbing a core bone (the jointless root, i.e. the torso) releases every bone so the whole body goes limp in your hand.")]
	public bool coreGrabReleasesWholeBody = true;

	[Tooltip("Bones to treat as 'core' in addition to the joint root. Limb release chains stop when they reach a core bone (useful for rigs with hips→spine→chest chains).")]
	public Transform[] extraCoreBones;

	[Header("Drag-along")]
	[Tooltip("Pulling the core body further than the deadzone from its target pose drags the whole NPC along (horizontally). Off = the NPC is anchored to its spot.")]
	public bool dragAlong = true;

	[Tooltip("Horizontal slack (metres) before the NPC starts being dragged.")]
	public float dragDeadzone = 0.35f;

	[Tooltip("Layers treated as ground when re-resolving the NPC's height during a drag (carrying it up a ledge / off a drop).")]
	public LayerMask dragGroundMask = 1;

	[Tooltip("How fast (m/s) the pose skeleton's height slews to new terrain during a drag. Slewing instead of snapping keeps ledge crossings from lurching the whole body.")]
	public float dragHeightSpeed = 3f;

	[Header("Physics setup (applied at Awake and by the editor button)")]
	[Tooltip("Speculative CCD on the bones so fast swings don't tunnel through geometry. Cheap enough on Quest for a handful of ragdolls.")]
	public bool useSpeculativeCCD = true;

	[Tooltip("Joint projection snaps over-stretched joints back into place — keeps hard-yanked limbs from going spaghetti at mobile physics rates.")]
	public bool enableJointProjection = true;

	private RagdollSystem[] _drives;

	private Rigidbody[] _rbs;

	private int[] _parent;

	private int[] _chainTop;

	private bool[] _isCore;

	private int[][] _releaseGroup;

	private int[] _holdCount;

	private float[] _weight;

	private int _coreIndex = -1;

	private int _heldBones;

	private float _rootAboveGround;

	private bool _groundOffsetValid;

	private Vector3[] _bonePosScratch;

	private Quaternion[] _boneRotScratch;

	private readonly Dictionary<RagdollSystem, int> _indexOf = new Dictionary<RagdollSystem, int>();

	public bool IsAnyBoneHeld => _heldBones > 0;

	private void Awake()
	{
		ApplyPhysicsSetup(true);
		BuildGraph();
		TryCaptureGroundOffset();
	}

	private void TryCaptureGroundOffset()
	{
		if (_groundOffsetValid)
		{
			return;
		}
		if (Physics.Raycast(transform.position + Vector3.up * 0.25f, Vector3.down, out RaycastHit hit, 4f, dragGroundMask, QueryTriggerInteraction.Ignore))
		{
			_rootAboveGround = transform.position.y - hit.point.y;
			_groundOffsetValid = true;
		}
	}

	internal void NotifyBoneGrabbed(RagdollBoneGrabbable bone)
	{
		if (bone == null || bone.drive == null)
		{
			return;
		}
		if (!_indexOf.TryGetValue(bone.drive, out int index))
		{
			return;
		}
		int[] group = _releaseGroup[index];
		foreach (int i in group)
		{
			_holdCount[i]++;
		}
		_heldBones++;
	}

	internal void NotifyBoneDropped(RagdollBoneGrabbable bone)
	{
		if (bone is null || bone.drive is null)
		{
			return;
		}
		if (!_indexOf.TryGetValue(bone.drive, out int index))
		{
			return;
		}
		int[] group = _releaseGroup[index];
		foreach (int i in group)
		{
			_holdCount[i] = Mathf.Max(0, _holdCount[i] - 1);
		}
		_heldBones = Mathf.Max(0, _heldBones - 1);
	}

	private void FixedUpdate()
	{
		if (_drives == null)
		{
			return;
		}
		float dt = Time.fixedDeltaTime;
		for (int i = 0; i < _drives.Length; i++)
		{
			RagdollSystem drive = _drives[i];
			if (drive == null)
			{
				continue;
			}
			float target = (_holdCount[i] > 0) ? 0f : 1f;
			float seconds = (target < _weight[i]) ? releaseBlendSeconds : recoverSeconds;
			float weight = target;
			if (seconds > 0f)
			{
				weight = Mathf.MoveTowards(_weight[i], target, dt / seconds);
			}
			_weight[i] = weight;
			drive.DriveWeight = weight;
		}
		UpdateDragAlong();
	}

	private void UpdateDragAlong()
	{
		if (!dragAlong || _coreIndex < 0)
		{
			return;
		}
		RagdollSystem drive = _drives[_coreIndex];
		Rigidbody rb = _rbs[_coreIndex];
		if (drive == null || rb == null || drive.target == null)
		{
			return;
		}
		Vector3 offset = rb.position - drive.target.position;
		offset.y = 0f;
		float distance = offset.magnitude;
		if (distance <= dragDeadzone)
		{
			return;
		}
		Vector3 newRoot = transform.position + offset * ((distance - dragDeadzone) / distance);
		TryCaptureGroundOffset();
		if (_groundOffsetValid && Physics.Raycast(rb.position + Vector3.up * 0.25f, Vector3.down, out RaycastHit hit, 4f, dragGroundMask, QueryTriggerInteraction.Ignore))
		{
			newRoot.y = Mathf.MoveTowards(newRoot.y, hit.point.y + _rootAboveGround, dragHeightSpeed * Time.fixedDeltaTime);
		}
		for (int i = 0; i < _rbs.Length; i++)
		{
			Transform bone = (_rbs[i] != null) ? _rbs[i].transform : null;
			if (bone == null)
			{
				_bonePosScratch[i] = Vector3.zero;
			}
			else
			{
				bone.GetPositionAndRotation(out _bonePosScratch[i], out _boneRotScratch[i]);
			}
		}
		transform.position = newRoot;
		for (int j = 0; j < _rbs.Length; j++)
		{
			Transform bone2 = (_rbs[j] != null) ? _rbs[j].transform : null;
			if (!(bone2 == null))
			{
				bone2.SetPositionAndRotation(_bonePosScratch[j], _boneRotScratch[j]);
			}
		}
	}

	private void OnDisable()
	{
		ForceReleaseHeldBones();
	}

	private void OnDestroy()
	{
		ForceReleaseHeldBones();
	}

	private void ForceReleaseHeldBones()
	{
		if (_rbs == null || _heldBones == 0)
		{
			return;
		}
		for (int i = 0; i < _rbs.Length; i++)
		{
			Rigidbody rb = _rbs[i];
			if (rb is not null)
			{
				GrabInteractor.ForceReleaseHoldersOf(rb);
			}
		}
	}

	private void BuildGraph()
	{
		_drives = GetComponentsInChildren<RagdollSystem>(true);
		int n = _drives.Length;
		_rbs = new Rigidbody[n];
		_isCore = new bool[n];
		_chainTop = new int[n];
		_holdCount = new int[n];
		_weight = new float[n];
		_releaseGroup = new int[n][];
		_bonePosScratch = new Vector3[n];
		_boneRotScratch = new Quaternion[n];
		_indexOf.Clear();
		Dictionary<Rigidbody, int> rbIndex = new Dictionary<Rigidbody, int>(n);
		for (int i = 0; i < n; i++)
		{
			_weight[i] = 1f;
			_indexOf[_drives[i]] = i;
			_rbs[i] = (_drives[i].rb != null) ? _drives[i].rb : _drives[i].GetComponent<Rigidbody>();
			if (_rbs[i] != null)
			{
				rbIndex[_rbs[i]] = i;
			}
		}
		_parent = new int[n];
		for (int j = 0; j < n; j++)
		{
			_parent[j] = -1;
			if (_rbs[j] == null)
			{
				continue;
			}
			Joint[] joints = _rbs[j].GetComponents<Joint>();
			foreach (Joint joint in joints)
			{
				if (joint.connectedBody != null && rbIndex.TryGetValue(joint.connectedBody, out int parent) && parent != j)
				{
					_parent[j] = parent;
					break;
				}
			}
			_isCore[j] = _parent[j] < 0 || IsExtraCore(_drives[j].transform);
			if (_parent[j] < 0 && _coreIndex < 0)
			{
				_coreIndex = j;
			}
		}
		for (int k = 0; k < n; k++)
		{
			int top = k;
			for (int guard = 0; guard < n; guard++)
			{
				if (_isCore[top])
				{
					break;
				}
				int p = _parent[top];
				if (p < 0 || _isCore[p])
				{
					break;
				}
				top = p;
			}
			_chainTop[k] = top;
		}
		List<int> group = new List<int>(n);
		for (int l = 0; l < n; l++)
		{
			if (_isCore[l])
			{
				if (coreGrabReleasesWholeBody)
				{
					_releaseGroup[l] = new int[n];
					for (int m = 0; m < n; m++)
					{
						_releaseGroup[l][m] = m;
					}
				}
				else
				{
					_releaseGroup[l] = new int[1] { l };
				}
				continue;
			}
			group.Clear();
			for (int m2 = 0; m2 < n; m2++)
			{
				if (!_isCore[m2] && _chainTop[m2] == _chainTop[l])
				{
					group.Add(m2);
				}
			}
			_releaseGroup[l] = group.ToArray();
		}
	}

	private bool IsExtraCore(Transform bone)
	{
		if (extraCoreBones == null)
		{
			return false;
		}
		for (int i = 0; i < extraCoreBones.Length; i++)
		{
			if (extraCoreBones[i] == bone)
			{
				return true;
			}
		}
		return false;
	}

	private void ApplyPhysicsSetup(bool runtime)
	{
		CharacterController[] controllers = GetComponentsInChildren<CharacterController>(true);
		foreach (CharacterController controller in controllers)
		{
			if (runtime)
			{
				Debug.LogWarning("[RagdollManager] " + name + ": removing stray CharacterController on '" + controller.name + "'. Bake the prefab with the editor setup button to fix it permanently.", this);
				Object.Destroy(controller);
			}
		}
		CharacterJoint[] joints = GetComponentsInChildren<CharacterJoint>(true);
		foreach (CharacterJoint joint in joints)
		{
			joint.enableProjection = enableJointProjection;
			joint.projectionDistance = 0.05f;
			joint.projectionAngle = 90f;
			joint.enablePreprocessing = false;
		}
		RagdollSystem[] drives = GetComponentsInChildren<RagdollSystem>(true);
		foreach (RagdollSystem drive in drives)
		{
			Rigidbody rb = (drive.rb != null) ? drive.rb : drive.GetComponent<Rigidbody>();
			if (rb == null)
			{
				continue;
			}
			rb.maxAngularVelocity = 20f;
			rb.maxDepenetrationVelocity = 3f;
			rb.solverIterations = Mathf.Max(rb.solverIterations, 8);
			rb.solverVelocityIterations = Mathf.Max(rb.solverVelocityIterations, 2);
			if (useSpeculativeCCD)
			{
				rb.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative;
			}
			if (!drive.TryGetComponent<RagdollBoneGrabbable>(out RagdollBoneGrabbable grabbable))
			{
				grabbable = drive.gameObject.AddComponent<RagdollBoneGrabbable>();
			}
			grabbable.manager = this;
			grabbable.drive = drive;
		}
	}
}
