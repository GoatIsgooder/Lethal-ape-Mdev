using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmMapVolumeBinder : MonoBehaviour
	{
		[Tooltip("This map's volumes, highest priority first (the first one containing the camera wins).")]
		[SerializeField]
		private BakeryVolume[] volumes;

		[Header("Fog while inside the map")]
		[SerializeField]
		private bool overrideFog = true;

		[SerializeField]
		private bool fog = true;

		[SerializeField]
		private Color fogColor = new Color(0f, 0f, 0f, 1f);

		[SerializeField]
		private FogMode fogMode = FogMode.ExponentialSquared;

		[SerializeField]
		private float fogDensity = 0.079f;

		[SerializeField]
		private float fogStartDistance;

		[SerializeField]
		private float fogEndDistance = 300f;

		private BakeryVolume _bound;

		private Camera _cam;

		private bool _fogApplied;

		private bool _prevFog;

		private Color _prevFogColor;

		private FogMode _prevFogMode;

		private float _prevFogDensity;

		private float _prevFogStart;

		private float _prevFogEnd;

		private void OnEnable()
		{
			for (int i = 0; i < volumes.Length; i++)
			{
				if (volumes[i] != null)
				{
					volumes[i].UpdateBounds();
				}
			}
		}

		public bool Contains(Vector3 point, float margin)
		{
			for (int i = 0; i < volumes.Length; i++)
			{
				if (!(volumes[i] == null))
				{
					Bounds bounds = volumes[i].bounds;
					bounds.Expand(margin * 2f);
					if (bounds.Contains(point))
					{
						return true;
					}
				}
			}
			return false;
		}

		private void LateUpdate()
		{
			if (_cam == null || !_cam.isActiveAndEnabled)
			{
				_cam = Camera.main;
			}
			if (_cam == null)
			{
				return;
			}
			Vector3 position = _cam.transform.position;
			BakeryVolume bakeryVolume = null;
			for (int i = 0; i < volumes.Length; i++)
			{
				if (volumes[i] != null && volumes[i].bounds.Contains(position))
				{
					bakeryVolume = volumes[i];
					break;
				}
			}
			if (overrideFog && (bakeryVolume != null) != _fogApplied)
			{
				ApplyFog(bakeryVolume != null);
			}
			if (bakeryVolume == null)
			{
				bakeryVolume = BakeryVolume.globalVolume;
			}
			if (!(bakeryVolume == null) && !(bakeryVolume == _bound))
			{
				bakeryVolume.SetGlobalParams();
				_bound = bakeryVolume;
			}
		}

		private void ApplyFog(bool on)
		{
			if (on)
			{
				_prevFog = RenderSettings.fog;
				_prevFogColor = RenderSettings.fogColor;
				_prevFogMode = RenderSettings.fogMode;
				_prevFogDensity = RenderSettings.fogDensity;
				_prevFogStart = RenderSettings.fogStartDistance;
				_prevFogEnd = RenderSettings.fogEndDistance;
				RenderSettings.fog = fog;
				RenderSettings.fogColor = fogColor;
				RenderSettings.fogMode = fogMode;
				RenderSettings.fogDensity = fogDensity;
				RenderSettings.fogStartDistance = fogStartDistance;
				RenderSettings.fogEndDistance = fogEndDistance;
			}
			else
			{
				RenderSettings.fog = _prevFog;
				RenderSettings.fogColor = _prevFogColor;
				RenderSettings.fogMode = _prevFogMode;
				RenderSettings.fogDensity = _prevFogDensity;
				RenderSettings.fogStartDistance = _prevFogStart;
				RenderSettings.fogEndDistance = _prevFogEnd;
			}
			_fogApplied = on;
		}

		private void OnDisable()
		{
			if (_fogApplied)
			{
				ApplyFog(false);
			}
			if (_bound != null && _bound != BakeryVolume.globalVolume && BakeryVolume.globalVolume != null)
			{
				BakeryVolume.globalVolume.SetGlobalParams();
			}
			_bound = null;
		}
	}
}
