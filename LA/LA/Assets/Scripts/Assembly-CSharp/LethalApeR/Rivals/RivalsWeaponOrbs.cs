using System;
using System.Collections.Generic;
using LALocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Rivals.Weapons;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR;

namespace LethalApeR.Rivals
{
	public class RivalsWeaponOrbs : MonoBehaviour
	{
		[Serializable]
		public class OrbDef
		{
			[Tooltip("Slot this orb holds.")]
			public LoadoutSlot slot;

			[Tooltip("The orb transform (your pouch visual, parented near the chest). The weapon floats at its center.")]
			public Transform anchor;

			[Tooltip("The weapon is uniformly shrunk so its longest side fits this many meters. Ignored when Fixed Scale is set.")]
			public float fitDiameter = 0.12f;

			[Tooltip("> 0 = skip auto-fit and multiply the prefab's scale by exactly this (e.g. 0.1). Use when auto-fit picks a bad size.")]
			public float fixedScale;
		}

		private class OrbItem
		{
			public OrbDef def;

			public GameObject go;

			public Transform tr;

			public Rigidbody rb;

			public Grabbable grabbable;

			public UnityAction grabAction;

			public Collider[] colliders;

			public bool[] wasTrigger;

			public bool savedKinematic;

			public bool savedGravity;

			public RigidbodyInterpolation savedInterpolation;

			public Vector3 fullScale;

			public Vector3 fittedScale;

			public bool taken;
		}

		private class OrbVisual
		{
			public OrbDef def;

			public Renderer rend;

			public Transform tr;

			public Vector3 baseScale;

			public Color baseColor;

			public bool hasColor;

			public MaterialPropertyBlock mpb;

			public float hoverT;

			public bool[] handHover = new bool[8];
		}

		[Header("Orbs")]
		public List<OrbDef> orbs = new List<OrbDef>();

		[Header("Hover feel")]
		[Tooltip("Palm distance from the orb center that counts as hovering.")]
		public float hoverRadius = 0.11f;

		[Tooltip("Weapon scale boost while hovered (1.12 = +12%).")]
		public float hoverScale = 1.12f;

		[Tooltip("Orb visual scale boost while hovered.")]
		public float orbHoverScale = 1.18f;

		[Tooltip("How fast scale/color ease between rest and hovered.")]
		public float hoverLerpSpeed = 14f;

		[Range(0f, 1f)]
		public float hoverHapticAmplitude = 0.2f;

		public float hoverHapticDuration = 0.02f;

		[Tooltip("Played at the orb when a palm starts hovering it (3D, same path as grab sounds).")]
		public AudioClip hoverSound;

		[Range(0f, 2f)]
		public float hoverSoundVolume = 1f;

		[Header("Orb visual (per-orb tint via MaterialPropertyBlock)")]
		[Tooltip("Orb color while hovered. Rest color is taken from the material itself.")]
		public Color hoverColor = new Color(0.35f, 1f, 0.65f, 0.8f);

		[Tooltip("Color property driven on the orb's material (OrbShell + Standard both use _Color).")]
		public string colorProperty = "_Color";

		[Header("Holster (putting a weapon back)")]
		[Tooltip("ON: dropping a weapon ANYWHERE returns it straight to its orb. OFF: it only returns when released within Holster Radius of the orb.")]
		public bool returnOnAnyDrop = true;

		[Tooltip("Only used when Return On Any Drop is OFF — how close the weapon must be to its orb's center to snap back in once released.")]
		public float holsterRadius = 0.16f;

		[Range(0f, 1f)]
		public float holsterHapticAmplitude = 0.35f;

		public float holsterHapticDuration = 0.04f;

		[Header("Events")]
		public UnityEvent onWeaponTaken;

		public UnityEvent onWeaponHolstered;

		private readonly List<OrbItem> _items = new List<OrbItem>();

		private readonly List<OrbVisual> _visuals = new List<OrbVisual>();

		private readonly List<GameObject> _spawned = new List<GameObject>();

		private GrabInteractor[] _hands;

		private float _nextHandScan;

		public static RivalsWeaponOrbs Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
				return;
			}
			Instance = this;
		}

		private void Start()
		{
			foreach (OrbDef def in orbs)
			{
				if (def == null || def.anchor == null)
				{
					continue;
				}
				OrbVisual orbVisual = new OrbVisual();
				orbVisual.def = def;
				orbVisual.rend = def.anchor.GetComponentInChildren<Renderer>(true);
				orbVisual.mpb = new MaterialPropertyBlock();
				orbVisual.tr = ((orbVisual.rend != null) ? orbVisual.rend.transform : def.anchor);
				orbVisual.baseScale = orbVisual.tr.localScale;
				if (orbVisual.rend != null && orbVisual.rend.sharedMaterial != null && orbVisual.rend.sharedMaterial.HasProperty(colorProperty))
				{
					orbVisual.hasColor = true;
					orbVisual.baseColor = orbVisual.rend.sharedMaterial.GetColor(colorProperty);
				}
				_visuals.Add(orbVisual);
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void StockFromLoadout(GunUnlocker gun)
		{
			if (gun == null)
			{
				return;
			}
			foreach (OrbDef def in orbs)
			{
				if (def != null && !(def.anchor == null) && FindItem(def) == null)
				{
					WeaponData equipped = gun.GetEquipped(def.slot);
					if (equipped != null)
					{
						Stock(def, equipped);
					}
				}
			}
		}

		public void ClearAll()
		{
			foreach (OrbItem item in _items)
			{
				Unhook(item);
			}
			_items.Clear();
			foreach (GameObject item2 in _spawned)
			{
				if (item2 != null)
				{
					ForceDropIfHeld(item2);
					UnityEngine.Object.Destroy(item2);
				}
			}
			_spawned.Clear();
		}

		public static void ForceDropIfHeld(GameObject go)
		{
			if (go == null)
			{
				return;
			}
			Transform root = go.transform;
			Rigidbody[] componentsInChildren = go.GetComponentsInChildren<Rigidbody>(true);
			GrabInteractor[] array = UnityEngine.Object.FindObjectsOfType<GrabInteractor>();
			for (int i = 0; i < array.Length; i++)
			{
				GrabInteractor grabInteractor = array[i];
				if (grabInteractor == null || !grabInteractor.IsGrabbing)
				{
					continue;
				}
				bool held = false;
				if (grabInteractor.HeldRigidbody != null)
				{
					for (int j = 0; j < componentsInChildren.Length; j++)
					{
						if (grabInteractor.HeldRigidbody == componentsInChildren[j])
						{
							held = true;
							break;
						}
					}
				}
				if (!held && grabInteractor.HeldTransform != null && (grabInteractor.HeldTransform == root || grabInteractor.HeldTransform.IsChildOf(root)))
				{
					held = true;
				}
				if (held)
				{
					grabInteractor.ForceRelease();
				}
			}
			LAGrabbable[] componentsInChildren2 = go.GetComponentsInChildren<LAGrabbable>(true);
			foreach (LAGrabbable lAGrabbable in componentsInChildren2)
			{
				if (lAGrabbable.IsHeld)
				{
					lAGrabbable.Drop();
				}
			}
		}

		private void Stock(OrbDef def, WeaponData data)
		{
			GameObject prefab = ((data.grabbablePrefab != null) ? data.grabbablePrefab : data.modelPrefab);
			if (prefab == null)
			{
				Debug.LogWarning("[RivalsWeaponOrbs] '" + data.name + "' has no grabbablePrefab/modelPrefab — orb stays empty.");
				return;
			}
			if (data.grabbablePrefab == null)
			{
				Debug.LogWarning("[RivalsWeaponOrbs] '" + data.name + "' falling back to modelPrefab — assign grabbablePrefab for a working gun.");
			}
			GameObject go = UnityEngine.Object.Instantiate(prefab, def.anchor.position, def.anchor.rotation);
			OrbItem item = new OrbItem
			{
				def = def,
				go = go,
				tr = go.transform,
				rb = go.GetComponentInChildren<Rigidbody>(),
				grabbable = go.GetComponentInChildren<Grabbable>(),
				fullScale = go.transform.localScale
			};
			float scale;
			if (def.fixedScale > 0f)
			{
				scale = def.fixedScale;
			}
			else
			{
				Renderer[] componentsInChildren = go.GetComponentsInChildren<Renderer>(true);
				Bounds bounds = new Bounds(def.anchor.position, Vector3.zero);
				bool has = false;
				foreach (Renderer renderer in componentsInChildren)
				{
					if (!(renderer == null) && renderer.enabled && renderer.gameObject.activeInHierarchy && (renderer is MeshRenderer || renderer is SkinnedMeshRenderer))
					{
						if (has)
						{
							bounds.Encapsulate(renderer.bounds);
						}
						else
						{
							bounds = renderer.bounds;
						}
						has = true;
					}
				}
				scale = 1f;
				if (has)
				{
					float longest = Mathf.Max(bounds.size.x, bounds.size.y, bounds.size.z);
					if (longest > 0.0001f)
					{
						scale = Mathf.Clamp(def.fitDiameter / longest, 0.02f, 1f);
					}
				}
			}
			item.fittedScale = item.fullScale * scale;
			Freeze(item);
			if (item.grabbable != null)
			{
				item.grabAction = delegate
				{
					OnGrabbed(item);
				};
				item.grabbable.onGrab.AddListener(item.grabAction);
			}
			else
			{
				Debug.LogWarning("[RivalsWeaponOrbs] '" + go.name + "' has no Grabbable — relying on the per-frame held poll (grab alignment may be slightly off).");
			}
			_items.Add(item);
			_spawned.Add(go);
		}

		private void Freeze(OrbItem item)
		{
			if (item.go == null)
			{
				return;
			}
			item.tr.localScale = item.fittedScale;
			if (item.rb != null)
			{
				item.savedKinematic = item.rb.isKinematic;
				item.savedGravity = item.rb.useGravity;
				item.savedInterpolation = item.rb.interpolation;
				item.rb.isKinematic = true;
				item.rb.interpolation = RigidbodyInterpolation.None;
			}
			item.colliders = item.go.GetComponentsInChildren<Collider>(true);
			item.wasTrigger = new bool[item.colliders.Length];
			for (int i = 0; i < item.colliders.Length; i++)
			{
				item.wasTrigger[i] = item.colliders[i].isTrigger;
				item.colliders[i].isTrigger = true;
			}
			item.tr.SetPositionAndRotation(item.def.anchor.position, item.def.anchor.rotation);
			item.taken = false;
		}

		private void OnGrabbed(OrbItem item)
		{
			if (item.taken || item.go == null)
			{
				return;
			}
			item.taken = true;
			item.tr.localScale = item.fullScale;
			if (item.colliders != null)
			{
				for (int i = 0; i < item.colliders.Length; i++)
				{
					if (item.colliders[i] != null)
					{
						item.colliders[i].isTrigger = item.wasTrigger[i];
					}
				}
			}
			if (item.rb != null)
			{
				item.rb.isKinematic = item.savedKinematic;
				item.rb.useGravity = item.savedGravity;
				item.rb.interpolation = item.savedInterpolation;
			}
			onWeaponTaken?.Invoke();
		}

		private void TryHolster(OrbItem item)
		{
			if (!(item.go == null) && !(item.def.anchor == null) && !AnyHandHolds(item.rb) && (returnOnAnyDrop || !((item.tr.position - item.def.anchor.position).sqrMagnitude > holsterRadius * holsterRadius)))
			{
				Freeze(item);
				HapticNearestHand(item.def.anchor.position, holsterHapticAmplitude, holsterHapticDuration);
				onWeaponHolstered?.Invoke();
			}
		}

		private void Unhook(OrbItem item)
		{
			if (item.grabbable != null && item.grabAction != null)
			{
				item.grabbable.onGrab.RemoveListener(item.grabAction);
			}
			item.grabAction = null;
		}

		private void Update()
		{
			for (int num = _items.Count - 1; num >= 0; num--)
			{
				OrbItem orbItem = _items[num];
				if (orbItem.go == null)
				{
					Unhook(orbItem);
					_items.RemoveAt(num);
				}
				else if (orbItem.taken)
				{
					TryHolster(orbItem);
				}
				else if (orbItem.grabbable == null && AnyHandHolds(orbItem.rb))
				{
					OnGrabbed(orbItem);
				}
			}
		}

		private void LateUpdate()
		{
			GrabInteractor[] array = Hands();
			foreach (OrbVisual visual in _visuals)
			{
				if (visual.def.anchor == null)
				{
					continue;
				}
				bool any = false;
				for (int i = 0; i < array.Length && i < visual.handHover.Length; i++)
				{
					GrabInteractor grabInteractor = array[i];
					if (!(grabInteractor == null))
					{
						Vector3 palmPos = ((grabInteractor.palm != null) ? grabInteractor.palm.position : grabInteractor.transform.position);
						bool inside = (palmPos - visual.def.anchor.position).sqrMagnitude <= hoverRadius * hoverRadius;
						if (inside && !visual.handHover[i])
						{
							OnHoverEnter(grabInteractor, visual.def.anchor.position);
						}
						visual.handHover[i] = inside;
						any |= inside;
					}
				}
				visual.hoverT = Mathf.MoveTowards(visual.hoverT, any ? 1f : 0f, hoverLerpSpeed * Time.deltaTime);
				float e = Mathf.SmoothStep(0f, 1f, visual.hoverT);
				visual.tr.localScale = visual.baseScale * (1f + (orbHoverScale - 1f) * e);
				if (visual.hasColor && visual.rend != null)
				{
					visual.rend.GetPropertyBlock(visual.mpb);
					visual.mpb.SetColor(colorProperty, Color.Lerp(visual.baseColor, hoverColor, e));
					visual.rend.SetPropertyBlock(visual.mpb);
				}
			}
			foreach (OrbItem item in _items)
			{
				if (!item.taken && !(item.go == null) && !(item.def.anchor == null))
				{
					item.tr.SetPositionAndRotation(item.def.anchor.position, item.def.anchor.rotation);
					OrbVisual orbVisual = FindVisual(item.def);
					float e2 = ((orbVisual != null) ? Mathf.SmoothStep(0f, 1f, orbVisual.hoverT) : 0f);
					item.tr.localScale = item.fittedScale * (1f + (hoverScale - 1f) * e2);
				}
			}
		}

		private OrbItem FindItem(OrbDef def)
		{
			foreach (OrbItem item in _items)
			{
				if (item.def == def)
				{
					return item;
				}
			}
			return null;
		}

		private OrbVisual FindVisual(OrbDef def)
		{
			foreach (OrbVisual visual in _visuals)
			{
				if (visual.def == def)
				{
					return visual;
				}
			}
			return null;
		}

		private bool AnyHandHolds(Rigidbody rb)
		{
			if (rb == null)
			{
				return false;
			}
			GrabInteractor[] array = Hands();
			foreach (GrabInteractor grabInteractor in array)
			{
				if (grabInteractor != null && grabInteractor.HeldRigidbody == rb)
				{
					return true;
				}
			}
			return false;
		}

		private void OnHoverEnter(GrabInteractor hand, Vector3 orbPos)
		{
			if (hoverHapticAmplitude > 0f && hoverHapticDuration > 0f)
			{
				Pulse(hand, hoverHapticAmplitude, hoverHapticDuration);
			}
			if (hoverSound != null && hoverSoundVolume > 0f)
			{
				AudioSource.PlayClipAtPoint(hoverSound, orbPos, hoverSoundVolume);
			}
		}

		private void HapticNearestHand(Vector3 pos, float amplitude, float duration)
		{
			GrabInteractor[] array = Hands();
			GrabInteractor nearest = null;
			float best = 0.4f * 0.4f;
			foreach (GrabInteractor grabInteractor in array)
			{
				if (!(grabInteractor == null))
				{
					float sqr = (((grabInteractor.palm != null) ? grabInteractor.palm : grabInteractor.transform).position - pos).sqrMagnitude;
					if (sqr < best)
					{
						best = sqr;
						nearest = grabInteractor;
					}
				}
			}
			if (nearest != null)
			{
				Pulse(nearest, amplitude, duration);
			}
		}

		private static void Pulse(GrabInteractor hand, float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null) && !(amplitude <= 0f) && !(duration <= 0f))
			{
				if (hand.node == XRNode.LeftHand)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		private GrabInteractor[] Hands()
		{
			if (_hands == null || _hands.Length == 0 || Time.time >= _nextHandScan)
			{
				bool stale = _hands == null || _hands.Length == 0;
				if (!stale)
				{
					GrabInteractor[] hands = _hands;
					for (int i = 0; i < hands.Length; i++)
					{
						if (hands[i] == null)
						{
							stale = true;
							break;
						}
					}
				}
				if (stale)
				{
					_hands = UnityEngine.Object.FindObjectsOfType<GrabInteractor>();
				}
				_nextHandScan = Time.time + 2f;
			}
			return _hands ?? Array.Empty<GrabInteractor>();
		}

		private void OnDrawGizmosSelected()
		{
			foreach (OrbDef orb in orbs)
			{
				if (orb != null && !(orb.anchor == null))
				{
					Gizmos.color = new Color(0.3f, 0.9f, 1f, 0.8f);
					Gizmos.DrawWireSphere(orb.anchor.position, hoverRadius);
					Gizmos.color = new Color(0.3f, 1f, 0.5f, 0.5f);
					Gizmos.DrawWireSphere(orb.anchor.position, holsterRadius);
				}
			}
		}
	}
}
