using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgSpectateViewport : MonoBehaviourPunCallbacks
	{
		public Camera povCamera;

		public TMP_Text targetNameText;

		public List<AgNetSync> targets = new List<AgNetSync>();

		public AgNetSync tracked;

		public float viewDistance = 14f;

		public float viewAngle = 110f;

		public float renderFps = 36f;

		public float spectateFarClip;

		public GameObject spectateScreen;

		private const float GateInterval = 0.25f;

		private bool _active;

		private bool _hooked;

		private bool _cameraOn;

		private bool _cameraConfigured;

		private bool _screenOwnsCamera;

		private bool _localAliveCached = true;

		private float _nextRender;

		private float _nextGateCheck;

		private string _lastLabel;

		public int TrackedActor => tracked != null ? tracked.ActorNumber : -1;

		public bool IsActive => _active;

		public bool IsCameraOn => _cameraOn;

		public bool LocalAlive => ApeGamesManager.IsLocalAlive();

		public int RosterCount => AgNetSync.RegisteredCount;

		public int AliveCount
		{
			get
			{
				if (ApeGamesManager.Instance != null && ApeGamesManager.Instance.Props != null && ApeGamesManager.Instance.Props.alive != null)
				{
					return ApeGamesManager.Instance.Props.alive.Length;
				}
				return -1;
			}
		}

		public string PhaseLabel
		{
			get
			{
				if (ApeGamesManager.Instance != null)
				{
					AgRoundProperties props = ApeGamesManager.Instance.Props;
					if (props != null)
					{
						if (props.queue == "ApeGames")
						{
							return props.phase.ToString();
						}
						return "queue '" + props.queue + "'";
					}
				}
				return "no manager";
			}
		}

		public float HeadDistance
		{
			get
			{
				Transform head = MonkeDevNetworkingManager.Manager != null ? MonkeDevNetworkingManager.Manager.Head : null;
				if (head != null)
				{
					return Vector3.Distance(head.position, transform.position);
				}
				return -1f;
			}
		}

		private void Start()
		{
			ValidateWiring();
			ConfigureCamera();
			SetCameraActive(false);
			Hook();
		}

		private void ValidateWiring()
		{
			if (povCamera == null)
			{
				Debug.LogError("AgSpectateViewport on '" + name + "' has no povCamera assigned; this board can never render.", this);
				return;
			}
			if (povCamera.targetTexture == null)
			{
				Debug.LogError("AgSpectateViewport on '" + name + "': povCamera has no targetTexture, the board will stay blank.", this);
			}
			if (spectateScreen == null)
			{
				return;
			}
			if (spectateScreen == povCamera.gameObject || povCamera.transform.IsChildOf(spectateScreen.transform))
			{
				_screenOwnsCamera = true;
				if (!spectateScreen.activeSelf)
				{
					spectateScreen.SetActive(true);
				}
			}
		}

		private void ConfigureCamera()
		{
			if (povCamera == null || _cameraConfigured)
			{
				return;
			}
			_cameraConfigured = true;
			povCamera.enabled = false;
			povCamera.stereoTargetEye = StereoTargetEyeMask.None;
			povCamera.allowHDR = false;
			povCamera.allowMSAA = false;
			povCamera.useOcclusionCulling = true;
			if (spectateFarClip > 0f)
			{
				povCamera.farClipPlane = spectateFarClip;
			}
		}

		private void SetCameraActive(bool on)
		{
			if (povCamera == null)
			{
				return;
			}
			GameObject cameraObject = povCamera.gameObject;
			if (on)
			{
				ConfigureCamera();
			}
			if (cameraObject.activeSelf != on)
			{
				cameraObject.SetActive(on);
			}
			_cameraOn = on;
		}

		public override void OnEnable()
		{
			base.OnEnable();
			Hook();
			_nextGateCheck = 0f;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			Unhook();
			Deactivate();
		}

		private void Hook()
		{
			if (_hooked || ApeGamesManager.Instance == null)
			{
				return;
			}
			_hooked = true;
			ApeGamesManager.Instance.OnRoundStartedEvent += OnRoundStarted;
			ApeGamesManager.Instance.OnRoundEndedEvent += OnRoundEnded;
			ApeGamesManager.Instance.OnMatchEnded += OnMatchEnded;
			ApeGamesManager.Instance.OnPropsChanged += OnPropsChanged;
			ApeGamesManager.Instance.OnLocalEliminated += OnLocalEliminated;
			_localAliveCached = ApeGamesManager.IsLocalAlive();
		}

		private void Unhook()
		{
			if (!_hooked)
			{
				return;
			}
			_hooked = false;
			if (ApeGamesManager.Instance == null)
			{
				return;
			}
			ApeGamesManager.Instance.OnRoundStartedEvent -= OnRoundStarted;
			ApeGamesManager.Instance.OnRoundEndedEvent -= OnRoundEnded;
			ApeGamesManager.Instance.OnMatchEnded -= OnMatchEnded;
			ApeGamesManager.Instance.OnPropsChanged -= OnPropsChanged;
			ApeGamesManager.Instance.OnLocalEliminated -= OnLocalEliminated;
		}

		private void OnLocalEliminated()
		{
			_localAliveCached = false;
			if (ApeGamesManager.Instance != null)
			{
				Rebuild(ApeGamesManager.Instance.Props);
			}
			_nextGateCheck = Time.unscaledTime + 0.25f;
			SetCameraActive(ShouldSpectate());
			if (_cameraOn)
			{
				RenderOnce();
			}
		}

		private void OnRoundStarted(int round, AgRoundProperties p)
		{
			SetScreenActive(true);
			Rebuild(p);
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			SetScreenActive(IsWatchableWindow(p));
			Rebuild(p);
		}

		private void OnRoundEnded(int round, AgRoundProperties p)
		{
			SetScreenActive(IsWatchableWindow(p));
			Rebuild(p);
		}

		private static bool IsWatchableWindow(AgRoundProperties p)
		{
			if (p != null && p.queue == "ApeGames")
			{
				if (p.phase != AgPhase.Round)
				{
					return p.phase == AgPhase.Intermission;
				}
				return true;
			}
			return false;
		}

		private void OnMatchEnded(int[] winners)
		{
			Deactivate();
		}

		public override void OnJoinedRoom()
		{
			if (AgProps.TryRead(out var p))
			{
				Rebuild(p);
			}
		}

		public override void OnLeftRoom()
		{
			Deactivate();
		}

		private void Rebuild(AgRoundProperties p)
		{
			if (p == null || p.queue != "ApeGames" || p.alive == null || (p.phase != AgPhase.Round && p.phase != AgPhase.Intermission))
			{
				Deactivate();
				return;
			}
			bool wasActive = _active;
			_active = true;
			targets.Clear();
			int localActor = PhotonNetwork.LocalPlayer != null ? PhotonNetwork.LocalPlayer.ActorNumber : -1;
			for (int i = 0; i < p.alive.Length; i++)
			{
				int actor = p.alive[i];
				if (actor != localActor)
				{
					AgNetSync sync = AgNetSync.Get(actor);
					if (sync != null)
					{
						targets.Add(sync);
					}
				}
			}
			targets.Sort(CompareByActor);
			if (tracked != null && !targets.Contains(tracked))
			{
				Track(null);
			}
			EnsureTracked();
			RefreshLabel();
			bool alive = ApeGamesManager.IsLocalAlive();
			bool aliveChanged = _localAliveCached != alive;
			_localAliveCached = alive;
			if (!wasActive || aliveChanged)
			{
				SetCameraActive(ShouldSpectate());
				if (_cameraOn)
				{
					RenderOnce();
				}
			}
		}

		private void PollRebuild()
		{
			if (ApeGamesManager.Instance != null)
			{
				Rebuild(ApeGamesManager.Instance.Props);
			}
			else if (AgProps.TryRead(out var p))
			{
				Rebuild(p);
			}
			else
			{
				Deactivate();
			}
		}

		private static bool IsValidTarget(AgNetSync p)
		{
			if (p != null)
			{
				return p.Head != null;
			}
			return false;
		}

		private static int CompareByActor(AgNetSync a, AgNetSync b)
		{
			int actorA = a != null ? a.ActorNumber : int.MaxValue;
			int actorB = b != null ? b.ActorNumber : int.MaxValue;
			return actorA.CompareTo(actorB);
		}

		private void EnsureTracked()
		{
			if (IsValidTarget(tracked))
			{
				return;
			}
			for (int i = 0; i < targets.Count; i++)
			{
				if (IsValidTarget(targets[i]))
				{
					Track(targets[i]);
					return;
				}
			}
			if (tracked != null)
			{
				Track(null);
			}
		}

		private void Deactivate()
		{
			SetScreenActive(false);
			if (_active || _cameraOn || tracked != null || targets.Count != 0)
			{
				_active = false;
				targets.Clear();
				Track(null);
				SetCameraActive(false);
			}
		}

		private void SetScreenActive(bool on)
		{
			if (!_screenOwnsCamera && spectateScreen != null && spectateScreen.activeSelf != on)
			{
				spectateScreen.SetActive(on);
			}
		}

		private void Update()
		{
			if (!_hooked)
			{
				Hook();
			}
			if (Time.unscaledTime >= _nextGateCheck)
			{
				_nextGateCheck = Time.unscaledTime + 0.25f;
				PollRebuild();
				SetCameraActive(ShouldSpectate());
			}
			if (!_active || !_cameraOn)
			{
				return;
			}
			float now = Time.unscaledTime;
			if (now < _nextRender)
			{
				return;
			}
			float interval = renderFps > 0f ? 1f / renderFps : 0f;
			_nextRender = (_nextRender + interval > now) ? (_nextRender + interval) : (now + interval);
			EnsureTracked();
			if (!(tracked == null) && !(tracked.Head == null))
			{
				povCamera.transform.SetPositionAndRotation(tracked.Head.position, tracked.Head.rotation);
				povCamera.Render();
			}
		}

		private bool ShouldSpectate()
		{
			if (!_active || povCamera == null || ApeGamesManager.IsLocalAlive())
			{
				return false;
			}
			Transform head = MonkeDevNetworkingManager.Manager != null ? MonkeDevNetworkingManager.Manager.Head : null;
			if (head == null)
			{
				return true;
			}
			Vector3 toBoard = transform.position - head.position;
			if (toBoard.sqrMagnitude > viewDistance * viewDistance)
			{
				return false;
			}
			if (viewAngle >= 360f)
			{
				return true;
			}
			return Vector3.Angle(head.forward, toBoard) <= viewAngle * 0.5f;
		}

		private void RenderOnce()
		{
			if (povCamera == null || !_cameraOn)
			{
				return;
			}
			if (tracked != null && tracked.Head != null)
			{
				povCamera.transform.position = tracked.Head.position;
				povCamera.transform.rotation = tracked.Head.rotation;
			}
			povCamera.Render();
		}

		private void Track(AgNetSync target)
		{
			tracked = target;
			RefreshLabel();
			if (AgVoiceIsolation.Instance != null)
			{
				AgVoiceIsolation.Instance.SetWatchedActor(this, TrackedActor);
			}
		}

		private void RefreshLabel()
		{
			if (targetNameText == null)
			{
				return;
			}
			string label;
			if (tracked != null && tracked.Owner != null)
			{
				label = tracked.Owner.NickName;
			}
			else if (_active)
			{
				label = targets.Count == 0 ? "No live apes to watch" : "Selecting...";
			}
			else
			{
				label = string.Empty;
			}
			if (!string.Equals(label, _lastLabel))
			{
				_lastLabel = label;
				targetNameText.text = label;
			}
		}

		public void NextTarget()
		{
			Cycle(1);
		}

		public void PreviousTarget()
		{
			Cycle(-1);
		}

		private void Cycle(int step)
		{
			if (targets.Count == 0)
			{
				return;
			}
			int start = step > 0 ? -1 : 0;
			if (tracked != null)
			{
				int index = targets.IndexOf(tracked);
				if (index >= 0)
				{
					start = index;
				}
			}
			for (int i = 1; i <= targets.Count; i++)
			{
				int count = targets.Count;
				int candidate = ((start + step * i) % count + count) % count;
				if (IsValidTarget(targets[candidate]))
				{
					Track(targets[candidate]);
					break;
				}
			}
		}

		public void ToggleListen()
		{
			if (!(AgVoiceIsolation.Instance == null))
			{
				AgVoiceIsolation.Instance.SetListenToAlive(!AgVoiceIsolation.Instance.IsListeningToAlive, TrackedActor, this);
			}
		}
	}
}
