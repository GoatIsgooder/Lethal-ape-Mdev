using System.Reflection;
using UnityEngine;

namespace LethalApeR.CustomMaps
{
	[Obfuscation(Exclude = true)]
	public sealed class LeaveCustomMapButton : BaseButton
	{
		[SerializeField]
		private Transform cap;

		[SerializeField]
		[Min(0f)]
		private float pressDepth = 0.02f;

		[SerializeField]
		private AudioSource click;

		private float _pressedAt = -10f;

		private Vector3 _capRest;

		private void Awake()
		{
			if (cap != null)
			{
				_capRest = cap.localPosition;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (Time.time - _pressedAt < 1.5f)
			{
				return;
			}
			_pressedAt = Time.time;
			if (click != null)
			{
				click.Play();
			}
			if (CustomMapRoomBinder.Instance != null)
			{
				CustomMapRoomBinder.Instance.LeaveCustomMap();
			}
		}

		private void Update()
		{
			if (!(cap == null))
			{
				float num = (Time.time - _pressedAt) / 0.2f;
				float num2 = ((num < 1f) ? Mathf.Sin(Mathf.Clamp01(num) * Mathf.PI) : 0f);
				cap.localPosition = _capRest + Vector3.back * (num2 * pressDepth);
			}
		}
	}
}
