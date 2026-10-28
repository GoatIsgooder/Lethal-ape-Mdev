using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmSpinner : MonoBehaviour
	{
		[SerializeField]
		private Vector3 degreesPerSecond = new Vector3(0f, 20f, 0f);

		[SerializeField]
		private float bobHeight = 0.08f;

		[SerializeField]
		private float bobSpeed = 0.8f;

		private Vector3 _home;

		private float _phase;

		private void Awake()
		{
			_home = base.transform.localPosition;
			_phase = Random.value * Mathf.PI * 2f;
		}

		private void Update()
		{
			base.transform.Rotate(degreesPerSecond * Time.deltaTime, Space.Self);
			if (bobHeight > 0f)
			{
				base.transform.localPosition = _home + Vector3.up * (bobHeight * Mathf.Sin(Time.time * bobSpeed + _phase));
			}
		}
	}
}
