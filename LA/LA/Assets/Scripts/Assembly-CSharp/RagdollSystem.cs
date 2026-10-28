using UnityEngine;

public class RagdollSystem : MonoBehaviour
{
	public Transform target;

	public Rigidbody rb;

	[Header("Strength")]
	public float positionSpring = 800f;

	public float positionDamping = 80f;

	public float rotationSpring = 600f;

	public float rotationDamping = 60f;

	[Header("Stability")]
	[Tooltip("Cap on the corrective linear acceleration (m/s²). With the raw spring, a bone knocked 1 m off its target would get spring×1 = hundreds of m/s² and launch. The cap turns big errors into a firm, constant pull instead.")]
	public float maxLinearAcceleration = 60f;

	[Tooltip("Cap on the corrective angular acceleration (rad/s²). Same idea as the linear cap.")]
	public float maxAngularAcceleration = 120f;

	public float DriveWeight { get; set; } = 1f;

	private void Reset()
	{
		rb = GetComponent<Rigidbody>();
	}

	private void FixedUpdate()
	{
		if (!target || !rb)
		{
			return;
		}
		float weight = DriveWeight;
		if (weight <= 0.001f)
		{
			return;
		}
		Vector3 linear = (target.position - rb.position) * positionSpring - rb.linearVelocity * positionDamping;
		linear = Vector3.ClampMagnitude(linear, maxLinearAcceleration);
		rb.AddForce(linear * weight, ForceMode.Acceleration);
		Quaternion delta = target.rotation * Quaternion.Inverse(rb.rotation);
		if (delta.w < 0f)
		{
			delta = new Quaternion(0f - delta.x, 0f - delta.y, 0f - delta.z, 0f - delta.w);
		}
		delta.ToAngleAxis(out float angle, out Vector3 axis);
		if (float.IsFinite(axis.x) && axis.sqrMagnitude > 0.0001f)
		{
			Vector3 angular = axis.normalized * (angle * Mathf.Deg2Rad) * rotationSpring - rb.angularVelocity * rotationDamping;
			angular = Vector3.ClampMagnitude(angular, maxAngularAcceleration);
			rb.AddTorque(angular * weight, ForceMode.Acceleration);
		}
	}
}
