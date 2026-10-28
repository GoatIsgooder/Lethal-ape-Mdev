using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	public sealed class BansheeGrave : MonoBehaviour
	{
		[Tooltip("Where she rises from (in the dirt in front of the headstone).")]
		public Transform spawn;

		[Tooltip("Lit candle objects, in lighting order.")]
		public GameObject[] litCandles = new GameObject[5];

		[Tooltip("Unlit candle objects, same order.")]
		public GameObject[] unlitCandles = new GameObject[5];

		[Tooltip("The flames (scaled for flicker), same order.")]
		public Transform[] flames = new Transform[5];

		[Tooltip("Soft glow on the dirt that grows with the meter.")]
		public Renderer groundGlow;

		public ParticleSystem riseBurst;

		[Header("Audio")]
		public AudioSource ambience;

		public AudioSource oneShots;

		public AudioClip[] candleClips = new AudioClip[0];

		public AudioClip risePale;

		public AudioClip riseRed;

		[ColorUsage(false, true)]
		public Color paleGlow = new Color(0.22f, 0.24f, 0.32f, 1f);

		[ColorUsage(false, true)]
		public Color redGlow = new Color(1f, 0.07f, 0.04f, 1f);

		private static readonly int TintId = Shader.PropertyToID("_Tint");

		private BansheeDirector _director;

		private int _index;

		private int _shown = -1;

		private float _glow;

		private Vector3[] _flameScale = new Vector3[0];

		private MaterialPropertyBlock _block;

		public Vector3 SpawnPoint
		{
			get
			{
				if (spawn != null)
				{
					return spawn.position;
				}
				return base.transform.position + base.transform.forward * 0.8f;
			}
		}

		public void Bind(BansheeDirector director, int index)
		{
			_director = director;
			_index = index;
			_block = new MaterialPropertyBlock();
			_flameScale = new Vector3[flames.Length];
			for (int i = 0; i < flames.Length; i++)
			{
				_flameScale[i] = ((flames[i] != null) ? flames[i].localScale : Vector3.one);
			}
			ShowCandles(0, announce: false);
			if (ambience != null)
			{
				ambience.loop = true;
				ambience.volume = 0f;
			}
		}


		public void Tick(float dt)
		{
			if (_director == null)
			{
				return;
			}
			float meter = _director.Meter(_index);
			BansheePhase phase = _director.Phase;
			int graveIndex = _director.GraveIndex;
			float glow = 0f;
			int count;
			switch (phase)
			{
			case BansheePhase.Rising:
			case BansheePhase.Hunting:
			case BansheePhase.Chasing:
			case BansheePhase.Grabbing:
				if (graveIndex == _index)
				{
					count = 5;
					glow = ((phase == BansheePhase.Rising) ? 1f : 0.45f);
				}
				else
				{
					count = 0;
				}
				break;
			case BansheePhase.Leaving:
				count = ((graveIndex == _index) ? ((_director.Exit != BansheeExit.Caught) ? 5 : 0) : 0);
				break;
			case BansheePhase.Sleeping:
				count = Mathf.FloorToInt(meter * 5f + 0.001f);
				glow = meter * 0.6f;
				break;
			default:
				count = 0;
				break;
			}
			if (count != _shown)
			{
				ShowCandles(count, count > _shown && _shown >= 0 && phase == BansheePhase.Sleeping);
			}
			float hot = ((graveIndex == _index && _director.IsOut) ? 1f : 0f);
			float speed = hot * 10f + 6f;
			float flicker = hot * 0.25f;
			for (int i = 0; i < count && i < flames.Length; i++)
			{
				if (!(flames[i] == null))
				{
					float noise = Mathf.PerlinNoise(Time.time * speed, (float)i * 3.7f);
					flames[i].localScale = _flameScale[i] * (noise * 0.45f + 0.8f + flicker * Mathf.Sin(Time.time * 31f + (float)i));
				}
			}
			_glow = Mathf.MoveTowards(_glow, glow, dt * 1.5f);
			if (groundGlow != null)
			{
				if (groundGlow.enabled != _glow > 0.005f)
				{
					groundGlow.enabled = _glow > 0.005f;
				}
				if (_glow > 0.005f)
				{
					Color color = ((_director.Form == BansheeForm.Red && _director.IsOut) ? redGlow : paleGlow);
					float pulse = Mathf.Sin(Time.time * 3f);
					groundGlow.GetPropertyBlock(_block);
					_block.SetColor(TintId, color * (_glow * (pulse * 0.15f + 0.85f)));
					groundGlow.SetPropertyBlock(_block);
				}
			}
			if (ambience != null)
			{
				float volume = ((phase == BansheePhase.Sleeping) ? (meter * 0.75f + 0.12f) : 0f);
				ambience.volume = Mathf.MoveTowards(ambience.volume, volume, dt * 0.6f);
				if (ambience.volume > 0.001f && !ambience.isPlaying && ambience.clip != null && ambience.isActiveAndEnabled)
				{
					ambience.Play();
				}
				else if (!(ambience.volume > 0.001f) && ambience.isPlaying)
				{
					ambience.Stop();
				}
			}
		}

		private void ShowCandles(int count, bool announce)
		{
			for (int i = 0; i < litCandles.Length; i++)
			{
				if (litCandles[i] != null && litCandles[i].activeSelf != i < count)
				{
					litCandles[i].SetActive(i < count);
				}
				if (i < unlitCandles.Length && unlitCandles[i] != null && unlitCandles[i].activeSelf != i >= count)
				{
					unlitCandles[i].SetActive(i >= count);
				}
			}
			if (announce && oneShots != null && candleClips.Length != 0)
			{
				oneShots.PlayOneShot(candleClips[Random.Range(0, candleClips.Length)], 0.8f);
			}
			_shown = count;
		}

		public void OnPhase(BansheePhase previous, BansheePhase phase, bool mine)
		{
			if (previous == BansheePhase.Rising || phase != BansheePhase.Rising || !mine)
			{
				return;
			}
			if (riseBurst != null)
			{
				ParticleSystem.MainModule main = riseBurst.main;
				main.startColor = ((_director != null && _director.Form == BansheeForm.Red) ? redGlow : paleGlow) * 0.5f;
				riseBurst.Play();
			}
			AudioClip clip = ((_director != null && _director.Form == BansheeForm.Red) ? riseRed : risePale);
			if (oneShots != null && clip != null)
			{
				oneShots.PlayOneShot(clip);
			}
		}
	}
}
