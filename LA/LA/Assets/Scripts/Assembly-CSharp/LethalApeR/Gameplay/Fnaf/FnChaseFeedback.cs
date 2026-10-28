using LethalApeR.Gameplay.ApeGames;
using UnityEngine;
using UnityEngine.Audio;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnChaseFeedback : MonoBehaviour
	{
		[Tooltip("Mixer group for the chase layers (the game's music or SFX group).")]
		public AudioMixerGroup output;

		[Range(0f, 1f)]
		public float chaseVolume = 0.7f;

		[Range(0f, 1f)]
		public float heartbeatVolume = 0.55f;

		[Range(0f, 1f)]
		public float spottedVolume = 0.9f;

		[Tooltip("An awake animatronic this close to your head is a threat (m).")]
		public float nearWithin = 6f;

		[Tooltip("Full threat inside this (m).")]
		public float fullWithin = 2f;

		[Tooltip("Layers fade in over this (s).")]
		public float fadeInSeconds = 1.2f;

		[Tooltip("Layers fade out over this once the threat passes (s).")]
		public float fadeOutSeconds = 2.5f;

		[Tooltip("Heartbeat rate (Hz). Author heartbeatLoop at this tempo with a beat at 0 s and the pulses land on it.")]
		public float heartbeatHz = 1.1f;

		[Tooltip("Heartbeat haptic amplitude at the lowest and the highest threat.")]
		public Vector2 heartbeatAmplitude = new Vector2(0.12f, 0.5f);

		[Tooltip("A second spot inside this is silent (s).")]
		public float spottedCooldown = 1.5f;

		[Tooltip("An animatronic knocking behind a shut door while you are in the office drives the heartbeat at this fraction of its proximity threat, and never the chase music.")]
		[Range(0f, 1f)]
		public float behindDoorDread = 0.6f;

		private const float CutSeconds = 0.08f;

		private const float DubDelay = 0.29f;

		private FnNight _night;

		private AudioSource _music;

		private AudioSource _heart;

		private float _musicLevel;

		private float _heartLevel;

		private float _nextSpotted;

		private int _lastBeat = -1;

		private double _freeClock;

		private float _dubAt;

		private float _dubAmplitude;

		private void Awake()
		{
			_music = FnLocalLoop.Create(transform, "ChaseMusic", output);
			_heart = FnLocalLoop.Create(transform, "Heartbeat", output);
		}

		private void OnDisable()
		{
			_musicLevel = 0f;
			_heartLevel = 0f;
			_lastBeat = -1;
			_dubAt = 0f;
			FnLocalLoop.Drive(_music, null, 0f);
			FnLocalLoop.Drive(_heart, null, 0f);
			Bind(null);
		}

		private void Update()
		{
			Bind(FnNight.Instance);
			FnNight night = _night;
			bool chasing = false;
			float threat = 0f;
			float shielded = 0f;
			bool cut = FnGhost.LocalIsGhost || FnJumpscare.Playing;
			bool live = !cut && night != null && night.Active && night.Phase == FnPhase.Night && night.LocalIsAlive;
			if (live)
			{
				Evaluate(out chasing, out threat, out shielded);
			}
			float music = (chasing ? 1f : threat);
			float heart = Mathf.Max(threat, shielded * behindDoorDread);
			float dt = Time.unscaledDeltaTime;
			_musicLevel = Level(_musicLevel, music, dt, cut);
			_heartLevel = Level(_heartLevel, heart, dt, cut);
			FnAudioBank bank = FnGame.Audio;
			FnLocalLoop.Drive(_music, (bank != null) ? bank.chaseMusicLoop : null, _musicLevel * chaseVolume);
			FnLocalLoop.Drive(_heart, (bank != null) ? bank.heartbeatLoop : null, _heartLevel * heartbeatVolume);
			Beat(live ? heart : 0f, dt);
		}

		private void Evaluate(out bool chasing, out float threat, out float shielded)
		{
			chasing = false;
			threat = 0f;
			shielded = 0f;
			Transform head = FnPlatform.Head;
			if (head == null)
			{
				return;
			}
			Vector3 position = head.position;
			int localActor = FnGame.LocalActor;
			FnOffice office = FnOffice.Instance;
			bool inOffice = office != null && office.Contains(position, 0f);
			for (int i = 0; i < FnConst.AnimCount; i++)
			{
				FnAnimPose pose = FnAnimView.Get(i);
				if (!pose.Active || pose.PoweredDown || pose.State == FnAiState.Dormant || pose.State == FnAiState.PoweredDown)
				{
					continue;
				}
				if (localActor >= 1 && pose.State == FnAiState.Chase && pose.Target == localActor)
				{
					chasing = true;
				}
				Vector3 at = pose.HeadPosition;
				if (at == Vector3.zero)
				{
					at = pose.Position + Vector3.up * 1.5f;
				}
				float distance = Vector3.Distance(position, at);
				float t = 0f;
				if (distance < nearWithin)
				{
					t = ((distance <= fullWithin) ? 1f : (1f - (distance - fullWithin) / (nearWithin - fullWithin)));
				}
				if (inOffice && pose.State == FnAiState.DoorBang)
				{
					if (t > shielded)
					{
						shielded = t;
					}
				}
				else if (t > threat)
				{
					threat = t;
				}
			}
			if (chasing)
			{
				threat = 1f;
			}
		}

		private float Level(float current, float target, float dt, bool cut)
		{
			float seconds;
			if (cut)
			{
				target = 0f;
				seconds = CutSeconds;
			}
			else
			{
				seconds = ((target > current) ? fadeInSeconds : fadeOutSeconds);
			}
			return Mathf.MoveTowards(current, target, dt / Mathf.Max(seconds, 0.02f));
		}

		private void Beat(float threat, float dt)
		{
			float now = Time.unscaledTime;
			if (_dubAt > 0f && now >= _dubAt)
			{
				float amplitude = _dubAmplitude;
				_dubAt = 0f;
				AgHaptics.Both(amplitude, 0.04f);
			}
			if (threat <= 0.02f)
			{
				_freeClock = 0.0;
				_lastBeat = -1;
				return;
			}
			double clock;
			if (_heart != null && _heart.isPlaying && _heart.clip != null)
			{
				clock = _heart.time;
			}
			else
			{
				_freeClock += dt;
				clock = _freeClock;
			}
			int beat = FnGhostRules.BeatIndex(clock, heartbeatHz);
			if (beat != _lastBeat)
			{
				_lastBeat = beat;
				float pulse = Mathf.Lerp(heartbeatAmplitude.x, heartbeatAmplitude.y, threat);
				AgHaptics.Both(pulse, 0.05f);
				_dubAt = now + DubDelay;
				_dubAmplitude = pulse * 0.6f;
			}
		}

		private void OnSpotted(FnAnim anim, int actor)
		{
			if (FnGame.LocalActor == actor && !FnGhost.LocalIsGhost && !FnJumpscare.Playing && !(_night == null) && _night.Active && _night.Phase == FnPhase.Night && _night.LocalIsAlive && !(Time.unscaledTime < _nextSpotted))
			{
				_nextSpotted = Time.unscaledTime + spottedCooldown;
				FnAudioBank bank = FnGame.Audio;
				FnAudio.Flat((bank != null) ? bank.spottedSting : null, spottedVolume);
				AgHaptics.Both(0.45f, 0.12f);
			}
		}

		private void Bind(FnNight night)
		{
			if (!(night == _night))
			{
				if (_night != null)
				{
					_night.Spotted -= OnSpotted;
				}
				_night = night;
				if (_night != null)
				{
					_night.Spotted += OnSpotted;
				}
			}
		}
	}
}
