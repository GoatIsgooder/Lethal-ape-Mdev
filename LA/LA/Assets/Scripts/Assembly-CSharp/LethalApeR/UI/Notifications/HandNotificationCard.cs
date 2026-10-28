using System.Reflection;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.UI.Notifications
{
	[Obfuscation(Exclude = true)]
	public class HandNotificationCard : MonoBehaviour
	{
		[HideInInspector]
		public RectTransform root;

		[HideInInspector]
		public CanvasGroup group;

		[HideInInspector]
		public Image background;

		[HideInInspector]
		public Image accent;

		[HideInInspector]
		public TMP_Text titleText;

		[HideInInspector]
		public TMP_Text bodyText;

		[HideInInspector]
		public float positionSmoothTime = 0.16f;

		[HideInInspector]
		public float rotationLerpSpeed = 12f;

		[HideInInspector]
		public float popInDuration = 0.22f;

		[HideInInspector]
		public float fadeOutDuration = 0.35f;

		private Transform _anchor;

		private Transform _head;

		private Vector3 _stackOffset;

		private Vector3 _velocity;

		private float _bornAt;

		private float _life;

		private Vector3 _baseScale = Vector3.one;

		public float HeightMeters => (root != null) ? (root.sizeDelta.y * _baseScale.y) : 0f;

		public bool IsActive { get; private set; }

		public int Slot { get; set; }

		public float ExpiresAt { get; private set; }

		public string Key { get; private set; }

		public void Initialise(Vector3 baseScale)
		{
			_baseScale = baseScale;
			base.transform.localScale = Vector3.zero;
			base.gameObject.SetActive(false);
			IsActive = false;
		}

		public void Show(string key, Transform anchor, Transform head, Vector3 stackOffset, float life)
		{
			Key = key;
			_anchor = anchor;
			_head = head;
			_stackOffset = stackOffset;
			_life = Mathf.Max(0.5f, life);
			_bornAt = Time.unscaledTime;
			ExpiresAt = _bornAt + _life;
			IsActive = true;
			_velocity = Vector3.zero;
			base.gameObject.SetActive(true);
			if (group != null)
			{
				group.alpha = 0f;
			}
			base.transform.position = ResolveAnchorPosition();
			base.transform.localScale = Vector3.zero;
			FaceHead(true);
		}

		public void Refresh(float life)
		{
			_life = Mathf.Max(0.5f, life);
			ExpiresAt = Time.unscaledTime + _life;
		}

		public void SetStackOffset(Vector3 offset)
		{
			_stackOffset = offset;
		}

		public void SetRig(Transform anchor, Transform head)
		{
			if (anchor != null)
			{
				_anchor = anchor;
			}
			if (head != null)
			{
				_head = head;
			}
		}

		public void Hide()
		{
			Key = null;
			IsActive = false;
			_anchor = null;
			base.transform.localScale = Vector3.zero;
			if (group != null)
			{
				group.alpha = 0f;
			}
			base.gameObject.SetActive(false);
		}

		private void LateUpdate()
		{
			if (!IsActive)
			{
				return;
			}
			float unscaledTime = Time.unscaledTime;
			float deltaTime = Mathf.Min(Time.unscaledDeltaTime, 0.1f);
			Vector3 target = ResolveAnchorPosition() + _stackOffset;
			base.transform.position = Vector3.SmoothDamp(base.transform.position, target, ref _velocity, Mathf.Max(0.01f, positionSmoothTime), float.PositiveInfinity, deltaTime);
			FaceHead(false);
			float num = Mathf.Clamp01((unscaledTime - _bornAt) / Mathf.Max(0.01f, popInDuration));
			float num2 = EaseOutBack(num);
			float num3 = Mathf.Clamp01(num * 2.2f);
			float num4 = ExpiresAt - unscaledTime;
			if (num4 < fadeOutDuration)
			{
				float num5 = Mathf.Clamp01(num4 / Mathf.Max(0.01f, fadeOutDuration));
				num3 *= num5;
				num2 *= Mathf.Lerp(0.86f, 1f, num5);
			}
			base.transform.localScale = _baseScale * num2;
			if (group != null)
			{
				group.alpha = num3;
			}
			if (num4 <= 0f)
			{
				Hide();
			}
		}

		private Vector3 ResolveAnchorPosition()
		{
			if (_anchor != null)
			{
				return _anchor.position;
			}
			if (_head != null)
			{
				return _head.position + _head.forward * 0.45f;
			}
			return base.transform.position;
		}

		private void FaceHead(bool instant)
		{
			if (_head == null)
			{
				return;
			}
			Vector3 vector = base.transform.position - _head.position;
			vector.y *= 0.85f;
			if (!(vector.sqrMagnitude < 1E-06f))
			{
				Quaternion quaternion = Quaternion.LookRotation(vector.normalized, Vector3.up);
				base.transform.rotation = (instant ? quaternion : Quaternion.Slerp(base.transform.rotation, quaternion, 1f - Mathf.Exp((0f - rotationLerpSpeed) * Mathf.Min(Time.unscaledDeltaTime, 0.1f))));
			}
		}

		private static float EaseOutBack(float t)
		{
			float num = t - 1f;
			return 1f + 2.70158f * num * num * num + 1.70158f * num * num;
		}
	}
}
