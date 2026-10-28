using System;
using System.Collections.Generic;
using JigglePhysics;
using LethalApeR.Cosmetics;
using RootMotion.FinalIK;
using UnityEngine;

namespace LethalApeR.Networking
{
	[DisallowMultipleComponent]
	[AddComponentMenu("Slop/Player Animation LOD")]
	public class PlayerAnimationLOD : MonoBehaviour
	{
		private sealed class TierState
		{
			public Behaviour[] Set = Array.Empty<Behaviour>();

			public bool[] Claimed = Array.Empty<bool>();

			public Renderer[] Renderers = Array.Empty<Renderer>();

			public bool[] RendererClaimed = Array.Empty<bool>();

			public int Interval = 1;

			public bool LastApplied = true;

			public bool HasApplied;
		}

		[DefaultExecutionOrder(-1000)]
		private sealed class LodDriver : MonoBehaviour
		{
			private readonly LodRanker _ranker = new LodRanker();

			private readonly List<PlayerAnimationLOD> _ranked = new List<PlayerAnimationLOD>(64);

			private readonly List<float> _sqr = new List<float>(64);

			private float _next;

			private void Update()
			{
				int count = All.Count;
				if (count == 0)
				{
					return;
				}
				int frameCount = Time.frameCount;
				float deltaTime = Time.deltaTime;
				if (Time.unscaledTime >= _next)
				{
					float a = 0.1f;
					for (int i = 0; i < count; i++)
					{
						if (All[i] != null)
						{
							a = All[i].evaluateInterval;
							break;
						}
					}
					_next = Time.unscaledTime + Mathf.Max(a, 0.01f);
					Rank();
				}
				for (int j = 0; j < All.Count; j++)
				{
					PlayerAnimationLOD playerAnimationLOD = All[j];
					if (playerAnimationLOD != null && !playerAnimationLOD.IsProtectedLocal)
					{
						playerAnimationLOD.Tick(frameCount, deltaTime);
					}
				}
			}

			private void Rank()
			{
				Transform transform = PlayerLodRank.LocalHead();
				if (transform == null)
				{
					return;
				}
				Vector3 position = transform.position;
				int count = All.Count;
				_ranked.Clear();
				_sqr.Clear();
				_ranker.Begin(count);
				for (int i = 0; i < count; i++)
				{
					PlayerAnimationLOD playerAnimationLOD = All[i];
					if (playerAnimationLOD == null)
					{
						continue;
					}
					if (playerAnimationLOD.IsProtectedLocal)
					{
						playerAnimationLOD.RestoreIfLodded();
						continue;
					}
					float sqrMagnitude = (playerAnimationLOD.HeadPosition - position).sqrMagnitude;
					_ranked.Add(playerAnimationLOD);
					_sqr.Add(sqrMagnitude);
					_ranker.Add(sqrMagnitude);
				}
				if (_ranked.Count != 0)
				{
					_ranker.Sort();
					ActiveFingers = 0;
					ActiveFace = 0;
					ActiveDeform = 0;
					ActiveBody = 0;
					ActiveTrinkets = 0;
					ActiveNameplates = 0;
					for (int j = 0; j < _ranked.Count; j++)
					{
						_ranked[j].Evaluate(_sqr[j], _ranker.RankOf(j));
					}
				}
			}
		}

		private const float DefFingersOff = 10f;

		private const float DefFingersOn = 8f;

		private const float DefFaceOff = 12f;

		private const float DefFaceOn = 10f;

		private const float DefDeformOff = 12f;

		private const float DefDeformOn = 10f;

		private const float DefBodyOff = 20f;

		private const float DefBodyOn = 17f;

		private const float DefTrinketOff = 12f;

		private const float DefTrinketOn = 10f;

		private const float DefNameOff = 18f;

		private const float DefNameOn = 15f;

		private const int DefFingersBudget = 4;

		private const int DefFaceBudget = 6;

		private const int DefDeformBudget = 6;

		private const int DefBodyBudget = 12;

		private const int DefTrinketBudget = 8;

		private const int DefNameBudget = 12;

		private const int DefFingersInterval = 6;

		private const int DefFaceInterval = 4;

		private const int DefDeformInterval = 4;

		private const int DefBodyInterval = 3;

		private const int DefTrinketInterval = 6;

		private const float DefInterval = 0.1f;

		private const int FullRate = 1;

		private const int FullyOff = 0;

		[Header("Fingers  (FingerAnimations, HazmatFingerAnims)")]
		[Tooltip("Beyond this many metres finger curling drops to the reduced rate below. A curled finger is sub-pixel well before this.")]
		[SerializeField]
		private float fingersOffDistance = 10f;

		[Tooltip("Full-rate finger animation resumes inside this. Must be LESS than Off Distance -- the gap is hysteresis, without which a player sitting on the boundary flips state every frame.")]
		[SerializeField]
		private float fingersOnDistance = 8f;

		[Tooltip("Only the nearest this many players get full-rate fingers, however close the rest are. This is what caps the cost of a crowd.")]
		[SerializeField]
		private int fingersBudget = 4;

		[Tooltip("Out of range or over budget, fingers update once every this many frames instead of stopping. 6 at 72Hz is 12 updates a second.")]
		[SerializeField]
		private int fingersFarInterval = 6;

		[Header("Face  (JawMaster67, BlinkMaster67)")]
		[Tooltip("Beyond this, jaw and blink drop to the reduced rate. Keep it at conversational range -- it is the distance at which a moving mouth still reads as someone talking.")]
		[SerializeField]
		private float faceOffDistance = 12f;

		[Tooltip("Full-rate face animation resumes inside this. Must be LESS than Off Distance.")]
		[SerializeField]
		private float faceOnDistance = 10f;

		[Tooltip("Only the nearest this many players get full-rate jaw and blink.")]
		[SerializeField]
		private int faceBudget = 6;

		[Tooltip("Reduced face update interval, in frames.")]
		[SerializeField]
		private int faceFarInterval = 4;

		[Header("Deformation  (TwistRelaxer, JiggleRig)")]
		[Tooltip("Beyond this, forearm twist and jiggle bones drop to the reduced rate. These only refine the shape of a limb that is already in the right place, so they can go much earlier than the IK that positions it.")]
		[SerializeField]
		private float deformOffDistance = 12f;

		[Tooltip("Full-rate deformation resumes inside this. Must be LESS than Off Distance.")]
		[SerializeField]
		private float deformOnDistance = 10f;

		[Tooltip("Only the nearest this many players get full-rate twist/jiggle. The cheapest large saving available in a crowd.")]
		[SerializeField]
		private int deformBudget = 6;

		[Tooltip("Reduced deformation update interval, in frames.")]
		[SerializeField]
		private int deformFarInterval = 4;

		[Header("Body IK  (VRIK, ArmIK, Animator)")]
		[Tooltip("Beyond this, arm IK and the Animator drop to the reduced rate. Generous on purpose: ArmIK is what keeps hands attached to arms.")]
		[SerializeField]
		private float bodyOffDistance = 20f;

		[Tooltip("Full-rate body animation resumes inside this. Must be LESS than Off Distance.")]
		[SerializeField]
		private float bodyOnDistance = 17f;

		[Tooltip("Only the nearest this many players keep full-rate arm IK. Deliberately the most generous budget -- this is the most visible tier, so let the cheaper ones above take the load first.")]
		[SerializeField]
		private int bodyBudget = 12;

		[Tooltip("Reduced body-IK update interval, in frames. Keep this the gentlest of the set: it is the whole-body pose, so choppiness here is what people notice. 3 at 72Hz is 24 updates a second, which still reads as movement.")]
		[SerializeField]
		private int bodyFarInterval = 3;

		[Header("Trinkets  (FloorTracker, TrackToPoint, CosmeticSkinSync)")]
		[Tooltip("Beyond this, cosmetic follow/sync scripts drop to the reduced rate. FloorTracker fires a Physics.Raycast every frame, so this tier is worth more than its component count suggests.")]
		[SerializeField]
		private float trinketOffDistance = 12f;

		[Tooltip("Full-rate trinket scripts resume inside this. Must be LESS than Off Distance.")]
		[SerializeField]
		private float trinketOnDistance = 10f;

		[Tooltip("Only the nearest this many players run full-rate cosmetic follow/sync.")]
		[SerializeField]
		private int trinketBudget = 8;

		[Tooltip("Reduced trinket update interval, in frames.")]
		[SerializeField]
		private int trinketFarInterval = 6;

		[Header("Nameplate  (billboard script + Canvas + the TMP mesh)")]
		[Tooltip("The floating name stops updating AND stops drawing beyond this. Unlike the animation tiers this one switches fully off, because it is a draw-call saving and a missing name has no pose to look wrong.")]
		[SerializeField]
		private float nameplateOffDistance = 18f;

		[Tooltip("The nameplate comes back inside this. Must be LESS than Off Distance.")]
		[SerializeField]
		private float nameplateOnDistance = 15f;

		[Tooltip("Only the nearest this many players show a nameplate. Each one switched off is a Canvas that stops rebuilding and two draw calls that stop being issued.")]
		[SerializeField]
		private int nameplateBudget = 12;

		[Header("Scheduling")]
		[Tooltip("Seconds between re-rankings, shared across the whole lobby. One tick is a squared distance per player plus a single index sort. The per-frame rate limiting is separate and always runs.")]
		[SerializeField]
		private float evaluateInterval = 0.1f;

		[Tooltip("Never LOD your own avatar, and never let it occupy a crowd budget slot.")]
		[SerializeField]
		private bool neverCullLocalPlayer = true;

		[Header("Animator culling")]
		[Tooltip("Downgrade remote Animators from Always Animate to Cull Update Transforms, so an animator whose mesh is off-screen stops writing bone transforms. Independent of distance -- this is what covers players who are close but behind you. Restored when this component is disabled.")]
		[SerializeField]
		private bool manageAnimatorCulling = true;

		public static int ActiveFingers;

		public static int ActiveFace;

		public static int ActiveDeform;

		public static int ActiveBody;

		public static int ActiveTrinkets;

		public static int ActiveNameplates;

		private MonkeDevNetworkingPlayer _player;

		private readonly TierState _fingers = new TierState();

		private readonly TierState _face = new TierState();

		private readonly TierState _deform = new TierState();

		private readonly TierState _body = new TierState();

		private readonly TierState _trinkets = new TierState();

		private readonly TierState _nameplate = new TierState();

		private Animator[] _animators = Array.Empty<Animator>();

		private AnimatorCullingMode[] _animatorOriginalCulling;

		private bool _animatorsManual;

		private float _animatorAccum;

		private bool _cacheValid;

		private int _phase;

		private static int _phaseCursor;

		private static readonly List<PlayerAnimationLOD> All = new List<PlayerAnimationLOD>();

		private static LodDriver _driver;

		private static readonly List<Behaviour> _scratch = new List<Behaviour>(64);

		private static readonly List<Renderer> _rendererScratch = new List<Renderer>(8);

		private static readonly List<Renderer> _rendererBuffer = new List<Renderer>(8);

		private bool IsProtectedLocal
		{
			get
			{
				if (neverCullLocalPlayer && _player != null && _player.photonView != null)
				{
					return _player.photonView.IsMine;
				}
				return false;
			}
		}

		private Vector3 HeadPosition => ((_player != null && _player.Head != null) ? _player.Head : base.transform).position;

		private void Awake()
		{
			_player = GetComponent<MonkeDevNetworkingPlayer>();
		}

		private void OnEnable()
		{
			Sanitise();
			_phase = _phaseCursor++ & 0x3FF;
			if (!All.Contains(this))
			{
				All.Add(this);
			}
			_cacheValid = false;
			EnsureDriver();
		}

		private void OnDisable()
		{
			All.Remove(this);
			RestoreAll();
		}

		private static void EnsureDriver()
		{
			if (!(_driver != null))
			{
				GameObject gameObject = new GameObject("[PlayerAnim] LOD Driver");
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				_driver = gameObject.AddComponent<LodDriver>();
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
			}
		}

		private void Sanitise()
		{
			Fix(ref fingersOffDistance, ref fingersOnDistance, 10f, 8f);
			Fix(ref faceOffDistance, ref faceOnDistance, 12f, 10f);
			Fix(ref deformOffDistance, ref deformOnDistance, 12f, 10f);
			Fix(ref bodyOffDistance, ref bodyOnDistance, 20f, 17f);
			Fix(ref trinketOffDistance, ref trinketOnDistance, 12f, 10f);
			Fix(ref nameplateOffDistance, ref nameplateOnDistance, 18f, 15f);
			if (fingersBudget <= 0)
			{
				fingersBudget = 4;
			}
			if (faceBudget <= 0)
			{
				faceBudget = 6;
			}
			if (deformBudget <= 0)
			{
				deformBudget = 6;
			}
			if (bodyBudget <= 0)
			{
				bodyBudget = 12;
			}
			if (trinketBudget <= 0)
			{
				trinketBudget = 8;
			}
			if (nameplateBudget <= 0)
			{
				nameplateBudget = 12;
			}
			if (fingersFarInterval <= 1)
			{
				fingersFarInterval = 6;
			}
			if (faceFarInterval <= 1)
			{
				faceFarInterval = 4;
			}
			if (deformFarInterval <= 1)
			{
				deformFarInterval = 4;
			}
			if (bodyFarInterval <= 1)
			{
				bodyFarInterval = 3;
			}
			if (trinketFarInterval <= 1)
			{
				trinketFarInterval = 6;
			}
			if (evaluateInterval <= 0f)
			{
				evaluateInterval = 0.1f;
			}
		}

		private static void Fix(ref float off, ref float on, float defOff, float defOn)
		{
			if (off <= 0f)
			{
				off = defOff;
			}
			if (on <= 0f)
			{
				on = defOn;
			}
			if (on >= off)
			{
				on = Mathf.Max(off * (defOn / defOff), 0.1f);
			}
		}

		private void OnValidate()
		{
			Sanitise();
		}

		public void ApplyDefaultsIfUnset()
		{
			Sanitise();
		}

		public void InvalidateCache()
		{
			_cacheValid = false;
		}

		private void RebuildCache()
		{
			int interval = _fingers.Interval;
			int interval2 = _face.Interval;
			int interval3 = _deform.Interval;
			int interval4 = _body.Interval;
			int interval5 = _trinkets.Interval;
			int interval6 = _nameplate.Interval;
			RestoreAll();
			_cacheValid = true;
			Collect(_fingers, CollectFingers());
			Collect(_face, CollectFace());
			Collect(_deform, CollectDeform());
			Collect(_body, CollectBody());
			Collect(_trinkets, CollectTrinkets());
			Collect(_nameplate, CollectNameplate(), CollectNameplateRenderers());
			_animators = GetComponentsInChildren<Animator>(includeInactive: true);
			_animatorOriginalCulling = new AnimatorCullingMode[_animators.Length];
			for (int i = 0; i < _animators.Length; i++)
			{
				if (!(_animators[i] == null))
				{
					_animatorOriginalCulling[i] = _animators[i].cullingMode;
				}
			}
			ApplyAnimatorCulling();
			_fingers.Interval = interval;
			_face.Interval = interval2;
			_deform.Interval = interval3;
			_body.Interval = interval4;
			_trinkets.Interval = interval5;
			_nameplate.Interval = interval6;
		}

		private static void Collect(TierState tier, Behaviour[] set, Renderer[] renderers = null)
		{
			tier.Set = set;
			tier.Claimed = new bool[set.Length];
			tier.Renderers = renderers ?? Array.Empty<Renderer>();
			tier.RendererClaimed = new bool[tier.Renderers.Length];
			tier.LastApplied = true;
			tier.HasApplied = false;
		}

		private Behaviour[] CollectFingers()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<FingerAnimations>(includeInactive: true));
			AddAll(GetComponentsInChildren<HazmatFingerAnims>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Behaviour[] CollectFace()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<JawMaster67>(includeInactive: true));
			AddAll(GetComponentsInChildren<BlinkMaster67>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Behaviour[] CollectDeform()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<TwistRelaxer>(includeInactive: true));
			AddAll(GetComponentsInChildren<JiggleRigBuilder>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Behaviour[] CollectBody()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<VRIK>(includeInactive: true));
			AddAll(GetComponentsInChildren<ArmIK>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Behaviour[] CollectTrinkets()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<FloorTracker>(includeInactive: true));
			AddAll(GetComponentsInChildren<TrackToPoint>(includeInactive: true));
			AddAll(GetComponentsInChildren<CosmeticSkinSync>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Behaviour[] CollectNameplate()
		{
			_scratch.Clear();
			AddAll(GetComponentsInChildren<MonkeDevNetworkingPlayerName>(includeInactive: true));
			AddAll(GetComponentsInChildren<Canvas>(includeInactive: true));
			return _scratch.ToArray();
		}

		private Renderer[] CollectNameplateRenderers()
		{
			_rendererScratch.Clear();
			MonkeDevNetworkingPlayerName[] componentsInChildren = GetComponentsInChildren<MonkeDevNetworkingPlayerName>(includeInactive: true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				if (componentsInChildren[i] == null)
				{
					continue;
				}
				componentsInChildren[i].GetComponentsInChildren(includeInactive: true, _rendererBuffer);
				for (int j = 0; j < _rendererBuffer.Count; j++)
				{
					if (_rendererBuffer[j] != null)
					{
						_rendererScratch.Add(_rendererBuffer[j]);
					}
				}
			}
			return _rendererScratch.ToArray();
		}

		private static void AddAll<T>(T[] found) where T : Behaviour
		{
			if (found == null)
			{
				return;
			}
			for (int i = 0; i < found.Length; i++)
			{
				if (found[i] != null)
				{
					_scratch.Add(found[i]);
				}
			}
		}

		private void RestoreIfLodded()
		{
			if (!_cacheValid)
			{
				RebuildCache();
			}
			if (_fingers.Interval != 1 || _face.Interval != 1 || _deform.Interval != 1 || _body.Interval != 1 || _trinkets.Interval != 1 || _nameplate.Interval != 1)
			{
				RestoreAll();
			}
		}

		private void Evaluate(float sqr, int rank)
		{
			if (!_cacheValid)
			{
				RebuildCache();
			}
			Resolve(_fingers, sqr, fingersOffDistance, fingersOnDistance, rank, PlayerLodRank.Scale(fingersBudget), fingersFarInterval);
			Resolve(_face, sqr, faceOffDistance, faceOnDistance, rank, PlayerLodRank.Scale(faceBudget), faceFarInterval);
			Resolve(_deform, sqr, deformOffDistance, deformOnDistance, rank, PlayerLodRank.Scale(deformBudget), deformFarInterval);
			Resolve(_body, sqr, bodyOffDistance, bodyOnDistance, rank, PlayerLodRank.Scale(bodyBudget), bodyFarInterval);
			Resolve(_trinkets, sqr, trinketOffDistance, trinketOnDistance, rank, PlayerLodRank.Scale(trinketBudget), trinketFarInterval);
			Resolve(_nameplate, sqr, nameplateOffDistance, nameplateOnDistance, rank, PlayerLodRank.Scale(nameplateBudget), 0);
			if (_fingers.Interval == 1)
			{
				ActiveFingers++;
			}
			if (_face.Interval == 1)
			{
				ActiveFace++;
			}
			if (_deform.Interval == 1)
			{
				ActiveDeform++;
			}
			if (_body.Interval == 1)
			{
				ActiveBody++;
			}
			if (_trinkets.Interval == 1)
			{
				ActiveTrinkets++;
			}
			if (_nameplate.Interval == 1)
			{
				ActiveNameplates++;
			}
		}

		private static void Resolve(TierState tier, float sqr, float offDist, float onDist, int rank, int budget, int farInterval)
		{
			tier.Interval = (PlayerLodRank.Resolve(tier.Interval != 1, sqr, offDist, onDist, rank, budget) ? farInterval : 1);
		}

		private void Tick(int frame, float deltaTime)
		{
			if (_cacheValid)
			{
				ApplyTier(_fingers, frame);
				ApplyTier(_face, frame);
				ApplyTier(_deform, frame);
				ApplyTier(_trinkets, frame);
				ApplyTier(_nameplate, frame);
				bool ticksThisFrame = ApplyTier(_body, frame);
				TickAnimators(ticksThisFrame, deltaTime);
			}
		}

		private bool ApplyTier(TierState tier, int frame)
		{
			if (tier.Interval == 1)
			{
				if (tier.HasApplied)
				{
					ReleaseTier(tier);
				}
				return true;
			}
			bool flag = tier.Interval >= 1 && (_phase + frame) % tier.Interval == 0;
			if (!tier.HasApplied || tier.LastApplied != flag)
			{
				tier.LastApplied = flag;
				tier.HasApplied = true;
				SetTier(tier, flag);
			}
			return flag;
		}

		private static void SetTier(TierState tier, bool enable)
		{
			Behaviour[] set = tier.Set;
			bool[] claimed = tier.Claimed;
			if (set != null && claimed != null)
			{
				for (int i = 0; i < set.Length && i < claimed.Length; i++)
				{
					Behaviour behaviour = set[i];
					if (behaviour == null)
					{
						claimed[i] = false;
					}
					else if (enable)
					{
						if (claimed[i] && !behaviour.enabled)
						{
							behaviour.enabled = true;
						}
					}
					else
					{
						if (!claimed[i])
						{
							if (!behaviour.enabled || !behaviour.gameObject.activeInHierarchy)
							{
								continue;
							}
							claimed[i] = true;
						}
						if (behaviour.enabled)
						{
							behaviour.enabled = false;
						}
					}
				}
			}
			Renderer[] renderers = tier.Renderers;
			bool[] rendererClaimed = tier.RendererClaimed;
			if (renderers == null || rendererClaimed == null)
			{
				return;
			}
			for (int j = 0; j < renderers.Length && j < rendererClaimed.Length; j++)
			{
				Renderer renderer = renderers[j];
				if (renderer == null)
				{
					rendererClaimed[j] = false;
				}
				else if (enable)
				{
					if (rendererClaimed[j] && !renderer.enabled)
					{
						renderer.enabled = true;
					}
				}
				else
				{
					if (!rendererClaimed[j])
					{
						if (!renderer.enabled || !renderer.gameObject.activeInHierarchy)
						{
							continue;
						}
						rendererClaimed[j] = true;
					}
					if (renderer.enabled)
					{
						renderer.enabled = false;
					}
				}
			}
		}

		private static void ReleaseTier(TierState tier)
		{
			SetTier(tier, enable: true);
			for (int i = 0; i < tier.Claimed.Length; i++)
			{
				tier.Claimed[i] = false;
			}
			for (int j = 0; j < tier.RendererClaimed.Length; j++)
			{
				tier.RendererClaimed[j] = false;
			}
			tier.LastApplied = true;
			tier.HasApplied = false;
		}

		private void TickAnimators(bool ticksThisFrame, float deltaTime)
		{
			if (_animators == null || _animators.Length == 0)
			{
				return;
			}
			if (_body.Interval == 1)
			{
				if (_animatorsManual)
				{
					_animatorsManual = false;
					_animatorAccum = 0f;
					SetAnimators(enable: true);
				}
				return;
			}
			if (!_animatorsManual)
			{
				_animatorsManual = true;
				_animatorAccum = 0f;
				SetAnimators(enable: false);
			}
			_animatorAccum += deltaTime;
			if (!ticksThisFrame)
			{
				return;
			}
			float animatorAccum = _animatorAccum;
			_animatorAccum = 0f;
			if (animatorAccum <= 0f)
			{
				return;
			}
			for (int i = 0; i < _animators.Length; i++)
			{
				Animator animator = _animators[i];
				if (!(animator == null) && !animator.enabled && animator.gameObject.activeInHierarchy && !(animator.runtimeAnimatorController == null))
				{
					animator.Update(animatorAccum);
				}
			}
		}

		private void SetAnimators(bool enable)
		{
			if (_animators == null)
			{
				return;
			}
			for (int i = 0; i < _animators.Length; i++)
			{
				Animator animator = _animators[i];
				if (!(animator == null) && (enable || animator.gameObject.activeInHierarchy) && animator.enabled != enable)
				{
					animator.enabled = enable;
				}
			}
		}

		private void ApplyAnimatorCulling()
		{
			if (!manageAnimatorCulling || _animators == null || IsProtectedLocal)
			{
				return;
			}
			for (int i = 0; i < _animators.Length; i++)
			{
				Animator animator = _animators[i];
				if (!(animator == null) && animator.cullingMode == AnimatorCullingMode.AlwaysAnimate)
				{
					animator.cullingMode = AnimatorCullingMode.CullUpdateTransforms;
				}
			}
		}

		private void RestoreAll()
		{
			ReleaseTier(_fingers);
			ReleaseTier(_face);
			ReleaseTier(_deform);
			ReleaseTier(_body);
			ReleaseTier(_trinkets);
			ReleaseTier(_nameplate);
			_fingers.Interval = 1;
			_face.Interval = 1;
			_deform.Interval = 1;
			_body.Interval = 1;
			_trinkets.Interval = 1;
			_nameplate.Interval = 1;
			_animatorsManual = false;
			_animatorAccum = 0f;
			SetAnimators(enable: true);
			if (_animators == null || _animatorOriginalCulling == null)
			{
				return;
			}
			for (int i = 0; i < _animators.Length && i < _animatorOriginalCulling.Length; i++)
			{
				if (_animators[i] != null)
				{
					_animators[i].cullingMode = _animatorOriginalCulling[i];
				}
			}
		}
	}
}
