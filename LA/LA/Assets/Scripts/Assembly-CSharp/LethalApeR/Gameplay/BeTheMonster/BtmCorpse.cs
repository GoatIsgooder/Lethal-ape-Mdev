using System.Collections.Generic;
using LethalApeR.Networking;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmCorpse : MonoBehaviour
	{
		private const int MaxSplashes = 2;

		private readonly List<Mesh> _stumps = new List<Mesh>();

		private readonly List<Renderer> _headItems = new List<Renderer>();

		private const float ApeSize = 0.48f;

		private const float MaxInheritedSpeed = 14f;

		private const float KnockSpeed = 1.7f;

		private const float KnockLift = 0.8f;

		private readonly List<Rigidbody> _bodies = new List<Rigidbody>();

		private readonly List<Collider> _colliders = new List<Collider>();

		private Rigidbody _torsoBody;

		private readonly Rigidbody[] _roles = new Rigidbody[9];

		private static int _ragdollLayer = -2;

		private static readonly MaterialPropertyBlock Block = new MaterialPropertyBlock();

		private static readonly List<Material> MaterialScratch = new List<Material>();

		private static readonly List<Renderer> RendererScratch = new List<Renderer>();

		private readonly Dictionary<Transform, Transform> _mirror = new Dictionary<Transform, Transform>();

		private readonly Dictionary<string, Transform> _liveBoneByName = new Dictionary<string, Transform>();

		private readonly HashSet<Transform> _liveBones = new HashSet<Transform>();

		private readonly List<SkinnedMeshRenderer> _skinned = new List<SkinnedMeshRenderer>();

		private readonly List<Transform> _rigidRenderers = new List<Transform>();

		private static int _spawnCount;

		private BtmGore _gore;

		private BtmBodyPart _part;

		private int _seed;

		private Transform _liveModels;

		private BtmRig _liveRig;

		private BtmRig _rig;

		private int _splashes;

		internal BtmRig Rig => _rig;

		internal Vector3 HeadVelocity
		{
			get
			{
				if (_rig.Head && _rig.Head.TryGetComponent<Rigidbody>(out Rigidbody head))
				{
					return head.linearVelocity;
				}
				if (_torsoBody)
				{
					return _torsoBody.linearVelocity;
				}
				return Vector3.zero;
			}
		}

		public static int RagdollLayer
		{
			get
			{
				if (_ragdollLayer == -2)
				{
					_ragdollLayer = LayerMask.NameToLayer("Ragdoll");
				}
				if (_ragdollLayer < 0)
				{
					return 0;
				}
				return _ragdollLayer;
			}
		}

		public BtmBodyPart Part => _part;

		internal bool Retiring
		{
			get
			{
				if (!_part)
				{
					return true;
				}
				return _part.Retiring;
			}
		}

		private void Dress(Vector3 away)
		{
			if (!_gore)
			{
				return;
			}
			Vector3 neck = (_rig.Neck ? _rig.Neck : _rig.Head).position;
			Vector3 point = Vector3.Lerp(_rig.Torso.position, neck, 0.6f);
			_gore.Play(_gore.crunchClips, point);
			if (_gore.InFxRange(point))
			{
				_gore.Burst(_gore.burstPrefab, point, (away + Vector3.up * 0.6f).normalized);
			}
			float poolSize = Mathf.Clamp(_rig.Size / ApeSize * 1.4f, 1f, 1.6f);
			if (_torsoBody)
			{
				_torsoBody.gameObject.AddComponent<BtmGoreLanding>().Init(this, poolSize);
			}
		}

		internal void Landed(Vector3 point, Vector3 normal, float speed)
		{
			if (_gore && _gore.InFxRange(point))
			{
				_gore.Splat(point, normal, speed, ref _splashes, MaxSplashes);
			}
		}

		internal BtmBloodDecal Pool(Vector3 center, float size)
		{
			if (!_gore || !_gore.InFxRange(center))
			{
				return null;
			}
			return _gore.Pool(center, size);
		}

		internal void LoseHead(Rigidbody piece, List<Mesh> stumps)
		{
			Transform head = _rig.Head;
			head.GetComponentsInChildren(true, _headItems);
			foreach (Renderer item in _headItems)
			{
				if (!item || item.transform == head)
				{
					continue;
				}
				if (!(item is MeshRenderer) && (!(item is SkinnedMeshRenderer skinned) || skinned.bones.Length != 0))
				{
					continue;
				}
				if (item.transform.parent && !(item.transform.parent.GetComponent<Renderer>() is MeshRenderer))
				{
					item.transform.SetParent(piece.transform, true);
				}
			}
			_headItems.Clear();
			if (head.TryGetComponent<CharacterJoint>(out CharacterJoint joint))
			{
				Object.DestroyImmediate(joint);
			}
			Collider[] colliders = head.GetComponents<Collider>();
			foreach (Collider collider in colliders)
			{
				_colliders.Remove(collider);
				Object.Destroy(collider);
			}
			if (head.TryGetComponent<Rigidbody>(out Rigidbody body))
			{
				_bodies.Remove(body);
				if (_part)
				{
					_part.Forget(body);
				}
				Object.Destroy(body);
			}
			_stumps.AddRange(stumps);
		}

		private void OnDestroy()
		{
			foreach (Mesh stump in _stumps)
			{
				if (stump)
				{
					Object.Destroy(stump);
				}
			}
			_stumps.Clear();
		}

		private void BuildRagdoll()
		{
			float scale = _rig.Size / ApeSize;
			Vector3 top = (_rig.Neck ? _rig.Neck : _rig.Head).position;
			Vector3 bottom = _rig.Torso.position - (top - _rig.Torso.position) * 0.15f;
			_torsoBody = Body(_rig.Torso, 9f, Capsule(_rig.Torso, bottom, top, scale * 0.16f), null);
			_roles[0] = _torsoBody;
			Rigidbody neck = (_rig.Neck ? Body(_rig.Neck, 0.8f, Capsule(_rig.Neck, _rig.Neck.position, _rig.Head.position, scale * 0.06f), _torsoBody, 22f, 15f) : null);
			_roles[1] = neck;
			_roles[2] = Body(_rig.Head, 2.6f, Sphere(_rig.Head, scale * 0.13f, Vector3.up * 0.08f * scale), neck ? neck : _torsoBody, 15f, 12f);
			for (int i = 0; i < 2; i++)
			{
				Transform upper = _rig.Upper[i];
				Transform lower = _rig.Lower[i];
				Transform hand = _rig.Hand[i];
				if (!upper || !lower)
				{
					continue;
				}
				Rigidbody upperBody = Body(upper, 1.6f, Capsule(upper, upper.position, lower.position, scale * 0.065f), _torsoBody);
				Vector3 end = (hand ? hand.position : (lower.position + (lower.position - upper.position) * 0.8f));
				Rigidbody lowerBody = Body(lower, 1.1f, Capsule(lower, lower.position, end, scale * 0.055f), upperBody);
				_roles[3 + i * 3] = upperBody;
				_roles[4 + i * 3] = lowerBody;
				if (hand)
				{
					_roles[5 + i * 3] = Body(hand, 0.5f, Sphere(hand, scale * 0.06f, Vector3.zero), lowerBody, 35f, 20f);
				}
			}
			for (int j = 0; j < _colliders.Count; j++)
			{
				for (int k = j + 1; k < _colliders.Count; k++)
				{
					Physics.IgnoreCollision(_colliders[j], _colliders[k], true);
				}
			}
		}

		private Rigidbody Body(Transform bone, float mass, Collider shape, Rigidbody connectTo, float swing = 48f, float twist = 28f)
		{
			Rigidbody body = bone.gameObject.AddComponent<Rigidbody>();
			body.mass = mass;
			body.interpolation = RigidbodyInterpolation.Interpolate;
			body.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative;
			body.linearDamping = 0.05f;
			body.angularDamping = 0.3f;
			body.maxDepenetrationVelocity = 2f;
			_bodies.Add(body);
			if (connectTo)
			{
				CharacterJoint joint = bone.gameObject.AddComponent<CharacterJoint>();
				joint.connectedBody = connectTo;
				joint.enableProjection = true;
				SoftJointLimit limit = joint.lowTwistLimit;
				limit.limit = 0f - twist;
				joint.lowTwistLimit = limit;
				limit = joint.highTwistLimit;
				limit.limit = twist;
				joint.highTwistLimit = limit;
				limit = joint.swing1Limit;
				limit.limit = swing;
				joint.swing1Limit = limit;
				limit = joint.swing2Limit;
				limit.limit = swing;
				joint.swing2Limit = limit;
			}
			return body;
		}

		private CapsuleCollider Capsule(Transform bone, Vector3 a, Vector3 b, float radius)
		{
			CapsuleCollider capsule = bone.gameObject.AddComponent<CapsuleCollider>();
			Vector3 localA = bone.InverseTransformPoint(a);
			Vector3 localB = bone.InverseTransformPoint(b);
			float scale = Mathf.Max(MaxAbs(bone.lossyScale), 0.0001f);
			Vector3 span = localB - localA;
			int axis = ((Mathf.Abs(span.y) > Mathf.Abs(span.x)) ? 1 : 0);
			if (Mathf.Abs(span.z) > Mathf.Abs(span[axis]))
			{
				axis = 2;
			}
			capsule.direction = axis;
			capsule.center = (localA + localB) * 0.5f;
			capsule.radius = radius / scale;
			capsule.height = Mathf.Abs(span[axis]) + capsule.radius * 2f;
			Filter(capsule);
			return capsule;
		}

		private SphereCollider Sphere(Transform bone, float radius, Vector3 localOffset)
		{
			SphereCollider sphere = bone.gameObject.AddComponent<SphereCollider>();
			float scale = Mathf.Max(MaxAbs(bone.lossyScale), 0.0001f);
			sphere.radius = radius / scale;
			sphere.center = localOffset / scale;
			Filter(sphere);
			return sphere;
		}

		private void Filter(Collider c)
		{
			c.includeLayers = 1;
			c.excludeLayers = ~1;
			_colliders.Add(c);
		}

		private static float MaxAbs(Vector3 v)
		{
			return Mathf.Max(Mathf.Abs(v.x), Mathf.Max(Mathf.Abs(v.y), Mathf.Abs(v.z)));
		}

		private Vector3 Launch(Vector3 velocity, Vector3 hitFrom)
		{
			velocity = Vector3.ClampMagnitude(velocity, MaxInheritedSpeed);
			Vector3 away = Vector3.ProjectOnPlane(_rig.Torso.position - hitFrom, Vector3.up);
			Vector3 dir = ((away.sqrMagnitude > 0.0001f) ? away.normalized : (-_rig.Torso.forward));
			System.Random rng = new System.Random(_seed);
			Vector3 knock = dir * KnockSpeed + Vector3.up * KnockLift;
			foreach (Rigidbody body in _bodies)
			{
				bool limb = body != _torsoBody;
				body.linearVelocity = velocity + knock * (limb ? 1.15f : 1f) + Jitter(limb ? 0.5f : 0.15f);
				body.angularVelocity = Jitter(limb ? 3f : 0.8f);
			}
			return dir;
			Vector3 Jitter(float amount)
			{
				return new Vector3((float)rng.NextDouble() - 0.5f, (float)rng.NextDouble() - 0.5f, (float)rng.NextDouble() - 0.5f) * (amount * 2f);
			}
		}

		public static BtmCorpse Spawn(MonkeDevNetworkingPlayer victim, Vector3 velocity, Vector3 hitFrom, BtmGore gore)
		{
			if (!TryFindModel(victim, out Transform models, out SkinnedMeshRenderer body))
			{
				return null;
			}
			int viewID = victim.photonView.ViewID;
			BtmCorpse corpse = Spawn(models, body, "BTM Corpse " + viewID, viewID, velocity, hitFrom, gore);
			if (!corpse)
			{
				return null;
			}
			BtmGhost ghost = victim.GetComponent<BtmGhost>();
			if (ghost)
			{
				ghost.HoldBodyHidden(corpse._rig.Torso.position, 3f);
			}
			return corpse;
		}

		public static BtmCorpse Spawn(Transform models, SkinnedMeshRenderer body, string name, Vector3 velocity, Vector3 hitFrom, BtmGore gore)
		{
			return Spawn(models, body, name, -1, velocity, hitFrom, gore);
		}

		private static BtmCorpse Spawn(Transform models, SkinnedMeshRenderer body, string name, int victim, Vector3 velocity, Vector3 hitFrom, BtmGore gore)
		{
			if (!models || !body || !body.transform.IsChildOf(models))
			{
				return null;
			}
			BtmRig liveRig = BtmRig.Resolve(body);
			if (!liveRig.Valid)
			{
				return null;
			}
			BtmCorpse corpse = Create(name, gore);
			corpse.Build(models, body, liveRig);
			corpse.BuildRagdoll();
			corpse._part.Init(victim, BtmBodyPart.BodyKey, corpse._roles, gore ? gore.droppedSeconds : 10f, corpse._rig.Size);
			corpse._part.Arm(gore ? gore.corpseSeconds : 20f);
			corpse.Dress(corpse.Launch(velocity, hitFrom));
			return corpse;
		}

		private static BtmCorpse Create(string name, BtmGore gore)
		{
			GameObject go = new GameObject(name);
			go.layer = RagdollLayer;
			BtmCorpse corpse = go.AddComponent<BtmCorpse>();
			corpse._part = go.AddComponent<BtmBodyPart>();
			corpse._gore = gore;
			corpse._seed = ++_spawnCount * 7919;
			return corpse;
		}

		private static bool TryFindModel(MonkeDevNetworkingPlayer victim, out Transform models, out SkinnedMeshRenderer body)
		{
			models = null;
			body = null;
			if (!victim || !victim.Head)
			{
				return false;
			}
			models = victim.Head.Find("PlayerModels");
			if (!models)
			{
				return false;
			}
			body = BtmRig.FindBody(victim);
			if (!body)
			{
				return false;
			}
			return body.transform.IsChildOf(models);
		}

		private void Build(Transform models, SkinnedMeshRenderer body, BtmRig liveRig)
		{
			_liveModels = models;
			_liveRig = liveRig;
			base.transform.SetPositionAndRotation(models.position, models.rotation);
			base.transform.localScale = models.lossyScale;
			_mirror[models] = base.transform;
			Transform[] bones = body.bones;
			foreach (Transform bone in bones)
			{
				if (bone)
				{
					_liveBones.Add(bone);
					if (!_liveBoneByName.ContainsKey(bone.name))
					{
						_liveBoneByName[bone.name] = bone;
					}
				}
			}
			HashSet<Renderer> lowerLods = LowerLods(models);
			models.GetComponentsInChildren(false, RendererScratch);
			SkinnedMeshRenderer copiedBody = null;
			foreach (Renderer item in RendererScratch)
			{
				if (!Shows(item, lowerLods))
				{
					continue;
				}
				if (item is SkinnedMeshRenderer skinned && (bool)skinned.sharedMesh)
				{
					SkinnedMeshRenderer copy = CopySkinned(skinned);
					if (item == body)
					{
						copiedBody = copy;
					}
				}
				else if (item is MeshRenderer rigid)
				{
					CopyRigid(rigid);
				}
			}
			RendererScratch.Clear();
			AttachLooseRenderers();
			_rig = MirrorRig(liveRig, copiedBody);
		}

		internal static bool Shows(Renderer r, HashSet<Renderer> lowerLods)
		{
			if (!r.enabled || !r.gameObject.activeInHierarchy || lowerLods.Contains(r))
			{
				return false;
			}
			if (!(r is SkinnedMeshRenderer) && !(r is MeshRenderer))
			{
				return false;
			}
			if (r.name.EndsWith(" Highlight"))
			{
				return false;
			}
			return !r.GetComponent<TMP_Text>();
		}

		internal static HashSet<Renderer> LowerLods(Transform models)
		{
			HashSet<Renderer> lower = new HashSet<Renderer>();
			LODGroup[] groups = models.GetComponentsInChildren<LODGroup>(false);
			foreach (LODGroup group in groups)
			{
				LOD[] lods = group.GetLODs();
				HashSet<Renderer> first = new HashSet<Renderer>();
				if (lods.Length == 0)
				{
					continue;
				}
				Renderer[] renderers = lods[0].renderers;
				foreach (Renderer renderer in renderers)
				{
					if (renderer)
					{
						first.Add(renderer);
					}
				}
				for (int k = 1; k < lods.Length; k++)
				{
					renderers = lods[k].renderers;
					foreach (Renderer renderer2 in renderers)
					{
						if (renderer2 && !first.Contains(renderer2))
						{
							lower.Add(renderer2);
						}
					}
				}
			}
			return lower;
		}

		private Transform Mirror(Transform live)
		{
			if (!live)
			{
				return base.transform;
			}
			if (_mirror.TryGetValue(live, out Transform existing))
			{
				return existing;
			}
			GameObject go = new GameObject(live.name);
			go.layer = RagdollLayer;
			Transform copy = go.transform;
			if (live.IsChildOf(_liveModels))
			{
				copy.SetParent(Mirror(live.parent), false);
				copy.localPosition = live.localPosition;
				copy.localRotation = live.localRotation;
				copy.localScale = live.localScale;
			}
			else
			{
				copy.SetParent(base.transform, false);
				copy.SetPositionAndRotation(live.position, live.rotation);
				Vector3 parentScale = base.transform.lossyScale;
				Vector3 liveScale = live.lossyScale;
				copy.localScale = new Vector3(liveScale.x / parentScale.x, liveScale.y / parentScale.y, liveScale.z / parentScale.z);
			}
			_mirror[live] = copy;
			return copy;
		}

		private Transform MapBone(Transform live)
		{
			if (!live)
			{
				return null;
			}
			if (!_liveBones.Contains(live) && _liveBoneByName.TryGetValue(live.name, out Transform byName) && (!_liveRig.Root || !live.IsChildOf(_liveRig.Root)))
			{
				live = byName;
			}
			return Mirror(live);
		}

		private SkinnedMeshRenderer CopySkinned(SkinnedMeshRenderer live)
		{
			Transform[] liveBones = live.bones;
			Transform[] bones = new Transform[liveBones.Length];
			for (int i = 0; i < liveBones.Length; i++)
			{
				bones[i] = MapBone(liveBones[i]);
			}
			Transform host = Mirror(live.transform);
			SkinnedMeshRenderer copy = host.gameObject.AddComponent<SkinnedMeshRenderer>();
			copy.sharedMesh = live.sharedMesh;
			copy.sharedMaterials = live.sharedMaterials;
			copy.bones = bones;
			copy.rootBone = (live.rootBone ? MapBone(live.rootBone) : null);
			copy.quality = live.quality;
			copy.updateWhenOffscreen = true;
			CopyLook(live, copy);
			int blendShapeCount = live.sharedMesh.blendShapeCount;
			for (int j = 0; j < blendShapeCount; j++)
			{
				copy.SetBlendShapeWeight(j, live.GetBlendShapeWeight(j));
			}
			_skinned.Add(copy);
			if (liveBones.Length == 0 && !Driven(live.transform))
			{
				_rigidRenderers.Add(host);
			}
			return copy;
		}

		private void CopyRigid(MeshRenderer live)
		{
			MeshFilter filter = live.GetComponent<MeshFilter>();
			if (filter && (bool)filter.sharedMesh)
			{
				Transform host = Mirror(live.transform);
				host.gameObject.AddComponent<MeshFilter>().sharedMesh = filter.sharedMesh;
				MeshRenderer copy = host.gameObject.AddComponent<MeshRenderer>();
				copy.sharedMaterials = live.sharedMaterials;
				CopyLook(live, copy);
				if (!Driven(live.transform))
				{
					_rigidRenderers.Add(host);
				}
			}
		}

		internal static void CopyLook(Renderer from, Renderer to)
		{
			to.shadowCastingMode = from.shadowCastingMode;
			to.receiveShadows = from.receiveShadows;
			to.lightProbeUsage = from.lightProbeUsage;
			to.reflectionProbeUsage = from.reflectionProbeUsage;
			if (from.HasPropertyBlock())
			{
				from.GetPropertyBlock(Block);
				to.SetPropertyBlock(Block);
			}
			from.GetSharedMaterials(MaterialScratch);
			for (int i = 0; i < MaterialScratch.Count; i++)
			{
				from.GetPropertyBlock(Block, i);
				if (!Block.isEmpty)
				{
					to.SetPropertyBlock(Block, i);
				}
			}
			MaterialScratch.Clear();
			Block.Clear();
		}

		private bool Driven(Transform live)
		{
			while ((bool)live && live != _liveModels)
			{
				if (_liveBones.Contains(live))
				{
					return true;
				}
				live = live.parent;
			}
			return false;
		}

		private void AttachLooseRenderers()
		{
			Transform head = (_liveRig.Head ? Mirror(_liveRig.Head) : null);
			Transform torso = (_liveRig.Torso ? Mirror(_liveRig.Torso) : null);
			Vector3 neck = (_liveRig.Neck ? _liveRig.Neck : (_liveRig.Head ? _liveRig.Head : base.transform)).position;
			Vector3 up = ((_liveRig.Neck && _liveRig.Torso) ? (_liveRig.Neck.position - _liveRig.Torso.position).normalized : Vector3.up);
			foreach (Transform rigidRenderer in _rigidRenderers)
			{
				if (!rigidRenderer)
				{
					continue;
				}
				Renderer renderer = rigidRenderer.GetComponent<Renderer>();
				Vector3 point = (renderer ? renderer.bounds.center : rigidRenderer.position);
				Transform parent = ((Vector3.Dot(up, point - neck) < -0.02f) ? torso : head);
				if (parent && rigidRenderer != parent && !rigidRenderer.IsChildOf(parent))
				{
					rigidRenderer.SetParent(parent, true);
				}
			}
		}

		private BtmRig MirrorRig(BtmRig live, SkinnedMeshRenderer body)
		{
			BtmRig rig = new BtmRig();
			rig.Body = body;
			rig.Root = (live.Root ? Mirror(live.Root) : null);
			rig.Torso = (live.Torso ? Mirror(live.Torso) : null);
			rig.Neck = (live.Neck ? Mirror(live.Neck) : null);
			rig.Head = (live.Head ? Mirror(live.Head) : null);
			for (int i = 0; i < 2; i++)
			{
				rig.Upper[i] = (live.Upper[i] ? Mirror(live.Upper[i]) : null);
				rig.Lower[i] = (live.Lower[i] ? Mirror(live.Lower[i]) : null);
				rig.Hand[i] = (live.Hand[i] ? Mirror(live.Hand[i]) : null);
			}
			return rig;
		}

		public void Retire()
		{
			if (_part)
			{
				_part.Retire();
			}
		}
	}
}
