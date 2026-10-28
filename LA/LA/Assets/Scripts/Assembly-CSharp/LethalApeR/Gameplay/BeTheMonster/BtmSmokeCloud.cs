using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmSmokeCloud : MonoBehaviour
	{
		[SerializeField]
		private ParticleSystem[] systems;

		[SerializeField]
		[Min(0.5f)]
		private float radius = 3.2f;

		[Tooltip("Seconds for the cloud to bloom to full radius.")]
		[SerializeField]
		[Min(0.05f)]
		private float bloomSeconds = 0.7f;

		[Tooltip("How long a monster walking into the cloud still gets caught.")]
		[SerializeField]
		[Min(0f)]
		private float stunWindow = 6f;

		[SerializeField]
		[Min(0.5f)]
		private float lifetime = 10f;

		private float _bornAt = -100f;

		private bool _hitLocal;

		private void Awake()
		{
			base.gameObject.SetActive(false);
		}

		public void Burst(Vector3 position)
		{
			base.transform.SetPositionAndRotation(position, Quaternion.identity);
			base.gameObject.SetActive(true);
			_bornAt = Time.time;
			_hitLocal = false;
			if (systems == null)
			{
				return;
			}
			for (int i = 0; i < systems.Length; i++)
			{
				ParticleSystem particleSystem = systems[i];
				if (!(particleSystem == null))
				{
					particleSystem.Clear(true);
					particleSystem.Play(true);
				}
			}
		}

		private void Update()
		{
			float num = Time.time - _bornAt;
			if (num >= lifetime)
			{
				base.gameObject.SetActive(false);
			}
			else
			{
				if (_hitLocal || num > stunWindow)
				{
					return;
				}
				BtmItemRuntime instance = BtmItemRuntime.Instance;
				if (!(instance == null) && instance.IsPlaying && instance.LocalRole == BtmRole.Monster && Player.HasInstance)
				{
					Vector3 vector = ((Player.Instance.headCollider != null) ? Player.Instance.headCollider.transform.position : Player.Instance.transform.position);
					float num2 = radius * Mathf.Clamp01(num / bloomSeconds + 0.35f);
					if (!((vector - base.transform.position).sqrMagnitude > num2 * num2))
					{
						_hitLocal = true;
						instance.ApplySmokeHit();
					}
				}
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.8f, 0.8f, 0.85f, 0.6f);
			Gizmos.DrawWireSphere(base.transform.position, radius);
		}
	}
}
