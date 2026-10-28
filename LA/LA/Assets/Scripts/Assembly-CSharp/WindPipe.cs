using System.Collections.Generic;
using UnityEngine;

public class WindPipe : MonoBehaviour
{
	[Header("Path (local space)")]
	[Tooltip("Ordered list of points the spline passes through after the start. The last entry is the END / release point. Place intermediate entries to bend the path around corners.")]
	public List<Vector3> waypointsLocal = new List<Vector3>
	{
		new Vector3(0f, 2f, 2.5f),
		new Vector3(0f, 0f, 5f)
	};

	[Header("Filter")]
	public LayerMask affectedLayers = -1;

	[Tooltip("Optional tag filter. Leave empty to allow any tag.")]
	public string requiredTag = "";

	[Header("Intake (start)")]
	[Tooltip("Spherical suction radius at the start. Bodies inside this sphere are pulled toward the entry.")]
	public float intakeRadius = 1.5f;

	[Tooltip("Acceleration pulling bodies toward the start point.")]
	public float intakeAcceleration = 25f;

	[Header("Pipe (spline)")]
	[Tooltip("Tube radius around the spline. Bodies inside the tube are pushed along it.")]
	public float pipeRadius = 0.8f;

	[Tooltip("Acceleration along the spline tangent (the push).")]
	public float pipeAcceleration = 35f;

	[Tooltip("Inward pull keeping bodies clinging to the spline.")]
	public float pipeCohesion = 15f;

	[Tooltip("Cap on velocity component along the spline tangent.")]
	public float maxSpeed = 14f;

	[Header("Release (end)")]
	[Tooltip("Within this distance of the final waypoint, bodies stop being affected.")]
	public float releaseRadius = 0.5f;

	[Header("Gizmos")]
	public Color startColor = new Color(0.35f, 0.7f, 1f, 1f);

	public Color endColor = new Color(1f, 0.3f, 0.3f, 1f);

	public Color waypointColor = new Color(1f, 0.65f, 0.2f, 1f);

	[Range(4f, 32f)]
	public int gizmoSamplesPerSegment = 12;

	private const int k_RuntimeSamplesPerSegment = 10;

	private readonly Collider[] _hits = new Collider[64];

	private readonly List<Vector3> _samplePts = new List<Vector3>(128);

	private readonly List<Vector3> _sampleTans = new List<Vector3>(128);

	private Vector3[] _anchorBuf = new Vector3[16];

	public Vector3 StartWorld => base.transform.position;

	public Vector3 EndWorld
	{
		get
		{
			if (waypointsLocal == null || waypointsLocal.Count == 0)
			{
				return StartWorld;
			}
			return base.transform.TransformPoint(waypointsLocal[waypointsLocal.Count - 1]);
		}
	}

	public int WaypointCount
	{
		get
		{
			if (waypointsLocal == null)
			{
				return 0;
			}
			return waypointsLocal.Count;
		}
	}

	public Vector3 GetWaypointWorld(int i)
	{
		return base.transform.TransformPoint(waypointsLocal[i]);
	}

	public void SetWaypointWorld(int i, Vector3 world)
	{
		waypointsLocal[i] = base.transform.InverseTransformPoint(world);
	}

	private static Vector3 CatmullRom(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
	{
		float t2 = t * t;
		float t3 = t2 * t;
		return 0.5f * (2f * p1 + (p2 - p0) * t + (2f * p0 - 5f * p1 + 4f * p2 - p3) * t2 + (3f * p1 - p0 - 3f * p2 + p3) * t3);
	}

	private static Vector3 CatmullRomTangent(Vector3 p0, Vector3 p1, Vector3 p2, Vector3 p3, float t)
	{
		float t2 = t * t;
		return 0.5f * (p2 - p0 + 2f * (2f * p0 - 5f * p1 + 4f * p2 - p3) * t + 3f * (3f * p1 - p0 - 3f * p2 + p3) * t2);
	}

	private int BuildAnchors(Vector3[] buf)
	{
		int count = WaypointCount;
		buf[0] = base.transform.position;
		for (int i = 0; i < count; i++)
		{
			buf[i + 1] = base.transform.TransformPoint(waypointsLocal[i]);
		}
		return count + 1;
	}

	private void EnsureAnchorBuf(int needed)
	{
		if (_anchorBuf.Length < needed)
		{
			int size = needed - 1;
			size |= size >> 16;
			size |= size >> 8;
			size |= size >> 4;
			size |= size >> 2;
			size |= size >> 1;
			_anchorBuf = new Vector3[size + 1];
		}
	}

	private void Resample(int perSegment, List<Vector3> outPts, List<Vector3> outTans)
	{
		outPts.Clear();
		outTans.Clear();
		if (WaypointCount < 1)
		{
			return;
		}
		EnsureAnchorBuf(WaypointCount + 1);
		int anchorCount = BuildAnchors(_anchorBuf);
		int last = anchorCount - 1;
		for (int i = 0; i < last; i++)
		{
			Vector3 p0 = _anchorBuf[Mathf.Max(i - 1, 0)];
			Vector3 p1 = _anchorBuf[i];
			Vector3 p2 = _anchorBuf[i + 1];
			Vector3 p3 = _anchorBuf[Mathf.Min(i + 2, last)];
			int steps = ((i == anchorCount - 2) ? (perSegment + 1) : perSegment);
			for (int s = 0; s < steps; s++)
			{
				float t = (float)s / (float)perSegment;
				outPts.Add(CatmullRom(p0, p1, p2, p3, t));
				outTans.Add(CatmullRomTangent(p0, p1, p2, p3, t));
			}
		}
	}

	private int FindClosestSampleIndex(Vector3 p)
	{
		int best = -1;
		float bestSqr = float.MaxValue;
		for (int i = 0; i < _samplePts.Count; i++)
		{
			float sqr = (_samplePts[i] - p).sqrMagnitude;
			if (sqr < bestSqr)
			{
				bestSqr = sqr;
				best = i;
			}
		}
		return best;
	}

	private void FixedUpdate()
	{
		if (WaypointCount < 1)
		{
			return;
		}
		Resample(10, _samplePts, _sampleTans);
		if (_samplePts.Count == 0)
		{
			return;
		}
		EnsureAnchorBuf(WaypointCount + 1);
		int anchorCount = BuildAnchors(_anchorBuf);
		Vector3 min = _anchorBuf[0];
		Vector3 max = _anchorBuf[0];
		for (int i = 1; i < anchorCount; i++)
		{
			min = Vector3.Min(min, _anchorBuf[i]);
			max = Vector3.Max(max, _anchorBuf[i]);
		}
		Vector3 center = (min + max) * 0.5f;
		float radius = (max - min).magnitude * 0.5f + Mathf.Max(intakeRadius, pipeRadius) + 0.5f;
		int count = Physics.OverlapSphereNonAlloc(center, radius, _hits, affectedLayers, QueryTriggerInteraction.Ignore);
		for (int j = 0; j < count; j++)
		{
			Collider hit = _hits[j];
			if (hit == null)
			{
				continue;
			}
			Rigidbody rb = hit.attachedRigidbody;
			if (!(rb == null) && !rb.isKinematic && (string.IsNullOrEmpty(requiredTag) || rb.CompareTag(requiredTag)))
			{
				Apply(rb);
			}
		}
	}

	private void Apply(Rigidbody rb)
	{
		Vector3 pos = rb.worldCenterOfMass;
		Vector3 start = StartWorld;
		Vector3 end = EndWorld;
		if (Vector3.Distance(pos, end) < releaseRadius)
		{
			return;
		}
		Vector3 toStart = start - pos;
		float startDist = toStart.magnitude;
		Vector3 tangent;
		if (startDist <= intakeRadius)
		{
			Vector3 dir = ((startDist > 0.0001f) ? (toStart / startDist) : Vector3.zero);
			float falloff = 1f - Mathf.Clamp01(startDist / intakeRadius);
			rb.AddForce(dir * intakeAcceleration * (falloff * 0.6f + 0.4f), ForceMode.Acceleration);
			tangent = ((_sampleTans.Count > 0) ? _sampleTans[0].normalized : Vector3.forward);
			rb.AddForce(tangent * pipeAcceleration * 0.5f, ForceMode.Acceleration);
			CapTangentSpeed(rb, tangent);
			return;
		}
		int idx = FindClosestSampleIndex(pos);
		if (idx < 1)
		{
			return;
		}
		Vector3 toCurve = _samplePts[idx] - pos;
		float curveDist = toCurve.magnitude;
		if (!(curveDist > pipeRadius))
		{
			tangent = ((_sampleTans[idx].sqrMagnitude > 1E-08f) ? _sampleTans[idx].normalized : Vector3.forward);
			if (curveDist > 0.0001f)
			{
				rb.AddForce(toCurve / curveDist * pipeCohesion * (curveDist / pipeRadius), ForceMode.Acceleration);
			}
			rb.AddForce(tangent * pipeAcceleration, ForceMode.Acceleration);
			CapTangentSpeed(rb, tangent);
		}
	}

	private void CapTangentSpeed(Rigidbody rb, Vector3 tangent)
	{
		Vector3 velocity = rb.linearVelocity;
		float along = Vector3.Dot(tangent, velocity);
		if (along > maxSpeed)
		{
			rb.linearVelocity = velocity - tangent * (along - maxSpeed);
		}
	}

	private void OnDrawGizmos()
	{
		if (WaypointCount < 1)
		{
			return;
		}
		List<Vector3> pts = new List<Vector3>(64);
		List<Vector3> tans = new List<Vector3>(64);
		Resample(gizmoSamplesPerSegment, pts, tans);
		if (pts.Count == 0)
		{
			return;
		}
		Vector3 start = StartWorld;
		Gizmos.color = startColor;
		Gizmos.DrawWireSphere(start, intakeRadius);
		Gizmos.color = new Color(startColor.r, startColor.g, startColor.b, 0.6f);
		Gizmos.DrawSphere(start, Mathf.Min(intakeRadius * 0.08f, 0.07f));
		Gizmos.color = waypointColor;
		for (int i = 0; i < WaypointCount - 1; i++)
		{
			Gizmos.DrawSphere(GetWaypointWorld(i), 0.06f);
		}
		Vector3 end = EndWorld;
		Gizmos.color = endColor;
		Gizmos.DrawWireSphere(end, releaseRadius);
		Gizmos.DrawSphere(end, Mathf.Min(releaseRadius * 0.3f, 0.06f));
		Gizmos.color = endColor;
		for (int j = 1; j < pts.Count; j++)
		{
			if (j % 2 == 1)
			{
				Gizmos.DrawLine(pts[j - 1], pts[j]);
			}
		}
		if (tans.Count >= 1 && tans[0].sqrMagnitude > 1E-06f)
		{
			Vector3 dir = tans[0].normalized;
			float len = Mathf.Max(intakeRadius * 0.6f, 0.4f);
			Vector3 tip = start + dir * len;
			Gizmos.DrawLine(start, tip);
			Vector3 up = Vector3.up;
			if (Mathf.Abs(Vector3.Dot(dir, up)) > 0.95f)
			{
				up = Vector3.right;
			}
			Vector3 side = Vector3.Cross(dir, up).normalized;
			Vector3 back = tip - dir * (len * 0.22f);
			Vector3 wing = len * 0.18f * side;
			Gizmos.DrawLine(tip, back + wing);
			Gizmos.DrawLine(tip, back - wing);
		}
	}

	private void Reset()
	{
		waypointsLocal = new List<Vector3>
		{
			new Vector3(0f, 2f, 2.5f),
			new Vector3(0f, 0f, 5f)
		};
	}
}
