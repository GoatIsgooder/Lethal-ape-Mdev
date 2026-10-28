using System;
using UnityEngine;

namespace LethalApeR.Social.UI
{
	[RequireComponent(typeof(BoxCollider))]
	public sealed class FingerHitVolume : MonoBehaviour
	{
		private const float FrontMetres = 0.018f;

		private const float BackMetres = 0.008f;

		[SerializeField]
		private MonoBehaviour receiver;

		[Tooltip("The graphic this volume covers. Defaults to the parent.")]
		[SerializeField]
		private RectTransform target;

		[Tooltip("On the list's drum (rows and the wheel): placed on the drum and re-placed whenever the list settles.")]
		[SerializeField]
		private bool onDrum;

		[Tooltip("How far behind the face the box reaches. The wheel spans the whole drum, so it reaches further.")]
		[SerializeField]
		private float backMetres = BackMetres;

		[Tooltip("How far in front of the face the box reaches. The wheel's grip reaches out further so it's easy to catch.")]
		[SerializeField]
		private float frontMetres = FrontMetres;

		[Tooltip("Read back and front as canvas units instead of metres, so the box grows with a scaled-up board. The wheel's grip uses this: it must reach from the board face to well past the wheel at any board size.")]
		[SerializeField]
		private bool depthInUnits;

		private IFingerReceiver _receiver;

		private BoxCollider _box;

		private SocialCurve _curve;

		private bool _placed;

		public bool OnDrum => onDrum;

		public IFingerReceiver Receiver => _receiver;

		private void Awake()
		{
			_receiver = receiver as IFingerReceiver;
			_box = GetComponent<BoxCollider>();
			_box.isTrigger = true;
			if (target == null)
			{
				target = base.transform.parent as RectTransform;
			}
		}

		private void Start()
		{
			Place();
		}

		public void SetEnabled(bool on)
		{
			if (_box == null)
			{
				_box = GetComponent<BoxCollider>();
			}
			if (_box.enabled != on)
			{
				_box.enabled = on;
			}
		}

		public void Place()
		{
			if (target == null)
			{
				return;
			}
			if (_box == null)
			{
				_box = GetComponent<BoxCollider>();
			}
			if (_curve == null)
			{
				_curve = GetComponentInParent<SocialCurve>(true);
			}
			RectTransform rectTransform = ((_curve != null) ? _curve.Root : (target.root as RectTransform));
			if (!(rectTransform == null))
			{
				float num = Mathf.Max(rectTransform.lossyScale.x, 1E-06f);
				Rect rect = target.rect;
				Vector3 point = rectTransform.InverseTransformPoint(target.TransformPoint(rect.center));
				Quaternion turn = Quaternion.identity;
				if (_curve != null)
				{
					_curve.Surface(point, onDrum, out point, out turn);
				}
				float num2;
				float num3;
				if (depthInUnits)
				{
					num2 = frontMetres;
					num3 = backMetres;
				}
				else
				{
					float num4 = 1f / num;
					num2 = num4 * frontMetres;
					num3 = num4 * backMetres;
				}
				Vector3 vector = turn * new Vector3(0f, 0f, (num2 - num3) * -0.5f);
				base.transform.SetPositionAndRotation(rectTransform.TransformPoint(vector + point), rectTransform.rotation * turn);
				base.transform.localScale = Vector3.one;
				_box.center = Vector3.zero;
				_box.size = new Vector3(rect.width, rect.height, num2 + num3);
				_placed = true;
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (_receiver != null && _placed && other.CompareTag("HandTag"))
			{
				_receiver.FingerEnter(other, IsLeft(other));
			}
		}

		private void OnTriggerExit(Collider other)
		{
			if (_receiver != null && other.CompareTag("HandTag"))
			{
				_receiver.FingerExit(other);
			}
		}

		public static bool IsLeft(Collider finger)
		{
			string name = finger.gameObject.name;
			if (name.IndexOf("LeftFinger", StringComparison.Ordinal) >= 0 || name.IndexOf("L_end", StringComparison.Ordinal) >= 0)
			{
				return true;
			}
			return finger.CompareTag("LFinger");
		}
	}
}
