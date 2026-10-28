using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactables;
using UnityEngine.XR.Interaction.Toolkit.Interactors;
using UnityEngine.XR.Interaction.Toolkit.Transformers;

namespace LethalApeR.Vehicles
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	[RequireComponent(typeof(XRGrabInteractable))]
	public class ForkliftLiftLever : XRBaseGrabTransformer
	{
		[Header("Hinge")]
		[Tooltip("Pivot the stalk swings around (about its local X). The knob must be a child of it. Defaults to the parent.")]
		[SerializeField]
		private Transform hinge;

		[Header("Range")]
		[Tooltip("Travel each way from neutral, degrees. Positive = pulled back toward the driver.")]
		[SerializeField]
		[Range(5f, 80f)]
		private float maxAngle = 25f;

		[Tooltip("Neutral band as a fraction of travel; inside it the output is exactly 0.")]
		[SerializeField]
		[Range(0f, 0.5f)]
		private float deadzone = 0.12f;

		[SerializeField]
		[Min(0.005f)]
		private float minHandRadius = 0.02f;

		[Header("Release")]
		[Tooltip("Spring-back rate to neutral when let go (deg/s).")]
		[SerializeField]
		[Min(0f)]
		private float returnSpeed = 160f;

		[Header("Feel")]
		[SerializeField]
		[Range(0f, 1f)]
		private float grabHapticAmplitude = 0.2f;

		[SerializeField]
		[Min(0f)]
		private float grabHapticDuration = 0.03f;

		private XRGrabInteractable _grab;

		private Quaternion _hingeRestLocalRot;

		private Vector3 _knobLocalPos;

		private Quaternion _knobLocalRot;

		private IXRSelectInteractor _trackedHand;

		private float _lastHandAngle;

		private bool _hasLast;

		public float Angle { get; private set; }

		public float Value
		{
			get
			{
				float num = ((maxAngle > 0f) ? Mathf.Clamp(Angle / maxAngle, -1f, 1f) : 0f);
				float num2 = Mathf.Abs(num);
				if (num2 <= deadzone)
				{
					return 0f;
				}
				float num3 = Mathf.Clamp01((num2 - deadzone) / (1f - deadzone));
				if (!(num < 0f))
				{
					return num3;
				}
				return 0f - num3;
			}
		}

		public bool IsHeld
		{
			get
			{
				if (_grab != null)
				{
					return _grab.isSelected;
				}
				return false;
			}
		}

		protected override RegistrationMode registrationMode => RegistrationMode.Single;

		private void Awake()
		{
			_grab = GetComponent<XRGrabInteractable>();
			if (hinge == null)
			{
				hinge = base.transform.parent;
			}
			_hingeRestLocalRot = hinge.localRotation;
			_knobLocalPos = base.transform.localPosition;
			_knobLocalRot = base.transform.localRotation;
			_grab.selectEntered.AddListener(OnSelectEntered);
		}

		protected override void OnDestroy()
		{
			if (_grab != null)
			{
				_grab.selectEntered.RemoveListener(OnSelectEntered);
			}
			base.OnDestroy();
		}

		private void OnSelectEntered(SelectEnterEventArgs args)
		{
			_hasLast = false;
			if (!(grabHapticAmplitude > 0f) || !(grabHapticDuration > 0f))
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				switch (args.interactorObject.handedness)
				{
				case InteractorHandedness.Left:
					instance.PulseLeft(grabHapticAmplitude, grabHapticDuration);
					break;
				case InteractorHandedness.Right:
					instance.PulseRight(grabHapticAmplitude, grabHapticDuration);
					break;
				}
			}
		}

		public override void Process(XRGrabInteractable grabInteractable, XRInteractionUpdateOrder.UpdatePhase updatePhase, ref Pose targetPose, ref Vector3 localScale)
		{
			if (hinge == null)
			{
				return;
			}
			if (grabInteractable.interactorsSelecting.Count > 0)
			{
				IXRSelectInteractor iXRSelectInteractor = grabInteractable.interactorsSelecting[0];
				if (iXRSelectInteractor != _trackedHand)
				{
					_trackedHand = iXRSelectInteractor;
					_hasLast = false;
				}
				Transform attachTransform = iXRSelectInteractor.GetAttachTransform(grabInteractable);
				if (attachTransform != null)
				{
					Quaternion quaternion = ((hinge.parent != null) ? hinge.parent.rotation : Quaternion.identity);
					Vector3 vector = Quaternion.Inverse(quaternion * _hingeRestLocalRot) * (attachTransform.position - hinge.position);
					if (Mathf.Sqrt(vector.y * vector.y + vector.z * vector.z) < minHandRadius)
					{
						_hasLast = false;
					}
					else
					{
						float num = Mathf.Atan2(0f - vector.z, vector.y) * Mathf.Rad2Deg;
						if (_hasLast)
						{
							float num2 = Mathf.DeltaAngle(_lastHandAngle, num);
							Angle = Mathf.Clamp(Angle + num2, 0f - maxAngle, maxAngle);
						}
						_lastHandAngle = num;
						_hasLast = true;
					}
				}
			}
			ApplyHinge();
			targetPose.position = hinge.TransformPoint(_knobLocalPos);
			targetPose.rotation = hinge.rotation * _knobLocalRot;
		}

		private void ApplyHinge()
		{
			hinge.localRotation = _hingeRestLocalRot * Quaternion.AngleAxis(0f - Angle, Vector3.right);
		}

		private void Update()
		{
			if (!(hinge == null) && !IsHeld)
			{
				_trackedHand = null;
				_hasLast = false;
				if (returnSpeed > 0f && Angle != 0f)
				{
					Angle = Mathf.MoveTowards(Angle, 0f, returnSpeed * Time.deltaTime);
				}
				ApplyHinge();
				base.transform.SetLocalPositionAndRotation(_knobLocalPos, _knobLocalRot);
			}
		}

		public void SetValue(float raise01)
		{
			if (!IsHeld)
			{
				Angle = Mathf.Clamp(raise01, -1f, 1f) * maxAngle;
			}
		}
	}
}
