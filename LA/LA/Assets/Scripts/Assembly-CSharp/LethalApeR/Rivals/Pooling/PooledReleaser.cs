using UnityEngine;

namespace LethalApeR.Rivals.Pooling
{
	public class PooledReleaser : MonoBehaviour
	{
		private float _releaseAt;

		private bool _running;

		public void Begin(float lifetime)
		{
			_releaseAt = Time.time + Mathf.Max(0.01f, lifetime);
			_running = true;
		}

		private void Update()
		{
			if (_running && !(Time.time < _releaseAt))
			{
				_running = false;
				SimplePool.Release(base.gameObject);
			}
		}
	}
}
