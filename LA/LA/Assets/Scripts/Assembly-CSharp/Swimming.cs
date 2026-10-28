using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;
using UnityEngine.XR;

public class Swimming : MonoBehaviour
{
	[Header("Water Settings")]
	public LayerMask whatIsWater;

	public float radius = 0.25f;

	public bool canSwim;

	[Header("Swimming Force")]
	[Tooltip("Acceleration added by a full-power stroke")]
	public float swimForceMultiplier = 3f;

	[Tooltip("Player speed is clamped to this while in water")]
	public float maxSwimSpeed = 5f;

	[Tooltip("Rigidbody linear damping while submerged")]
	public float waterDrag = 2f;

	[Tooltip("Hand speed a stroke has to exceed to count")]
	public float minStrokeSpeed = 0.5f;

	[Tooltip("Hand speed at which a stroke reaches full power")]
	public float maxStrokeSpeed = 3f;

	[Header("Controller Vibration")]
	public float vibrationDuration = 0.1f;

	public float maxVibrationStrength = 0.3f;

	[Header("References")]
	[SerializeField]
	private GameObject objectToToggle;

	private const float StrokeCooldown = 0.15f;

	private const float PullAlignment = 0.3f;

	private const int IgnoreRaycastLayer = 2;

	private static readonly Vector3 WaterGravity = new Vector3(0f, -0.31f, 0f);

	private static readonly Vector3 LandGravity = new Vector3(0f, -9.81f, 0f);

	private readonly HashSet<Collider> submergedParts = new HashSet<Collider>();

	private Rigidbody body;

	private float dryDamping;

	private bool leftCooling;

	private bool rightCooling;

	private float leftCooldown;

	private float rightCooldown;

	private void Awake()
	{
		base.gameObject.layer = 2;
	}

	private void Start()
	{
		body = ((Player.Instance != null) ? Player.Instance.playerRigidBody : null);
		if (body != null)
		{
			dryDamping = body.linearDamping;
		}
		else
		{
			Debug.LogWarning("[Swimming] " + base.name + " Start: Player.Instance or playerRigidBody is null — swimming will not work.");
		}
	}

	private void OnTriggerEnter(Collider other)
	{
		if (!(Player.Instance == null) && !(other.GetComponentInParent<Player>() != Player.Instance))
		{
			int count = submergedParts.Count;
			submergedParts.Add(other);
			if (count == 0)
			{
				SetSubmerged(true);
			}
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (!(Player.Instance == null) && submergedParts.Remove(other) && submergedParts.Count == 0)
		{
			SetSubmerged(false);
		}
	}

	private void SetSubmerged(bool submerged)
	{
		Debug.Log(submerged ? "[Swimming] Entered water" : "[Swimming] Exited water");
		Physics.gravity = (submerged ? WaterGravity : LandGravity);
		canSwim = submerged;
		if (body != null)
		{
			body.linearDamping = (submerged ? waterDrag : dryDamping);
		}
		if (objectToToggle != null)
		{
			objectToToggle.SetActive(submerged);
		}
	}

	private void FixedUpdate()
	{
		if (canSwim)
		{
			InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(XRNode.LeftHand);
			InputDevice deviceAtXRNode2 = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);
			deviceAtXRNode.TryGetFeatureValue(CommonUsages.deviceVelocity, out var value);
			deviceAtXRNode2.TryGetFeatureValue(CommonUsages.deviceVelocity, out var value2);
			Vector3 forward = Player.Instance.headCollider.transform.forward;
			Stroke(ref leftCooling, ref leftCooldown, deviceAtXRNode, value, forward);
			Stroke(ref rightCooling, ref rightCooldown, deviceAtXRNode2, value2, forward);
			float fixedDeltaTime = Time.fixedDeltaTime;
			TickCooldown(ref leftCooling, ref leftCooldown, fixedDeltaTime);
			TickCooldown(ref rightCooling, ref rightCooldown, fixedDeltaTime);
			LimitSpeed();
		}
	}

	private void Stroke(ref bool cooling, ref float remaining, InputDevice device, Vector3 handVelocity, Vector3 lookDirection)
	{
		float magnitude = handVelocity.magnitude;
		if (Vector3.Dot(-handVelocity.normalized, lookDirection) > 0.3f)
		{
			if (!cooling && magnitude > minStrokeSpeed)
			{
				Propel(device, handVelocity);
				cooling = true;
				remaining = 0.15f;
			}
		}
		else
		{
			cooling = false;
		}
	}

	private static void TickCooldown(ref bool cooling, ref float remaining, float dt)
	{
		if (cooling)
		{
			remaining -= dt;
			if (remaining <= 0f)
			{
				cooling = false;
			}
		}
	}

	private void Propel(InputDevice device, Vector3 handVelocity)
	{
		float magnitude = handVelocity.magnitude;
		Vector3 normalized = handVelocity.normalized;
		float num = Mathf.InverseLerp(minStrokeSpeed, maxStrokeSpeed, magnitude);
		Vector3 vector = -normalized;
		if (normalized.y > 0.5f)
		{
			vector.y *= 0.5f;
		}
		body.AddForce(vector * (num * swimForceMultiplier), ForceMode.Acceleration);
		Rumble(device, num * maxVibrationStrength);
	}

	private void LimitSpeed()
	{
		Vector3 linearVelocity = body.linearVelocity;
		if (linearVelocity.magnitude > maxSwimSpeed)
		{
			body.linearVelocity = linearVelocity.normalized * maxSwimSpeed;
		}
	}

	private void Rumble(InputDevice device, float amplitude)
	{
		if (device.TryGetHapticCapabilities(out var capabilities) && capabilities.supportsImpulse)
		{
			device.SendHapticImpulse(0u, amplitude, vibrationDuration);
		}
	}
}
