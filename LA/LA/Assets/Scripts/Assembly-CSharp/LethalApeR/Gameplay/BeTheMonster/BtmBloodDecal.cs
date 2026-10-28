using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmBloodDecal : MonoBehaviour
	{
		private const int MaxLive = 48;

		private static readonly Queue<BtmBloodDecal> Live = new Queue<BtmBloodDecal>();

		private static readonly int AtlasId = Shader.PropertyToID("_Atlas");

		private static readonly int FadeId = Shader.PropertyToID("_Fade");

		[SerializeField]
		private MeshRenderer target;

		[SerializeField]
		private Vector2 scaleRange = new Vector2(0.5f, 1.05f);

		[SerializeField]
		private float surfaceOffset = 0.012f;

		[SerializeField]
		private float lifetime = 26f;

		[SerializeField]
		private float fadeSeconds = 5f;

		private MaterialPropertyBlock _block;

		private float _age;

		private float _scale;

		private float _growSeconds;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetLive()
		{
			Live.Clear();
		}

		public void Place(Vector3 position, Vector3 normal, float size)
		{
			if (!target)
			{
				target = GetComponentInChildren<MeshRenderer>();
			}
			if (!target)
			{
				return;
			}
			transform.position = position + normal * surfaceOffset;
			transform.rotation = Quaternion.LookRotation(-normal, Random.onUnitSphere) * Quaternion.Euler(0f, 0f, Random.Range(0f, 360f));
			_scale = Random.Range(scaleRange.x, scaleRange.y) * size;
			transform.localScale = Vector3.one * _scale;
			if (_block == null)
			{
				_block = new MaterialPropertyBlock();
			}
			_block.SetFloat(AtlasId, Random.Range(0, 4));
			_block.SetFloat(FadeId, 1f);
			target.SetPropertyBlock(_block);
			_age = 0f;
			Live.Enqueue(this);
			while (Live.Count > MaxLive)
			{
				BtmBloodDecal oldest = Live.Dequeue();
				if (oldest && oldest != this)
				{
					Destroy(oldest.gameObject);
				}
			}
		}

		public void Grow(float seconds)
		{
			_growSeconds = Mathf.Max(seconds, 0.01f);
			transform.localScale = Vector3.one * (_scale * 0.2f);
		}

		private void Update()
		{
			_age += Time.deltaTime;
			if (_age >= lifetime)
			{
				Destroy(gameObject);
				return;
			}
			if (_growSeconds > 0f && _age <= _growSeconds)
			{
				transform.localScale = Vector3.one * (_scale * Mathf.SmoothStep(0.2f, 1f, _age / _growSeconds));
			}
			float fadeStart = lifetime - fadeSeconds;
			if (_age >= fadeStart && target && _block != null)
			{
				_block.SetFloat(FadeId, 1f - Mathf.InverseLerp(fadeStart, lifetime, _age));
				target.SetPropertyBlock(_block);
			}
		}
	}
}
