using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class RiftStorm : MonoBehaviour
	{
		private static readonly int CoverageId = Shader.PropertyToID("_Coverage");

		private static readonly int FlashId = Shader.PropertyToID("_Flash");

		public Renderer cloud;

		[Tooltip("Bolts that flicker inside the cloud (and drop onto vortexes when a zombie climbs out).")]
		public RiftBolt[] bolts = new RiftBolt[0];

		public AudioSource loop;

		public AudioClip crackle;

		[Tooltip("Cloud radius (m), for placing the inner flickers.")]
		public float radius = 9f;

		[Tooltip("Seconds between flickers inside the cloud.")]
		public Vector2 flickerEvery = new Vector2(2.2f, 4.8f);

		public float formTime = 1.6f;

		public float clearTime = 2.2f;

		[Range(0f, 1f)]
		public float loopVolume = 0.55f;

		private MaterialPropertyBlock _block;

		private float _coverage;

		private float _target;

		private float _flash;

		private float _nextFlicker;

		private int _boltCursor;

		public bool Visible => _coverage > 0.001f;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			Apply();
		}

		public void Form()
		{
			_target = 1f;
			_nextFlicker = Time.time + Random.Range(0.6f, 1.4f);
			if (cloud != null)
			{
				cloud.enabled = true;
			}
			if (loop != null && !loop.isPlaying)
			{
				loop.Play();
			}
		}

		public void Clear()
		{
			_target = 0f;
		}

		public void Hide()
		{
			_coverage = 0f;
			_target = 0f;
			_flash = 0f;
			if (loop != null)
			{
				loop.Stop();
			}
			Apply();
		}

		public void Flash(float amount)
		{
			_flash = Mathf.Max(_flash, amount);
		}

		public void StrikeDown(Vector3 point)
		{
			if (Visible && bolts.Length != 0)
			{
				RiftBolt riftBolt = bolts[_boltCursor++ % bolts.Length];
				Vector3 from = transform.position + Vector3.ProjectOnPlane(point - transform.position, Vector3.up) * 0.4f;
				riftBolt.Strike(from, point + Vector3.up * 0.1f, 0.28f, 0.55f, 1, 0.45f);
				_flash = Mathf.Max(_flash, 1.2f);
			}
		}

		private void Update()
		{
			float deltaTime = Time.deltaTime;
			float num = 1f / Mathf.Max((_target > _coverage) ? formTime : clearTime, 0.05f);
			_coverage = Mathf.MoveTowards(_coverage, _target, deltaTime * num);
			_flash = Mathf.Max(0f, _flash - deltaTime * 4f);
			if (_target > 0.5f && Time.time >= _nextFlicker)
			{
				_nextFlicker = Time.time + Random.Range(flickerEvery.x, flickerEvery.y);
				Flicker();
			}
			if (loop != null)
			{
				loop.volume = _coverage * loopVolume;
				if (_coverage <= 0.001f && loop.isPlaying)
				{
					loop.Stop();
				}
			}
			Apply();
		}

		private void Flicker()
		{
			_flash = Mathf.Max(_flash, Random.Range(0.6f, 1.1f));
			if (bolts.Length != 0)
			{
				RiftBolt riftBolt = bolts[_boltCursor++ % bolts.Length];
				if (!riftBolt.Live)
				{
					Vector2 vector = Random.insideUnitCircle * radius * 0.7f;
					Vector2 normalized = Random.insideUnitCircle.normalized;
					Vector2 vector2 = vector + normalized * radius * Random.Range(0.3f, 0.6f);
					riftBolt.Strike(transform.TransformPoint(new Vector3(vector.x, -0.4f, vector.y)), transform.TransformPoint(new Vector3(vector2.x, -0.6f, vector2.y)), 0.22f, 0.35f, 1, 0.5f);
				}
			}
			if (loop != null && crackle != null)
			{
				loop.PlayOneShot(crackle, 0.5f);
			}
		}

		private void Apply()
		{
			if (!(cloud == null))
			{
				bool visible = Visible;
				if (cloud.enabled != visible)
				{
					cloud.enabled = visible;
				}
				if (visible)
				{
					cloud.GetPropertyBlock(_block);
					_block.SetFloat(CoverageId, _coverage);
					_block.SetFloat(FlashId, _flash);
					cloud.SetPropertyBlock(_block);
				}
			}
		}
	}
}
