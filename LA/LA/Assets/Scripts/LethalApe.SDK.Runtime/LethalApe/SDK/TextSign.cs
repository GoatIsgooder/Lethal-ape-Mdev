using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Content/Text Sign")]
	[DisallowMultipleComponent]
	public sealed class TextSign : MapComponent
	{
		[SerializeField]
		[TextArea(2, 8)]
		private string text = "Welcome!";

		[SerializeField]
		[Tooltip("Sign width and height in metres.")]
		private Vector2 size = new Vector2(1.2f, 0.6f);

		[SerializeField]
		[Range(0.02f, 0.6f)]
		[Tooltip("Letter height in metres.")]
		private float letterHeight = 0.08f;

		[SerializeField]
		private SignStyle style;

		[SerializeField]
		private SignAlignment alignment = SignAlignment.Center;

		[SerializeField]
		private Color textColor = Color.white;

		public string Text => text;

		public Vector2 Size => size;

		public float LetterHeight => letterHeight;

		public SignStyle Style => style;

		public SignAlignment Alignment => alignment;

		public Color TextColor => textColor;
	}
}
