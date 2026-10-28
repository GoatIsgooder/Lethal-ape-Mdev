using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmImpactFx : MonoBehaviour
	{
		[SerializeField]
		private ParticleSystem[] tinted;

		[SerializeField]
		private ParticleSystem[] untinted;

		[SerializeField]
		[Min(0.1f)]
		private float lifetime = 2.5f;

		private float[] _authoredAlpha;

		private float _hideAt;

		private void Awake()
		{
			_authoredAlpha = new float[(tinted != null) ? tinted.Length : 0];
			for (int i = 0; i < _authoredAlpha.Length; i++)
			{
				_authoredAlpha[i] = ((tinted[i] != null) ? tinted[i].main.startColor.color.a : 1f);
			}
			base.gameObject.SetActive(false);
		}

		public void Play(Vector3 position, Color tint)
		{
			base.transform.SetPositionAndRotation(position, Quaternion.Euler(0f, Random.Range(0f, 360f), 0f));
			base.gameObject.SetActive(true);
			for (int i = 0; i < tinted.Length; i++)
			{
				ParticleSystem ps = tinted[i];
				if (!(ps == null))
				{
					ParticleSystem.MainModule main = ps.main;
					main.startColor = new ParticleSystem.MinMaxGradient(new Color(tint.r, tint.g, tint.b, _authoredAlpha[i]));
					ps.Clear(true);
					ps.Play(true);
				}
			}
			if (untinted != null)
			{
				ParticleSystem[] array = untinted;
				foreach (ParticleSystem ps2 in array)
				{
					if (!(ps2 == null))
					{
						ps2.Clear(true);
						ps2.Play(true);
					}
				}
			}
			_hideAt = Time.time + lifetime;
		}

		private void Update()
		{
			if (!(Time.time < _hideAt))
			{
				base.gameObject.SetActive(false);
			}
		}
	}
}
