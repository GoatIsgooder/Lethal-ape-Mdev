using System.Collections.Generic;
using Photon.Pun;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	[ExecuteAlways]
	public class FingerAnimations : MonoBehaviourPun
	{
		[Header("General")]
		public HandType handType;

		[Tooltip("Curl responsiveness for the local hand; higher is snappier")]
		public float animationSpeed = 15f;

		[Header("Bones (drag & drop)")]
		public List<Transform> buttonBones = new List<Transform>();

		public List<Transform> triggerBones = new List<Transform>();

		public List<Transform> gripBones = new List<Transform>();

		[Header("Default Open Rotations")]
		public List<Quaternion> buttonOpenRotations = new List<Quaternion>();

		public List<Quaternion> triggerOpenRotations = new List<Quaternion>();

		public List<Quaternion> gripOpenRotations = new List<Quaternion>();

		[Header("Curl Rotations")]
		public List<Quaternion> buttonCurlRotations = new List<Quaternion>();

		public List<Quaternion> triggerCurlRotations = new List<Quaternion>();

		public List<Quaternion> gripCurlRotations = new List<Quaternion>();

		[Header("Edit Mode")]
		public bool editMode;

		public bool saveOpenRotations;

		public bool saveCurlRotations;

		[Header("Networking / Bandwidth")]
		[Tooltip("How fast remote hands chase the received curl values")]
		public float remoteLerpSpeed = 12f;

		private const float RedrawEpsilon = 0.001f;

		private const float ByteScale = 255f;

		private const float InvByteScale = 0.003921569f;

		private static readonly List<InputDevice> s_devices = new List<InputDevice>(2);

		private Transform[] _buttonRig;

		private Transform[] _triggerRig;

		private Transform[] _gripRig;

		private Quaternion[] _buttonOpen;

		private Quaternion[] _buttonClosed;

		private Quaternion[] _triggerOpen;

		private Quaternion[] _triggerClosed;

		private Quaternion[] _gripOpen;

		private Quaternion[] _gripClosed;

		private int _buttonBoneCount;

		private int _triggerBoneCount;

		private int _gripBoneCount;

		private float _button;

		private float _trigger;

		private float _grip;

		private float _buttonVel;

		private float _triggerVel;

		private float _gripVel;

		private float _buttonGoal;

		private float _triggerGoal;

		private float _gripGoal;

		private float _buttonRx;

		private float _triggerRx;

		private float _gripRx;

		private float _buttonDrawn = -999f;

		private float _triggerDrawn = -999f;

		private float _gripDrawn = -999f;

		private InputDevice _device;

		private bool _isOwner;

		private bool _initialized;

		public HandType Hand => handType;

		public float CurrentButton => _button;

		public float CurrentTrigger => _trigger;

		public float CurrentGrip => _grip;

		private void Start()
		{
			PadAllRotationLists();
			CacheArrays();
			RefreshOwnership();
			_initialized = true;
		}

		private void OnEnable()
		{
			if (_initialized)
			{
				_device = default(InputDevice);
				RefreshOwnership();
			}
		}

		private void RefreshOwnership()
		{
			if (base.photonView != null)
			{
				_isOwner = base.photonView.IsMine;
				if (_isOwner && Application.isPlaying && !editMode)
				{
					AcquireDevice();
				}
			}
			else
			{
				_isOwner = false;
			}
		}

		private void Update()
		{
			if (base.photonView == null)
			{
				return;
			}
			if (editMode)
			{
				ProcessSaveRequests();
				Redraw(_buttonRig, _buttonBoneCount, _buttonOpen, _buttonClosed, _button, ref _buttonDrawn);
				Redraw(_triggerRig, _triggerBoneCount, _triggerOpen, _triggerClosed, _trigger, ref _triggerDrawn);
				Redraw(_gripRig, _gripBoneCount, _gripOpen, _gripClosed, _grip, ref _gripDrawn);
				return;
			}
			if (_isOwner && Application.isPlaying)
			{
				TickLocal();
			}
			else
			{
				TickRemote();
			}
			if (Mathf.Abs(_button - _buttonDrawn) > 0.001f)
			{
				Redraw(_buttonRig, _buttonBoneCount, _buttonOpen, _buttonClosed, _button, ref _buttonDrawn);
			}
			if (Mathf.Abs(_trigger - _triggerDrawn) > 0.001f)
			{
				Redraw(_triggerRig, _triggerBoneCount, _triggerOpen, _triggerClosed, _trigger, ref _triggerDrawn);
			}
			if (Mathf.Abs(_grip - _gripDrawn) > 0.001f)
			{
				Redraw(_gripRig, _gripBoneCount, _gripOpen, _gripClosed, _grip, ref _gripDrawn);
			}
		}

		private void TickLocal()
		{
			if (!_device.isValid)
			{
				AcquireDevice();
			}
			SampleController();
			float smoothTime = 1f / Mathf.Max(animationSpeed, 0.01f);
			_button = Mathf.SmoothDamp(_button, _buttonGoal, ref _buttonVel, smoothTime);
			_trigger = Mathf.SmoothDamp(_trigger, _triggerGoal, ref _triggerVel, smoothTime);
			_grip = Mathf.SmoothDamp(_grip, _gripGoal, ref _gripVel, smoothTime);
		}

		private void TickRemote()
		{
			float t = Time.deltaTime * remoteLerpSpeed;
			_button = Mathf.Lerp(_button, _buttonRx, t);
			_trigger = Mathf.Lerp(_trigger, _triggerRx, t);
			_grip = Mathf.Lerp(_grip, _gripRx, t);
		}

		private void AcquireDevice()
		{
			InputDeviceCharacteristics desiredCharacteristics = ((handType == HandType.Left) ? (InputDeviceCharacteristics.HeldInHand | InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Left) : (InputDeviceCharacteristics.HeldInHand | InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Right));
			s_devices.Clear();
			InputDevices.GetDevicesWithCharacteristics(desiredCharacteristics, s_devices);
			_device = ((s_devices.Count > 0) ? s_devices[0] : default(InputDevice));
		}

		private void SampleController()
		{
			bool value = false;
			bool value2 = false;
			if (!_device.isValid)
			{
				_buttonGoal = (_triggerGoal = (_gripGoal = 0f));
				return;
			}
			_device.TryGetFeatureValue(CommonUsages.trigger, out _triggerGoal);
			_device.TryGetFeatureValue(CommonUsages.grip, out _gripGoal);
			_device.TryGetFeatureValue(CommonUsages.primaryButton, out value);
			_device.TryGetFeatureValue(CommonUsages.secondaryButton, out value2);
			_buttonGoal = ((value || value2) ? 1f : 0f);
		}

		private void CacheArrays()
		{
			_buttonBoneCount = buttonBones.Count;
			_triggerBoneCount = triggerBones.Count;
			_gripBoneCount = gripBones.Count;
			_buttonRig = buttonBones.ToArray();
			_triggerRig = triggerBones.ToArray();
			_gripRig = gripBones.ToArray();
			_buttonOpen = buttonOpenRotations.ToArray();
			_buttonClosed = buttonCurlRotations.ToArray();
			_triggerOpen = triggerOpenRotations.ToArray();
			_triggerClosed = triggerCurlRotations.ToArray();
			_gripOpen = gripOpenRotations.ToArray();
			_gripClosed = gripCurlRotations.ToArray();
		}

		private static void Redraw(Transform[] bones, int count, Quaternion[] open, Quaternion[] closed, float curl, ref float drawn)
		{
			for (int i = 0; i < count; i++)
			{
				Transform transform = bones[i];
				if (transform != null)
				{
					transform.localRotation = Quaternion.LerpUnclamped(open[i], closed[i], curl);
				}
			}
			drawn = curl;
		}

		private void PadAllRotationLists()
		{
			PadRotations(buttonBones.Count, buttonOpenRotations, buttonCurlRotations);
			PadRotations(triggerBones.Count, triggerOpenRotations, triggerCurlRotations);
			PadRotations(gripBones.Count, gripOpenRotations, gripCurlRotations);
		}

		private static void PadRotations(int boneCount, List<Quaternion> open, List<Quaternion> closed)
		{
			while (open.Count < boneCount)
			{
				open.Add(Quaternion.identity);
			}
			while (closed.Count < boneCount)
			{
				closed.Add(Quaternion.identity);
			}
		}

		private void ProcessSaveRequests()
		{
			if (saveOpenRotations)
			{
				CaptureRotations(buttonBones, buttonOpenRotations);
				CaptureRotations(triggerBones, triggerOpenRotations);
				CaptureRotations(gripBones, gripOpenRotations);
				saveOpenRotations = false;
				CacheArrays();
				Debug.Log("Open rotations saved.");
			}
			if (saveCurlRotations)
			{
				CaptureRotations(buttonBones, buttonCurlRotations);
				CaptureRotations(triggerBones, triggerCurlRotations);
				CaptureRotations(gripBones, gripCurlRotations);
				saveCurlRotations = false;
				CacheArrays();
				Debug.Log("Curl rotations saved.");
			}
		}

		private static void CaptureRotations(List<Transform> bones, List<Quaternion> into)
		{
			for (int i = 0; i < bones.Count; i++)
			{
				Transform transform = bones[i];
				if (!(transform == null))
				{
					if (i < into.Count)
					{
						into[i] = transform.localRotation;
					}
					else
					{
						into.Add(transform.localRotation);
					}
				}
			}
		}

		public void ApplyNetworkValues(float button, float trigger, float grip)
		{
			_buttonRx = button;
			_triggerRx = trigger;
			_gripRx = grip;
		}

		public static int PackThreeFloats(float a, float b, float c)
		{
			return (ToByte(a) << 16) | (ToByte(b) << 8) | ToByte(c);
		}

		public static void UnpackToTargets(int packed, out float a, out float b, out float c)
		{
			a = (float)((packed >> 16) & 0xFF) * 0.003921569f;
			b = (float)((packed >> 8) & 0xFF) * 0.003921569f;
			c = (float)(packed & 0xFF) * 0.003921569f;
		}

		private static int ToByte(float v)
		{
			return (int)(Mathf.Clamp01(v) * 255f + 0.5f);
		}
	}
}
