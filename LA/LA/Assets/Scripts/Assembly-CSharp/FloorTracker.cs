using UnityEngine;

public class FloorTracker : MonoBehaviour
{
	[Header("Target")]
	[Tooltip("The player body/rig root to stay underneath. Do NOT use the head camera.")]
	public Transform target;

	[Header("Raycast")]
	public float raycastOriginHeight = 2f;

	public float raycastMaxDistance = 10f;

	public LayerMask floorLayers = -1;

	[Header("Offset")]
	public float floorOffset = 0.01f;

	public Vector3 positionOffset;

	[Header("Rotation")]
	public bool alignToSurface = true;

	public Vector3 rotationOffset;

	private void LateUpdate()
	{
		if (!(target == null))
		{
			Vector3 origin = target.position + Vector3.up * raycastOriginHeight;
			if (Physics.Raycast(origin, Vector3.down, out RaycastHit hitInfo, raycastOriginHeight + raycastMaxDistance, floorLayers))
			{
				base.transform.position = hitInfo.point + Vector3.up * floorOffset + positionOffset;
				Quaternion quaternion = (alignToSurface ? Quaternion.FromToRotation(Vector3.up, hitInfo.normal) : Quaternion.identity);
				base.transform.rotation = quaternion * Quaternion.Euler(rotationOffset);
			}
		}
	}
}
