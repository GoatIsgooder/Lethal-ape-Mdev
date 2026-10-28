using UnityEngine;

public class MenuFollower : MonoBehaviour
{
	[Header("Target")]
	[Tooltip("The transform to follow (e.g. player hand or any GameObject).")]
	public Transform target;

	[Header("Offset")]
	[Tooltip("Position offset relative to the target.")]
	public Vector3 positionOffset = new Vector3(0f, 0.1f, 0.2f);

	[Tooltip("Rotation offset applied on top of the target's rotation.")]
	public Vector3 rotationOffset = Vector3.zero;

	[Header("Follow")]
	[Tooltip("Off: locked to the target with no lag (hand menus). On: eases after it, for panels anchored to the head, which would otherwise be glued to your face.")]
	public bool smoothFollow;

	[Tooltip("Smooth Follow only.")]
	public float positionLerpSpeed = 8f;

	[Tooltip("Smooth Follow only.")]
	public float rotationLerpSpeed = 8f;

	[Header("Options")]
	[Tooltip("Match the target's rotation as well as position.")]
	public bool followRotation = true;

	[Tooltip("Only follow position, ignore Y axis (keeps menu at a fixed height).")]
	public bool lockYAxis;

	private void OnEnable()
	{
		Application.onBeforeRender += OnBeforeRender;
		Follow(true);
	}

	private void OnDisable()
	{
		Application.onBeforeRender -= OnBeforeRender;
	}

	private void LateUpdate()
	{
		Follow(!smoothFollow);
	}

	private void OnBeforeRender()
	{
		if (smoothFollow)
		{
			return;
		}
		Follow(true);
	}

	private void Follow(bool snap)
	{
		if (target == null)
		{
			return;
		}
		Vector3 position = target.position + target.TransformDirection(positionOffset);
		if (lockYAxis)
		{
			position.y = transform.position.y;
		}
		Quaternion rotation = target.rotation * Quaternion.Euler(rotationOffset);
		if (!snap)
		{
			float deltaTime = Time.deltaTime;
			position = Vector3.Lerp(transform.position, position, deltaTime * positionLerpSpeed);
			rotation = Quaternion.Lerp(transform.rotation, rotation, deltaTime * rotationLerpSpeed);
		}
		if (followRotation)
		{
			transform.SetPositionAndRotation(position, rotation);
		}
		else
		{
			transform.position = position;
		}
	}
}
