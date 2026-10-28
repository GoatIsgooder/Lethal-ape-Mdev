using UnityEngine;

public class MangoFloat : MonoBehaviour
{
	public float floatHeight = 0.5f;

	public float floatSpeed = 2f;

	public float rotationSpeed = 60f;

	public float springStrength = 8f;

	public float damping = 4f;

	public float pulseStrength = 0.08f;

	public float pulseSpeed = 3f;

	private Vector3 startPos;

	private Vector3 velocity;

	private Vector3 startScale;

	private void Start()
	{
		startPos = transform.position;
		startScale = transform.localScale;
	}

	private void Update()
	{
		Vector3 target = new Vector3(startPos.x, startPos.y + floatHeight * Mathf.Sin(Time.time * floatSpeed), startPos.z);
		Vector3 force = (target - transform.position) * springStrength;
		velocity += force * Time.deltaTime;
		velocity *= Mathf.Exp(-damping * Time.deltaTime);
		transform.position += velocity * Time.deltaTime;
		transform.Rotate(Vector3.up * rotationSpeed * Time.deltaTime, Space.Self);
		float pulse = 1f + pulseStrength * Mathf.Sin(Time.time * pulseSpeed);
		transform.localScale = startScale * pulse;
	}
}
