using UnityEngine;

[RequireComponent(typeof(LineRenderer))]
public class GrappleLine : MonoBehaviour
{
	[Header("Script written by ElmoPM - Use credit.")]
	[Space(5f)]
	[Header("Gun Rope Start")]
	[Tooltip("Empty object placed where the rope should come out of the gun.")]
	public Transform gunAttachPoint;

	[Header("Rope End Point")]
	[Tooltip("Empty object that represents where the rope visually ends.")]
	public Transform ropeEndPoint;

	[Header("Rope Visual Settings")]
	[Tooltip("Thickness of the rope.")]
	public float ropeWidth = 0.03f;

	private LineRenderer lr;

	private void Awake()
	{
		lr = GetComponent<LineRenderer>();
		lr.positionCount = 2;
		lr.useWorldSpace = true;
	}

	private void Update()
	{
		if (!(gunAttachPoint == null) && !(ropeEndPoint == null))
		{
			lr.startWidth = ropeWidth;
			lr.endWidth = ropeWidth;
			lr.SetPosition(0, gunAttachPoint.position);
			lr.SetPosition(1, ropeEndPoint.position);
		}
	}
}
