using System.Reflection;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgGeneratorCrank : MonoBehaviour, IGrabbable
	{
		private const float ReportInterval = 0.25f;

		private const float MinReportDegrees = 1f;

		private const float DeadzoneRadius = 0.05f;

		private const float MaxDegreesPerFrame = 30f;

		[SerializeField]
		private AgGenerator generator;

		[SerializeField]
		private bool invertDirection;

		[Header("Ratchet")]
		[SerializeField]
		private float detentDegrees = 18f;

		[SerializeField]
		[Range(0f, 1f)]
		private float detentAmplitude = 0.4f;

		[SerializeField]
		private float detentDuration = 0.03f;

		[SerializeField]
		private AudioClip detentClick;

		private static GrabInteractor[] _interactors;

		private int _holdCount;

		private GrabInteractor _drivingHand;

		private Vector3 _prevPlanarDir;

		private bool _dirSeeded;

		private float _pendingDegrees;

		private float _nextReportTime;

		private float _detentAccum;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_interactors = null;
		}

		private void Awake()
		{
			if (generator == null)
			{
				generator = GetComponentInParent<AgGenerator>();
			}
		}

		[Obfuscation(Exclude = true)]
		public void OnGrab()
		{
			_holdCount++;
			_drivingHand = null;
			_dirSeeded = false;
			_pendingDegrees = 0f;
			_detentAccum = 0f;
			if (NeedInteractorRefresh())
			{
				_interactors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
		}

		[Obfuscation(Exclude = true)]
		public void OnDrop()
		{
			_holdCount = Mathf.Max(0, _holdCount - 1);
			_drivingHand = null;
			_dirSeeded = false;
			_detentAccum = 0f;
			Flush();
		}

		private void OnDisable()
		{
			_holdCount = 0;
			_drivingHand = null;
			_dirSeeded = false;
			_detentAccum = 0f;
			_pendingDegrees = 0f;
		}

		private static bool NeedInteractorRefresh()
		{
			if (_interactors == null || _interactors.Length == 0)
			{
				return true;
			}
			for (int i = 0; i < _interactors.Length; i++)
			{
				if (_interactors[i] != null)
				{
					return false;
				}
			}
			return true;
		}

		private void Update()
		{
			if (_holdCount <= 0)
			{
				return;
			}
			GrabInteractor grabInteractor = ResolveDrivingHand();
			if (grabInteractor == null || grabInteractor.palm == null)
			{
				_dirSeeded = false;
				return;
			}
			Transform transform = ((generator != null && generator.CrankWheel != null) ? generator.CrankWheel : base.transform);
			Vector3 normalized = transform.TransformDirection((generator != null) ? generator.WheelLocalSpinAxis : Vector3.forward).normalized;
			Vector3 vector = Vector3.ProjectOnPlane(grabInteractor.palm.position - transform.position, normalized);
			if (vector.sqrMagnitude < 0.0025f)
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
			if (!(num2 <= 0f) && !(generator == null) && !generator.IsPowered && CanLocalCrank())
			{
				float num3 = Mathf.Min(num2, 30f);
				_pendingDegrees += num3;
				generator.AddLocalWheelSpin(num3);
				PulseDetents(grabInteractor, num3);
				if (Time.time >= _nextReportTime && _pendingDegrees >= 1f)
				{
					Flush();
				}
			}
		}

		private static bool CanLocalCrank()
		{
			if (!ApeGamesManager.IsLocalAlive())
			{
				return false;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null)
			{
				return false;
			}
			AgRoundProperties props = instance.Props;
			if (props == null)
			{
				return false;
			}
			if (PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (actorNumber < 1)
			{
				return false;
			}
			if (props.SeekersContains(actorNumber))
			{
				return false;
			}
			return !props.EscapedContains(actorNumber);
		}

		private GrabInteractor ResolveDrivingHand()
		{
			GrabInteractor grabInteractor = null;
			if (_interactors != null)
			{
				for (int i = 0; i < _interactors.Length; i++)
				{
					GrabInteractor grabInteractor2 = _interactors[i];
					if (!(grabInteractor2 == null) && grabInteractor2.IsGrabbing && !(grabInteractor2.HeldTransform != base.transform))
					{
						grabInteractor = grabInteractor2;
						break;
					}
				}
			}
			if (grabInteractor != _drivingHand)
			{
				_drivingHand = grabInteractor;
				_dirSeeded = false;
			}
			return grabInteractor;
		}

		private void PulseDetents(GrabInteractor hand, float clockwiseDelta)
		{
			if (detentDegrees <= 0f || detentAmplitude <= 0f)
			{
				return;
			}
			_detentAccum += clockwiseDelta;
			if (!(_detentAccum < detentDegrees))
			{
				_detentAccum %= detentDegrees;
				if (hand.node == XRNode.LeftHand)
				{
					AgHaptics.Left(detentAmplitude, detentDuration);
				}
				else
				{
					AgHaptics.Right(detentAmplitude, detentDuration);
				}
				if (detentClick != null && generator != null)
				{
					generator.PlayDetentClick(detentClick);
				}
			}
		}

		private void Flush()
		{
			if (!(_pendingDegrees < 1f))
			{
				float pendingDegrees = _pendingDegrees;
				_pendingDegrees = 0f;
				_nextReportTime = Time.time + 0.25f;
				if (generator != null && ApeGamesManager.Instance != null)
				{
					ApeGamesManager.Instance.ContributeCrank(generator.generatorId, pendingDegrees);
				}
			}
		}
	}
}
