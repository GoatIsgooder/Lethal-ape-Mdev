using LethalApeR.Rivals.Weapons;
using UnityEngine;

namespace LethalApeR.Rivals.Shop
{
	public class WeaponWheelCategoryButton : BaseButton
	{
		[Tooltip("The wheel this button drives. Auto-found in parents when empty.")]
		public WeaponWheel wheel;

		[Tooltip("Which category this button shows on the wheel.")]
		public LoadoutSlot category;

		[Header("Highlight")]
		public Renderer highlightRenderer;

		public Color activeColor = new Color(1f, 0.85f, 0.25f, 1f);

		public Color inactiveColor = new Color(0.45f, 0.45f, 0.45f, 1f);

		private MaterialPropertyBlock _mpb;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private void Awake()
		{
			if (wheel == null)
			{
				wheel = GetComponentInParent<WeaponWheel>();
			}
			if (highlightRenderer == null)
			{
				highlightRenderer = GetComponent<Renderer>();
			}
		}

		private void OnEnable()
		{
			if (wheel != null)
			{
				wheel.onCategoryChanged += HandleCategoryChanged;
				HandleCategoryChanged(wheel.CurrentCategory);
			}
		}

		private void OnDisable()
		{
			if (wheel != null)
			{
				wheel.onCategoryChanged -= HandleCategoryChanged;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (wheel != null)
			{
				wheel.SetCategory(category);
			}
		}

		private void HandleCategoryChanged(LoadoutSlot active)
		{
			if (!(highlightRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				highlightRenderer.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, (category == active) ? activeColor : inactiveColor);
				highlightRenderer.SetPropertyBlock(_mpb);
			}
		}
	}
}
