using System.Collections.Generic;
using LethalApeR.Rivals.Combat;
using LethalApeR.Rivals.Pooling;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	public class Projectile : MonoBehaviour
	{
		[Tooltip("Layers the projectile collides with. Set to your environment + players.")]
		[SerializeField]
		private LayerMask collisionMask = -1;

		[Tooltip("Trail/visual root spawned with the projectile (optional).")]
		[SerializeField]
		private GameObject visualRoot;

		private float _speed;

		private float _maxLifetime;

		private float _explosionRadius;

		private float _damage;

		private float _headshotMultiplier;

		private int _ownerActor;

		private Team _ownerTeam;

		private WeaponType _weaponType;

		private string _sourceName;

		private GameObject _impactVfx;

		private float _vfxLifetime;

		private Vector3 _velocity;

		private float _spawnTime;

		private bool _active;

		private static readonly Collider[] _overlap = new Collider[32];

		public void Launch(WeaponData data, Vector3 origin, Vector3 direction, int ownerActor, Team ownerTeam)
		{
			_speed = data.projectileSpeed;
			_maxLifetime = 6f;
			_explosionRadius = data.explosionRadius;
			_damage = data.damage;
			_headshotMultiplier = data.headshotMultiplier;
			_ownerActor = ownerActor;
			_ownerTeam = ownerTeam;
			_weaponType = data.type;
			_sourceName = data.displayName;
			_impactVfx = data.impactVfxPrefab;
			_vfxLifetime = data.vfxLifetime;
			direction = direction.normalized;
			base.transform.position = origin;
			base.transform.rotation = Quaternion.LookRotation(direction);
			_velocity = direction * _speed;
			_spawnTime = Time.time;
			_active = true;
			if (visualRoot != null)
			{
				visualRoot.SetActive(true);
			}
		}

		private void FixedUpdate()
		{
			if (!_active)
			{
				return;
			}
			float fixedDeltaTime = Time.fixedDeltaTime;
			float num = _velocity.magnitude * fixedDeltaTime;
			Vector3 position = base.transform.position;
			if (num > 0f && Physics.Raycast(position, _velocity.normalized, out var hitInfo, num, collisionMask, QueryTriggerInteraction.Ignore))
			{
				Detonate(hitInfo.point, hitInfo.normal, hitInfo.collider);
				return;
			}
			base.transform.position = position + _velocity * fixedDeltaTime;
			base.transform.rotation = Quaternion.LookRotation(_velocity.normalized);
			if (Time.time - _spawnTime >= _maxLifetime)
			{
				Detonate(base.transform.position, Vector3.up, null);
			}
		}

		private void Detonate(Vector3 point, Vector3 normal, Collider directHit)
		{
			_active = false;
			if (_explosionRadius > 0f)
			{
				int num = Physics.OverlapSphereNonAlloc(point, _explosionRadius, _overlap, -1, QueryTriggerInteraction.Collide);
				HashSet<IDamageable> hashSet = new HashSet<IDamageable>();
				for (int i = 0; i < num; i++)
				{
					Collider collider = _overlap[i];
					if (collider == null)
					{
						continue;
					}
					IDamageable componentInParent = collider.GetComponentInParent<IDamageable>();
					if (componentInParent != null && componentInParent.IsAlive && !hashSet.Contains(componentInParent))
					{
						hashSet.Add(componentInParent);
						float num2 = 1f - Mathf.Clamp01(Vector3.Distance(point, collider.transform.position) / _explosionRadius);
						if (num2 > 0f)
						{
							DamageInfo info = DamageInfo.Create(_damage * num2, _ownerActor, _weaponType, _sourceName, point, normal, false, _headshotMultiplier);
							componentInParent.ApplyDamage(in info);
						}
					}
				}
			}
			else if (directHit != null)
			{
				IDamageable componentInParent2 = directHit.GetComponentInParent<IDamageable>();
				if (componentInParent2 != null && componentInParent2.IsAlive)
				{
					DamageInfo info2 = DamageInfo.Create(_damage, _ownerActor, _weaponType, _sourceName, point, normal, Weapon.IsHeadCollider(directHit), _headshotMultiplier);
					componentInParent2.ApplyDamage(in info2);
				}
			}
			if (_impactVfx != null)
			{
				SimplePool.SpawnTimed(_impactVfx, point, Quaternion.LookRotation(normal), _vfxLifetime);
			}
			if (visualRoot != null)
			{
				visualRoot.SetActive(false);
			}
			SimplePool.Release(base.gameObject);
		}

		private void OnDrawGizmosSelected()
		{
			if (_explosionRadius > 0f)
			{
				Gizmos.color = new Color(1f, 0.85f, 0f, 0.6f);
				Gizmos.DrawWireSphere(base.transform.position, _explosionRadius);
			}
		}
	}
}
