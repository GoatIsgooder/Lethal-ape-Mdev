using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Logic/Door")]
	[DisallowMultipleComponent]
	public sealed class Door : MapComponent
	{
		[SerializeField]
		[Tooltip("How far the door moves when open, in the parent's space.")]
		private Vector3 openPositionOffset = new Vector3(0f, 0f, 0f);

		[SerializeField]
		[Tooltip("How far the door turns when open, in degrees. (0, 90, 0) swings it around its pivot.")]
		private Vector3 openRotationOffset = new Vector3(0f, 90f, 0f);

		[SerializeField]
		[Range(0.1f, 5f)]
		[Tooltip("Seconds to open or close.")]
		private float duration = 0.8f;

		[SerializeField]
		private bool startOpen;

		[SerializeField]
		[Min(0f)]
		[Tooltip("Close again after this many seconds. 0 stays open.")]
		private float autoCloseSeconds;

		[SerializeField]
		[Tooltip("Buttons that open and close this door.")]
		private MapButton[] buttons = new MapButton[0];

		[SerializeField]
		private AudioClip openSound;

		[SerializeField]
		private AudioClip closeSound;

		public Vector3 OpenPositionOffset => openPositionOffset;

		public Vector3 OpenRotationOffset => openRotationOffset;

		public float Duration => duration;

		public bool StartOpen => startOpen;

		public float AutoCloseSeconds => autoCloseSeconds;

		public MapButton[] Buttons => buttons;

		public AudioClip OpenSound => openSound;

		public AudioClip CloseSound => closeSound;
	}
}
