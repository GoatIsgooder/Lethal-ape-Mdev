using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using LALocomotion;
using LethalApeR.Rivals;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmItemOrbs : MonoBehaviour
	{
		private sealed class SlotState
		{
			public Transform anchor;

			public Renderer shell;

			public Vector3 shellBaseScale;

			public MaterialPropertyBlock mpb;

			public int colorId;

			public BtmItemDefinition item;

			public BtmOrbItem orbItem;

			public GameObject go;

			public Transform tr;

			public Rigidbody rb;

			public Grabbable grabbable;

			public LAGrabbable la;

			public UnityAction grabAction;

			public Collider[] colliders;

			public bool[] wasTrigger;

			public bool savedKinematic;

			public bool savedGravity;

			public RigidbodyInterpolation savedInterpolation;

			public Vector3 fullScale;

			public Vector3 fittedScale;

			public bool taken;

			public bool heldLastFrame;

			public bool consumed;

			public float presence;

			public float hoverT;

			public bool[] handHover = new bool[2];
		}

		[Header("Orbs (one child per slot, each with the shell renderer)")]
		[SerializeField]
		private Transform[] anchors = new Transform[3];

		[Header("Placement (metres at scale 1, head-yaw space)")]
		[SerializeField]
		private Vector3 pouchOffset = new Vector3(0f, -0.36f, 0.2f);

		[SerializeField]
		private float slotSpacing = 0.12f;

		[Tooltip("Side orbs curve back toward the body so every orb is the same reach away.")]
		[SerializeField]
		private float sideCurve = 0.03f;

		[SerializeField]
		[Min(0.5f)]
		private float yawFollow = 7f;

		[Tooltip("Head pitch beyond this is ignored — looking down at the pouch must not move it.")]
		[SerializeField]
		private float yawOnlyAbovePitch = 60f;

		[Header("Item fit")]
		[SerializeField]
		private float fitDiameter = 0.08f;

		[Header("Hover")]
		[SerializeField]
		private float hoverRadius = 0.1f;

		[SerializeField]
		private float orbHoverScale = 1.18f;

		[SerializeField]
		private float itemHoverScale = 1.12f;

		[SerializeField]
		private float hoverLerpSpeed = 12f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverHapticAmplitude = 0.18f;

		[SerializeField]
		private float hoverHapticDuration = 0.02f;

		[SerializeField]
		private AudioClip hoverSound;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverVolume = 0.35f;

		[SerializeField]
		private AudioClip holsterSound;

		[SerializeField]
		[Range(0f, 1f)]
		private float holsterVolume = 0.5f;

		[Header("Shell tint (MaterialPropertyBlock on one shared material)")]
		[SerializeField]
		private string colorProperty = "_Color";

		[SerializeField]
		[Range(0f, 1f)]
		private float restAlpha = 0.45f;

		[SerializeField]
		[Range(0f, 1f)]
		private float hoverAlpha = 0.85f;

		[SerializeField]
		[Min(0.01f)]
		private float presenceSeconds = 0.35f;

		public UnityEvent onItemTaken;

		public UnityEvent onItemUsed;

		private readonly List<SlotState> _slots = new List<SlotState>(3);

		private float _yaw;

		private bool _yawSeeded;

		private AudioSource _voice;

		public static BtmItemOrbs Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
				return;
			}
			Instance = this;
			Transform[] array = anchors;
			foreach (Transform anchor in array)
			{
				SlotState slotState = new SlotState
				{
					anchor = anchor,
					mpb = new MaterialPropertyBlock(),
					colorId = Shader.PropertyToID(colorProperty)
				};
				if (anchor != null)
				{
					slotState.shell = anchor.GetComponentInChildren<Renderer>(true);
					slotState.shellBaseScale = ((slotState.shell != null) ? slotState.shell.transform.localScale : Vector3.one);
					anchor.gameObject.SetActive(false);
				}
				_slots.Add(slotState);
			}
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				ClearAll();
				Instance = null;
			}
		}

		public void Stock(IReadOnlyList<BtmItemDefinition> items)
		{
			ClearAll();
			_yawSeeded = false;
			for (int i = 0; i < _slots.Count; i++)
			{
				BtmItemDefinition item = ((items != null && i < items.Count) ? items[i] : null);
				if (!(item == null) && !(item.heldPrefab == null) && !(_slots[i].anchor == null))
				{
					Fill(_slots[i], i, item);
				}
			}
		}

		public void ClearAll()
		{
			foreach (SlotState slot in _slots)
			{
				if (slot.go != null)
				{
					RivalsWeaponOrbs.ForceDropIfHeld(slot.go);
					Unhook(slot);
					Object.Destroy(slot.go);
				}
				Reset(slot);
				if (slot.anchor != null)
				{
					slot.anchor.gameObject.SetActive(false);
				}
			}
		}

		public void Holster(int slot)
		{
			if (slot < 0 || slot >= _slots.Count)
			{
				return;
			}
			SlotState slotState = _slots[slot];
			if (!(slotState.go == null) && !slotState.consumed)
			{
				RivalsWeaponOrbs.ForceDropIfHeld(slotState.go);
				Freeze(slotState);
				slotState.orbItem.OnHolstered();
				PlayVoice(holsterSound, holsterVolume);
				HapticNearest(slotState.anchor.position, 0.3f, 0.04f);
			}
		}

		public void Consume(int slot)
		{
			if (slot >= 0 && slot < _slots.Count)
			{
				SlotState slotState = _slots[slot];
				if (!slotState.consumed)
				{
					slotState.consumed = true;
					Unhook(slotState);
					slotState.go = null;
					slotState.tr = null;
					onItemUsed?.Invoke();
				}
			}
		}

		private void Fill(SlotState s, int slot, BtmItemDefinition item)
		{
			GameObject gameObject = Object.Instantiate(item.heldPrefab, s.anchor.position, s.anchor.rotation);
			BtmOrbItem componentInChildren = gameObject.GetComponentInChildren<BtmOrbItem>();
			if (componentInChildren == null)
			{
				Debug.LogError(string.Format("[BtmItemOrbs] '{0}' has no BtmOrbItem component — slot {1} left empty.", item.name, slot), item);
				Object.Destroy(gameObject);
				return;
			}
			s.item = item;
			s.orbItem = componentInChildren;
			s.go = gameObject;
			s.tr = gameObject.transform;
			s.rb = gameObject.GetComponentInChildren<Rigidbody>();
			s.grabbable = gameObject.GetComponentInChildren<Grabbable>();
			s.la = gameObject.GetComponentInChildren<LAGrabbable>();
			s.fullScale = s.tr.localScale;
			s.fittedScale = s.fullScale * FitScale(gameObject);
			s.consumed = false;
			s.presence = 0f;
			componentInChildren.Bind(item, this, slot);
			if (s.grabbable != null)
			{
				s.grabAction = delegate
				{
					TakeOut(s);
				};
				s.grabbable.onGrab.AddListener(s.grabAction);
			}
			s.anchor.gameObject.SetActive(true);
			Freeze(s);
		}

		private float FitScale(GameObject go)
		{
			Bounds bounds = new Bounds(go.transform.position, Vector3.zero);
			bool flag = false;
			Renderer[] componentsInChildren = go.GetComponentsInChildren<Renderer>(true);
			foreach (Renderer renderer in componentsInChildren)
			{
				if (renderer is MeshRenderer || renderer is SkinnedMeshRenderer)
				{
					if (!flag)
					{
						bounds = renderer.bounds;
						flag = true;
					}
					else
					{
						bounds.Encapsulate(renderer.bounds);
					}
				}
			}
			if (!flag)
			{
				return 1f;
			}
			float num = Mathf.Max(bounds.size.x, bounds.size.y, bounds.size.z);
			if (num <= 0.0001f)
			{
				return 1f;
			}
			return Mathf.Clamp(fitDiameter / num, 0.05f, 1f);
		}

		private void Freeze(SlotState s)
		{
			if (s.go == null)
			{
				return;
			}
			if (s.rb != null)
			{
				if (!s.taken && s.colliders == null)
				{
					s.savedKinematic = s.rb.isKinematic;
					s.savedGravity = s.rb.useGravity;
					s.savedInterpolation = s.rb.interpolation;
				}
				s.rb.isKinematic = true;
				s.rb.interpolation = RigidbodyInterpolation.None;
			}
			if (s.colliders == null)
			{
				s.colliders = s.go.GetComponentsInChildren<Collider>(true);
				s.wasTrigger = new bool[s.colliders.Length];
				for (int i = 0; i < s.colliders.Length; i++)
				{
					s.wasTrigger[i] = s.colliders[i].isTrigger;
				}
			}
			Collider[] colliders = s.colliders;
			foreach (Collider collider in colliders)
			{
				if (collider != null)
				{
					collider.isTrigger = true;
				}
			}
			s.tr.SetParent(null, true);
			s.tr.localScale = s.fittedScale;
			s.tr.SetPositionAndRotation(s.anchor.position, s.anchor.rotation);
			s.taken = false;
			s.heldLastFrame = false;
		}

		private void TakeOut(SlotState s)
		{
			if (s.taken || s.go == null || s.consumed)
			{
				return;
			}
			s.taken = true;
			s.heldLastFrame = true;
			SetWorldScale(s.tr, s.fullScale);
			if (s.colliders != null)
			{
				for (int i = 0; i < s.colliders.Length; i++)
				{
					if (s.colliders[i] != null)
					{
						s.colliders[i].isTrigger = s.wasTrigger[i];
					}
				}
			}
			if (s.la != null && s.la.IsHeld)
			{
				s.la.SetReleasedKinematic(s.savedKinematic);
				s.la.AddPart(s.tr);
			}
			else if (s.rb != null)
			{
				s.rb.isKinematic = s.savedKinematic;
				s.rb.useGravity = s.savedGravity;
				s.rb.interpolation = s.savedInterpolation;
			}
			s.orbItem.OnTakenOut();
			onItemTaken?.Invoke();
		}

		private void Unhook(SlotState s)
		{
			if (s.grabbable != null && s.grabAction != null)
			{
				s.grabbable.onGrab.RemoveListener(s.grabAction);
			}
			s.grabAction = null;
		}

		private static void Reset(SlotState s)
		{
			s.item = null;
			s.orbItem = null;
			s.go = null;
			s.tr = null;
			s.rb = null;
			s.grabbable = null;
			s.la = null;
			s.colliders = null;
			s.wasTrigger = null;
			s.taken = false;
			s.heldLastFrame = false;
			s.consumed = false;
			s.presence = 0f;
			s.hoverT = 0f;
		}

		private void Update()
		{
			foreach (SlotState slot in _slots)
			{
				if (slot.go == null || slot.consumed || !slot.taken)
				{
					continue;
				}
				bool flag = AnyHandHolds(slot);
				if (slot.heldLastFrame && !flag)
				{
					if (slot.la != null && slot.rb != null)
					{
						slot.rb.interpolation = slot.savedInterpolation;
					}
					Vector3 velocity = ((slot.rb != null) ? slot.rb.linearVelocity : Vector3.zero);
					if (slot.orbItem.OnReleased(velocity))
					{
						Holster(_slots.IndexOf(slot));
					}
				}
				slot.heldLastFrame = flag;
			}
		}

		private void LateUpdate()
		{
			if (!PlacePouch())
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			foreach (SlotState slot in _slots)
			{
				if (slot.anchor == null || !slot.anchor.gameObject.activeSelf)
				{
					continue;
				}
				bool flag = slot.item != null && !slot.consumed;
				slot.presence = Mathf.MoveTowards(slot.presence, flag ? 1f : 0f, deltaTime / presenceSeconds);
				float target = 0f;
				if (flag)
				{
					if (!slot.taken)
					{
						bool flag2 = false;
						for (int i = 0; i < BtmHands.Count; i++)
						{
							BtmHand btmHand = BtmHands.At(i);
							if (btmHand.Present)
							{
								float num = hoverRadius * RigScale();
								bool flag3 = (btmHand.Palm - slot.anchor.position).sqrMagnitude <= num * num;
								if (flag3 && !slot.handHover[i])
								{
									OnHoverEnter(btmHand);
								}
								slot.handHover[i] = flag3;
								flag2 = flag2 || flag3;
							}
						}
						target = (flag2 ? 1f : 0f);
					}
				}
				else if (slot.presence <= 0f)
				{
					slot.anchor.gameObject.SetActive(false);
					continue;
				}
				slot.hoverT = Mathf.MoveTowards(slot.hoverT, target, deltaTime * hoverLerpSpeed);
				float num2 = Mathf.SmoothStep(0f, 1f, slot.hoverT);
				float num3 = Mathf.SmoothStep(0f, 1f, slot.presence);
				if (slot.shell != null)
				{
					slot.shell.transform.localScale = slot.shellBaseScale * Mathf.LerpUnclamped(1f, orbHoverScale, num2) * num3;
					Color color = ((slot.item != null) ? slot.item.tint : Color.white);
					slot.shell.GetPropertyBlock(slot.mpb);
					color.a = num3 * Mathf.Lerp(restAlpha, hoverAlpha, num2);
					slot.mpb.SetColor(slot.colorId, color);
					slot.shell.SetPropertyBlock(slot.mpb);
				}
				if (slot.go != null && !slot.taken)
				{
					slot.tr.SetPositionAndRotation(slot.anchor.position, slot.anchor.rotation * Quaternion.Euler(0f, Time.time * 40f, 0f));
					slot.tr.localScale = slot.fittedScale * RigScale() * Mathf.LerpUnclamped(1f, itemHoverScale, num2) * num3;
				}
			}
		}

		private bool PlacePouch()
		{
			if (!Player.HasInstance)
			{
				return false;
			}
			Player instance = Player.Instance;
			Transform transform = ((instance.headCollider != null) ? ((Component)instance.headCollider) : ((Component)instance)).transform;
			Vector3 vector = transform.forward;
			float num = Mathf.Asin(0f - Mathf.Clamp(vector.y, -1f, 1f)) * 57.29578f;
			if (Mathf.Abs(num) > yawOnlyAbovePitch)
			{
				vector = transform.up * Mathf.Sign(num);
			}
			if (vector.x * vector.x + vector.z * vector.z > 1E-06f)
			{
				float num2 = Mathf.Atan2(vector.x, vector.z) * 57.29578f;
				_yaw = (_yawSeeded ? Mathf.LerpAngle(_yaw, num2, 1f - Mathf.Exp((0f - yawFollow) * Time.deltaTime)) : num2);
				_yawSeeded = true;
			}
			float num3 = RigScale();
			Quaternion quaternion = Quaternion.Euler(0f, _yaw, 0f);
			base.transform.SetPositionAndRotation(transform.position + quaternion * (pouchOffset * num3), quaternion);
			int num4 = 0;
			foreach (SlotState slot in _slots)
			{
				if (slot.anchor != null && slot.anchor.gameObject.activeSelf)
				{
					num4++;
				}
			}
			int num5 = 0;
			float num6 = (float)(num4 - 1) * 0.5f;
			foreach (SlotState slot2 in _slots)
			{
				if (!(slot2.anchor == null) && slot2.anchor.gameObject.activeSelf)
				{
					float num7 = ((float)num5 - num6) * slotSpacing;
					float z = (0f - Mathf.Abs(num7)) / Mathf.Max(slotSpacing, 0.001f) * sideCurve;
					slot2.anchor.localPosition = new Vector3(num7, 0f, z) * num3;
					slot2.anchor.localRotation = Quaternion.identity;
					num5++;
				}
			}
			return true;
		}

		private static float RigScale()
		{
			if (!Player.HasInstance)
			{
				return 1f;
			}
			return Mathf.Max(Player.Instance.CurrentScale, 0.1f);
		}

		private static bool AnyHandHolds(SlotState s)
		{
			if (s.la != null && s.la.IsHeld)
			{
				return true;
			}
			return BtmHands.Holding(s.rb) != null;
		}

		public BtmHand HandHolding(Rigidbody rb)
		{
			return BtmHands.Holding(rb);
		}

		private void OnHoverEnter(BtmHand hand)
		{
			hand.Pulse(hoverHapticAmplitude, hoverHapticDuration);
			PlayVoice(hoverSound, hoverVolume);
		}

		private static void HapticNearest(Vector3 pos, float amplitude, float duration)
		{
			BtmHands.Nearest(pos, 0.4f)?.Pulse(amplitude, duration);
		}

		private static void SetWorldScale(Transform t, Vector3 world)
		{
			Vector3 vector = ((t.parent != null) ? t.parent.lossyScale : Vector3.one);
			t.localScale = new Vector3(world.x / NonZero(vector.x), world.y / NonZero(vector.y), world.z / NonZero(vector.z));
		}

		private static float NonZero(float v)
		{
			if (!(Mathf.Abs(v) > 1E-06f))
			{
				return 1f;
			}
			return v;
		}

		private void PlayVoice(AudioClip clip, float volume)
		{
			if (!(clip == null) && !(_voice == null))
			{
				_voice.PlayOneShot(clip, volume);
			}
		}
	}
}
