using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class PodiumCamera : MonoBehaviour
	{
		[Header("Orbit")]
		[Tooltip("Distance from the stage center (m).")]
		public float orbitRadius = 6f;

		[Tooltip("Camera height above the orbit center (m).")]
		public float orbitHeight = 2.6f;

		[Tooltip("Orbit speed (degrees/second). Slow = broadcast crane shot.")]
		public float orbitDegreesPerSecond = 12f;

		[Header("Render")]
		[Tooltip("Far clip — the podium area + sky dome, not the whole map.")]
		public float farClip = 80f;

		private Transform _center;

		private Camera _cam;

		private Camera _mainCam;

		private bool _prevDisableMovement;

		private bool _live;

		private float _angle;

		public bool IsLive => _live;

		public Camera Camera => _cam;

		public void Begin(Transform orbitCenter)
		{
			_center = ((orbitCenter != null) ? orbitCenter : base.transform);
			_angle = Random.Range(0f, 360f);
			_mainCam = ResolveHmdCamera();
			if (_cam == null)
			{
				GameObject go = new GameObject("PodiumOrbitCamera");
				go.transform.SetParent(base.transform, false);
				_cam = go.AddComponent<Camera>();
			}
			if (_mainCam != null)
			{
				_cam.cullingMask = _mainCam.cullingMask;
				_cam.clearFlags = _mainCam.clearFlags;
				_cam.backgroundColor = _mainCam.backgroundColor;
				_cam.nearClipPlane = _mainCam.nearClipPlane;
				_cam.fieldOfView = _mainCam.fieldOfView;
				_cam.depth = _mainCam.depth + 1f;
			}
			_cam.farClipPlane = farClip;
			_cam.stereoTargetEye = StereoTargetEyeMask.Both;
			_cam.enabled = true;
			EnsurePostProcessing();
			if (_mainCam != null)
			{
				_mainCam.enabled = false;
			}
			if (Player.Instance != null)
			{
				_prevDisableMovement = Player.Instance.disableMovement;
				Player.Instance.disableMovement = true;
			}
			_live = true;
			PlaceCamera();
		}

		public void End()
		{
			if (_live)
			{
				_live = false;
				if (_mainCam != null)
				{
					_mainCam.enabled = true;
				}
				if (Player.Instance != null)
				{
					Player.Instance.disableMovement = _prevDisableMovement;
				}
				if (_cam != null)
				{
					_cam.enabled = false;
				}
			}
		}

		private void LateUpdate()
		{
			if (_live && !(_cam == null) && !(_center == null))
			{
				_angle += orbitDegreesPerSecond * Time.deltaTime;
				PlaceCamera();
			}
		}

		private void PlaceCamera()
		{
			if (!(_cam == null) && !(_center == null))
			{
				float rad = _angle * ((float)Mathf.PI / 180f);
				Vector3 center = _center.position;
				Vector3 pos = center + new Vector3(Mathf.Cos(rad) * orbitRadius, orbitHeight, Mathf.Sin(rad) * orbitRadius);
				Quaternion rot = ((_mainCam != null) ? _mainCam.transform.rotation : Quaternion.LookRotation(center + Vector3.up - pos, Vector3.up));
				_cam.transform.SetPositionAndRotation(pos, rot);
			}
		}

		private void EnsurePostProcessing()
		{
			if (_cam == null)
			{
				return;
			}
			SlopColorGrade grade = _cam.GetComponent<SlopColorGrade>();
			if (grade == null)
			{
				grade = _cam.gameObject.AddComponent<SlopColorGrade>();
			}
			SlopColorGrade src = ((_mainCam != null) ? _mainCam.GetComponent<SlopColorGrade>() : null);
			if (src == null)
			{
				Debug.LogWarning("[PodiumCamera] Rig camera has no SlopColorGrade — orbit camera will use default grading.");
				return;
			}
			grade.postExposure = src.postExposure;
			grade.contrast = src.contrast;
			grade.saturation = src.saturation;
			grade.keepRed = src.keepRed;
			grade.colorFilter = src.colorFilter;
			grade.temperature = src.temperature;
			grade.tint = src.tint;
			grade.vignetteIntensity = src.vignetteIntensity;
			grade.vignetteSmoothness = src.vignetteSmoothness;
			grade.vignetteColor = src.vignetteColor;
			grade.grainIntensity = src.grainIntensity;
			grade.bypass = src.bypass;
		}

		private static Camera ResolveHmdCamera()
		{
			if (Player.Instance != null && Player.Instance.mainCamera != null)
			{
				return Player.Instance.mainCamera;
			}
			return Camera.main;
		}

		private void OnDisable()
		{
			End();
		}

		private void OnDestroy()
		{
			End();
			if (_cam != null)
			{
				Object.Destroy(_cam.gameObject);
			}
		}
	}
}
