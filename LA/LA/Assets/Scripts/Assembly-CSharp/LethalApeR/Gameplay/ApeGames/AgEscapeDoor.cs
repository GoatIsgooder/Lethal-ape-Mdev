using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgEscapeDoor : MonoBehaviour
	{
		[Header("Panels (the two leaves)")]
		[SerializeField]
		private Transform leftPanel;

		[SerializeField]
		private Transform rightPanel;

		[Header("Saved poses, capture via the inspector's Edit Mode buttons")]
		[SerializeField]
		private Vector3 leftClosedPos;

		[SerializeField]
		private Vector3 leftClosedEuler;

		[SerializeField]
		private Vector3 leftOpenPos;

		[SerializeField]
		private Vector3 leftOpenEuler;

		[SerializeField]
		private Vector3 rightClosedPos;

		[SerializeField]
		private Vector3 rightClosedEuler;

		[SerializeField]
		private Vector3 rightOpenPos;

		[SerializeField]
		private Vector3 rightOpenEuler;

		[SerializeField]
		[HideInInspector]
		private bool closedPoseSaved;

		[SerializeField]
		[HideInInspector]
		private bool openPoseSaved;

		[Header("Feel")]
		[SerializeField]
		private float openDuration = 1.6f;

		[Header("Audio")]
		[SerializeField]
		private AudioSource openAudio;

		private float _openT;

		private bool _open;

		private bool _openFxPlayed;

		private bool _escapeFxPlayed;

		private BoxCollider _probeBox;

		private float _enableTime;

		private bool _postEnableRecheck;

		private ApeGamesManager _hookedManager;

		private void Awake()
		{
			if (openAudio != null)
			{
				openAudio.spatialize = false;
			}
			_probeBox = GetComponent<BoxCollider>();
			if (_probeBox != null && _probeBox.enabled)
			{
				_probeBox.enabled = false;
			}
			if (!closedPoseSaved)
			{
				if (leftPanel != null)
				{
					leftClosedPos = leftPanel.localPosition;
					leftClosedEuler = leftPanel.localEulerAngles;
				}
				if (rightPanel != null)
				{
					rightClosedPos = rightPanel.localPosition;
					rightClosedEuler = rightPanel.localEulerAngles;
				}
				Debug.LogError("[AgEscapeDoor] CLOSED pose never saved, using the panels' scene placement. Select the door and use ENTER EDIT MODE → Save CLOSED Pose.", this);
			}
			if (!openPoseSaved)
			{
				leftOpenPos = leftClosedPos;
				leftOpenEuler = leftClosedEuler;
				rightOpenPos = rightClosedPos;
				rightOpenEuler = rightClosedEuler;
				Debug.LogError("[AgEscapeDoor] OPEN pose never saved, the door will not visibly move. Select the door and use ENTER EDIT MODE → Save OPEN Pose.", this);
			}
		}

		private void OnEnable()
		{
			TryHook();
			_enableTime = Time.time;
			_postEnableRecheck = true;
			_open = ComputeShouldBeOpen();
			_openFxPlayed = _open;
			_openT = (_open ? 1f : 0f);
			ApplyPanels();
		}

		private void OnDisable()
		{
			Unhook();
			_escapeFxPlayed = false;
		}

		private void TryHook()
		{
			if (!(_hookedManager != null))
			{
				ApeGamesManager instance = ApeGamesManager.Instance;
				if (!(instance == null))
				{
					_hookedManager = instance;
					instance.OnPropsChanged += OnPropsChanged;
				}
			}
		}

		private void Unhook()
		{
			if (!(_hookedManager == null))
			{
				_hookedManager.OnPropsChanged -= OnPropsChanged;
				_hookedManager = null;
			}
		}

		private void OnPropsChanged(AgRoundProperties props)
		{
			bool flag = ComputeShouldBeOpen();
			if (flag == _open)
			{
				return;
			}
			_open = flag;
			if (!flag)
			{
				_openFxPlayed = false;
				return;
			}
			if (Time.time - _enableTime < 2f)
			{
				_openT = 1f;
				_openFxPlayed = true;
				ApplyPanels();
			}
			else if (!_openFxPlayed)
			{
				if (openAudio != null && openAudio.clip != null)
				{
					openAudio.Play();
				}
				AgHaptics.Both(0.5f, 0.4f);
				_openFxPlayed = true;
			}
		}

		private static bool ComputeShouldBeOpen()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null)
			{
				return false;
			}
			AgRoundProperties props = instance.Props;
			if (props == null || props.phase != AgPhase.Round)
			{
				return false;
			}
			if (!instance.TryGetGeneratorProgress(out var powered, out var total))
			{
				return false;
			}
			if (total >= 1)
			{
				return powered == total;
			}
			return false;
		}

		private void Update()
		{
			if (_hookedManager == null)
			{
				TryHook();
			}
			if (_postEnableRecheck)
			{
				_postEnableRecheck = false;
				bool flag = ComputeShouldBeOpen();
				if (flag != _open)
				{
					_open = flag;
					_openFxPlayed = flag;
					_openT = (flag ? 1f : 0f);
					ApplyPanels();
				}
			}
			TryEscapeByHeadProbe();
			float num = (_open ? 1f : 0f);
			if (!Mathf.Approximately(_openT, num))
			{
				_openT = Mathf.MoveTowards(_openT, num, Time.deltaTime / Mathf.Max(0.05f, openDuration));
				ApplyPanels();
			}
		}

		private void ApplyPanels()
		{
			float num = Mathf.SmoothStep(0f, 1f, _openT);
			if (leftPanel != null)
			{
				leftPanel.localPosition = Vector3.Lerp(leftClosedPos, leftOpenPos, num);
				leftPanel.localRotation = Quaternion.Slerp(Quaternion.Euler(leftClosedEuler), Quaternion.Euler(leftOpenEuler), num);
			}
			if (rightPanel != null)
			{
				rightPanel.localPosition = Vector3.Lerp(rightClosedPos, rightOpenPos, num);
				rightPanel.localRotation = Quaternion.Slerp(Quaternion.Euler(rightClosedEuler), Quaternion.Euler(rightOpenEuler), num);
			}
		}

		private void TryEscapeByHeadProbe()
		{
			if (_probeBox == null || _openT < 0.6f)
			{
				return;
			}
			Transform head = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null);
			if (!(head == null))
			{
				Vector3 vector = base.transform.InverseTransformPoint(head.position);
				Vector3 center = _probeBox.center;
				Vector3 size = _probeBox.size;
				if (!(Mathf.Abs(vector.x - center.x) > size.x * 0.5f) && !(Mathf.Abs(vector.y - center.y) > size.y * 0.5f) && !(Mathf.Abs(vector.z - center.z) > size.z * 0.5f))
				{
					TryEscapeLocalHead();
				}
			}
		}

		private void OnTriggerStay(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				TryEscapeLocalHead();
			}
		}

		private void TryEscapeLocalHead()
		{
			if (_openT < 0.6f)
			{
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || !ApeGamesManager.IsLocalAlive())
			{
				return;
			}
			AgRoundProperties props = instance.Props;
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (props == null || props.phase != AgPhase.Round || localPlayer == null || localPlayer.ActorNumber < 1 || props.SeekersContains(localPlayer.ActorNumber) || props.EscapedContains(localPlayer.ActorNumber) || !instance.TryGetGeneratorProgress(out var powered, out var total) || total < 1 || powered < total)
			{
				return;
			}
			if (!_escapeFxPlayed)
			{
				_escapeFxPlayed = true;
				AgHaptics.Both(0.75f, 0.2f);
			}
			instance.RequestHiderEscape();
		}
	}
}
