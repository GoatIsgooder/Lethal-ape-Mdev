using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;

public class StartFade : MonoBehaviour
{
	[SerializeField]
	private Shader _fadeShader;

	[SerializeField]
	private float fadeDuration = 0.5f;

	private Material _mat;

	private Renderer _renderer;

	private Coroutine _active;

	private static readonly int AlphaId = Shader.PropertyToID("_Alpha");

	private void Awake()
	{
		GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Sphere);
		gameObject.name = "FadeSphere";
		gameObject.transform.SetParent(base.transform, false);
		gameObject.transform.localScale = Vector3.one * 0.28f;
		UnityEngine.Object.Destroy(gameObject.GetComponent<SphereCollider>());
		Shader shader = ((_fadeShader != null) ? _fadeShader : Shader.Find("Slop/FadeSphere"));
		_mat = new Material(shader);
		_mat.SetFloat(AlphaId, 0f);
		_renderer = gameObject.GetComponent<MeshRenderer>();
		_renderer.material = _mat;
		_renderer.shadowCastingMode = ShadowCastingMode.Off;
		_renderer.receiveShadows = false;
		_renderer.enabled = false;
	}

	private void OnDestroy()
	{
		UnityEngine.Object.Destroy(_mat);
	}

	public void FadeIn(Action onComplete = null)
	{
		Run(CurrentAlpha(), 1f, onComplete);
	}

	public void FadeOut(Action onComplete = null)
	{
		Run(CurrentAlpha(), 0f, onComplete);
	}

	private float CurrentAlpha()
	{
		if (!(_mat != null))
		{
			return 0f;
		}
		return _mat.GetFloat(AlphaId);
	}

	private void Run(float from, float to, Action onComplete)
	{
		if (_active != null)
		{
			StopCoroutine(_active);
		}
		_active = StartCoroutine(Fade(from, to, onComplete));
	}

	private IEnumerator Fade(float from, float to, Action onComplete)
	{
		_renderer.enabled = true;
		float elapsed = 0f;
		float duration = fadeDuration * Mathf.Abs(to - from);
		while (elapsed < duration)
		{
			elapsed += Time.deltaTime;
			_mat.SetFloat(AlphaId, Mathf.Lerp(from, to, elapsed / duration));
			yield return null;
		}
		_mat.SetFloat(AlphaId, to);
		if (to <= 0f)
		{
			_renderer.enabled = false;
		}
		_active = null;
		onComplete?.Invoke();
	}
}
