using UnityEngine;

public class UIFadeByDistance : MonoBehaviour
{
	public Transform cameraTransform;

	public Transform targetObject;

	public CanvasGroup canvasGroup;

	public float minDistance = 5f;

	public float maxDistance = 20f;

	public GameObject enableWhenInvisible;

	private const float RecheckSeconds = 0.1f;

	private Vector3 _camPos;

	private Vector3 _targetPos;

	private float _sinceCheck;

	private float _appliedAlpha = -1f;

	private bool _hidden;

	private void Start()
	{
		if (!cameraTransform)
		{
			Camera main = Camera.main;
			cameraTransform = ((main != null) ? main.transform : null);
		}
		_camPos = (cameraTransform ? cameraTransform.position : Vector3.zero);
		_targetPos = (targetObject ? targetObject.position : Vector3.zero);
		if ((bool)enableWhenInvisible)
		{
			enableWhenInvisible.SetActive(true);
		}
	}

	private void Update()
	{
		bool camMoved = HasMoved(cameraTransform, _camPos);
		bool targetMoved = HasMoved(targetObject, _targetPos);
		_sinceCheck += Time.unscaledDeltaTime;
		if (camMoved || targetMoved || !(_sinceCheck < RecheckSeconds))
		{
			_sinceCheck = 0f;
			if ((bool)cameraTransform)
			{
				_camPos = cameraTransform.position;
			}
			if ((bool)targetObject)
			{
				_targetPos = targetObject.position;
			}
			float t = Mathf.InverseLerp(minDistance, maxDistance, Vector3.Distance(_camPos, _targetPos));
			float alpha = 1f - t;
			ApplyAlpha(alpha);
			UpdateCanvasActive(alpha);
			UpdateFallback(alpha);
		}
	}

	private static bool HasMoved(Transform t, Vector3 cached)
	{
		if (!t)
		{
			return false;
		}
		return t.position != cached;
	}

	private void ApplyAlpha(float alpha)
	{
		if (!Mathf.Approximately(alpha, _appliedAlpha))
		{
			if ((bool)canvasGroup)
			{
				canvasGroup.alpha = alpha;
			}
			_appliedAlpha = alpha;
		}
	}

	private void UpdateCanvasActive(float alpha)
	{
		if (alpha <= 0f && !_hidden)
		{
			SetCanvasActive(false);
			_hidden = true;
		}
		else if (alpha > 0.001f && _hidden)
		{
			SetCanvasActive(true);
			_hidden = false;
		}
	}

	private void SetCanvasActive(bool active)
	{
		if ((bool)canvasGroup && canvasGroup.gameObject.activeSelf != active)
		{
			canvasGroup.gameObject.SetActive(active);
		}
	}

	private void UpdateFallback(float alpha)
	{
		if ((bool)enableWhenInvisible)
		{
			bool invisible = Mathf.Approximately(alpha, 0f);
			if (enableWhenInvisible.activeSelf != invisible)
			{
				enableWhenInvisible.SetActive(invisible);
			}
		}
	}

	private void OnDrawGizmosSelected()
	{
		Vector3 center = (targetObject ? targetObject.position : base.transform.position);
		Gizmos.color = new Color(0f, 1f, 0f, 0.4f);
		Gizmos.DrawWireSphere(center, minDistance);
		Gizmos.color = new Color(1f, 0f, 0f, 0.25f);
		Gizmos.DrawWireSphere(center, maxDistance);
	}
}
