using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[RequireComponent(typeof(ParticleSystem))]
	public sealed class BtmBloodBurst : MonoBehaviour
	{
		[Tooltip("Slower, heavier emitters (drips) played alongside the main spray.")]
		[SerializeField]
		private ParticleSystem[] additional;

		[Tooltip("Players, ragdolls and invisible blockers walk away from anything that lands on them, so blood stopping on them would hang in the air. World only.")]
		[SerializeField]
		private LayerMask collisionLayers = 1;

		[Header("Splats")]
		[Tooltip("Every droplet that lands would cost a quad of overdraw; only the first few of a burst leave a mark.")]
		[SerializeField]
		private int maxDecals = 2;

		[SerializeField]
		private float minDecalSpacing = 0.65f;

		[SerializeField]
		private float despawnPadding = 1.5f;

		private ParticleSystem _particles;

		private BtmGore _gore;

		private readonly List<ParticleCollisionEvent> _events = new List<ParticleCollisionEvent>();

		private readonly List<Vector3> _decalPoints = new List<Vector3>();

		private float _despawnAt = -1f;

		private void Awake()
		{
			_particles = GetComponent<ParticleSystem>();
			Configure(_particles, reportCollisions: true);
			if (additional == null)
			{
				return;
			}
			ParticleSystem[] array = additional;
			foreach (ParticleSystem particleSystem in array)
			{
				if ((bool)particleSystem)
				{
					Configure(particleSystem, reportCollisions: false);
				}
			}
		}

		private void Configure(ParticleSystem ps, bool reportCollisions)
		{
			ParticleSystem.MainModule main = ps.main;
			main.simulationSpace = ParticleSystemSimulationSpace.World;
			main.playOnAwake = false;
			ParticleSystem.CollisionModule collision = ps.collision;
			collision.enabled = true;
			collision.type = ParticleSystemCollisionType.World;
			collision.collidesWith = collisionLayers;
			collision.enableDynamicColliders = false;
			collision.sendCollisionMessages = reportCollisions;
		}

		public void Play(BtmGore gore, Vector3 position, Vector3 direction)
		{
			_gore = gore;
			Vector3 forward = ((direction.sqrMagnitude > 0.0001f) ? direction.normalized : Vector3.up);
			base.transform.SetPositionAndRotation(position, Quaternion.LookRotation(forward));
			_decalPoints.Clear();
			_particles.Play();
			if (additional != null)
			{
				ParticleSystem[] array = additional;
				foreach (ParticleSystem particleSystem in array)
				{
					if ((bool)particleSystem)
					{
						particleSystem.Play();
					}
				}
			}
			_despawnAt = Time.time + LongestDuration() + despawnPadding;
		}

		private float LongestDuration()
		{
			float num = _particles.main.duration + _particles.main.startLifetime.constantMax;
			if (additional != null)
			{
				ParticleSystem[] array = additional;
				foreach (ParticleSystem particleSystem in array)
				{
					if ((bool)particleSystem)
					{
						num = Mathf.Max(num, particleSystem.main.duration + particleSystem.main.startLifetime.constantMax);
					}
				}
			}
			return num;
		}

		private void Update()
		{
			if (_despawnAt > 0f && Time.time >= _despawnAt)
			{
				Object.Destroy(base.gameObject);
			}
		}

		private void OnParticleCollision(GameObject other)
		{
			if (!_gore || !_gore.decalPrefab || _decalPoints.Count >= maxDecals)
			{
				return;
			}
			int collisionEvents = _particles.GetCollisionEvents(other, _events);
			for (int i = 0; i < collisionEvents; i++)
			{
				if (_decalPoints.Count >= maxDecals)
				{
					break;
				}
				Vector3 intersection = _events[i].intersection;
				if (!TooClose(intersection))
				{
					Object.Instantiate(_gore.decalPrefab).Place(intersection, _events[i].normal, 1f);
					_decalPoints.Add(intersection);
				}
			}
		}

		private bool TooClose(Vector3 point)
		{
			float num = minDecalSpacing * minDecalSpacing;
			foreach (Vector3 decalPoint in _decalPoints)
			{
				if ((decalPoint - point).sqrMagnitude < num)
				{
					return true;
				}
			}
			return false;
		}
	}
}
