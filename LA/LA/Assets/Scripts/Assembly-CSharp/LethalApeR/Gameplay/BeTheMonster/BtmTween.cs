using System;
using System.Collections;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmTween
	{
		public static float OutQuad(float t)
		{
			return 1f - (1f - t) * (1f - t);
		}

		public static float InQuad(float t)
		{
			return t * t;
		}

		public static float OutBack(float t)
		{
			t -= 1f;
			return t * t * (t * 2.70158f + 1.70158f) + 1f;
		}

		public static float InBack(float t)
		{
			return t * t * (t * 2.70158f - 1.70158f);
		}

		public static IEnumerator FadeCanvas(CanvasGroup cg, float from, float to, float dur, Func<float, float> ease)
		{
			if (cg == null)
			{
				yield break;
			}
			float e = 0f;
			while (e < dur)
			{
				e += Time.deltaTime;
				cg.alpha = Mathf.LerpUnclamped(from, to, ease(Mathf.Clamp01(e / dur)));
				yield return null;
			}
			cg.alpha = to;
		}

		public static IEnumerator ScaleTo(Transform tr, float from, float to, float dur, Func<float, float> ease)
		{
			if (tr == null)
			{
				yield break;
			}
			float e = 0f;
			while (e < dur)
			{
				e += Time.deltaTime;
				tr.localScale = Vector3.one * Mathf.LerpUnclamped(from, to, ease(Mathf.Clamp01(e / dur)));
				yield return null;
			}
			tr.localScale = Vector3.one * to;
		}

		public static IEnumerator PunchScale(Transform tr, float amplitude, float dur, int vibrato, float elasticity)
		{
			if (tr == null)
			{
				yield break;
			}
			float e = 0f;
			float baseScale = tr.localScale.x;
			while (e < dur)
			{
				e += Time.deltaTime;
				float num = Mathf.Clamp01(e / dur);
				tr.localScale = Vector3.one * (baseScale + (1f - num) * Mathf.Sin(num * Mathf.PI * (float)vibrato) * Mathf.Lerp(1f, elasticity, num) * amplitude);
				yield return null;
			}
			tr.localScale = Vector3.one * baseScale;
		}
	}
}
