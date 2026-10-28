using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(SlopColorGrade))]
[DisallowMultipleComponent]
[AddComponentMenu("Slop/Slop Dread Receiver")]
public class SlopDreadReceiver : MonoBehaviour
{
	[Tooltip("How fast the effect eases in and out, in units per second. Higher = snappier.")]
	public float responseSpeed = 4f;

	[Tooltip("Turn off to freeze the effect without removing the component.")]
	public bool active = true;

	private SlopColorGrade _grade;

	private float _baseGrain;

	private float _baseVignette;

	private float _baseSmoothness;

	private Color _baseColor;

	private float _strength;

	private float _targetGrain;

	private float _targetVignette;

	private float _targetSmoothness;

	private Color _targetColor;

	private void Awake()
	{
		_grade = GetComponent<SlopColorGrade>();
		_baseGrain = _grade.grainIntensity;
		_baseVignette = _grade.vignetteIntensity;
		_baseSmoothness = _grade.vignetteSmoothness;
		_baseColor = _grade.vignetteColor;
	}

	private void OnDisable()
	{
		if (!(_grade == null))
		{
			_grade.grainIntensity = _baseGrain;
			_grade.vignetteIntensity = _baseVignette;
			_grade.vignetteSmoothness = _baseSmoothness;
			_grade.vignetteColor = _baseColor;
			_strength = 0f;
		}
	}

	private void LateUpdate()
	{
		if (_grade == null)
		{
			return;
		}
		float num = 0f;
		if (active)
		{
			List<SlopDreadEmitter> list = SlopDreadEmitter.Active;
			Vector3 position = base.transform.position;
			Transform root = base.transform.root;
			for (int i = 0; i < list.Count; i++)
			{
				SlopDreadEmitter slopDreadEmitter = list[i];
				if (!(slopDreadEmitter == null) && !(slopDreadEmitter.transform.root == root))
				{
					float num2 = slopDreadEmitter.Influence(position);
					if (num2 > num)
					{
						num = num2;
						_targetGrain = slopDreadEmitter.grain;
						_targetVignette = slopDreadEmitter.vignette;
						_targetSmoothness = slopDreadEmitter.vignetteSmoothness;
						_targetColor = slopDreadEmitter.vignetteColor;
					}
				}
			}
		}
		_strength = Mathf.MoveTowards(_strength, num, responseSpeed * Time.deltaTime);
		_grade.grainIntensity = Mathf.Max(_baseGrain, _strength * _targetGrain);
		_grade.vignetteIntensity = Mathf.Max(_baseVignette, _strength * _targetVignette);
		bool flag = _strength > 0.001f;
		_grade.vignetteSmoothness = (flag ? _targetSmoothness : _baseSmoothness);
		_grade.vignetteColor = (flag ? _targetColor : _baseColor);
	}
}
