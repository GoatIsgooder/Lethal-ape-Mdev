using System.Collections;
using LethalApeR.SceneFlow;
using UnityEngine;

namespace LethalApeR
{
	public class ScreenFader : MonoBehaviour
	{
		private static ScreenFader _instance;

		public static ScreenFader Get()
		{
			if (!_instance)
			{
				GameObject gameObject = new GameObject("~ScreenFader");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<ScreenFader>();
				SceneFadeOverlay.Ensure();
			}
			return _instance;
		}

		private void Awake()
		{
			_instance = this;
			SceneFadeOverlay.Ensure();
		}

		private void OnDestroy()
		{
			if (_instance == this)
			{
				_instance = null;
			}
		}

		public IEnumerator FadeOut(float duration = 1f)
		{
			return SceneFadeOverlay.Ensure().FadeTo(1f, duration);
		}

		public IEnumerator FadeIn(float duration = 1f)
		{
			return SceneFadeOverlay.Ensure().FadeTo(0f, duration);
		}
	}
}
