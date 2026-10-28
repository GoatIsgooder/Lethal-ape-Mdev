using System;
using System.Collections.Generic;
using LethalApeR.Rivals.Economy;
using LethalApeR.Rivals.Weapons;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.Shop
{
	public class WeaponWheel : MonoBehaviour
	{
		public enum PurchaseResult
		{
			NoWeapon = 0,
			AlreadyOwned = 1,
			StoreClosed = 2,
			CantAfford = 3,
			Failed = 4,
			Purchased = 5
		}

		[Header("Rig (wired by the scaffolder)")]
		[Tooltip("Rotates around its local X axis. Gondola pivots are created under it at runtime.")]
		[SerializeField]
		private Transform axle;

		[Tooltip("Shows the focused weapon's display name.")]
		[SerializeField]
		private TMP_Text nameText;

		[Tooltip("Shows the focused weapon's price / OWNED, sits above the buy button.")]
		[SerializeField]
		private TMP_Text priceText;

		[Header("Wheel shape")]
		[Tooltip("Gondola distance from the axle.")]
		public float radius = 1f;

		[Tooltip("Sideways lean off straight-up so the spinning gun reads as a showcase piece (degrees).")]
		public float modelLean = 18f;

		[Header("Showcase spin")]
		[Tooltip("Idle spin of each gun around the vertical axis (degrees/second).")]
		public float spinSpeed = 45f;

		[Tooltip("Per-gondola phase offset so the guns don't twirl in lockstep (degrees).")]
		public float spinPhaseOffset = 40f;

		[Header("Motion")]
		[Tooltip("Spring frequency of the wheel rotation (Hz) — how hard it chases the target.")]
		public float springFrequency = 1.5f;

		[Tooltip("Below 1 the wheel overshoots its stop a touch and swings back — like a real wheel with a bit of slack.")]
		[Range(0.1f, 1f)]
		public float springDamping = 0.5f;

		[Tooltip("Optional pop on the focused gondola. 1 = weapons always at natural size.")]
		public float focusScale = 1f;

		public float focusScaleLerpSpeed = 8f;

		[Header("Price colors")]
		public Color affordableColor = new Color(0.55f, 1f, 0.55f, 1f);

		public Color tooExpensiveColor = new Color(1f, 0.35f, 0.3f, 1f);

		public Color ownedColor = new Color(0.55f, 0.9f, 1f, 1f);

		private readonly Dictionary<WeaponData, GameObject> _displays = new Dictionary<WeaponData, GameObject>();

		private readonly List<WeaponData> _weapons = new List<WeaponData>();

		private readonly List<Transform> _pivots = new List<Transform>();

		private readonly List<Transform> _spinners = new List<Transform>();

		private Transform _shelf;

		private LoadoutSlot _category;

		private int _virtualIndex;

		private float _step;

		private float _angle;

		private float _targetAngle;

		private float _angleVel;

		private float _spinAngle;

		private bool _built;

		public LoadoutSlot CurrentCategory => _category;

		public WeaponData Focused
		{
			get
			{
				if (_weapons.Count <= 0)
				{
					return null;
				}
				return _weapons[FocusedIndex];
			}
		}

		public int FocusedIndex
		{
			get
			{
				if (_weapons.Count <= 0)
				{
					return 0;
				}
				return Mod(_virtualIndex, _weapons.Count);
			}
		}

		public event Action<LoadoutSlot> onCategoryChanged;

		public event Action<WeaponData> onFocusChanged;

		private void Start()
		{
			PreloadAllModels();
			SetCategory(LoadoutSlot.Primary);
		}

		private void OnEnable()
		{
			RivalsEvents.OnCoinsChanged += HandleCoinsChanged;
			RivalsEvents.OnWeaponUnlocked += HandleWeaponUnlocked;
			if (_built)
			{
				RefreshInfo();
			}
		}

		private void OnDisable()
		{
			RivalsEvents.OnCoinsChanged -= HandleCoinsChanged;
			RivalsEvents.OnWeaponUnlocked -= HandleWeaponUnlocked;
		}

		private void HandleCoinsChanged(int _)
		{
			RefreshInfo();
		}

		private void HandleWeaponUnlocked(WeaponData _)
		{
			RefreshInfo();
		}

		private void Update()
		{
			if (axle == null || _weapons.Count == 0)
			{
				return;
			}
			float num = Mathf.Min(Time.deltaTime, 0.05f);
			float num2 = Mathf.Max(springFrequency, 0.1f) * ((float)Math.PI * 2f);
			_angleVel += num * (-2f * springDamping * num2 * _angleVel - num2 * num2 * (_angle - _targetAngle));
			_angle += _angleVel * num;
			axle.localRotation = Quaternion.AngleAxis(_angle, Vector3.right);
			_spinAngle = Mathf.Repeat(_spinAngle + spinSpeed * Time.deltaTime, 360f);
			Quaternion localRotation = Quaternion.AngleAxis(0f - _angle, Vector3.right);
			int focusedIndex = FocusedIndex;
			float t = Mathf.Clamp01(Time.deltaTime * focusScaleLerpSpeed);
			for (int i = 0; i < _weapons.Count && i < _pivots.Count; i++)
			{
				Transform transform = _pivots[i];
				transform.localRotation = localRotation;
				_spinners[i].localRotation = Quaternion.AngleAxis(_spinAngle + spinPhaseOffset * (float)i, Vector3.up);
				float b = ((i == focusedIndex) ? focusScale : 1f);
				transform.localScale = Vector3.one * Mathf.Lerp(transform.localScale.x, b, t);
			}
		}

		public void ScrollDown()
		{
			Scroll(1);
		}

		public void ScrollUp()
		{
			Scroll(-1);
		}

		private void Scroll(int dir)
		{
			if (_weapons.Count != 0)
			{
				_virtualIndex += dir;
				_targetAngle = _step * (float)_virtualIndex;
				RefreshInfo();
				this.onFocusChanged?.Invoke(Focused);
			}
		}

		public void SetCategory(LoadoutSlot slot)
		{
			if (!_built)
			{
				PreloadAllModels();
			}
			_category = slot;
			foreach (KeyValuePair<WeaponData, GameObject> display in _displays)
			{
				GameObject value = display.Value;
				if (!(value == null))
				{
					value.transform.SetParent(_shelf, false);
					value.SetActive(false);
				}
			}
			_weapons.Clear();
			GunUnlocker instance = GunUnlocker.Instance;
			WeaponDatabase weaponDatabase = ((instance != null) ? instance.Database : null);
			if (weaponDatabase != null)
			{
				foreach (WeaponData item in weaponDatabase.ForSlot(slot))
				{
					if (item != null)
					{
						_weapons.Add(item);
					}
				}
			}
			_step = ((_weapons.Count > 0) ? (360f / (float)_weapons.Count) : 360f);
			EnsurePivots(_weapons.Count);
			for (int i = 0; i < _weapons.Count; i++)
			{
				Transform transform = _pivots[i];
				float f = _step * (float)i * ((float)Math.PI / 180f);
				transform.gameObject.SetActive(true);
				transform.localPosition = new Vector3(0f, Mathf.Sin(f) * radius, Mathf.Cos(f) * radius);
				transform.localScale = Vector3.one;
				if (_displays.TryGetValue(_weapons[i], out var value2) && value2 != null)
				{
					value2.transform.SetParent(_spinners[i], false);
					value2.transform.localPosition = Vector3.zero;
					value2.transform.localRotation = Quaternion.Euler(0f, 0f, modelLean) * Quaternion.Euler(-90f, 0f, 0f);
					value2.SetActive(true);
				}
			}
			for (int j = _weapons.Count; j < _pivots.Count; j++)
			{
				_pivots[j].gameObject.SetActive(false);
			}
			_virtualIndex = 0;
			_angle = 0f;
			_targetAngle = 0f;
			_angleVel = 0f;
			if (axle != null)
			{
				axle.localRotation = Quaternion.identity;
			}
			this.onCategoryChanged?.Invoke(slot);
			RefreshInfo();
			this.onFocusChanged?.Invoke(Focused);
		}

		public PurchaseResult TryPurchaseFocused()
		{
			WeaponData focused = Focused;
			if (focused == null)
			{
				return PurchaseResult.NoWeapon;
			}
			GunUnlocker instance = GunUnlocker.Instance;
			if (instance == null)
			{
				return PurchaseResult.Failed;
			}
			if (instance.IsUnlocked(focused))
			{
				return PurchaseResult.AlreadyOwned;
			}
			if (!instance.PurchasingAllowed)
			{
				return PurchaseResult.StoreClosed;
			}
			KeyManager instance2 = KeyManager.Instance;
			if (instance2 != null && !instance2.CanAfford(focused.unlockPrice))
			{
				return PurchaseResult.CantAfford;
			}
			if (!instance.TryUnlock(focused))
			{
				return PurchaseResult.Failed;
			}
			instance.Equip(focused, focused.slot);
			RefreshInfo();
			return PurchaseResult.Purchased;
		}

		private void PreloadAllModels()
		{
			if (_built)
			{
				return;
			}
			if (_shelf == null)
			{
				_shelf = new GameObject("PreloadedModels").transform;
				_shelf.SetParent(base.transform, false);
			}
			GunUnlocker instance = GunUnlocker.Instance;
			WeaponDatabase weaponDatabase = ((instance != null) ? instance.Database : null);
			if (weaponDatabase == null)
			{
				Debug.LogWarning("[WeaponWheel] No GunUnlocker/WeaponDatabase found — wheel will be empty.", this);
				return;
			}
			_built = true;
			foreach (WeaponData weapon in weaponDatabase.Weapons)
			{
				if (weapon == null || _displays.ContainsKey(weapon))
				{
					continue;
				}
				GameObject gameObject = BuildDisplayModel(weapon, _shelf);
				if (gameObject == null)
				{
					Debug.LogWarning("[WeaponWheel] '" + weapon.displayName + "' has no grabbable/model prefab — gondola will be empty.", weapon);
					_displays[weapon] = null;
				}
				else
				{
					gameObject.SetActive(false);
					_displays[weapon] = gameObject;
				}
			}
		}

		private void EnsurePivots(int count)
		{
			while (_pivots.Count < count)
			{
				Transform transform = new GameObject($"Gondola_{_pivots.Count}").transform;
				transform.SetParent((axle != null) ? axle : base.transform, false);
				Transform transform2 = new GameObject("Spinner").transform;
				transform2.SetParent(transform, false);
				_pivots.Add(transform);
				_spinners.Add(transform2);
			}
		}

		private void RefreshInfo()
		{
			WeaponData focused = Focused;
			if (nameText != null)
			{
				nameText.text = ((focused != null) ? focused.displayName : ((_weapons.Count == 0) ? "COMING SOON" : ""));
			}
			if (priceText == null)
			{
				return;
			}
			if (focused == null)
			{
				priceText.text = "";
				return;
			}
			GunUnlocker instance = GunUnlocker.Instance;
			if (instance != null && instance.IsUnlocked(focused))
			{
				priceText.text = "OWNED";
				priceText.color = ownedColor;
				return;
			}
			KeyManager instance2 = KeyManager.Instance;
			bool flag = instance2 != null && !instance2.CanAfford(focused.unlockPrice);
			priceText.text = ((focused.unlockPrice > 0) ? string.Format("{0:N0} KEYS", focused.unlockPrice) : "FREE");
			priceText.color = (flag ? tooExpensiveColor : affordableColor);
		}

		private static GameObject BuildDisplayModel(WeaponData w, Transform shelf)
		{
			GameObject gameObject = ((w.grabbablePrefab != null) ? w.grabbablePrefab : w.modelPrefab);
			if (gameObject == null)
			{
				return null;
			}
			GameObject gameObject2 = UnityEngine.Object.Instantiate(gameObject, shelf);
			gameObject2.name = "Display_" + w.name;
			MonoBehaviour[] componentsInChildren = gameObject2.GetComponentsInChildren<MonoBehaviour>(true);
			foreach (MonoBehaviour monoBehaviour in componentsInChildren)
			{
				if (monoBehaviour != null)
				{
					monoBehaviour.enabled = false;
				}
			}
			Collider[] componentsInChildren2 = gameObject2.GetComponentsInChildren<Collider>(true);
			for (int i = 0; i < componentsInChildren2.Length; i++)
			{
				componentsInChildren2[i].enabled = false;
			}
			Rigidbody[] componentsInChildren3 = gameObject2.GetComponentsInChildren<Rigidbody>(true);
			foreach (Rigidbody obj in componentsInChildren3)
			{
				obj.isKinematic = true;
				obj.detectCollisions = false;
				obj.interpolation = RigidbodyInterpolation.None;
			}
			AudioSource[] componentsInChildren4 = gameObject2.GetComponentsInChildren<AudioSource>(true);
			for (int i = 0; i < componentsInChildren4.Length; i++)
			{
				componentsInChildren4[i].enabled = false;
			}
			Renderer[] componentsInChildren5 = gameObject2.GetComponentsInChildren<Renderer>(true);
			foreach (Renderer renderer in componentsInChildren5)
			{
				if ((!(renderer is MeshRenderer) && !(renderer is SkinnedMeshRenderer)) || !renderer.gameObject.activeInHierarchy)
				{
					renderer.enabled = false;
				}
			}
			TMP_Text[] componentsInChildren6 = gameObject2.GetComponentsInChildren<TMP_Text>(true);
			for (int i = 0; i < componentsInChildren6.Length; i++)
			{
				MeshRenderer component = componentsInChildren6[i].GetComponent<MeshRenderer>();
				if (component != null)
				{
					component.enabled = false;
				}
			}
			gameObject2.transform.localPosition = Vector3.zero;
			gameObject2.transform.localRotation = Quaternion.identity;
			return gameObject2;
		}

		private static int Mod(int v, int n)
		{
			return (v % n + n) % n;
		}
	}
}
