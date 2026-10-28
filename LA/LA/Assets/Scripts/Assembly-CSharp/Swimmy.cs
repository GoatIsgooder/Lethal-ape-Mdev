using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;

public class Swimmy : MonoBehaviour
{
	private InputDevice LeftControllerDevice;

	private InputDevice RightControllerDevice;

	private Vector3 LeftControllerVelocity;

	private Vector3 RightControllerVelocity;

	private InputDevice targetDevice;

	private InputDevice targetDevice1;

	public Rigidbody poopyhead;

	public float thresh = 0.2f;

	public float gravity = 9.81f;

	public float drag = 0.1f;

	public float LMag;

	public float RMag;

	public float sped = 1f;

	private void Start()
	{
		LeftControllerDevice = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);
		RightControllerDevice = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);
	}

	private void FixedUpdate()
	{
		if (poopyhead.useGravity)
		{
			poopyhead.AddForce(Vector3.down * gravity, ForceMode.Acceleration);
		}
		poopyhead.AddForce(-poopyhead.linearVelocity * drag, ForceMode.Acceleration);
		targetDevice.TryGetFeatureValue(CommonUsages.trigger, out float _);
		targetDevice1.TryGetFeatureValue(CommonUsages.trigger, out float _);
		targetDevice.TryGetFeatureValue(CommonUsages.deviceVelocity, out LeftControllerVelocity);
		targetDevice1.TryGetFeatureValue(CommonUsages.deviceVelocity, out RightControllerVelocity);
		LMag = LeftControllerVelocity.magnitude;
		RMag = RightControllerVelocity.magnitude;
		if (LMag > thresh || RMag > thresh)
		{
			poopyhead.AddRelativeForce(-(LeftControllerVelocity + RightControllerVelocity) * sped, ForceMode.Acceleration);
		}
	}

	private void LateUpdate()
	{
		List<InputDevice> list = new List<InputDevice>();
		InputDevices.GetDevicesWithCharacteristics(InputDeviceCharacteristics.Left | InputDeviceCharacteristics.Controller, list);
		if (list.Count > 0)
		{
			targetDevice = list[0];
		}
		List<InputDevice> list2 = new List<InputDevice>();
		InputDevices.GetDevicesWithCharacteristics(InputDeviceCharacteristics.Right | InputDeviceCharacteristics.Controller, list2);
		if (list2.Count > 0)
		{
			targetDevice1 = list2[0];
		}
	}
}
