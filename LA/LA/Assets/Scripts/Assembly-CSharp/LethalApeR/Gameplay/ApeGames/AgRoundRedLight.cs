using System.Reflection;
using LethalApeR.Audio;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundRedLight : AgRoundBase
	{
		[Header("Light Beacon")]
		[SerializeField]
		private Renderer lightRenderer;

		[SerializeField]
		private Material greenMaterial;

		[SerializeField]
		private Material redMaterial;

		[SerializeField]
		private PlaySfx greenSfx;

		[SerializeField]
		private PlaySfx redSfx;

		[SerializeField]
		private AudioSource redTickLoop;

		[SerializeField]
		private float tickPitch = 1f;

		[Header("Screen pulse (works with sound off)")]
		[SerializeField]
		private AgVignettePulse vignettePulse;

		[SerializeField]
		private Color pulseGreen = new Color(0.1f, 0.9f, 0.25f, 1f);

		[SerializeField]
		private Color pulseRed = new Color(0.95f, 0.12f, 0.12f, 1f);

		[Header("Safe zone (spawn). Head inside = never detected on red.")]
		[SerializeField]
		private BoxCollider safeZone;

		[Header("Watcher (falls back to AgWatcherController.Instance)")]
		[SerializeField]
		private AgWatcherController watcher;

		private bool _hasLightState;

		private AgLightState _lightState;

		private int _violationStreak;

		private double _reportedRedStamp = -1.0;

		private Vector3 _redAnchor;

		private bool _hasAnchor;

		private bool _wasInSafeZone;

		public AgWatcherController Watcher => (watcher != null) ? watcher : AgWatcherController.Instance;

		public override int RoundIndex => 0;

		public void RegisterWatcher(AgWatcherController w)
		{
			if (watcher == null)
			{
				watcher = w;
			}
		}

		private void Awake()
		{
			if (vignettePulse == null)
			{
				vignettePulse = GetComponent<AgVignettePulse>();
			}
			if (vignettePulse == null)
			{
				vignettePulse = Object.FindFirstObjectByType<AgVignettePulse>();
			}
			if (vignettePulse == null)
			{
				vignettePulse = base.gameObject.AddComponent<AgVignettePulse>();
			}
			if (redTickLoop == null)
			{
				Transform transform = base.transform.Find("RedTickLoop");
				if (transform != null)
				{
					redTickLoop = transform.GetComponent<AudioSource>();
				}
			}
			if (redTickLoop != null)
			{
				redTickLoop.spatialize = false;
				redTickLoop.spatialBlend = 0f;
				redTickLoop.loop = true;
				redTickLoop.playOnAwake = false;
				if (redTickLoop.clip == null)
				{
					Debug.LogError("[AgRoundRedLight] RedTickLoop has no AudioClip, the red tick is silent until one is assigned.", redTickLoop);
				}
			}
			else
			{
				Debug.LogError("[AgRoundRedLight] redTickLoop unwired and no 'RedTickLoop' child AudioSource found, no clock tick during red.", this);
			}
			if (safeZone != null && safeZone.enabled)
			{
				safeZone.enabled = false;
			}
		}

		public override void OnRoundPrepare(AgRoundProperties p)
		{
			base.OnRoundPrepare(p);
			_hasLightState = false;
			_violationStreak = 0;
			_reportedRedStamp = -1.0;
			_hasAnchor = false;
			_wasInSafeZone = LocalHeadInSafeZone();
			AgWatcherController agWatcherController = Watcher;
			if (agWatcherController != null)
			{
				agWatcherController.ResetToPost();
				if (p != null)
				{
					agWatcherController.ApplyLightState((AgLightState)p.lightState);
				}
			}
		}

		public override void OnRoundCleanup()
		{
			AgWatcherController agWatcherController = Watcher;
			if (agWatcherController != null)
			{
				agWatcherController.ResetToPost();
			}
			if (redTickLoop != null && redTickLoop.isPlaying)
			{
				redTickLoop.Stop();
			}
			if (vignettePulse != null)
			{
				vignettePulse.CancelToZero();
			}
			base.OnRoundCleanup();
		}

		private void OnDisable()
		{
			if (redTickLoop != null && redTickLoop.isPlaying)
			{
				redTickLoop.Stop();
			}
			if (vignettePulse != null)
			{
				vignettePulse.CancelToZero();
			}
			_hasLightState = false;
			_violationStreak = 0;
			_hasAnchor = false;
			_wasInSafeZone = false;
		}

		public override void LocalTick(double elapsed, AgRoundProperties p)
		{
			if (p == null)
			{
				return;
			}
			AgLightState lightState = (AgLightState)p.lightState;
			ApplyLightState(lightState);
			AgWatcherController agWatcherController = Watcher;
			if (agWatcherController != null)
			{
				agWatcherController.ApplyLightState(lightState);
			}
			bool flag = LocalHeadInSafeZone();
			if (safeZone != null && _wasInSafeZone != flag)
			{
				_wasInSafeZone = flag;
				AgHaptics.Both(flag ? 0.25f : 0.45f, 0.06f);
				if (flag && vignettePulse != null)
				{
					vignettePulse.Pulse(pulseGreen);
				}
			}
			if (lightState != AgLightState.Red || _reportedRedStamp.Equals(p.lightStamp) || flag)
			{
				_violationStreak = 0;
				_hasAnchor = false;
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			float num = 0.6f;
			if (instance != null && instance.settings != null)
			{
				num = instance.settings.redLight.graceSeconds;
			}
			if (PhotonNetwork.Time - p.lightStamp <= (double)num || instance == null || !PhotonNetwork.InRoom || !ApeGamesManager.IsLocalAlive() || p.EscapedContains(PhotonNetwork.LocalPlayer.ActorNumber) || !GorillaLocomotion.Player.HasInstance)
			{
				_violationStreak = 0;
				_hasAnchor = false;
				return;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
			float currentScale = player.CurrentScale;
			SphereCollider headCollider = player.headCollider;
			if (headCollider == null)
			{
				_violationStreak = 0;
				_hasAnchor = false;
				return;
			}
			Vector3 position = headCollider.transform.position;
			if (!_hasAnchor)
			{
				_redAnchor = position;
				_hasAnchor = true;
				_violationStreak = 0;
				return;
			}
			float num2 = ((instance.settings != null) ? instance.settings.redLight.moveThreshold : 0.2f);
			float num3 = position.x - _redAnchor.x;
			float num4 = position.z - _redAnchor.z;
			float num5 = Mathf.Max(0.1f, currentScale) * num2;
			if (num3 * num3 + num4 * num4 > num5 * num5)
			{
				_violationStreak++;
				int num6 = ((instance.settings != null) ? instance.settings.redLight.violationFrames : 3);
				if (_violationStreak >= num6)
				{
					_violationStreak = 0;
					if (instance.ReportRunner())
					{
						_reportedRedStamp = p.lightStamp;
						AgHaptics.Both(0.9f, 0.18f);
						if (vignettePulse != null)
						{
							vignettePulse.Pulse(pulseRed);
						}
					}
				}
			}
			else
			{
				_violationStreak = 0;
			}
		}

		private bool LocalHeadInSafeZone()
		{
			if (safeZone == null)
			{
				return false;
			}
			Transform transform = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null);
			if (transform == null)
			{
				return false;
			}
			Vector3 vector = safeZone.transform.InverseTransformPoint(transform.position);
			Vector3 center = safeZone.center;
			Vector3 size = safeZone.size;
			if (Mathf.Abs(vector.x - center.x) <= size.x * 0.5f && Mathf.Abs(vector.y - center.y) <= size.y * 0.5f)
			{
				return Mathf.Abs(vector.z - center.z) <= size.z * 0.5f;
			}
			return false;
		}

		private void ApplyLightState(AgLightState state)
		{
			bool hasLightState = _hasLightState;
			if (hasLightState && _lightState == state)
			{
				return;
			}
			_hasLightState = true;
			_lightState = state;
			_violationStreak = 0;
			if (lightRenderer != null)
			{
				Material material = ((state == AgLightState.Green) ? greenMaterial : redMaterial);
				if (material != null)
				{
					lightRenderer.sharedMaterial = material;
				}
			}
			if (redTickLoop != null)
			{
				if (state == AgLightState.Red)
				{
					redTickLoop.pitch = tickPitch;
					if (!redTickLoop.isPlaying)
					{
						redTickLoop.Play();
					}
				}
				else if (redTickLoop.isPlaying)
				{
					redTickLoop.Stop();
				}
			}
			if (hasLightState)
			{
				PlaySfx playSfx = ((state == AgLightState.Green) ? greenSfx : redSfx);
				if (playSfx != null)
				{
					playSfx.PlayAudio();
				}
				if (vignettePulse != null)
				{
					vignettePulse.Pulse((state == AgLightState.Green) ? pulseGreen : pulseRed);
				}
			}
		}
	}
}
