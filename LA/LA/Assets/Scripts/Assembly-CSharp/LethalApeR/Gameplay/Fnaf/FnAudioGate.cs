using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[RequireComponent(typeof(AudioSource))]
	public class FnAudioGate : MonoBehaviour
	{
		[Tooltip("Voiced inside this distance to the local head (m).")]
		public float audibleWithin = 14f;

		[Tooltip("Extra distance before it is silenced again (m).")]
		public float hysteresis = 2f;

		[Tooltip("Checks per second.")]
		public float checkHz = 4f;

		[Tooltip("Start wanted (ambience). Owners flip Wanted for event loops.")]
		public bool wantedOnStart = true;

		[Tooltip("Start each voicing at a random point (ambience beds), or at the top (a tune like the music box).")]
		public bool randomStart = true;

		[Tooltip("Fade in and out over this long (s), so a loop never starts or stops with a click.")]
		public float fadeSeconds = 0.15f;

		private AudioSource _source;

		private float _nextCheck;

		private bool _voiced;

		private float _volume;

		private float _level;

		public bool Wanted { get; set; }

		private void Awake()
		{
			_source = GetComponent<AudioSource>();
			_source.playOnAwake = false;
			_source.spatialize = false;
			_source.loop = true;
			_volume = _source.volume;
			_source.volume = 0f;
			Wanted = wantedOnStart;
		}

		private void OnDisable()
		{
			if (_source != null && _source.isPlaying)
			{
				_source.Stop();
			}
			_voiced = false;
			_level = 0f;
			if (_source != null)
			{
				_source.volume = 0f;
			}
		}

		private void Update()
		{
			if (Time.unscaledTime >= _nextCheck)
			{
				_nextCheck = Time.unscaledTime + 1f / Mathf.Max(0.5f, checkHz);
				Transform head = FnPlatform.Head;
				bool voiced = false;
				if (head != null)
				{
					float num = Vector3.Distance(head.position, base.transform.position);
					float num2 = audibleWithin + (_voiced ? hysteresis : 0f);
					if (num <= num2 && Wanted && _source.clip != null)
					{
						if (!_voiced && !_source.isPlaying)
						{
							_source.time = (randomStart ? Random.Range(0f, _source.clip.length * 0.9f) : 0f);
							_source.Play();
						}
						voiced = true;
					}
				}
				_voiced = voiced;
			}
			float num3 = (_voiced ? 1f : 0f);
			if (!Mathf.Approximately(_level, num3))
			{
				_level = Mathf.MoveTowards(_level, num3, Time.unscaledDeltaTime / Mathf.Max(0.01f, fadeSeconds));
				_source.volume = _level * _volume;
				if (_level <= 0f && _source.isPlaying)
				{
					_source.Stop();
				}
			}
		}
	}
}
