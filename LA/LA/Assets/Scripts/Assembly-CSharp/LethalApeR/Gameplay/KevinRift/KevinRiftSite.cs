using System;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class KevinRiftSite : MonoBehaviour
	{
		private static readonly int GlowId = Shader.PropertyToID("_Glow");

		private static readonly int PulseId = Shader.PropertyToID("_Pulse");

		private static readonly int OccupiedId = Shader.PropertyToID("_Occupied");

		private static readonly int OpenId = Shader.PropertyToID("_Open");

		private static readonly int IntensityId = Shader.PropertyToID("_Intensity");

		private static readonly int ProgressId = Shader.PropertyToID("_Progress");

		[Header("Crystal")]
		public Transform crystalRoot;

		public KevinCrystalTouch crystal;

		[Tooltip("Height of the crystal's top above the anchor (m), where the strike lands.")]
		public float crystalTop = 2.45f;

		[Tooltip("How far below ground the crystal starts when it arrives, and sinks to when it collapses (m).")]
		public float buryDepth = 2.9f;

		public AudioSource hum;

		public AudioClip humClip;

		public AudioClip primedClip;

		[Range(0f, 1f)]
		public float humVolume = 0.45f;

		[Header("Pads")]
		public Renderer[] pads = new Renderer[3];

		public AudioSource[] padAudio = new AudioSource[3];

		public AudioClip padOn;

		public AudioClip padOff;

		[Header("Counter")]
		public TMP_Text counter;

		public float counterHeight = 3.05f;

		[Header("Strike")]
		public RiftBolt bolt;

		public Light flash;

		[Tooltip("Point-light intensity at the strike. Kept moderate: a full-scene white-out in a headset is a comfort problem.")]
		public float flashPeak = 3.2f;

		public Renderer ring;

		public Renderer halo;

		public Renderer[] chargeStreaks = new Renderer[0];

		public ParticleSystem sparks;

		public AudioSource oneShots;

		public AudioClip chargeClip;

		public AudioClip thunderClip;

		public AudioClip shatterClip;

		public AudioClip collapseClip;

		[Header("Storm")]
		public RiftStorm storm;

		public float stormHeight = 14f;

		[Header("Vortexes")]
		public Renderer[] vortexes = new Renderer[5];

		public Renderer[] vortexStreaks = new Renderer[5];

		public AudioSource vortexLoop;

		[Range(0f, 1f)]
		public float vortexVolume = 0.5f;

		[Header("Shatter")]
		public ParticleSystem shards;

		[NonSerialized]
		public KevinRiftDirector director;

		private MaterialPropertyBlock _block;

		private KevinRiftAnchor _placedAt;

		private RiftPhase _lastPhase;

		private int _struckEpoch = -1;

		private readonly int[] _lastHolders = new int[3];

		private readonly float[] _padGlow = new float[3];

		private float _awake;

		private float _flash;

		private float _flashLight;

		private float _ring = 1f;

		private float _ringStrength = 1f;

		private float _open;

		private float _vortexPulse;

		private float _waveCueUntil;

		private float _charge;

		private int _counterKey = int.MinValue;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			HideAll();
		}

		private void HideAll()
		{
			if (crystalRoot != null)
			{
				crystalRoot.gameObject.SetActive(false);
			}
			Renderer[] array = pads;
			foreach (Renderer renderer in array)
			{
				if (renderer != null)
				{
					renderer.enabled = false;
				}
			}
			array = vortexes;
			foreach (Renderer renderer2 in array)
			{
				if (renderer2 != null)
				{
					renderer2.enabled = false;
				}
			}
			array = vortexStreaks;
			foreach (Renderer renderer3 in array)
			{
				if (renderer3 != null)
				{
					renderer3.enabled = false;
				}
			}
			array = chargeStreaks;
			foreach (Renderer renderer4 in array)
			{
				if (renderer4 != null)
				{
					renderer4.enabled = false;
				}
			}
			if (counter != null)
			{
				counter.gameObject.SetActive(false);
			}
			if (ring != null)
			{
				ring.enabled = false;
			}
			if (halo != null)
			{
				halo.enabled = false;
			}
			if (flash != null)
			{
				flash.enabled = false;
			}
			if (storm != null)
			{
				storm.Hide();
			}
			if (hum != null)
			{
				hum.Stop();
			}
			if (vortexLoop != null)
			{
				vortexLoop.Stop();
			}
		}

		public void OnPhase(RiftPhase previous, int previousWave)
		{
			if (director == null)
			{
				return;
			}
			Place();
			switch (director.Phase)
			{
			case RiftPhase.Off:
			case RiftPhase.Away:
				if (storm != null)
				{
					storm.Clear();
				}
				break;
			case RiftPhase.Charging:
				if (previous != RiftPhase.Charging)
				{
					Play(chargeClip, 1f);
					if (crystal != null && _placedAt != null)
					{
						for (int i = 0; i < 3; i++)
						{
							crystal.AddRipple(Vector3.Lerp(crystalRoot.position, _placedAt.PadPosition(i), 0.35f) + Vector3.up * 1.3f);
						}
					}
				}
				break;
			case RiftPhase.Waves:
				_vortexPulse = 1f;
				_waveCueUntil = Time.time + 3f;
				break;
			case RiftPhase.Cleared:
				if (previous != RiftPhase.Cleared)
				{
					Shatter();
				}
				break;
			case RiftPhase.Failed:
				if (previous != RiftPhase.Failed)
				{
					Play(collapseClip, 1f);
				}
				break;
			case RiftPhase.Arriving:
				if (previous != RiftPhase.Arriving)
				{
					Strike(0.55f, 0.6f);
				}
				break;
			}
		}

		public void HostSummonedBy(Vector3 hand)
		{
			if (crystal != null)
			{
				crystal.AddRipple(hand);
			}
		}

		public void OnZombieEmerge(Vector3 point)
		{
			_vortexPulse = Mathf.Max(_vortexPulse, 0.8f);
			if (storm != null)
			{
				storm.StrikeDown(point);
			}
		}

		private void Strike(float strength, float thunderVolume)
		{
			if (crystalRoot == null)
			{
				return;
			}
			Vector3 vector = base.transform.position + Vector3.up * crystalTop;
			Vector3 from = vector + Vector3.up * 40f + new Vector3(UnityEngine.Random.Range(-6f, 6f), 0f, UnityEngine.Random.Range(-6f, 6f));
			if (bolt != null)
			{
				bolt.Strike(from, vector, 0.5f, strength, (strength > 0.8f) ? 4 : 2, Mathf.Lerp(0.6f, 1f, strength));
			}
			_flashLight = strength;
			_ring = 0f;
			_ringStrength = strength;
			_flash = Mathf.Max(_flash, strength * 2.5f);
			if (sparks != null)
			{
				sparks.Play();
			}
			Play(thunderClip, thunderVolume);
			if (storm != null)
			{
				storm.Flash(strength * 2f);
			}
		}

		private void Shatter()
		{
			if (shards != null)
			{
				shards.transform.position = base.transform.position + Vector3.up * (crystalTop * 0.5f);
				shards.Play();
			}
			_flash = 3f;
			_flashLight = 0.8f;
			_ring = 0f;
			_ringStrength = 0.8f;
			Play(shatterClip, 1f);
			if (storm != null)
			{
				storm.Clear();
			}
		}

		private void Play(AudioClip clip, float volume)
		{
			if (oneShots != null && clip != null)
			{
				oneShots.PlayOneShot(clip, volume);
			}
		}

		private void Place()
		{
			KevinRiftAnchor kevinRiftAnchor = ((director != null) ? director.Anchor : null);
			if (kevinRiftAnchor == null || kevinRiftAnchor == _placedAt)
			{
				return;
			}
			_placedAt = kevinRiftAnchor;
			base.transform.SetPositionAndRotation(kevinRiftAnchor.transform.position, Quaternion.Euler(0f, kevinRiftAnchor.transform.eulerAngles.y, 0f));
			for (int i = 0; i < 3 && i < pads.Length; i++)
			{
				if (pads[i] != null)
				{
					pads[i].transform.SetPositionAndRotation(kevinRiftAnchor.PadPosition(i) + Vector3.up * 0.02f, kevinRiftAnchor.PadRotation(i));
				}
			}
			for (int j = 0; j < vortexes.Length; j++)
			{
				int vortexCount = kevinRiftAnchor.VortexCount;
				if (vortexes[j] != null)
				{
					vortexes[j].gameObject.SetActive(j < vortexCount);
				}
				if (j < vortexStreaks.Length && vortexStreaks[j] != null)
				{
					vortexStreaks[j].gameObject.SetActive(j < vortexCount);
				}
				if (j < vortexCount)
				{
					Vector3 position = kevinRiftAnchor.vortexPoints[j] + Vector3.up * 0.04f;
					if (vortexes[j] != null)
					{
						vortexes[j].transform.position = position;
					}
					if (j < vortexStreaks.Length && vortexStreaks[j] != null)
					{
						vortexStreaks[j].transform.position = position;
					}
				}
			}
			if (storm != null)
			{
				storm.transform.position = base.transform.position + Vector3.up * stormHeight;
			}
			if (vortexLoop != null && kevinRiftAnchor.VortexCount > 0)
			{
				Vector3 zero = Vector3.zero;
				for (int k = 0; k < kevinRiftAnchor.VortexCount; k++)
				{
					zero += kevinRiftAnchor.vortexPoints[k];
				}
				vortexLoop.transform.position = zero / kevinRiftAnchor.VortexCount;
			}
		}

		public void Tick()
		{
			if (director == null)
			{
				return;
			}
			Place();
			float deltaTime = Time.deltaTime;
			RiftPhase phase = director.Phase;
			float phaseTime = director.PhaseTime;
			bool flag = phase != RiftPhase.Off && phase != RiftPhase.Away && _placedAt != null;
			if (phase != _lastPhase)
			{
				if (!flag)
				{
					HideAll();
				}
				_lastPhase = phase;
			}
			if (!flag)
			{
				return;
			}
			if (phase == RiftPhase.Charging && phaseTime >= 1.2f)
			{
				if (_struckEpoch != director.Epoch)
				{
					_struckEpoch = director.Epoch;
					if (phaseTime < 1.7f)
					{
						Strike(1f, 1f);
					}
					if (storm != null)
					{
						storm.Form();
					}
				}
			}
			else if (phase == RiftPhase.Cleared || phase == RiftPhase.Failed)
			{
				if (storm != null)
				{
					storm.Clear();
				}
			}
			else if (phase == RiftPhase.Waves && storm != null && !storm.Visible)
			{
				storm.Form();
			}
			TickCrystal(phase, phaseTime, deltaTime);
			TickPads(phase, deltaTime);
			TickCounter(phase);
			TickStrikeFx(phase, phaseTime, deltaTime);
			TickVortexes(phase, phaseTime, deltaTime);
			TickHum(phase);
		}

		private void TickCrystal(RiftPhase phase, float t, float dt)
		{
			if (crystalRoot == null)
			{
				return;
			}
			bool flag = phase != RiftPhase.Cleared || t < 0.08f;
			if (crystalRoot.gameObject.activeSelf != flag)
			{
				crystalRoot.gameObject.SetActive(flag);
			}
			if (!flag)
			{
				return;
			}
			float y = 0f;
			if (phase == RiftPhase.Failed)
			{
				y = (0f - buryDepth) * EaseIn(Mathf.Clamp01(t * 0.5f));
			}
			else if (phase == RiftPhase.Arriving)
			{
				y = (0f - buryDepth) * (1f - EaseOut(Mathf.Clamp01((t - 0.2f) / 1.4f)));
			}
			crystalRoot.localPosition = new Vector3(0f, y, 0f);
			float target;
			switch (phase)
			{
			case RiftPhase.Dormant:
				target = (director.PadsFull ? 1f : ((float)director.PadsHeld * 0.18f));
				break;
			case RiftPhase.Waves:
				target = 0.75f;
				break;
			case RiftPhase.Charging:
				target = 1f;
				break;
			default:
				target = 0f;
				break;
			}
			_awake = Mathf.MoveTowards(_awake, target, dt * 2.5f);
			if (phase == RiftPhase.Charging)
			{
				_charge = Mathf.Clamp01(t / 1.2f);
			}
			else
			{
				_charge = Mathf.MoveTowards(_charge, (phase == RiftPhase.Waves) ? 0.55f : 0f, dt * 0.6f);
			}
			_flash = Mathf.Max(0f, _flash - dt * 5f);
			if (crystal != null)
			{
				crystal.RiftAwake = _awake;
				crystal.RiftCrack = ((phase == RiftPhase.Waves) ? (_charge + Mathf.Sin(Time.time * 3f) * 0.12f) : _charge);
				crystal.RiftFlash = _flash;
			}
		}

		private void TickPads(RiftPhase phase, float dt)
		{
			float num = ((phase == RiftPhase.Charging) ? 1f : ((phase == RiftPhase.Arriving) ? 0.22f : 0f));
			for (int i = 0; i < 3 && i < pads.Length; i++)
			{
				Renderer renderer = pads[i];
				if (renderer == null)
				{
					continue;
				}
				int num2 = ((phase == RiftPhase.Dormant) ? director.PadHolder(i) : 0);
				if (num2 != _lastHolders[i])
				{
					AudioSource audioSource = ((i < padAudio.Length) ? padAudio[i] : null);
					if (audioSource != null)
					{
						audioSource.PlayOneShot((num2 != 0) ? padOn : padOff, (num2 != 0) ? 0.9f : 0.6f);
					}
					_lastHolders[i] = num2;
				}
				float num3 = ((phase == RiftPhase.Dormant) ? ((num2 != 0) ? 1f : 0.22f) : num);
				_padGlow[i] = Mathf.MoveTowards(_padGlow[i], num3, ((num3 > _padGlow[i]) ? 6f : 1.2f) * dt);
				bool flag = phase == RiftPhase.Dormant || phase == RiftPhase.Charging || phase == RiftPhase.Arriving || _padGlow[i] > 0.01f;
				if (renderer.enabled != flag)
				{
					renderer.enabled = flag;
				}
				if (flag)
				{
					renderer.GetPropertyBlock(_block);
					_block.SetFloat(GlowId, _padGlow[i]);
					_block.SetFloat(PulseId, (phase == RiftPhase.Dormant && director.PadsFull) ? 1f : 0f);
					_block.SetFloat(OccupiedId, (num2 != 0) ? ((num2 == RiftPlayers.LocalActor) ? 1f : 0.7f) : 0f);
					renderer.SetPropertyBlock(_block);
				}
			}
		}

		private void TickCounter(RiftPhase phase)
		{
			if (counter == null)
			{
				return;
			}
			int num;
			switch (phase)
			{
			case RiftPhase.Dormant:
				num = (director.PadsFull ? 100 : (director.PadsHeld + 10 * KevinRiftDirector.PadsRequired));
				break;
			case RiftPhase.Cleared:
				num = 300;
				break;
			case RiftPhase.Waves:
				num = ((Time.time < _waveCueUntil) ? (200 + director.Wave) : (-1));
				break;
			default:
				num = -1;
				break;
			}
			if (counter.gameObject.activeSelf != num >= 0)
			{
				counter.gameObject.SetActive(num >= 0);
			}
			if (num < 0)
			{
				return;
			}
			if (num != _counterKey)
			{
				_counterKey = num;
				counter.text = ((num == 100) ? "TOUCH THE CRYSTAL" : ((num < 100) ? string.Format("{0}/{1}", director.PadsHeld, KevinRiftDirector.PadsRequired) : ((num < 300) ? string.Format("WAVE {0}/{1}", director.Wave + 1, director.WaveCount) : "RIFT CLEARED")));
			}
			Transform transform = counter.transform;
			transform.position = base.transform.position + Vector3.up * counterHeight;
			if (RiftPlayers.TryGetLocal(out var avatar))
			{
				Vector3 forward = transform.position - avatar.head;
				forward.y = 0f;
				if (forward.sqrMagnitude > 0.0001f)
				{
					transform.rotation = Quaternion.LookRotation(forward, Vector3.up);
				}
			}
		}

		private void TickStrikeFx(RiftPhase phase, float t, float dt)
		{
			_flashLight = Mathf.Max(0f, _flashLight - dt * 3.2f);
			if (flash != null)
			{
				bool flag = _flashLight > 0.01f;
				if (flash.enabled != flag)
				{
					flash.enabled = flag;
				}
				float num = ((_flashLight < 0.7f && _flashLight > 0.55f) ? 0.35f : 1f);
				if (flag)
				{
					flash.intensity = num * (flashPeak * _flashLight * _flashLight);
				}
			}
			if (ring != null)
			{
				_ring = Mathf.Min(1f, _ring + dt / 0.7f);
				if (ring.enabled != _ring < 1f)
				{
					ring.enabled = _ring < 1f;
				}
				if (_ring < 1f)
				{
					ring.GetPropertyBlock(_block);
					_block.SetFloat(ProgressId, _ring);
					_block.SetFloat(IntensityId, _ringStrength * 2.5f);
					ring.SetPropertyBlock(_block);
				}
			}
			float num2 = 0f;
			if (phase == RiftPhase.Charging)
			{
				num2 = ((t < 1.5f) ? 1f : 0f) * Mathf.Clamp01(t / 1.2f);
			}
			float value = num2 * 2.2f;
			for (int i = 0; i < chargeStreaks.Length; i++)
			{
				Renderer renderer = chargeStreaks[i];
				if (!(renderer == null))
				{
					if (renderer.enabled != num2 > 0.01f)
					{
						renderer.enabled = num2 > 0.01f;
					}
					if (num2 > 0.01f)
					{
						renderer.GetPropertyBlock(_block);
						_block.SetFloat(IntensityId, value);
						renderer.SetPropertyBlock(_block);
					}
				}
			}
			if (!(halo != null))
			{
				return;
			}
			float num3 = Mathf.Max(num2 * 1.5f, _flash * 0.8f, (phase == RiftPhase.Dormant && director.PadsFull) ? (Mathf.Sin(Time.time * 6f) * 0.2f + 0.5f) : 0f);
			if (halo.enabled != num3 > 0.01f)
			{
				halo.enabled = num3 > 0.01f;
			}
			if (num3 > 0.01f)
			{
				halo.transform.position = base.transform.position + Vector3.up * crystalTop;
				if (RiftPlayers.TryGetLocal(out var avatar))
				{
					halo.transform.rotation = Quaternion.LookRotation(halo.transform.position - avatar.head, Vector3.up);
				}
				halo.GetPropertyBlock(_block);
				_block.SetFloat(IntensityId, num3);
				halo.SetPropertyBlock(_block);
			}
		}

		private void TickVortexes(RiftPhase phase, float t, float dt)
		{
			float target;
			float num;
			switch (phase)
			{
			case RiftPhase.Charging:
				target = ((t > 1.5f) ? 1f : 0f);
				num = ((t > 1.5f) ? 0.7f : 0.9f);
				break;
			case RiftPhase.Waves:
				target = 1f;
				num = 0.7f;
				break;
			default:
				target = 0f;
				num = 0.9f;
				break;
			}
			_open = Mathf.MoveTowards(_open, target, dt / num);
			_vortexPulse = Mathf.Max(0f, _vortexPulse - dt * 2f);
			int num2 = ((_placedAt != null) ? _placedAt.VortexCount : 0);
			for (int i = 0; i < vortexes.Length; i++)
			{
				Renderer renderer = vortexes[i];
				Renderer renderer2 = ((i < vortexStreaks.Length) ? vortexStreaks[i] : null);
				bool flag = i < num2 && _open > 0.001f;
				if (renderer != null && renderer.enabled != flag)
				{
					renderer.enabled = flag;
				}
				if (renderer2 != null && renderer2.enabled != flag)
				{
					renderer2.enabled = flag;
				}
				if (flag)
				{
					if (renderer != null)
					{
						renderer.GetPropertyBlock(_block);
						_block.SetFloat(OpenId, _open);
						_block.SetFloat(PulseId, _vortexPulse);
						_block.SetFloat(IntensityId, 1f);
						renderer.SetPropertyBlock(_block);
					}
					if (renderer2 != null)
					{
						renderer2.GetPropertyBlock(_block);
						_block.SetFloat(IntensityId, _open * (_vortexPulse + 0.8f));
						renderer2.SetPropertyBlock(_block);
					}
				}
			}
			if (vortexLoop != null)
			{
				if (_open > 0.001f && !vortexLoop.isPlaying)
				{
					vortexLoop.Play();
				}
				vortexLoop.volume = _open * vortexVolume;
				if (!(_open > 0.001f) && vortexLoop.isPlaying)
				{
					vortexLoop.Stop();
				}
			}
		}

		private void TickHum(RiftPhase phase)
		{
			if (hum == null)
			{
				return;
			}
			AudioClip audioClip = ((phase == RiftPhase.Charging || (phase == RiftPhase.Dormant && director.PadsFull)) ? primedClip : humClip);
			if (phase == RiftPhase.Dormant || phase == RiftPhase.Charging || phase == RiftPhase.Waves || phase == RiftPhase.Arriving)
			{
				if (audioClip != null && hum.clip != audioClip)
				{
					hum.clip = audioClip;
					hum.Play();
				}
				else if (!hum.isPlaying && hum.clip != null)
				{
					hum.Play();
				}
				float num = 1f;
				if (phase == RiftPhase.Arriving)
				{
					num = Mathf.Clamp01(director.PhaseTime / 1.8f);
				}
				hum.volume = humVolume * num;
			}
			else if (hum.isPlaying)
			{
				hum.Stop();
			}
		}

		private static float EaseOut(float t)
		{
			return 1f - (1f - t) * (1f - t);
		}

		private static float EaseIn(float t)
		{
			return t * t;
		}
	}
}
