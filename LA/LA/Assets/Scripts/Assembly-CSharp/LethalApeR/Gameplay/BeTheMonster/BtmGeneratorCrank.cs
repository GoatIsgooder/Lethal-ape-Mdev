using System.Reflection;
using Locomotion.Scripts;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGeneratorCrank : MonoBehaviour, IStaticGrabbable, IGrabbable, ILocalGrabGate
	{
		private const float ReportInterval = 0.25f;

		private const float MinReportDegrees = 1f;

		private const float DeadzoneRadius = 0.05f;

		private const float MaxDegreesPerFrame = 30f;

		[Tooltip("Wired by the generator's self-configure; parent lookup as fallback.")]
		[SerializeField]
		private BtmGenerator generator;

		[Tooltip("Flip if clockwise registers as counter-clockwise for this wheel's mounting.")]
		[SerializeField]
		private bool invertDirection;

		[Header("Haptics")]
		[Tooltip("A ratchet click fires on the cranking hand every this many degrees. 0 disables.")]
		[SerializeField]
		private float detentDegrees = 18f;

		[SerializeField]
		[Range(0f, 1f)]
		private float detentAmplitude = 0.4f;

		[SerializeField]
		private float detentDuration = 0.03f;

		private int _holdCount;

		private BtmHand _drivingHand;

		private Vector3 _prevPlanarDir;

		private bool _dirSeeded;

		private float _pendingDegrees;

		private float _nextReportTime;

		private float _detentAccum;

		public bool LocalCanGrab => BTMGameManager.IsLocalSurvivor();

		private void Awake()
		{
			if (generator == null)
			{
				generator = GetComponentInParent<BtmGenerator>();
			}
		}

		public void OnGrab()
		{
			_holdCount++;
			_drivingHand = null;
			_dirSeeded = false;
		}

		public void OnDrop()
		{
			_holdCount = Mathf.Max(0, _holdCount - 1);
			_drivingHand = null;
			_dirSeeded = false;
			Flush();
		}

		private void OnDisable()
		{
			_holdCount = 0;
			_drivingHand = null;
			_dirSeeded = false;
			Flush();
		}

		private void Update()
		{
			if (_holdCount < 1)
			{
				return;
			}
			BtmHand btmHand = ResolveDrivingHand();
			if (btmHand == null)
			{
				_dirSeeded = false;
				return;
			}
			Transform transform = ((generator != null && generator.CrankWheel != null) ? generator.CrankWheel : base.transform);
			Vector3 normalized = transform.TransformDirection((generator != null) ? generator.WheelLocalSpinAxis : Vector3.forward).normalized;
			Vector3 vector = Vector3.ProjectOnPlane(btmHand.Palm - transform.position, normalized);
			if (vector.sqrMagnitude < DeadzoneRadius * DeadzoneRadius)
			{
				_dirSeeded = false;
				return;
			}
			Vector3 normalized2 = vector.normalized;
			if (!_dirSeeded)
			{
				_prevPlanarDir = normalized2;
				_dirSeeded = true;
				return;
			}
			float num = Vector3.SignedAngle(_prevPlanarDir, normalized2, normalized);
			_prevPlanarDir = normalized2;
			float num2 = (invertDirection ? num : (0f - num));
			if (!(num2 <= 0f) && !(generator == null) && !generator.IsPowered && BTMGameManager.IsLocalSurvivor())
			{
				float num3 = Mathf.Min(num2, MaxDegreesPerFrame);
				_pendingDegrees += num3;
				generator.AddLocalWheelSpin(num3);
				PulseDetents(btmHand, num3);
				if (!(Time.time < _nextReportTime) && !(_pendingDegrees < MinReportDegrees))
				{
					Flush();
				}
			}
		}

		private BtmHand ResolveDrivingHand()
		{
			BtmHand btmHand = null;
			for (int i = 0; i < BtmHands.Count; i++)
			{
				BtmHand btmHand2 = BtmHands.At(i);
				if (btmHand2.Present && btmHand2.HoldsHandle(base.transform))
				{
					btmHand = btmHand2;
					break;
				}
			}
			if (btmHand != _drivingHand)
			{
				_drivingHand = btmHand;
				_dirSeeded = false;
			}
			return btmHand;
		}

		private void PulseDetents(BtmHand hand, float clockwiseDelta)
		{
			if (!(detentDegrees <= 0f) && !(detentAmplitude <= 0f))
			{
				_detentAccum += clockwiseDelta;
				if (!(_detentAccum < detentDegrees))
				{
					_detentAccum %= detentDegrees;
					hand.Pulse(detentAmplitude, detentDuration);
				}
			}
		}

		private void Flush()
		{
			float pendingDegrees = _pendingDegrees;
			if (!(pendingDegrees < MinReportDegrees))
			{
				_pendingDegrees = 0f;
				_nextReportTime = Time.time + ReportInterval;
				if (generator != null && BTMGameManager.Instance != null)
				{
					BTMGameManager.Instance.ContributeCrankSpin(generator.generatorId, pendingDegrees);
				}
			}
		}
	}
}
