using System.Collections.Generic;
using UnityEngine;

[DisallowMultipleComponent]
[AddComponentMenu("Slop/Slop Dread Emitter")]
public class SlopDreadEmitter : MonoBehaviour
{
	public static readonly List<SlopDreadEmitter> Active = new List<SlopDreadEmitter>();

	[Tooltip("Metres. Full strength at the centre, zero at the edge. The old volume used blendDistance 2.79.")]
	public float radius = 2.79f;

	[Tooltip("Grain at full strength. The old profile used 1.")]
	[Range(0f, 1f)]
	public float grain = 1f;

	[Tooltip("Vignette at full strength. The old profile used 0.309.")]
	[Range(0f, 1f)]
	public float vignette = 0.309f;

	[Range(0.01f, 1f)]
	public float vignetteSmoothness = 1f;

	[Tooltip("The vignette's colour while this emitter is the strongest one near the player. The old profile used black.")]
	[ColorUsage(false)]
	public Color vignetteColor = Color.black;

	private void OnEnable()
	{
		Active.Add(this);
	}

	private void OnDisable()
	{
		Active.Remove(this);
	}

	public float Influence(Vector3 point)
	{
		if (radius <= 0.001f)
		{
			return 0f;
		}
		return Mathf.SmoothStep(1f, 0f, Vector3.Distance(point, base.transform.position) / radius);
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.color = new Color(0.8f, 0.1f, 0.1f, 0.35f);
		Gizmos.DrawWireSphere(base.transform.position, radius);
	}
}
