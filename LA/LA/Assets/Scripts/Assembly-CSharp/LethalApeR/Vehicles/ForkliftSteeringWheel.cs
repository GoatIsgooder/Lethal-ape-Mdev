using System.Collections.Generic;
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
	public class ForkliftSteeringWheel : XRBaseGrabTransformer
	{
		[Header("Mount")]
		[Tooltip("Rest pose of the wheel. Its +Z is the column axis and MUST point at the driver; the wheel rotates around it. Defaults to the parent.")]
		[SerializeField]
		private Transform mount;

		[Header("Range")]
		[Tooltip("Rotation each way from centre, in degrees. Full lock = +/- this.")]
		[SerializeField]
		[Min(10f)]
		private float maxAngle = 200f;

		[Tooltip("Hands closer than this to the column axis (metres) don't contribute - the angle is undefined near the hub.")]
		[SerializeField]
		[Min(0.005f)]
		private float minHandRadius = 0.03f;

		[Header("Release")]
		[Tooltip("With no hands on it the wheel eases back to centre at this rate (deg/s). 0 = stays where it was left.")]
		[SerializeField]
		[Min(0f)]
		private float returnSpeed = 240f;

		[Header("Feel")]
		[Tooltip("Short haptic tick on the grabbing hand.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float grabHapticAmplitude = 0.25f;

		[SerializeField]
		[Min(0f)]
		private float grabHapticDuration = 0.04f;

		private XRGrabInteractable _grab;

		private readonly Dictionary<IXRSelectInteractor, float> _lastHandAngle = new Dictionary<IXRSelectInteractor, float>(2);

		private readonly List<IXRSelectInteractor> _stale = new List<IXRSelectInteractor>(2);

		public float Angle { get; private set; }

		public float Steer01
		{
			get
			{
				if (!(maxAngle > 0f))
				{
					return 0f;
				}
				return Mathf.Clamp(Angle / maxAngle, -1f, 1f);
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

		public float MaxAngle => maxAngle;

		protected override RegistrationMode registrationMode => RegistrationMode.SingleAndMultiple;

		private void Awake()
		{
			_grab = GetComponent<XRGrabInteractable>();
			if (mount == null)
			{
				mount = base.transform.parent;
			}
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

		public override void OnGrabCountChanged(XRGrabInteractable grabInteractable, Pose targetPose, Vector3 localScale)
		{
		}

		public override void Process(XRGrabInteractable grabInteractable, XRInteractionUpdateOrder.UpdatePhase updatePhase, ref Pose targetPose, ref Vector3 localScale)
		{
			if (!(mount == null))
			{
				AccumulateHands(grabInteractable);
				targetPose = ComposePose();
			}
		}

		private void AccumulateHands(XRGrabInteractable grabInteractable)
		{
			float num = 0f;
			int num2 = 0;
			List<IXRSelectInteractor> interactorsSelecting = grabInteractable.interactorsSelecting;
			for (int i = 0; i < interactorsSelecting.Count; i++)
			{
				IXRSelectInteractor iXRSelectInteractor = interactorsSelecting[i];
				Transform attachTransform = iXRSelectInteractor.GetAttachTransform(grabInteractable);
				if (attachTransform == null)
				{
					continue;
				}
				Vector3 vector = mount.InverseTransformPoint(attachTransform.position);
				if (Mathf.Sqrt(vector.x * vector.x + vector.y * vector.y) < minHandRadius)
				{
					_lastHandAngle.Remove(iXRSelectInteractor);
					continue;
				}
				float num3 = Mathf.Atan2(vector.x, vector.y) * -Mathf.Rad2Deg;
				if (_lastHandAngle.TryGetValue(iXRSelectInteractor, out var value))
				{
					num += Mathf.DeltaAngle(value, num3);
					num2++;
				}
				_lastHandAngle[iXRSelectInteractor] = num3;
			}
			if (_lastHandAngle.Count > 0)
			{
				_stale.Clear();
				foreach (KeyValuePair<IXRSelectInteractor, float> item in _lastHandAngle)
				{
					bool flag = false;
					for (int j = 0; j < interactorsSelecting.Count; j++)
					{
						if (interactorsSelecting[j] == item.Key)
						{
							flag = true;
							break;
						}
					}
					if (!flag)
					{
						_stale.Add(item.Key);
					}
				}
				for (int k = 0; k < _stale.Count; k++)
				{
					_lastHandAngle.Remove(_stale[k]);
				}
			}
			if (num2 > 0)
			{
				Angle = Mathf.Clamp(Angle + num / (float)num2, 0f - maxAngle, maxAngle);
			}
		}

		private Pose ComposePose()
		{
			return new Pose(mount.position, mount.rotation * Quaternion.AngleAxis(Angle, Vector3.forward));
		}

		private void Update()
		{
			if (!(mount == null) && !IsHeld)
			{
				if (_lastHandAngle.Count > 0)
				{
					_lastHandAngle.Clear();
				}
				if (returnSpeed > 0f && Angle != 0f)
				{
					Angle = Mathf.MoveTowards(Angle, 0f, returnSpeed * Time.deltaTime);
				}
				Pose pose = ComposePose();
				base.transform.SetPositionAndRotation(pose.position, pose.rotation);
			}
		}

		public void SetAngle(float degrees)
		{
			if (!IsHeld)
			{
				Angle = Mathf.Clamp(degrees, 0f - maxAngle, maxAngle);
			}
		}
	}
}
