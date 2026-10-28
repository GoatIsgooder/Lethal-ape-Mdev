using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Logic/Button")]
	[DisallowMultipleComponent]
	public sealed class MapButton : MapComponent
	{
		[SerializeField]
		[Tooltip("Centre of the press area, local to this object.")]
		private Vector3 pressCenter = Vector3.zero;

		[SerializeField]
		[Tooltip("Size of the press area. Keep the front face at least 8 cm wide for real hands.")]
		private Vector3 pressSize = new Vector3(0.12f, 0.12f, 0.06f);

		[SerializeField]
		[Tooltip("Optional: the part that sinks in when pressed.")]
		private Transform pressVisual;

		[SerializeField]
		[Range(0f, 0.05f)]
		[Tooltip("How far the press visual sinks along its local -Z, in metres.")]
		private float pressDepth = 0.012f;

		[SerializeField]
		[Range(0.1f, 5f)]
		[Tooltip("Seconds before it can be pressed again.")]
		private float cooldown = 0.5f;

		[SerializeField]
		[Tooltip("On: each press flips between on and off. Off: every press is a new trigger.")]
		private bool toggle;

		[SerializeField]
		[Tooltip("Who sees what this button does.")]
		private LogicScope scope = LogicScope.Everyone;

		[SerializeField]
		[Tooltip("Optional sound. Leave empty for the game's default click.")]
		private AudioClip pressSound;

		public Vector3 PressCenter => pressCenter;

		public Vector3 PressSize => pressSize;

		public Transform PressVisual => pressVisual;

		public float PressDepth => pressDepth;

		public float Cooldown => cooldown;

		public bool Toggle => toggle;

		public LogicScope Scope => scope;

		public AudioClip PressSound => pressSound;
	}
}
