using System.Collections;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using Locomotion.Scripts;
using UnityEngine;

namespace LethalApeR.Gameplay.Grenade
{
	[RequireComponent(typeof(Rigidbody))]
	public class GrenadePin : MonoBehaviour, IGrabbable
	{
		[HideInInspector]
		public Grenade grenade;

		[Header("Pull")]
		public float pullThreshold = 0.12f;

		[Range(0f, 1f)]
		public float resistanceAmplitude = 0.8f;

		public float snapBackDuration = 0.15f;

		[Header("String")]
		public LineRenderer lineRenderer;

		private Rigidbody _rb;

		private bool _isGrabbed;

		private bool _pulled;

		private Coroutine _snapBack;

		private Vector3 _localSocketPos;

		private Quaternion _localSocketRot;

		private Vector3 _cachedSocketWorldPos;

		public string EditorStateDisplay
		{
			get
			{
				if (_pulled)
				{
					return "Pin Out";
				}
				if (_isGrabbed)
				{
					return string.Format("Pulling {0:F0}%", GetPullProgress() * 100f);
				}
				return "Ready";
			}
		}

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_rb.isKinematic = true;
			_rb.useGravity = false;
			_localSocketPos = transform.localPosition;
			_localSocketRot = transform.localRotation;
		}

		private void Start()
		{
			Player instance = Player.Instance;
			if (instance == null)
			{
				return;
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>();
			foreach (Collider collider in componentsInChildren)
			{
				if (instance.headCollider != null)
				{
					Physics.IgnoreCollision(collider, instance.headCollider, true);
				}
				if (instance.bodyCollider != null)
				{
					Physics.IgnoreCollision(collider, instance.bodyCollider, true);
				}
			}
			if (lineRenderer != null)
			{
				lineRenderer.positionCount = 2;
				lineRenderer.useWorldSpace = true;
				lineRenderer.enabled = true;
			}
		}

		public void OnGrab()
		{
			if (_pulled)
			{
				return;
			}
			if (_snapBack != null)
			{
				StopCoroutine(_snapBack);
				_snapBack = null;
			}
			_cachedSocketWorldPos = GetSocketWorldPos();
			_isGrabbed = true;
			transform.SetParent(null, true);
			_rb.isKinematic = false;
			_rb.useGravity = false;
		}

		public void OnDrop()
		{
			if (_isGrabbed)
			{
				_isGrabbed = false;
				if (!_pulled)
				{
					_snapBack = StartCoroutine(SnapBackCoroutine());
				}
			}
		}

		private void Update()
		{
			if (_isGrabbed && !_pulled)
			{
				float pullProgress = GetPullProgress();
				if (pullProgress > 0.1f)
				{
					VRInputController instance = VRInputController.Instance;
					if (instance != null)
					{
						float amplitude = Mathf.Lerp(0f, resistanceAmplitude, pullProgress);
						instance.PulseLeft(amplitude, Time.deltaTime * 2f);
						instance.PulseRight(amplitude, Time.deltaTime * 2f);
					}
				}
				if (pullProgress >= 1f)
				{
					CompletePull();
				}
			}
			UpdateLine();
		}

		private void UpdateLine()
		{
			if (!(lineRenderer == null))
			{
				lineRenderer.enabled = !_pulled;
				lineRenderer.SetPosition(0, GetSocketWorldPos());
				lineRenderer.SetPosition(1, transform.position);
			}
		}

		private float GetPullProgress()
		{
			return Mathf.Clamp01(Vector3.Distance(transform.position, GetSocketWorldPos()) / pullThreshold);
		}

		private Vector3 GetSocketWorldPos()
		{
			if (grenade != null)
			{
				return grenade.transform.TransformPoint(_localSocketPos);
			}
			if (_isGrabbed)
			{
				return _cachedSocketWorldPos;
			}
			if (transform.parent != null)
			{
				return transform.parent.TransformPoint(_localSocketPos);
			}
			return transform.position;
		}

		private void CompletePull()
		{
			_isGrabbed = false;
			_pulled = true;
			VRInputController instance = VRInputController.Instance;
			if ((object)instance != null)
			{
				instance.PulseLeft(1f, 0.18f);
				instance.PulseRight(1f, 0.18f);
			}
			if ((object)grenade != null)
			{
				grenade.NotifyPinPulled();
			}
		}

		private IEnumerator SnapBackCoroutine()
		{
			_rb.isKinematic = true;
			_rb.linearVelocity = Vector3.zero;
			_rb.angularVelocity = Vector3.zero;
			if (grenade == null)
			{
				yield break;
			}
			Vector3 startPos = transform.position;
			Quaternion startRot = transform.rotation;
			float elapsed = 0f;
			while (elapsed < snapBackDuration)
			{
				elapsed += Time.deltaTime;
				float t = Mathf.SmoothStep(0f, 1f, elapsed / snapBackDuration);
				transform.position = Vector3.Lerp(startPos, grenade.transform.TransformPoint(_localSocketPos), t);
				transform.rotation = Quaternion.Slerp(startRot, grenade.transform.rotation * _localSocketRot, t);
				yield return null;
			}
			transform.SetParent(grenade.transform, false);
			transform.localPosition = _localSocketPos;
			transform.localRotation = _localSocketRot;
			_snapBack = null;
		}

		public void ResetPin()
		{
			StopAllCoroutines();
			_snapBack = null;
			_isGrabbed = false;
			_pulled = false;
			_rb.isKinematic = true;
			_rb.useGravity = false;
			_rb.linearVelocity = Vector3.zero;
			_rb.angularVelocity = Vector3.zero;
			if (grenade != null)
			{
				transform.SetParent(grenade.transform, false);
				transform.localPosition = _localSocketPos;
				transform.localRotation = _localSocketRot;
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = Color.yellow;
			Gizmos.DrawWireSphere(transform.position, pullThreshold);
		}
	}
}
