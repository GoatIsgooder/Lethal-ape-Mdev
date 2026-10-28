using GorillaLocomotion;
using Liv.Lck;
using UnityEngine;

[DisallowMultipleComponent]
[AddComponentMenu(null)]
public class SlopLckColorGrade : MonoBehaviour
{
	private const float SourceSearchInterval = 0.5f;

	private SlopColorGrade _grade;

	private SlopColorGrade _source;

	private float _nextSourceSearch;

	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
	private static void Hook()
	{
		LckMediator.CameraRegistered -= Attach;
		LckMediator.CameraRegistered += Attach;
	}

	[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
	private static void AttachExisting()
	{
		foreach (ILckCamera camera in LckMediator.GetCameras())
		{
			Attach(camera);
		}
	}

	private static void Attach(ILckCamera lckCamera)
	{
		Camera camera = lckCamera?.GetCameraComponent();
		if (!(camera == null) && !(camera.GetComponent<SlopLckColorGrade>() != null))
		{
			camera.gameObject.AddComponent<SlopLckColorGrade>();
		}
	}

	private void Awake()
	{
		_grade = GetComponent<SlopColorGrade>();
		if (_grade == null)
		{
			_grade = base.gameObject.AddComponent<SlopColorGrade>();
		}
	}

	private void LateUpdate()
	{
		if (!IsLive(_source) && Time.unscaledTime >= _nextSourceSearch)
		{
			_nextSourceSearch = Time.unscaledTime + 0.5f;
			_source = FindHeadsetGrade();
		}
		if (IsLive(_source))
		{
			_grade.CopyFrom(_source);
		}
		else
		{
			_grade.bypass = true;
		}
	}

	private static bool IsLive(SlopColorGrade source)
	{
		if (source != null && source.gameObject.activeInHierarchy)
		{
			return source.PlayerWantsGrade;
		}
		return false;
	}

	private static SlopColorGrade FindHeadsetGrade()
	{
		Player player = (Player.HasInstance ? Player.Instance : null);
		Camera camera = ((player != null && player.mainCamera != null) ? player.mainCamera : Camera.main);
		if (!(camera != null))
		{
			return null;
		}
		return camera.GetComponent<SlopColorGrade>();
	}
}
