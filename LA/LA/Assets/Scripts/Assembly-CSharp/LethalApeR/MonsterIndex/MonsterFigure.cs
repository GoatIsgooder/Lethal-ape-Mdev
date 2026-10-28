using System;
using System.Collections.Generic;
using LethalApeR.Social.UI;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	[RequireComponent(typeof(BoxCollider))]
	public sealed class MonsterFigure : MonoBehaviour
	{
		private const float GrowSeconds = 0.34f;

		private const float TickDegrees = 20f;

		[SerializeField]
		private Transform turntable;

		[SerializeField]
		private Transform riser;

		[SerializeField]
		private MeshFilter filter;

		[SerializeField]
		private MeshRenderer figureRenderer;

		[Tooltip("The plinth and anything else that hides with the figure.")]
		[SerializeField]
		private Renderer[] fixtures = Array.Empty<Renderer>();

		[Header("Turn")]
		[Tooltip("Degrees a second it turns on its own.")]
		[SerializeField]
		private float idleSpeed = 16f;

		[Tooltip("How quickly a spin settles back to the idle turn.")]
		[SerializeField]
		private float friction = 2.2f;

		[SerializeField]
		private float maxSpeed = 720f;

		private readonly List<Collider> _fingers = new List<Collider>(2);

		private readonly List<float> _fingerAngles = new List<float>(2);

		private float _angle;

		private float _speed;

		private float _grow = 1f;

		private float _sinceTick;

		private bool _shown = true;

		private void Awake()
		{
			GetComponent<BoxCollider>().isTrigger = true;
			_speed = idleSpeed;
		}

		public void Show(MonsterIndexEntry entry, bool grow)
		{
			bool flag;
			if (entry != null && entry.figure != null)
			{
				filter.sharedMesh = entry.figure;
				figureRenderer.sharedMaterials = entry.figureMaterials;
				figureRenderer.enabled = _shown;
				flag = true;
			}
			else
			{
				filter.sharedMesh = null;
				figureRenderer.enabled = false;
				flag = false;
			}
			_angle = ((entry != null) ? entry.facing : 0f);
			_speed = idleSpeed;
			ApplyTurn();
			_grow = ((flag && grow) ? 0f : 1f);
			ApplyGrow();
		}

		public void SetShown(bool shown)
		{
			if (_shown == shown)
			{
				return;
			}
			_shown = shown;
			figureRenderer.enabled = shown && filter.sharedMesh != null;
			for (int i = 0; i < fixtures.Length; i++)
			{
				if (fixtures[i] != null)
				{
					fixtures[i].enabled = shown;
				}
			}
			if (!shown)
			{
				ClearFingers();
			}
			base.enabled = shown;
		}

		private void OnDisable()
		{
			ClearFingers();
		}

		private void ClearFingers()
		{
			_fingers.Clear();
			_fingerAngles.Clear();
		}

		private void Update()
		{
			float num = Mathf.Min(Time.unscaledDeltaTime, 0.05f);
			if (!(num > 0f))
			{
				return;
			}
			float num2 = 0f;
			bool flag = false;
			bool leftHand = false;
			for (int num3 = _fingers.Count - 1; num3 >= 0; num3--)
			{
				Collider collider = _fingers[num3];
				if (collider == null || !collider.enabled || !collider.gameObject.activeInHierarchy)
				{
					_fingers.RemoveAt(num3);
					_fingerAngles.RemoveAt(num3);
				}
				else
				{
					float num4 = FingerAngle(collider);
					num2 += Mathf.DeltaAngle(_fingerAngles[num3], num4);
					_fingerAngles[num3] = num4;
					leftHand = FingerHitVolume.IsLeft(collider);
					flag = true;
				}
			}
			if (flag)
			{
				_sinceTick += Mathf.Abs(num2);
				_speed = Mathf.Clamp(Mathf.Lerp(_speed, num2 / num, 0.35f), 0f - maxSpeed, maxSpeed);
				_angle += num2;
				if (_sinceTick >= 20f)
				{
					_sinceTick = 0f;
					SocialStyle.Pulse(leftHand, 0.12f, 0.012f);
				}
			}
			else
			{
				float num5 = ((_speed < 0f) ? (0f - idleSpeed) : idleSpeed);
				_speed = num5 + (_speed - num5) * Mathf.Exp((0f - friction) * num);
				_angle += _speed * num;
			}
			_angle = Mathf.Repeat(_angle, 360f);
			ApplyTurn();
			if (_grow < 1f)
			{
				_grow = Mathf.Min(1f, _grow + num / 0.34f);
				ApplyGrow();
			}
		}

		private void ApplyTurn()
		{
			turntable.localRotation = Quaternion.Euler(0f, _angle, 0f);
		}

		private void ApplyGrow()
		{
			float num = 1f;
			if (_grow < 1f)
			{
				float num2 = _grow - 1f;
				num = 1f + 2.6f * Mathf.Pow(num2, 3f) + 1.6f * (num2 * num2);
			}
			riser.localScale = Vector3.one * Mathf.Max(num, 0.001f);
		}

		private float FingerAngle(Collider finger)
		{
			Vector3 vector = base.transform.InverseTransformPoint(finger.transform.position);
			return Mathf.Atan2(vector.x, vector.z) * 57.29578f;
		}

		private void OnTriggerEnter(Collider other)
		{
			if (_shown && other.CompareTag("HandTag") && !_fingers.Contains(other))
			{
				_fingers.Add(other);
				_fingerAngles.Add(FingerAngle(other));
			}
		}

		private void OnTriggerExit(Collider other)
		{
			int num = _fingers.IndexOf(other);
			if (num >= 0)
			{
				_fingers.RemoveAt(num);
				_fingerAngles.RemoveAt(num);
			}
		}
	}
}
