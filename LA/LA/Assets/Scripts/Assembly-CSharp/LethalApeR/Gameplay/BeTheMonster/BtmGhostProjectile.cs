using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGhostProjectile : MonoBehaviour
	{
		private const float MaxLife = 3f;

		private const float LandedLinger = 0.6f;

		private static readonly int LandMask = -9797;

		private Vector3 _velocity;

		private Vector3 _spin;

		private float _dieAt;

		private bool _landed;

		public static BtmGhostProjectile Spawn(GameObject prefab, Vector3 position, Vector3 velocity)
		{
			GameObject gameObject = BtmVisualCopy.Create(prefab, position, Random.rotationUniform);
			if (gameObject == null)
			{
				return null;
			}
			BtmGhostProjectile btmGhostProjectile = gameObject.AddComponent<BtmGhostProjectile>();
			btmGhostProjectile._velocity = velocity;
			btmGhostProjectile._spin = Random.onUnitSphere * Random.Range(180f, 420f);
			btmGhostProjectile._dieAt = Time.time + MaxLife;
			return btmGhostProjectile;
		}

		private void Update()
		{
			float deltaTime = Time.deltaTime;
			if (Time.time >= _dieAt)
			{
				Object.Destroy(base.gameObject);
			}
			else
			{
				if (_landed)
				{
					return;
				}
				_velocity += Physics.gravity * deltaTime;
				Vector3 step = _velocity * deltaTime;
				float magnitude = step.magnitude;
				if (magnitude > 0f && Physics.Raycast(base.transform.position, step / magnitude, out RaycastHit hitInfo, magnitude + 0.04f, LandMask, QueryTriggerInteraction.Ignore))
				{
					base.transform.position = hitInfo.point + hitInfo.normal * 0.03f;
					_landed = true;
					_dieAt = Mathf.Min(_dieAt, Time.time + LandedLinger);
				}
				else
				{
					base.transform.position += step;
					base.transform.Rotate(_spin * deltaTime, Space.World);
				}
			}
		}
	}
}
