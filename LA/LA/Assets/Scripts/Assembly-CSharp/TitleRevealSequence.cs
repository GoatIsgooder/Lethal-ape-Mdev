using System;
using System.Collections;
using UnityEngine;

public class TitleRevealSequence : MonoBehaviour
{
	[Header("Assign the material using TitleReveal shader")]
	public Renderer targetRenderer;

	[Header("What scales up (defaults to this object)")]
	public Transform scaleTarget;

	[Header("Timing (seconds)")]
	public float outlineFadeIn = 1f;

	public float fillSweep = 1.2f;

	public float holdSolid = 1f;

	public float dissolveOut = 1.5f;

	[Header("Scale-up (during glow-in)")]
	public float startScale = 0.05f;

	public float endScale = 1f;

	[Tooltip("0 = linear, 1 = ease-out (fast then settle). Matches a title that pops then eases.")]
	[Range(0f, 1f)]
	public float scaleEasing = 1f;

	[Header("Flow")]
	[Tooltip("Off: nothing happens until Play() is called (the loading menu faces the player first).")]
	public bool autoStart = true;

	[Tooltip("Off: stop on the solid title instead of dissolving it away.")]
	public bool dissolveAtEnd = true;

	[Tooltip("How much faster the rest of the reveal runs after Skip().")]
	public float skipSpeed = 5f;

	private Material mat;

	private Vector3 baseScale;

	private bool started;

	private bool skipping;

	public bool IsRevealed { get; private set; }

	public event Action Revealed;

	private void Awake()
	{
		mat = targetRenderer.material;
		mat.SetFloat("_OutlineGlow", 0f);
		mat.SetFloat("_FillAmount", 0f);
		mat.SetFloat("_Dissolve", 0f);
		if (scaleTarget == null)
		{
			scaleTarget = transform;
		}
		baseScale = scaleTarget.localScale;
		scaleTarget.localScale = baseScale * startScale;
	}

	private void Start()
	{
		if (autoStart)
		{
			Play();
		}
	}

	public void Play()
	{
		if (!started)
		{
			started = true;
			StartCoroutine(Run());
		}
	}

	public void Skip()
	{
		skipping = true;
	}

	private IEnumerator Run()
	{
		yield return Lerp(outlineFadeIn, delegate(float t)
		{
			mat.SetFloat("_OutlineGlow", t);
			float k = Mathf.Lerp(t, EaseOut(t), scaleEasing);
			scaleTarget.localScale = Mathf.Lerp(startScale, endScale, k) * baseScale;
		});
		scaleTarget.localScale = baseScale * endScale;
		yield return Lerp(fillSweep, delegate(float t)
		{
			mat.SetFloat("_FillAmount", t);
		});
		float e = 0f;
		while (e < holdSolid)
		{
			yield return null;
			e += Time.deltaTime * (skipping ? skipSpeed : 1f);
		}
		IsRevealed = true;
		Revealed?.Invoke();
		if (dissolveAtEnd)
		{
			yield return Lerp(dissolveOut, delegate(float t)
			{
				mat.SetFloat("_Dissolve", t);
			});
		}
	}

	private float EaseOut(float t)
	{
		return 1f - Mathf.Pow(1f - t, 3f);
	}

	private IEnumerator Lerp(float duration, Action<float> apply)
	{
		float e = 0f;
		while (e < duration)
		{
			e += Time.deltaTime * (skipping ? skipSpeed : 1f);
			apply(Mathf.Clamp01(e / duration));
			yield return null;
		}
		apply(1f);
	}
}
