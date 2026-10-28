using UnityEngine;

[ExecuteInEditMode]
public class Liquid : MonoBehaviour
{
	public enum UpdateMode
	{
		Normal = 0,
		UnscaledTime = 1
	}

	public UpdateMode updateMode;

	[SerializeField]
	private float MaxWobble = 0.03f;

	[SerializeField]
	private float WobbleSpeedMove = 1f;

	[SerializeField]
	private float fillAmount = 0.5f;

	[SerializeField]
	private float Recovery = 1f;

	[SerializeField]
	private float Thickness = 1f;

	[Range(0f, 1f)]
	public float CompensateShapeAmount;

	[SerializeField]
	private Mesh mesh;

	[SerializeField]
	private Renderer rend;

	private Vector3 pos;

	private Vector3 lastPos;

	private Vector3 velocity;

	private Quaternion lastRot;

	private Vector3 angularVelocity;

	private float wobbleAmountX;

	private float wobbleAmountZ;

	private float wobbleAmountToAddX;

	private float wobbleAmountToAddZ;

	private float pulse;

	private float sinewave;

	private float time = 0.5f;

	private Vector3 comp;

	private void Start()
	{
		GetMeshAndRend();
	}

	private void OnValidate()
	{
		GetMeshAndRend();
	}

	private void GetMeshAndRend()
	{
		if (mesh == null)
		{
			mesh = GetComponent<MeshFilter>().sharedMesh;
		}
		if (rend == null)
		{
			rend = GetComponent<Renderer>();
		}
	}

	private void Update()
	{
		float deltaTime = 0f;
		switch (updateMode)
		{
		case UpdateMode.Normal:
			deltaTime = Time.deltaTime;
			break;
		case UpdateMode.UnscaledTime:
			deltaTime = Time.unscaledDeltaTime;
			break;
		}
		time += deltaTime;
		if (deltaTime != 0f)
		{
			wobbleAmountToAddX = Mathf.Lerp(wobbleAmountToAddX, 0f, deltaTime * Recovery);
			wobbleAmountToAddZ = Mathf.Lerp(wobbleAmountToAddZ, 0f, deltaTime * Recovery);
			pulse = 2f * Mathf.PI * WobbleSpeedMove;
			sinewave = Mathf.Lerp(sinewave, Mathf.Sin(pulse * time), deltaTime * Mathf.Clamp(velocity.magnitude + angularVelocity.magnitude, Thickness, 10f));
			wobbleAmountX = wobbleAmountToAddX * sinewave;
			wobbleAmountZ = wobbleAmountToAddZ * sinewave;
			velocity = (lastPos - transform.position) / deltaTime;
			angularVelocity = GetAngularVelocity(lastRot, transform.rotation);
			wobbleAmountToAddX += Mathf.Clamp((velocity.x + velocity.y * 0.2f + angularVelocity.z + angularVelocity.y) * MaxWobble, 0f - MaxWobble, MaxWobble);
			wobbleAmountToAddZ += Mathf.Clamp((velocity.z + velocity.y * 0.2f + angularVelocity.x + angularVelocity.y) * MaxWobble, 0f - MaxWobble, MaxWobble);
		}
		rend.sharedMaterial.SetFloat("_WobbleX", wobbleAmountX);
		rend.sharedMaterial.SetFloat("_WobbleZ", wobbleAmountZ);
		UpdatePos(deltaTime);
		lastPos = transform.position;
		lastRot = transform.rotation;
	}

	private void UpdatePos(float deltaTime)
	{
		Vector3 worldPos = transform.TransformPoint(new Vector3(mesh.bounds.center.x, mesh.bounds.center.y, mesh.bounds.center.z));
		if (CompensateShapeAmount > 0f)
		{
			if (deltaTime != 0f)
			{
				comp = Vector3.Lerp(comp, worldPos - new Vector3(0f, GetLowestPoint(), 0f), deltaTime * 10f);
			}
			else
			{
				comp = worldPos - new Vector3(0f, GetLowestPoint(), 0f);
			}
			pos = worldPos - transform.position - new Vector3(0f, fillAmount - comp.y * CompensateShapeAmount, 0f);
		}
		else
		{
			pos = worldPos - transform.position - new Vector3(0f, fillAmount, 0f);
		}
		rend.sharedMaterial.SetVector("_FillAmount", pos);
	}

	private Vector3 GetAngularVelocity(Quaternion foreLastFrameRotation, Quaternion lastFrameRotation)
	{
		Quaternion q = lastFrameRotation * Quaternion.Inverse(foreLastFrameRotation);
		if (Mathf.Abs(q.w) > 0.9995117f)
		{
			return Vector3.zero;
		}
		float gain;
		if (q.w < 0f)
		{
			float angle = Mathf.Acos(0f - q.w);
			gain = -2f * angle / (Mathf.Sin(angle) * Time.deltaTime);
		}
		else
		{
			float angle2 = Mathf.Acos(q.w);
			gain = 2f * angle2 / (Mathf.Sin(angle2) * Time.deltaTime);
		}
		Vector3 result = new Vector3(q.x * gain, q.y * gain, q.z * gain);
		if (float.IsNaN(result.z))
		{
			result = Vector3.zero;
		}
		return result;
	}

	private float GetLowestPoint()
	{
		float lowestY = float.MaxValue;
		Vector3 lowestVert = Vector3.zero;
		Vector3[] vertices = mesh.vertices;
		for (int i = 0; i < vertices.Length; i++)
		{
			Vector3 position = transform.TransformPoint(vertices[i]);
			if (position.y < lowestY)
			{
				lowestY = position.y;
				lowestVert = position;
			}
		}
		return lowestVert.y;
	}
}
