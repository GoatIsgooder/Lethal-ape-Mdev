using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.LandmineSystem
{
	public class LandmineFlashbang : MonoBehaviour
	{
		public enum Style
		{
			Knockback = 0,
			Death = 1
		}

		private SlopColorGrade _grade;

		private Style _style;

		private float _duration;

		private float _baseExposure;

		private float _baseSaturation;

		private Color _baseFilter;

		public static LandmineFlashbang Spawn(Style style, float duration)
		{
			SlopColorGrade slopColorGrade = ResolveGrade();
			if (slopColorGrade == null)
			{
				Debug.LogWarning("[LandmineFlashbang] No SlopColorGrade on the player camera — flashbang skipped.");
				return null;
			}
			GameObject gameObject = new GameObject((style == Style.Death) ? "LandmineFlashbang_Death" : "LandmineFlashbang");
			DontDestroyOnLoad(gameObject);
			LandmineFlashbang landmineFlashbang = gameObject.AddComponent<LandmineFlashbang>();
			landmineFlashbang.Init(slopColorGrade, style, Mathf.Max(duration, 0.1f));
			return landmineFlashbang;
		}

		private static SlopColorGrade ResolveGrade()
		{
			Camera camera = ((GorillaLocomotion.Player.Instance != null) ? GorillaLocomotion.Player.Instance.mainCamera : Camera.main);
			if (!(camera != null))
			{
				return null;
			}
			return camera.GetComponent<SlopColorGrade>();
		}

		private void Init(SlopColorGrade grade, Style style, float duration)
		{
			_grade = grade;
			_style = style;
			_duration = duration;
			_baseExposure = grade.postExposure;
			_baseSaturation = grade.saturation;
			_baseFilter = grade.colorFilter;
			StartCoroutine((style == Style.Death) ? RunDeath() : RunKnockback());
		}

		private IEnumerator RunKnockback()
		{
			float t = 0f;
			while (t < _duration)
			{
				t += Time.deltaTime;
				float num = Mathf.Clamp01(t / _duration);
				float num2 = (1f - num) * (1f - num);
				_grade.postExposure = _baseExposure + num2 * 4f;
				_grade.colorFilter = Color.white;
				_grade.saturation = Mathf.Lerp(_baseSaturation, -100f, num2);
				yield return null;
			}
			Cleanup();
		}

		private IEnumerator RunDeath()
		{
			Color deadTint = new Color(0.6f, 0.08f, 0.08f, 1f);
			float t = 0f;
			while (t < 0.3f)
			{
				t += Time.deltaTime;
				float num = Mathf.Clamp01(t / 0.3f);
				_grade.postExposure = Mathf.Lerp(_baseExposure + 4f, _baseExposure - 3f, num);
				_grade.colorFilter = Color.Lerp(Color.white, deadTint, num);
				_grade.saturation = Mathf.Lerp(-100f, -75f, num);
				yield return null;
			}
			float recovery = Mathf.Max(_duration - 0.3f, 0.1f);
			t = 0f;
			while (t < recovery)
			{
				t += Time.deltaTime;
				float num2 = Mathf.Clamp01(t / recovery);
				_grade.postExposure = Mathf.Lerp(_baseExposure - 3f, _baseExposure, num2);
				_grade.colorFilter = Color.Lerp(deadTint, _baseFilter, num2);
				_grade.saturation = Mathf.Lerp(-75f, _baseSaturation, num2);
				yield return null;
			}
			Cleanup();
		}

		private void Restore()
		{
			if (!(_grade == null))
			{
				_grade.postExposure = _baseExposure;
				_grade.saturation = _baseSaturation;
				_grade.colorFilter = _baseFilter;
			}
		}

		private void OnDisable()
		{
			Restore();
		}

		private void Cleanup()
		{
			Restore();
			Destroy(base.gameObject);
		}
	}
}
