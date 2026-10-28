using UnityEngine;

namespace LethalApeR.Rendering
{
	public class ProximityActivator : MonoBehaviour
	{
		[Tooltip("Transform to measure distance FROM. Auto-assigned to Camera.main on Awake if left null. For VR, point this at the head/Camera Offset.")]
		public Transform observer;

		[Tooltip("Objects toggled by proximity. Each item is independently checked against its own world position.")]
		public GameObject[] objects;

		[Tooltip("Radius in metres around the observer within which assigned objects are enabled.")]
		public float radius = 12f;

		[Tooltip("Extra distance past `radius` before objects flip back off. Prevents flicker when the player stands exactly on the boundary.")]
		public float hysteresis = 1.5f;

		[Tooltip("Seconds between distance checks. 0.2s is invisible to players and ~5x cheaper than checking every frame.")]
		public float checkInterval = 0.2f;

		[Header("Gizmo")]
		public bool drawGizmo = true;

		public Color gizmoColor = new Color(0f, 1f, 1f, 0.4f);

		private float _nextCheck;

		private void Awake()
		{
			if (observer == null && Camera.main != null)
			{
				observer = Camera.main.transform;
			}
		}

		private void Start()
		{
			EvaluateOnce();
		}

		private void Update()
		{
			if (!(Time.time < _nextCheck))
			{
				EvaluateOnce();
			}
		}

		private void EvaluateOnce()
		{
			_nextCheck = Time.time + checkInterval;
			if (observer == null)
			{
				if (!(Camera.main != null))
				{
					return;
				}
				observer = Camera.main.transform;
			}
			if (objects == null || objects.Length == 0)
			{
				return;
			}
			Vector3 position = observer.position;
			float onSqr = radius * radius;
			float offSqr = (radius + hysteresis) * (radius + hysteresis);
			for (int i = 0; i < objects.Length; i++)
			{
				GameObject go = objects[i];
				if (!(go == null))
				{
					float sqrDist = (go.transform.position - position).sqrMagnitude;
					bool activeSelf = go.activeSelf;
					bool shouldBeActive = sqrDist <= (activeSelf ? offSqr : onSqr);
					if (activeSelf != shouldBeActive)
					{
						go.SetActive(shouldBeActive);
					}
				}
			}
		}

		private void OnDrawGizmos()
		{
			if (drawGizmo)
			{
				// RE: unsure - binary calls Application.isPlaying here and discards the result; both branches use transform
				Vector3 center = ((observer != null) ? observer : (Application.isPlaying ? transform : transform)).position;
				Gizmos.color = gizmoColor;
				Gizmos.DrawWireSphere(center, radius);
				Gizmos.color = new Color(gizmoColor.r, gizmoColor.g, gizmoColor.b, gizmoColor.a * 0.5f);
				Gizmos.DrawWireSphere(center, radius + hysteresis);
			}
		}
	}
}
