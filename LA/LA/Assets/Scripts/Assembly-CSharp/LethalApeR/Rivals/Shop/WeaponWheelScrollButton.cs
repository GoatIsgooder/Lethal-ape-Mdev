using UnityEngine;

namespace LethalApeR.Rivals.Shop
{
	public class WeaponWheelScrollButton : BaseButton
	{
		[Tooltip("The wheel this button drives. Auto-found in parents when empty.")]
		public WeaponWheel wheel;

		[Tooltip("Off = scroll DOWN (next weapon descends to you). On = scroll back up.")]
		public bool scrollUp;

		private void Awake()
		{
			if (wheel == null)
			{
				wheel = GetComponentInParent<WeaponWheel>();
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (!(wheel == null))
			{
				if (scrollUp)
				{
					wheel.ScrollUp();
				}
				else
				{
					wheel.ScrollDown();
				}
			}
		}
	}
}
