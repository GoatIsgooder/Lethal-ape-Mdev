using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnDeskFan : MonoBehaviour
	{
		[Tooltip("The blade hub; spins about its local forward (+Z) axis.")]
		public Transform blades;

		[Tooltip("Full speed (revolutions per minute).")]
		public float rpm = 780f;

		[Tooltip("Seconds to spin down to a stop, or back up to speed.")]
		public float spinSeconds = 2.5f;

		[Tooltip("The motor hum (FnAudioBank.officeFanLoop). Created on this object when empty.")]
		public AudioSource hum;

		[Range(0f, 1f)]
		public float humVolume = 0.35f;

		private float _speed;

		private FnAudioGate _gate;

		private void Awake()
		{
			if (hum == null)
			{
				hum = base.gameObject.AddComponent<AudioSource>();
				hum.spatialBlend = 1f;
				hum.rolloffMode = AudioRolloffMode.Linear;
				hum.minDistance = 0.5f;
				hum.maxDistance = 7f;
				hum.dopplerLevel = 0f;
			}
			hum.spatialize = false;
			_gate = hum.GetComponent<FnAudioGate>();
			if (_gate == null)
			{
				_gate = hum.gameObject.AddComponent<FnAudioGate>();
				_gate.audibleWithin = 7f;
				_gate.hysteresis = 1f;
			}
		}

		private void Start()
		{
			FnAudioBank audio = FnGame.Audio;
			if (hum.clip == null && audio != null)
			{
				hum.clip = audio.officeFanLoop;
			}
		}

		private void Update()
		{
			FnNight instance = FnNight.Instance;
			float num = 1f;
			if (!(instance == null) && instance.InNightRoom)
			{
				num = (instance.Blackout ? 0f : 1f);
			}
			_speed = Mathf.MoveTowards(_speed, num, Time.deltaTime / Mathf.Max(spinSeconds, 0.1f));
			if (blades != null && _speed > 0f)
			{
				blades.Rotate(0f, 0f, _speed * (rpm * 6f) * Time.deltaTime, Space.Self);
			}
			_gate.Wanted = _speed > 0.02f;
			hum.volume = _speed * humVolume;
			hum.pitch = Mathf.Lerp(0.55f, 1f, _speed);
		}
	}
}
