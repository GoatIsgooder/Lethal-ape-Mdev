using System;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Audio;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRopeSpinner : MonoBehaviour
	{
		private const float ReflingCooldownSeconds = 3f;

		private const float FlingUpBias = 0.35f;

		private const float MaxSpeedWarp = 0.95f;

		[Header("Speed, THE dial. Edit in EDIT mode to persist")]
		public float degreesPerSecond = 180f;

		[Range(0f, 0.95f)]
		public float speedWarp = 0.5f;

		public float bottomAngle;

		public float flingSpeed = 14f;

		[SerializeField]
		private Vector3 spinAxis = Vector3.forward;

		[SerializeField]
		private Transform flingDirection;

		[SerializeField]
		private Collider[] ropeTriggers;

		[SerializeField]
		private PlaySfx flingSfx;

		[SerializeField]
		private PlaySfx bottomPassSfx;

		private Quaternion _baseRotation;

		private float _nextFlingTime;

		private long _lastBottomPass;

		private bool _hasBottomPass;

		public float PeakDegreesPerSecond => Mathf.Abs(degreesPerSecond) * (1f + Mathf.Clamp(speedWarp, 0f, MaxSpeedWarp));

		private void Awake()
		{
			_baseRotation = base.transform.localRotation;
			Rigidbody rigidbody = GetComponent<Rigidbody>();
			if (rigidbody == null)
			{
				rigidbody = base.gameObject.AddComponent<Rigidbody>();
			}
			rigidbody.isKinematic = true;
			rigidbody.useGravity = false;
			if (ropeTriggers == null)
			{
				return;
			}
			for (int i = 0; i < ropeTriggers.Length; i++)
			{
				if (ropeTriggers[i] != null)
				{
					ropeTriggers[i].isTrigger = true;
				}
			}
		}

		public void ResetForRound()
		{
			_nextFlingTime = 0f;
			_hasBottomPass = false;
			base.transform.localRotation = _baseRotation;
		}

		private void OnDisable()
		{
			base.transform.localRotation = _baseRotation;
		}

		public void Tick(double roundStartTime)
		{
			double num = (PhotonNetwork.Time - roundStartTime) * (double)degreesPerSecond;
			float linearAngle = (float)(num % 360.0);
			base.transform.localRotation = _baseRotation * Quaternion.AngleAxis(WarpAngle(linearAngle), spinAxis);
			TickBottomPass(num);
		}

		private void TickBottomPass(double totalDegrees)
		{
			if (bottomPassSfx == null)
			{
				return;
			}
			long num = (long)Math.Floor((totalDegrees - (double)bottomAngle) / 360.0);
			if (!_hasBottomPass)
			{
				_lastBottomPass = num;
				_hasBottomPass = true;
			}
			else if (num != _lastBottomPass)
			{
				_lastBottomPass = num;
				bottomPassSfx.PlayAudio();
			}
		}

		private float WarpAngle(float linearAngle)
		{
			float num = Mathf.Clamp(speedWarp, 0f, MaxSpeedWarp);
			if (num <= 0f)
			{
				return linearAngle;
			}
			return linearAngle + num * 57.29578f * Mathf.Sin((linearAngle - bottomAngle) * (MathF.PI / 180f));
		}

		private void OnTriggerEnter(Collider other)
		{
			if (Time.time < _nextFlingTime || !IsLocalRigCollider(other) || !(ApeGamesManager.Instance != null))
			{
				return;
			}
			AgRoundProperties props = ApeGamesManager.Instance.Props;
			if (props == null || props.phase != AgPhase.Round || props.round != 1 || !PhotonNetwork.InRoom || !ApeGamesManager.IsLocalAlive() || props.EscapedContains(PhotonNetwork.LocalPlayer.ActorNumber) || !Player.HasInstance)
			{
				return;
			}
			_nextFlingTime = Time.time + ReflingCooldownSeconds;
			Player instance = Player.Instance;
			Vector3 position = ((instance.headCollider != null) ? instance.headCollider.transform : instance.transform).position;
			Vector3 vector = ComputeSweepDirection(position, degreesPerSecond);
			if (vector.sqrMagnitude < 0.0001f)
			{
				Vector3 vector2 = ((flingDirection != null) ? (flingDirection.position - position) : Vector3.ProjectOnPlane(position - base.transform.position, Vector3.up));
				vector = ((vector2.sqrMagnitude < 0.0001f) ? Vector3.up : vector2.normalized);
			}
			AgLauncher.Launch(vector * flingSpeed);
			if (flingSfx != null)
			{
				flingSfx.PlayAudio();
			}
			AgHaptics.Both(0.6f, 0.15f);
		}

		private Vector3 ComputeSweepDirection(Vector3 victimPosition, float degreesPerSecond)
		{
			Vector3 vector = base.transform.TransformDirection(spinAxis);
			if (vector.sqrMagnitude < 0.0001f)
			{
				return Vector3.zero;
			}
			vector = vector.normalized;
			Vector3 vector2 = victimPosition - base.transform.position;
			Vector3 rhs = vector2 - vector * Vector3.Dot(vector, vector2);
			Vector3 vector3 = Vector3.Cross(vector * (degreesPerSecond * (MathF.PI / 180f)), rhs);
			vector3.y = 0f;
			if (vector3.sqrMagnitude < 0.0001f)
			{
				return Vector3.zero;
			}
			return (vector3.normalized + Vector3.up * FlingUpBias).normalized;
		}

		private static bool IsLocalRigCollider(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				return true;
			}
			if (!Player.HasInstance)
			{
				return false;
			}
			Transform transform = Player.Instance.transform;
			Rigidbody attachedRigidbody = other.attachedRigidbody;
			if (attachedRigidbody != null && attachedRigidbody.transform.IsChildOf(transform))
			{
				return true;
			}
			return other.transform.IsChildOf(transform);
		}
	}
}
