using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgSpectatorScreen : MonoBehaviourPunCallbacks
	{
		[Header("Render target")]
		public Camera povCamera;

		public TMP_Text targetNameText;

		[Header("Shuffle")]
		[SerializeField]
		private float shuffleInterval = 5f;

		[Header("Orbit camera")]
		[SerializeField]
		private float orbitRadius = 4f;

		[SerializeField]
		private float orbitHeight = 1.2f;

		[SerializeField]
		private float orbitSpeed = 25f;

		[SerializeField]
		private Vector3 lookAtOffset = new Vector3(0f, -0.4f, 0f);

		[Header("Performance")]
		[SerializeField]
		private float renderFps = 30f;

		private readonly List<AgNetSync> _targets = new List<AgNetSync>();

		private AgNetSync _tracked;

		private double _matchStamp = -1.0;

		private bool _active;

		private bool _hooked;

		private bool _cameraOn;

		private bool _cameraConfigured;

		private float _lastRender;

		private int _shuffleSlot = -1;

		private float _orbitAngle;

		private float RenderInterval => renderFps > 0f ? 1f / renderFps : 1f / 30f;

		private void Start()
		{
			ConfigureCamera();
			SetCameraActive(false);
			Hook();
			if (AgProps.TryRead(out var p))
			{
				Evaluate(p);
			}
		}

		private void ConfigureCamera()
		{
			if (!(povCamera == null) && !_cameraConfigured)
			{
				_cameraConfigured = true;
				povCamera.enabled = false;
				povCamera.stereoTargetEye = StereoTargetEyeMask.None;
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
			if (AgProps.TryRead(out var p))
			{
				Evaluate(p);
			}
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
		}

		private void OnRoundStarted(int round, AgRoundProperties p)
		{
			Evaluate(p);
		}

		private void OnRoundEnded(int round, AgRoundProperties p)
		{
			Evaluate(p);
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			Evaluate(p);
		}

		private void OnMatchEnded(int[] winners)
		{
			Deactivate();
		}

		public override void OnJoinedRoom()
		{
			if (AgProps.TryRead(out var p))
			{
				Evaluate(p);
			}
		}

		public override void OnLeftRoom()
		{
			Deactivate();
		}

		private void Evaluate(AgRoundProperties p)
		{
			if (p == null || p.queue != "ApeGames" || p.alive == null || (p.phase != AgPhase.Round && p.phase != AgPhase.Intermission))
			{
				Deactivate();
				return;
			}
			_active = true;
			_matchStamp = p.matchStamp;
			RebuildTargets(p);
			if (!_cameraOn && _targets.Count > 0)
			{
				SetCameraActive(true);
			}
		}

		private void RebuildTargets(AgRoundProperties p)
		{
			_targets.Clear();
			for (int i = 0; i < p.alive.Length; i++)
			{
				AgNetSync sync = AgNetSync.Get(p.alive[i]);
				if (sync != null)
				{
					_targets.Add(sync);
				}
			}
			_targets.Sort(CompareByActor);
			if (_targets.Count == 0)
			{
				Track(null);
				SetCameraActive(false);
			}
		}

		private static int CompareByActor(AgNetSync a, AgNetSync b)
		{
			int actorA = a != null ? a.ActorNumber : int.MaxValue;
			int actorB = b != null ? b.ActorNumber : int.MaxValue;
			return actorA.CompareTo(actorB);
		}

		private void Deactivate()
		{
			if (_active || _cameraOn || _tracked != null || _targets.Count != 0)
			{
				_active = false;
				_shuffleSlot = -1;
				_targets.Clear();
				Track(null);
				SetCameraActive(false);
			}
		}

		private void Update()
		{
			if (!_hooked)
			{
				Hook();
			}
			if (!_active || _targets.Count == 0)
			{
				if (_cameraOn)
				{
					SetCameraActive(false);
				}
				return;
			}
			if (!_cameraOn)
			{
				SetCameraActive(true);
				if (!_cameraOn)
				{
					return;
				}
			}
			int slot = 0;
			if (shuffleInterval > 0f)
			{
				double elapsed = PhotonNetwork.Time - _matchStamp;
				slot = (int)((elapsed < 0.0 ? 0.0 : elapsed) / (double)shuffleInterval);
			}
			int count = _targets.Count;
			if (slot != _shuffleSlot || _tracked == null || !_targets.Contains(_tracked))
			{
				_shuffleSlot = slot;
				Track(_targets[slot % count]);
				_orbitAngle = 0f;
			}
			if (!(_tracked == null) && !(_tracked.Head == null))
			{
				float delta = Time.unscaledTime - _lastRender;
				if (!(delta < RenderInterval))
				{
					_lastRender = Time.unscaledTime;
					_orbitAngle += delta * orbitSpeed;
					PositionOrbit(_tracked.Head);
					povCamera.Render();
				}
			}
		}

		private void PositionOrbit(Transform head)
		{
			float angle = _orbitAngle;
			Vector3 headPos = head.position;
			Transform cam = povCamera.transform;
			float rad = angle * Mathf.Deg2Rad;
			cam.position = headPos + new Vector3(Mathf.Sin(rad) * orbitRadius, orbitHeight, Mathf.Cos(rad) * orbitRadius);
			cam.rotation = Quaternion.LookRotation(headPos + lookAtOffset - cam.position);
		}

		private void Track(AgNetSync target)
		{
			_tracked = target;
			if (targetNameText != null)
			{
				if (target != null)
				{
					var owner = target.Owner;
					targetNameText.text = owner != null ? owner.NickName : string.Empty;
				}
				else
				{
					targetNameText.text = string.Empty;
				}
			}
		}
	}
}
