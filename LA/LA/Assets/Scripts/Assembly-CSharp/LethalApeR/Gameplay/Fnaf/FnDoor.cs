using LethalApeR.Gameplay.ApeGames;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnDoor : MonoBehaviour
	{
		public FnDoorSide side;

		[Tooltip("The moving panel. Its collider blocks players while it is down.")]
		public Transform panel;

		[Tooltip("Panel local position when open (raised) and closed (down).")]
		public Vector3 openLocalPosition = new Vector3(0f, 2.4f, 0f);

		public Vector3 closedLocalPosition = Vector3.zero;

		[Tooltip("Blinks while the door's buttons are jammed.")]
		public Renderer jamLamp;

		[Tooltip("Dust puff on a bang (door-local, optional).")]
		public ParticleSystem dust;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private MaterialPropertyBlock _mpb;

		private bool _closed;

		private float _shakeUntil;

		private float _shakeAmount;

		private Vector3 _shakeOffset;

		private bool _lastJamLit;

		private FnAnim _knocker;

		private int _rapsLeft;

		private int _rapIndex;

		private float _burstAt;

		private bool _slam;

		private void OnEnable()
		{
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.Knocked += OnKnocked;
			}
		}

		private void OnDisable()
		{
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.Knocked -= OnKnocked;
			}
			_rapsLeft = 0;
		}

		private void OnKnocked(FnAnim anim, FnDoorSide knockSide, int raps, bool heavy)
		{
			if (knockSide == side)
			{
				_knocker = anim;
				_rapsLeft = Mathf.Clamp(raps, 1, 6);
				_rapIndex = 0;
				_burstAt = Time.time;
				_slam = heavy;
			}
		}

		private void PlayDueRaps()
		{
			while (_rapsLeft > 0)
			{
				float num = Time.time - _burstAt;
				float num2 = (_slam ? 0.36f : 0.22999999f);
				float num3 = (_slam ? ((_knocker == FnAnim.Endo) ? 0.34f : 0.62f) : (_knocker switch
				{
					FnAnim.Bear => 0.27f,
					FnAnim.Bunny => 0.19f,
					FnAnim.Chicken => 0.23f,
					_ => 0.3f,
				}));
				if (num < num2 + num3 * (float)Mathf.Max(0, _rapIndex))
				{
					break;
				}
				Rap(_slam, _rapIndex);
				_rapsLeft--;
				_rapIndex++;
			}
		}

		private void Rap(bool slam, int index)
		{
			FnSettings.OfficeSettings office = FnGame.Settings.office;
			float time = Time.time;
			if (slam)
			{
				_shakeUntil = time + office.bangShakeSeconds * 1.6f;
				_shakeAmount = office.bangShakeAmount;
			}
			else
			{
				_shakeUntil = time + 0.12f;
				_shakeAmount = office.bangShakeAmount * 0.3f;
			}
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				AudioClip clip;
				float volume;
				if (slam)
				{
					clip = FnAudioBank.Pick(audio.bangHeavy);
					volume = 1f;
				}
				else
				{
					clip = FnAudioBank.Pick(audio.bang);
					volume = ((index != 0) ? Random.Range(0.72f, 0.85f) : 0.9f);
				}
				FnAudio.Play(clip, base.transform.position, volume, 1f, slam ? 24f : 16f, Random.Range(0.95f, 1.05f));
			}
			if (slam)
			{
				if (dust != null)
				{
					dust.Play();
				}
				FnHallLight fnHallLight = ((FnOffice.Instance != null) ? ((side == FnDoorSide.West) ? FnOffice.Instance.westLight : FnOffice.Instance.eastLight) : null);
				if (fnHallLight != null)
				{
					fnHallLight.Flicker();
				}
				HapticIfClose(heavy: true);
			}
		}

		private void HapticIfClose(bool heavy)
		{
			Transform head = FnPlatform.Head;
			if (!(head == null) && !((head.position - base.transform.position).sqrMagnitude > 4f))
			{
				AgHaptics.Both(heavy ? 0.9f : 0.5f, heavy ? 0.25f : 0.12f);
			}
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || panel == null)
			{
				return;
			}
			PlayDueRaps();
			bool flag = instance.Active && instance.DoorClosed(side);
			if (_closed != flag)
			{
				_closed = flag;
				FnAudioBank audio = FnGame.Audio;
				if (audio != null)
				{
					FnAudio.Play(flag ? FnAudioBank.Pick(audio.doorSlam) : audio.doorOpen, base.transform.position, 0.9f, 1f, 16f, 1f);
				}
			}
			Vector3 target = (flag ? closedLocalPosition : openLocalPosition);
			float num = Mathf.Max(FnGame.Settings.office.doorTravelSeconds, 0.05f);
			Vector3 current = panel.localPosition - _shakeOffset;
			current = Vector3.MoveTowards(current, target, Vector3.Distance(openLocalPosition, closedLocalPosition) / num * Time.deltaTime);
			_shakeOffset = Vector3.zero;
			if (Time.time < _shakeUntil)
			{
				float shakeAmount = _shakeAmount;
				_shakeOffset = new Vector3(Random.Range(0f - shakeAmount, shakeAmount), Random.Range(0f - shakeAmount, shakeAmount) * 0.3f, Random.Range(0f - shakeAmount, shakeAmount) * 0.5f);
			}
			panel.localPosition = current + _shakeOffset;
			if (!(jamLamp == null))
			{
				bool flag2 = instance.Active && instance.DoorJammed(side) && Mathf.Repeat(Time.time, 0.5f) < 0.25f;
				if (_lastJamLit != flag2)
				{
					_lastJamLit = flag2;
					Color value = (flag2 ? new Color(1f, 0.1f, 0.05f) : new Color(0.15f, 0.05f, 0.05f));
					if (_mpb == null)
					{
						_mpb = new MaterialPropertyBlock();
					}
					jamLamp.GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, value);
					_mpb.SetColor(BaseColorId, value);
					_mpb.SetColor(EmissionId, value);
					jamLamp.SetPropertyBlock(_mpb);
				}
			}
		}
	}
}
