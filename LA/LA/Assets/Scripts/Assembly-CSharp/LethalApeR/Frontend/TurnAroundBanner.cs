using UnityEngine;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(CanvasGroup), typeof(Canvas))]
	public sealed class TurnAroundBanner : MonoBehaviour
	{
		[SerializeField]
		private MenuRig rig;

		[Tooltip("Its forward is the menu's forward.")]
		[SerializeField]
		private Transform menuRoot;

		[SerializeField]
		private RectTransform chevronLeft;

		[SerializeField]
		private RectTransform chevronRight;

		[SerializeField]
		private float distance = 1.7f;

		[Tooltip("Metres relative to the player's eye.")]
		[SerializeField]
		private float heightOffset = -0.14f;

		[Tooltip("Degrees away from the menu where the banner starts / finishes fading in.")]
		[SerializeField]
		private Vector2 fadeAngles = new Vector2(100f, 125f);

		[SerializeField]
		private float followSpeed = 2.2f;

		[SerializeField]
		private float chevronTravel = 10f;

		private CanvasGroup _group;

		private Canvas _canvas;

		private float _alpha;

		private float _yaw;

		private Vector2 _leftBase;

		private Vector2 _rightBase;

		public bool Active { get; set; }

		private void Awake()
		{
			_group = GetComponent<CanvasGroup>();
			_canvas = GetComponent<Canvas>();
			_leftBase = chevronLeft.anchoredPosition;
			_rightBase = chevronRight.anchoredPosition;
			_group.alpha = 0f;
			_canvas.enabled = false;
		}

		private void LateUpdate()
		{
			Camera head = rig.Head;
			if (head == null)
			{
				return;
			}
			Transform headTransform = head.transform;
			Vector3 headForward = Flat(headTransform.forward);
			Vector3 menuForward = Flat(menuRoot.forward);
			float angle = Vector3.SignedAngle(menuForward, headForward, Vector3.up);
			float targetYaw = Mathf.Atan2(headForward.x, headForward.z) * 57.29578f;
			float target = (Active ? Mathf.SmoothStep(0f, 1f, Mathf.InverseLerp(fadeAngles.x, fadeAngles.y, Mathf.Abs(angle))) : 0f);
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			_alpha = Mathf.MoveTowards(_alpha, target, unscaledDeltaTime * 3f);
			if (_alpha <= 0.001f)
			{
				if (_canvas.enabled)
				{
					_canvas.enabled = false;
				}
				_group.alpha = 0f;
				_yaw = targetYaw;
				return;
			}
			if (!_canvas.enabled)
			{
				_canvas.enabled = true;
			}
			_group.alpha = _alpha;
			_yaw = Mathf.LerpAngle(_yaw, targetYaw, 1f - Mathf.Exp((0f - followSpeed) * unscaledDeltaTime));
			Vector3 position = headTransform.position + Quaternion.Euler(0f, _yaw, 0f) * Vector3.forward * distance + Vector3.up * heightOffset;
			base.transform.SetPositionAndRotation(position, Quaternion.LookRotation(position - headTransform.position, Vector3.up));
			float bob = (Mathf.Sin(Time.unscaledTime * 4f) * 0.5f + 0.5f) * chevronTravel;
			chevronLeft.gameObject.SetActive(angle > 0f);
			chevronRight.gameObject.SetActive(angle <= 0f);
			chevronLeft.anchoredPosition = _leftBase + Vector2.left * bob;
			chevronRight.anchoredPosition = _rightBase + Vector2.right * bob;
		}

		private static Vector3 Flat(Vector3 v)
		{
			v.y = 0f;
			if (!(v.sqrMagnitude > 1E-06f))
			{
				return Vector3.forward;
			}
			return v.normalized;
		}
	}
}
