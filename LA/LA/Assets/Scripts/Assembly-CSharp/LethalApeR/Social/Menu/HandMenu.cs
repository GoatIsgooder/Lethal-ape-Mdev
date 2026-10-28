using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using LethalApeR.Social.UI;
using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Social.Menu
{
	public sealed class HandMenu : MonoBehaviour
	{
		public const string ResourcePath = "Systems/HandMenu";

		private const int TabAudio = 0;

		private const int TabPlayers = 1;

		[Header("Parts")]
		[SerializeField]
		private RectTransform panel;

		[SerializeField]
		private CanvasGroup group;

		[SerializeField]
		private HandMenuPanel rayTarget;

		[SerializeField]
		private SocialButton close;

		[SerializeField]
		private SocialButton[] tabs = new SocialButton[3];

		[SerializeField]
		private GameObject[] pages = new GameObject[3];

		[SerializeField]
		private MenuPlayersPage playersPage;

		[SerializeField]
		private RectTransform countChip;

		[SerializeField]
		private TMP_Text countLabel;

		[Tooltip("Our own pointer, used only when the scene doesn't already have a BtmRayPointer (BeTheMonster does).")]
		[SerializeField]
		private GameObject pointer;

		[Header("Placement")]
		[SerializeField]
		private float distance = 0.5f;

		[SerializeField]
		private float drop = 0.12f;

		[SerializeField]
		private float nearest = 0.3f;

		[Tooltip("Degrees you can turn before the menu starts gliding back in front of you.")]
		[SerializeField]
		private float followAngle = 18f;

		[Tooltip("Metres you can move before the menu starts following.")]
		[SerializeField]
		private float followDistance = 0.12f;

		[Tooltip("Seconds the glide takes to catch up. Higher is lazier.")]
		[SerializeField]
		private float followTime = 0.28f;

		[Header("Motion")]
		[SerializeField]
		private float openSeconds = 0.18f;

		[SerializeField]
		private float closeSeconds = 0.12f;

		[SerializeField]
		private float stickScrollSpeed = 900f;

		private static HandMenu _instance;

		private bool _open;

		private float _t;

		private bool _wasPressed;

		private int _tab = -1;

		private Vector3 _targetPos;

		private Quaternion _targetRot;

		private Vector3 _followVelocity;

		private bool _following;

		private bool _collected;

		private int _countShown = -1;

		private int _capacityShown = -1;

		[SerializeField]
		[HideInInspector]
		private float panelScale = 0.0005f;

		private const float TeleportDistance = 3f;

		public static bool IsOpen
		{
			get
			{
				if (_instance != null)
				{
					return _instance._open;
				}
				return false;
			}
		}

		private float PanelScale => panelScale;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Boot()
		{
			if (!(_instance != null))
			{
				HandMenu handMenu = Resources.Load<HandMenu>(ResourcePath);
				if (handMenu == null)
				{
					Debug.LogWarning("[Social] Resources/Systems/HandMenu is missing: no hand menu. Run Slop > Social > Build Social UI.");
					return;
				}
				_instance = Object.Instantiate(handMenu);
				_instance.name = "[Social] Hand Menu";
				Object.DontDestroyOnLoad(_instance.gameObject);
			}
		}

		private void Awake()
		{
			close.Pressed += Close;
			for (int i = 0; i < tabs.Length; i++)
			{
				int index = i;
				tabs[i].Pressed += delegate
				{
					Select(index);
				};
			}
			panel.gameObject.SetActive(false);
			if (pointer != null)
			{
				pointer.SetActive(false);
			}
		}

		private void OnEnable()
		{
			SceneManager.sceneLoaded += OnSceneLoaded;
		}

		private void OnDisable()
		{
			SceneManager.sceneLoaded -= OnSceneLoaded;
		}

		private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			if (_open)
			{
				Close();
				_t = 0f;
				panel.gameObject.SetActive(false);
			}
		}

		private void Update()
		{
			ReadInput();
			if (!_open && _t <= 0f)
			{
				return;
			}
			Animate();
			if (_open)
			{
				Transform transform = Head();
				if (!(transform == null))
				{
					Follow(transform);
					UpdateCount();
					ScrollWithStick();
				}
			}
		}

		private void ReadInput()
		{
			VRInputController instance = VRInputController.Instance;
			bool flag = instance != null && instance.LeftMenuButton;
			if (flag && !_wasPressed)
			{
				Toggle();
			}
			_wasPressed = flag;
		}

		public void Toggle()
		{
			if (_open)
			{
				Close();
			}
			else
			{
				Open();
			}
		}

		public void Open()
		{
			Transform transform = Head();
			if (transform == null || _open)
			{
				return;
			}
			_open = true;
			if (!panel.gameObject.activeSelf)
			{
				panel.gameObject.SetActive(true);
			}
			if (!_collected)
			{
				_collected = true;
				rayTarget.Collect();
			}
			Place(transform, out _targetPos, out _targetRot);
			base.transform.SetPositionAndRotation(_targetPos, _targetRot);
			_following = false;
			_followVelocity = Vector3.zero;
			if (_tab < 0)
			{
				Select(0);
			}
			else
			{
				RefreshTabs();
			}
			if (pointer != null)
			{
				pointer.SetActive(!OtherPointerExists());
			}
			rayTarget.Register();
			SocialAssets instance = SocialAssets.Instance;
			if (instance != null)
			{
				SocialStyle.Play(instance.menuOpenClip, 0.7f);
			}
		}

		public void Close()
		{
			if (_open)
			{
				_open = false;
				rayTarget.Interactive = false;
				rayTarget.Unregister();
				if (pointer != null)
				{
					pointer.SetActive(false);
				}
				SocialAssets instance = SocialAssets.Instance;
				if (instance != null)
				{
					SocialStyle.Play(instance.menuCloseClip, 0.5f);
				}
			}
		}

		private void Select(int index)
		{
			_tab = index;
			RefreshTabs();
			_countShown = -1;
		}

		private void RefreshTabs()
		{
			for (int i = 0; i < pages.Length; i++)
			{
				if (pages[i].activeSelf != (i == _tab))
				{
					pages[i].SetActive(i == _tab);
				}
				tabs[i].SetLook((i == _tab) ? ButtonLook.TabSelected : ButtonLook.Tab);
			}
			countChip.gameObject.SetActive(_tab == 1);
		}

		private void Animate()
		{
			float num = Time.unscaledDeltaTime / (_open ? openSeconds : closeSeconds);
			_t = Mathf.Clamp01(_t + (_open ? num : (0f - num)));
			float num2;
			float y;
			float num3;
			if (_open)
			{
				float num4 = EaseAt(_t);
				num2 = ((_t < 0.7f) ? Mathf.Lerp(0.9f, 1.015f, num4 / 0.973f) : Mathf.Lerp(1.015f, 1f, (_t - 0.7f) / 0.3f));
				y = Mathf.Lerp(-0.007f, 0f, num4);
				num3 = Mathf.Clamp01(_t / 0.7f);
			}
			else
			{
				float num5 = 1f - _t;
				num2 = Mathf.Lerp(1f, 0.95f, num5 * num5);
				y = Mathf.Lerp(0f, -0.003f, num5);
				num3 = _t;
			}
			panel.localScale = Vector3.one * num2 * PanelScale;
			panel.localPosition = new Vector3(0f, y, 0f);
			if (!Mathf.Approximately(group.alpha, num3))
			{
				group.alpha = num3;
			}
			if (_open)
			{
				rayTarget.Interactive = _t >= 1f;
				return;
			}
			rayTarget.Interactive = false;
			if (_t <= 0f)
			{
				panel.gameObject.SetActive(false);
			}
		}

		private static float EaseAt(float t)
		{
			float num = 1f - t;
			return 1f - num * num * num;
		}

		private void Place(Transform head, out Vector3 position, out Quaternion rotation)
		{
			RaycastHit hitInfo = default(RaycastHit);
			Vector3 forward = head.forward;
			forward.y = 0f;
			if (forward.sqrMagnitude < 0.0001f)
			{
				forward = Vector3.ProjectOnPlane(head.up, Vector3.up);
			}
			forward.Normalize();
			position = head.position + forward * distance + Vector3.down * drop;
			Vector3 vector = position - head.position;
			float magnitude = vector.magnitude;
			Vector3 vector2 = vector / magnitude;
			if (Physics.Raycast(head.position, vector2, out hitInfo, magnitude, 1, QueryTriggerInteraction.Ignore))
			{
				position = head.position + vector2 * Mathf.Max(nearest, hitInfo.distance - 0.06f);
			}
			rotation = Quaternion.LookRotation(position - head.position, Vector3.up);
		}

		private void Follow(Transform head)
		{
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			Place(head, out _targetPos, out _targetRot);
			Vector3 from = base.transform.position - head.position;
			from.y = 0f;
			Vector3 to = _targetPos - head.position;
			to.y = 0f;
			float num = 0f;
			if (from.sqrMagnitude > 0.0001f && to.sqrMagnitude > 0.0001f)
			{
				num = Vector3.Angle(from, to);
			}
			float num2 = Vector3.Distance(base.transform.position, _targetPos);
			if (num2 > 3f)
			{
				base.transform.SetPositionAndRotation(_targetPos, _targetRot);
				_following = false;
				_followVelocity = Vector3.zero;
				return;
			}
			if (!_following)
			{
				if (!(num > followAngle) && !(num2 > followDistance))
				{
					Quaternion b = Quaternion.LookRotation(base.transform.position - head.position, Vector3.up);
					base.transform.rotation = Quaternion.Slerp(base.transform.rotation, b, 1f - Mathf.Exp((0f - unscaledDeltaTime) / 0.3f));
					return;
				}
				_following = true;
			}
			base.transform.position = Vector3.SmoothDamp(base.transform.position, _targetPos, ref _followVelocity, followTime, float.PositiveInfinity, unscaledDeltaTime);
			base.transform.rotation = Quaternion.Slerp(base.transform.rotation, _targetRot, 1f - Mathf.Exp((0f - unscaledDeltaTime) / (followTime * 0.5f)));
			if (num < 1.5f && num2 < 0.01f)
			{
				_following = false;
				_followVelocity = Vector3.zero;
			}
		}

		private static Transform Head()
		{
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (!(manager != null))
			{
				return null;
			}
			return manager.Head;
		}

		private static bool OtherPointerExists()
		{
			BtmRayPointer[] array = Object.FindObjectsByType<BtmRayPointer>(FindObjectsSortMode.None);
			foreach (BtmRayPointer btmRayPointer in array)
			{
				if (_instance == null || !btmRayPointer.transform.IsChildOf(_instance.transform))
				{
					return true;
				}
			}
			return false;
		}

		private void UpdateCount()
		{
			if (_tab != 1)
			{
				return;
			}
			int playerCount = SocialRoster.PlayerCount;
			int capacity = SocialRoster.Capacity;
			if (playerCount != _countShown || capacity != _capacityShown)
			{
				_countShown = playerCount;
				_capacityShown = capacity;
				countLabel.text = (PhotonNetwork.InRoom ? ((capacity > 0) ? (playerCount + "/" + capacity) : playerCount.ToString()) : "OFFLINE");
				float x = countLabel.GetPreferredValues(countLabel.text).x;
				countChip.sizeDelta = new Vector2(x + 22f, countChip.sizeDelta.y);
			}
		}

		private void ScrollWithStick()
		{
			if (_tab != 1 || !rayTarget.Hovered || playersPage == null)
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				float num = ((Mathf.Abs(instance.LeftJoystick.y) > Mathf.Abs(instance.RightJoystick.y)) ? instance.LeftJoystick.y : instance.RightJoystick.y);
				if (!(Mathf.Abs(num) < 0.2f))
				{
					playersPage.List.Glide((0f - num) * stickScrollSpeed);
				}
			}
		}
	}
}
