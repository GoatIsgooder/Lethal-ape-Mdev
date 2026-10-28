using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	[ExecuteAlways]
	[DisallowMultipleComponent]
	public class HazmatFingerAnims : MonoBehaviour
	{
		[Header("Hand")]
		public HandType handType = HandType.Right;

		[Header("Bones")]
		public List<Transform> gripBones = new List<Transform>();

		public List<Transform> triggerBones = new List<Transform>();

		public List<Transform> buttonBones = new List<Transform>();

		[Header("Open Rotations (Save Open)")]
		public List<Quaternion> gripOpen = new List<Quaternion>();

		public List<Quaternion> triggerOpen = new List<Quaternion>();

		public List<Quaternion> buttonOpen = new List<Quaternion>();

		[Header("Close Rotations (Save Closed)")]
		public List<Quaternion> gripClose = new List<Quaternion>();

		public List<Quaternion> triggerClose = new List<Quaternion>();

		public List<Quaternion> buttonClose = new List<Quaternion>();

		[Header("Feel")]
		[Tooltip("Higher = snappier curl.")]
		public float animationSpeed = 15f;

		[Tooltip("How far a finger curls when only RESTING on its control (0..1).")]
		[Range(0f, 1f)]
		public float touchAmount = 0.2f;

		[Header("Close-All Fist")]
		[Tooltip("Input above this (per group) counts as 'pressed' for the fist roll.")]
		[Range(0f, 1f)]
		public float fistThreshold = 0.6f;

		[Tooltip("Seconds between each finger group closing during the fist roll.")]
		public float closeAllStepDelay = 0.08f;

		[Header("PC Test")]
		[Tooltip("Enable to drive the fingers from the slider below instead of the controller — lets you test on PC without a headset.")]
		public bool pcTest;

		[Tooltip("Scrubs the close-all fist: drag toward 1 and the fingers roll closed one at a time (grip -> trigger -> thumb).")]
		[Range(0f, 1f)]
		public float pcTestSlider;

		[Header("Edit Mode (non-destructive posing)")]
		[Tooltip("While ON the script stops driving the bones so you can pose them by hand. Turning it OFF reverts anything not Saved.")]
		public bool editMode;

		[Tooltip("Capture the bones' CURRENT local rotations as the Open pose.")]
		public bool saveOpen;

		[Tooltip("Capture the bones' CURRENT local rotations as the Close pose.")]
		public bool saveClosed;

		private float _gripValue;

		private float _triggerValue;

		private float _buttonValue;

		private float _fistTimer;

		private bool _wasEditMode;

		private Quaternion[] _gripSnap;

		private Quaternion[] _triggerSnap;

		private Quaternion[] _buttonSnap;


		private void OnEnable()
		{
			EnsureRotationCounts();
		}

		private void Start()
		{
			EnsureRotationCounts();
		}

		private void Update()
		{
			if (editMode && !_wasEditMode)
			{
				EnterEditMode();
			}
			else if (!editMode && _wasEditMode)
			{
				ExitEditMode();
			}
			_wasEditMode = editMode;
			if (editMode)
			{
				HandleSaveButtons();
			}
			else if (Application.isPlaying)
			{
				float deltaTime = Time.deltaTime;
				float gripT;
				float triggerT;
				float buttonT;
				if (pcTest)
				{
					PcTestTargets(out gripT, out triggerT, out buttonT);
				}
				else
				{
					ReadTargets(out gripT, out triggerT, out buttonT);
					ApplyFistRoll(ref gripT, ref triggerT, ref buttonT, deltaTime);
				}
				float t = Mathf.Clamp01(deltaTime * animationSpeed);
				_gripValue = Mathf.Lerp(_gripValue, gripT, t);
				_triggerValue = Mathf.Lerp(_triggerValue, triggerT, t);
				_buttonValue = Mathf.Lerp(_buttonValue, buttonT, t);
				Apply(gripBones, gripOpen, gripClose, _gripValue);
				Apply(triggerBones, triggerOpen, triggerClose, _triggerValue);
				Apply(buttonBones, buttonOpen, buttonClose, _buttonValue);
			}
		}

		private void ReadTargets(out float gripT, out float triggerT, out float buttonT)
		{
			gripT = 0f;
			triggerT = 0f;
			buttonT = 0f;
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				bool flag = handType == HandType.Left;
				float num = (flag ? instance.LeftTriggerValue : instance.RightTriggerValue);
				bool flag2 = (flag ? instance.LeftPrimaryButton : instance.RightPrimaryButton);
				bool flag3 = (flag ? instance.LeftSecondaryButton : instance.RightSecondaryButton);
				bool flag4 = (flag ? instance.LeftJoystickClick : instance.RightJoystickClick);
				gripT = (flag ? instance.LeftGripValue : instance.RightGripValue);
				float b = ((num > 0.02f) ? touchAmount : 0f);
				triggerT = Mathf.Max(num, b);
				InputDevice inputDevice = (flag ? instance.LeftController : instance.RightController);
				bool value = false;
				if (inputDevice.isValid)
				{
					inputDevice.TryGetFeatureValue(UnityEngine.XR.CommonUsages.primary2DAxisTouch, out value);
				}
				if (flag2 || flag4 || flag3)
				{
					buttonT = 1f;
				}
				else if (flag2 || value || flag3)
				{
					buttonT = touchAmount;
				}
				else
				{
					buttonT = 0f;
				}
			}
		}

		private void ApplyFistRoll(ref float gripT, ref float triggerT, ref float buttonT, float dt)
		{
			if (gripT > fistThreshold && triggerT > fistThreshold && buttonT > fistThreshold)
			{
				_fistTimer += dt;
				float num = Mathf.Max(0f, closeAllStepDelay);
				gripT = 1f;
				triggerT = ((_fistTimer >= num) ? 1f : _triggerValue);
				buttonT = ((_fistTimer >= num * 2f) ? 1f : _buttonValue);
			}
			else
			{
				_fistTimer = 0f;
			}
		}

		private void PcTestTargets(out float gripT, out float triggerT, out float buttonT)
		{
			float num = Mathf.Clamp01(pcTestSlider);
			gripT = Mathf.Clamp01(num / (1f / 3f));
			triggerT = Mathf.Clamp01((num - 1f / 3f) / (1f / 3f));
			buttonT = Mathf.Clamp01((num - 2f / 3f) / (1f / 3f));
		}

		private static void Apply(List<Transform> bones, List<Quaternion> open, List<Quaternion> close, float value)
		{
			int count = bones.Count;
			for (int i = 0; i < count; i++)
			{
				Transform transform = bones[i];
				if (!(transform == null) && i < open.Count && i < close.Count)
				{
					transform.localRotation = Quaternion.LerpUnclamped(open[i], close[i], value);
				}
			}
		}

		private void EnterEditMode()
		{
			_gripSnap = Snapshot(gripBones);
			_triggerSnap = Snapshot(triggerBones);
			_buttonSnap = Snapshot(buttonBones);
		}

		private void ExitEditMode()
		{
			Restore(gripBones, _gripSnap);
			Restore(triggerBones, _triggerSnap);
			Restore(buttonBones, _buttonSnap);
		}

		private void HandleSaveButtons()
		{
			if (saveOpen)
			{
				Capture(gripBones, gripOpen);
				Capture(triggerBones, triggerOpen);
				Capture(buttonBones, buttonOpen);
				saveOpen = false;
				Debug.Log("[HazmatFingerAnims] Open pose saved.", this);
			}
			if (saveClosed)
			{
				Capture(gripBones, gripClose);
				Capture(triggerBones, triggerClose);
				Capture(buttonBones, buttonClose);
				saveClosed = false;
				Debug.Log("[HazmatFingerAnims] Close pose saved.", this);
			}
		}

		private static Quaternion[] Snapshot(List<Transform> bones)
		{
			Quaternion[] array = new Quaternion[bones.Count];
			for (int i = 0; i < bones.Count; i++)
			{
				array[i] = ((bones[i] != null) ? bones[i].localRotation : Quaternion.identity);
			}
			return array;
		}

		private static void Restore(List<Transform> bones, Quaternion[] snap)
		{
			if (snap == null)
			{
				return;
			}
			for (int i = 0; i < bones.Count && i < snap.Length; i++)
			{
				if (bones[i] != null)
				{
					bones[i].localRotation = snap[i];
				}
			}
		}

		private static void Capture(List<Transform> bones, List<Quaternion> target)
		{
			target.Clear();
			for (int i = 0; i < bones.Count; i++)
			{
				target.Add((bones[i] != null) ? bones[i].localRotation : Quaternion.identity);
			}
		}

		private void EnsureRotationCounts()
		{
			Fit(gripBones, gripOpen);
			Fit(gripBones, gripClose);
			Fit(triggerBones, triggerOpen);
			Fit(triggerBones, triggerClose);
			Fit(buttonBones, buttonOpen);
			Fit(buttonBones, buttonClose);
		}

		private static void Fit(List<Transform> bones, List<Quaternion> rots)
		{
			while (rots.Count < bones.Count)
			{
				rots.Add(Quaternion.identity);
			}
		}

		private void MarkDirty()
		{
		}
	}
}
