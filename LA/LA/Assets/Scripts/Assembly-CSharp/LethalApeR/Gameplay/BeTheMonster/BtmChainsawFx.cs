using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(10000)]
	public sealed class BtmChainsawFx : MonoBehaviourPun
	{
		private const float HapticInterval = 0.05f;

		private const float BlatThrottle = 0.35f;

		private static readonly int ChainOffsetId = Shader.PropertyToID("_ChainOffset");

		private static readonly int ChainGlowId = Shader.PropertyToID("_ChainGlow");

		private static readonly int ChainColorId = Shader.PropertyToID("_Color");

		private static readonly List<BtmChainsawFx> Running = new List<BtmChainsawFx>();

		[Tooltip("Which trigger runs this saw.")]
		[SerializeField]
		private bool leftHand;

		[Tooltip("The bone the saw rides on, buzzed after the IK has posed it.")]
		[SerializeField]
		private Transform handBone;

		[Header("Bar")]
		[Tooltip("The bar's middle. Its up axis is the face of the blade, which is the plane a cut follows.")]
		[SerializeField]
		private Transform bar;

		[Tooltip("The cutting length of the bar, in the bar's space: where the chain starts and the tip.")]
		[SerializeField]
		private Vector3 barStart = new Vector3(0f, 0f, -0.2f);

		[SerializeField]
		private Vector3 barEnd = new Vector3(0f, 0f, 0.3f);

		[Tooltip("How far either side of the bar it bites, in metres.")]
		[SerializeField]
		private float barRadius = 0.08f;

		[Tooltip("Trigger past which the bar kills.")]
		[SerializeField]
		[Range(0.1f, 1f)]
		private float cutThrottle = 0.5f;

		[Header("Engine")]
		[SerializeField]
		private AudioSource idleLoop;

		[SerializeField]
		private AudioSource revLoop;

		[SerializeField]
		private float spinUpPerSecond = 6f;

		[SerializeField]
		private float spinDownPerSecond = 2.2f;

		[SerializeField]
		private float ownerVolumeScale = 0.6f;

		[Header("Look")]
		[SerializeField]
		private ParticleSystem exhaust;

		[SerializeField]
		private ParticleSystem sparks;

		[SerializeField]
		private Renderer chain;

		[SerializeField]
		private Color chainColor = new Color(1.2f, 1.15f, 1.05f, 0.9f);

		[SerializeField]
		private int blatPuffs = 6;

		[SerializeField]
		private float shakeFrequency = 28f;

		[Header("Kill")]
		[SerializeField]
		private float killRevSeconds = 1.6f;

		[Header("Blood")]
		[SerializeField]
		private ParticleSystem bloodFling;

		[SerializeField]
		private ParticleSystem bloodDrips;

		[SerializeField]
		private float bloodySeconds = 12f;

		[SerializeField]
		private float flingRate = 60f;

		[SerializeField]
		private float dripRate = 8f;

		[SerializeField]
		private int cutFling = 40;

		[Header("Full Throttle")]
		[SerializeField]
		private Color hotChainColor = new Color(2.6f, 0.95f, 0.3f, 1f);

		[SerializeField]
		private float superChainSpeed = 2.6f;

		[SerializeField]
		private float superSparks = 2.5f;

		[SerializeField]
		private float superPitch = 0.22f;

		[SerializeField]
		private float superShake = 1.6f;

		[SerializeField]
		private float superIdleGlow = 0.35f;

		[SerializeField]
		private BtmChainsawRules.Tuning tuning = new BtmChainsawRules.Tuning
		{
			idleVolume = 0.55f,
			idleVolumeAtFullRev = 0.2f,
			idlePitchRise = 0.12f,
			revVolume = 0.95f,
			revPitchLow = 0.8f,
			revPitchHigh = 1.2f,
			idleSmokeRate = 4f,
			revSmokeRate = 26f,
			revSparkRate = 70f,
			chainTeethPerSecond = 22f,
			idleChainSpeed = 0.3f,
			idleChainGlow = 0.4f,
			idleShakeDegrees = 0.25f,
			revShakeDegrees = 1.1f,
			revHaptic = 0.55f
		};

		private MonkeDevNetworkingPlayer _player;

		private MaterialPropertyBlock _block;

		private float _rev;

		private float _shakeDegrees;

		private float _chainOffset;

		private float _killRevUntil;

		private float _bloodyUntil;

		private float _nextHaptic;

		private float _seed;

		private bool _throttleWasOpen;

		private bool _shaken;

		private Quaternion _restRotation;

		private Quaternion _shakenRotation;

		public bool LeftHand => leftHand;

		public Transform Bar => bar ? bar : transform;

		public float Throttle
		{
			get
			{
				float trigger = 0f;
				if (photonView != null && photonView.IsMine)
				{
					VRInputController input = VRInputController.Instance;
					if (input)
					{
						trigger = leftHand ? input.LeftTriggerValue : input.RightTriggerValue;
					}
				}
				else if (_player)
				{
					trigger = leftHand ? _player.NetLeftTrigger : _player.NetRightTrigger;
				}
				return BtmChainsawRules.Throttle(trigger);
			}
		}

		public bool Revving => isActiveAndEnabled && Throttle >= cutThrottle;

		public void Blade(out Vector3 start, out Vector3 end, out float radius)
		{
			Transform t = Bar;
			start = t.TransformPoint(barStart);
			end = t.TransformPoint(barEnd);
			radius = barRadius;
		}

		private void Awake()
		{
			_player = GetComponentInParent<MonkeDevNetworkingPlayer>();
		}

		private void OnEnable()
		{
			Running.Add(this);
			_rev = 0f;
			_killRevUntil = 0f;
			_bloodyUntil = 0f;
			_throttleWasOpen = false;
			_shaken = false;
			_seed = UnityEngine.Random.value * 100f;
			if (_block == null)
			{
				_block = new MaterialPropertyBlock();
			}
			if (idleLoop && idleLoop.clip)
			{
				idleLoop.Play();
				idleLoop.time = UnityEngine.Random.value * idleLoop.clip.length * 0.9f;
			}
			if (revLoop && revLoop.clip)
			{
				revLoop.volume = 0f;
				revLoop.Play();
			}
			BtmChainsawRules.EngineMix mix = BtmChainsawRules.Mix(0f, tuning);
			Apply(in mix, 0f);
			PreloadVictims();
		}

		private void OnDisable()
		{
			Running.Remove(this);
			if (idleLoop)
			{
				idleLoop.Stop();
			}
			if (revLoop)
			{
				revLoop.Stop();
			}
			if (_shaken && handBone)
			{
				handBone.localRotation = _restRotation;
			}
			_shaken = false;
		}

		public static void PreloadIfRunning()
		{
			if (Running.Count > 0)
			{
				PreloadVictims();
			}
		}

		private static void PreloadVictims()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			foreach (MonkeDevNetworkingPlayer player in manager.Players)
			{
				if (player && player.photonView != null && !player.photonView.IsMine)
				{
					BtmCutMeshes.Preload(player);
				}
			}
		}

		private void Update()
		{
			if (_shaken && handBone && handBone.localRotation == _shakenRotation)
			{
				handBone.localRotation = _restRotation;
			}
			_shaken = false;
			float throttle = Throttle;
			if (Time.time < _killRevUntil)
			{
				throttle = 1f;
			}
			bool open = throttle > BlatThrottle;
			if (open && !_throttleWasOpen && exhaust)
			{
				exhaust.Emit(blatPuffs);
			}
			_throttleWasOpen = open;
			_rev = BtmChainsawRules.Spin(_rev, throttle, Time.deltaTime, spinUpPerSecond, spinDownPerSecond);
			BtmChainsawRules.EngineMix mix = BtmChainsawRules.Mix(_rev, tuning);
			Supercharge(ref mix, _rev);
			Apply(in mix, Time.deltaTime);
			Rumble(mix.Haptic);
		}

		private void LateUpdate()
		{
			if (handBone && _shakeDegrees > 0f)
			{
				float t = Time.time * shakeFrequency;
				Vector3 jitter = new Vector3(Mathf.PerlinNoise(t, _seed) - 0.5f, Mathf.PerlinNoise(_seed, t) - 0.5f, Mathf.PerlinNoise(t + 31.7f, _seed + 7.3f) - 0.5f);
				_restRotation = handBone.localRotation;
				_shakenRotation = _restRotation * Quaternion.Euler(jitter * (_shakeDegrees * 2f));
				handBone.localRotation = _shakenRotation;
				_shaken = true;
			}
		}

		private void Supercharge(ref BtmChainsawRules.EngineMix mix, float drive)
		{
			mix.ChainSpeed *= Mathf.Lerp(1f, superChainSpeed, drive);
			mix.ChainGlow = Mathf.Max(mix.ChainGlow, superIdleGlow * drive);
			mix.SparkRate *= Mathf.Lerp(1f, superSparks, drive);
			mix.RevPitch += superPitch * drive * drive;
			mix.IdlePitch += superPitch * 0.5f * drive;
			mix.RevVolume = Mathf.Min(mix.RevVolume * Mathf.Lerp(1f, 1.15f, drive), 1f);
			mix.ShakeDegrees *= Mathf.Lerp(1f, superShake, drive);
			mix.Haptic = Mathf.Min(mix.Haptic * Mathf.Lerp(1f, 1.4f, drive), 1f);
		}

		private void Apply(in BtmChainsawRules.EngineMix mix, float deltaTime)
		{
			float wobble = Mathf.PerlinNoise(_seed, Time.time * 2.3f) - 0.5f;
			float volumeScale = (photonView != null && photonView.IsMine) ? ownerVolumeScale : 1f;
			if (idleLoop)
			{
				idleLoop.volume = mix.IdleVolume * volumeScale * (1f + wobble * 0.2f);
				idleLoop.pitch = mix.IdlePitch * (1f + wobble * 0.04f);
			}
			if (revLoop)
			{
				revLoop.volume = mix.RevVolume * volumeScale;
				revLoop.pitch = mix.RevPitch * (1f + wobble * 0.02f);
			}
			if (exhaust)
			{
				ParticleSystem.EmissionModule emission = exhaust.emission;
				emission.rateOverTimeMultiplier = mix.SmokeRate;
			}
			if (sparks)
			{
				ParticleSystem.EmissionModule emission2 = sparks.emission;
				emission2.rateOverTimeMultiplier = mix.SparkRate;
			}
			float bloody = Mathf.Clamp01((_bloodyUntil - Time.time) / bloodySeconds);
			if (bloodFling)
			{
				ParticleSystem.EmissionModule emission3 = bloodFling.emission;
				emission3.rateOverTimeMultiplier = bloody * flingRate * _rev;
			}
			if (bloodDrips)
			{
				ParticleSystem.EmissionModule emission4 = bloodDrips.emission;
				emission4.rateOverTimeMultiplier = bloody * dripRate;
			}
			_shakeDegrees = mix.ShakeDegrees;
			if (chain)
			{
				chain.enabled = mix.ChainGlow > 0.001f;
				if (chain.enabled)
				{
					_chainOffset = Mathf.Repeat(_chainOffset + mix.ChainSpeed * deltaTime, 1024f);
					chain.GetPropertyBlock(_block);
					_block.SetFloat(ChainOffsetId, _chainOffset);
					_block.SetFloat(ChainGlowId, mix.ChainGlow);
					_block.SetColor(ChainColorId, Color.Lerp(chainColor, hotChainColor, _rev));
					chain.SetPropertyBlock(_block);
				}
			}
		}

		private void Rumble(float amplitude)
		{
			if (amplitude > 0f && !(photonView == null) && photonView.IsMine && !(Time.time < _nextHaptic))
			{
				_nextHaptic = Time.time + HapticInterval;
				Pulse(amplitude, 0.08f);
			}
		}

		private void Pulse(float amplitude, float duration)
		{
			VRInputController input = VRInputController.Instance;
			if (input && !(photonView == null) && photonView.IsMine)
			{
				if (leftHand)
				{
					input.PulseLeft(amplitude, duration);
				}
				else
				{
					input.PulseRight(amplitude, duration);
				}
				_nextHaptic = Time.time + duration;
			}
		}

		public static bool Cut(MonkeDevNetworkingPlayer killer, MonkeDevNetworkingPlayer victim, out Vector3 bar)
		{
			bar = Vector3.zero;
			BtmChainsawFx fx = Of(killer, victim);
			if (!fx)
			{
				return false;
			}
			bar = fx.Bar.position;
			return fx.Killed(victim);
		}

		private static BtmChainsawFx Of(MonkeDevNetworkingPlayer killer, MonkeDevNetworkingPlayer victim)
		{
			if (!killer || killer.photonView == null || !victim)
			{
				return null;
			}
			int owner = killer.photonView.OwnerActorNr;
			Vector3 target = (victim.Head ? victim.Head : victim.transform).position;
			BtmChainsawFx best = null;
			float bestDistance = float.MaxValue;
			foreach (BtmChainsawFx fx in Running)
			{
				if (fx && !(fx.photonView == null) && fx.photonView.OwnerActorNr == owner)
				{
					fx.Blade(out var start, out var end, out var _);
					float distance = BtmGrabReach.SegmentDistanceSqr(start, end, target, target);
					if (distance < bestDistance)
					{
						bestDistance = distance;
						best = fx;
					}
				}
			}
			return best;
		}

		private bool Killed(MonkeDevNetworkingPlayer victim)
		{
			BtmChainsawCutter cutter = BtmChainsawCutter.Instance;
			return Present(cutter && cutter.Cut(victim, Bar.up));
		}

		public bool CutModel(Transform models, SkinnedMeshRenderer body, string name, Action revealed)
		{
			BtmChainsawCutter cutter = BtmChainsawCutter.Instance;
			return Present(cutter && cutter.CutModel(models, body, Bar.up, name, revealed));
		}

		private bool Present(bool cut)
		{
			_killRevUntil = Time.time + killRevSeconds;
			_bloodyUntil = Time.time + bloodySeconds;
			Transform t = Bar;
			BtmGore gore = BtmGore.Instance;
			if (gore && gore.InFxRange(t.position))
			{
				gore.Burst(gore.burstPrefab, t.position, t.forward);
			}
			if (cut && bloodFling)
			{
				bloodFling.Emit(cutFling);
			}
			Pulse(cut ? 1f : 0.9f, 0.35f);
			return cut;
		}

		private void OnDrawGizmosSelected()
		{
			Blade(out var start, out var end, out var radius);
			Gizmos.color = new Color(1f, 0.4f, 0.1f, 0.9f);
			Gizmos.DrawLine(start, end);
			Gizmos.DrawWireSphere(start, radius);
			Gizmos.DrawWireSphere(end, radius);
			Transform t = Bar;
			Gizmos.color = Color.green;
			Gizmos.DrawLine(t.position, t.position + t.up * 0.15f);
		}
	}
}
