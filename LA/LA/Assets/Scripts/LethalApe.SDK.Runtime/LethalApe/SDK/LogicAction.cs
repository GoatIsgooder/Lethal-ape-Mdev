using System;
using UnityEngine;

namespace LethalApe.SDK
{
	[Serializable]
	public sealed class LogicAction
	{
		[Tooltip("What happens.")]
		public LogicActionType type = LogicActionType.ToggleObject;

		[Min(0f)]
		[Tooltip("Seconds to wait after the trigger fires.")]
		public float delay;

		[Tooltip("Enable / Disable / Toggle / Move / Rotate: the object to change. Play Sound: where the sound plays (empty = 2D).")]
		public GameObject target;

		[Tooltip("Move Object: the pose to move to. Teleport Player: where to send the player.")]
		public Transform destination;

		[Min(0f)]
		[Tooltip("Move / Rotate: seconds the motion takes. 0 is instant.")]
		public float duration = 1f;

		[Tooltip("Rotate Object: degrees to turn by (local).  Launch Player: velocity in m/s (world).")]
		public Vector3 vector = Vector3.zero;

		[Tooltip("Play Sound: the clip.")]
		public AudioClip sound;

		[Range(0f, 1f)]
		public float volume = 1f;

		[Tooltip("Set Sign Text / Show Message: the text.")]
		public string text = "";

		public Door door;

		public MovingPlatform platform;

		public TextSign sign;

		[Tooltip("Teleport / Launch / Respawn: affect every player instead of only the one who triggered it.")]
		public bool allPlayers;

		public bool AffectsPlayer => type == LogicActionType.TeleportPlayer || type == LogicActionType.LaunchPlayer || type == LogicActionType.RespawnPlayer;
	}
}
