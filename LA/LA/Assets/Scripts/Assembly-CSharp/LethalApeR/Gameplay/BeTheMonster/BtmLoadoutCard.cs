using System.Reflection;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmLoadoutCard : BaseButton
	{
		[SerializeField]
		private TMP_Text nameText;

		[SerializeField]
		private Image background;

		[SerializeField]
		private float previewSize = 0.055f;

		[SerializeField]
		private float previewSpin = 35f;

		[SerializeField]
		private Color currentColor = new Color(1f, 1f, 1f, 0.75f);

		[SerializeField]
		private Color chosenColor = new Color(1f, 0.84f, 0.2f, 0.85f);

		private BtmLoadoutBox _box;

		private GameObject _preview;

		private Color _idleColor;

		private bool _hasIdle;

		public BtmItemDefinition Item { get; private set; }

		public RectTransform Tile => transform.parent as RectTransform;

		public void Bind(BtmLoadoutBox box, BtmItemDefinition item, bool isCurrent, Transform previewParent)
		{
			_box = box;
			Item = item;
			if (!_hasIdle && background != null)
			{
				_idleColor = background.color;
				_hasIdle = true;
			}
			if (nameText != null)
			{
				nameText.text = item.displayName;
			}
			if (_preview != null)
			{
				Object.Destroy(_preview);
			}
			if (item.heldPrefab != null && previewParent != null)
			{
				Transform anchor = (Tile != null) ? Tile : transform;
				Vector3 position = anchor.position - anchor.forward * 0.012f + anchor.up * 0.008f;
				_preview = BtmVisualCopy.Create(item.heldPrefab, position, anchor.rotation, previewParent);
				BtmVisualCopy.FitTo(_preview, previewSize);
				BtmVisualCopy.ApplyTint(_preview, item.tint);
				SetLayerRecursive(_preview.transform, anchor.gameObject.layer);
			}
			SetCurrent(isCurrent);
		}

		public void SetCurrent(bool current)
		{
			if (background != null && _hasIdle)
			{
				background.color = current ? currentColor : _idleColor;
			}
		}

		public void SetChosen(bool chosen)
		{
			if (background != null && _hasIdle && chosen)
			{
				background.color = chosenColor;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (_box != null)
			{
				_box.OnCardPressed(this, false);
			}
		}

		private void Update()
		{
			if (_preview != null)
			{
				_preview.transform.Rotate(0f, previewSpin * Time.deltaTime, 0f, Space.Self);
			}
		}

		private void OnDestroy()
		{
			if (_preview != null)
			{
				Object.Destroy(_preview);
			}
		}

		private static void SetLayerRecursive(Transform t, int layer)
		{
			if (t == null)
			{
				return;
			}
			t.gameObject.layer = layer;
			for (int i = 0; i < t.childCount; i++)
			{
				SetLayerRecursive(t.GetChild(i), layer);
			}
		}
	}
}
