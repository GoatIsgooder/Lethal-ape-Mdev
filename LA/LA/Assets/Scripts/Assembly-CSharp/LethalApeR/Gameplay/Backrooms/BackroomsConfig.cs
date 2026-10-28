using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[CreateAssetMenu(fileName = "BackroomsConfig", menuName = "LethalApeR/Backrooms/Backrooms Config", order = 1)]
	public class BackroomsConfig : ScriptableObject
	{
		[Serializable]
		public struct MonsterVariant
		{
			[Tooltip("Display name (for the inspector only).")]
			public string name;

			[Tooltip("A fully-assembled RoamingMonster prefab (FBX + RoamingMonster + Animator + NavMeshAgent + ChaseTarget colliders + PhotonView). All variants share the same AI; only the visuals differ.")]
			public GameObject prefab;
		}

		[Header("Lobby")]
		[Tooltip("Smallest lobby that auto-starts a run. Below this the room waits in Lobby.")]
		[Min(1f)]
		public int lobbyMin = 4;

		[Tooltip("Room capacity for a co-op run. Used when (re)joining the BACKROOMS queue.")]
		[Min(1f)]
		public int lobbyMax = 6;

		[Tooltip("Seconds the authority waits, once lobbyMin is present, before teleporting everyone into Level 0.")]
		public float lobbyCountdown = 8f;

		[Header("State durations (seconds)")]
		[Tooltip("Settle time after the spawn teleport before objectives go live.")]
		public float spawnSettleDuration = 2f;

		[Tooltip("Power-door ramp: light + audio build before the door opens.")]
		public float doorPowerRampDuration = 6f;

		[Tooltip("How long the escape cutscene plays for everyone before the win resolves.")]
		public float escapeCutsceneDuration = 7f;

		[Tooltip("How long the result room (void dome + win/loss card) dwells before the run restarts. BOTH a win and a wipe then restart at the Backrooms spawn points — neither returns to the hub.")]
		public float endDwellDuration = 6f;

		[Header("Hub return (LEGACY — no longer used by the auto round flow)")]
		[Tooltip("LEGACY: runs no longer auto-return to the hub (both win and wipe restart at the Backrooms spawn). Only the unused ReturnEveryoneToHub() path reads this; leaving the Backrooms is via the manual portal button.")]
		public string hubSceneName = "MainScene";

		[Header("Keycards")]
		[Tooltip("How many keycards (and door slots) a run needs. Default 3.")]
		[Min(1f)]
		public int keycardCount = 3;

		[Tooltip("If true, each colored keycard must go in its matching colored slot. If false, any card fills any slot (count-based, simplest).")]
		public bool enforceColorMatch;

		[Header("Watcher — Still Life")]
		[Tooltip("Radius A: the watcher's head tracks the nearest player inside this distance. Purely cosmetic (local).")]
		public float watcherStareRadius = 14f;

		[Tooltip("Radius B (smaller): a player crossing this makes the watcher scream and raise a host alert.")]
		public float watcherScreamRadius = 4f;

		[Tooltip("Minimum seconds between a single watcher's screams, so it can't spam the alert.")]
		public float watcherScreamCooldown = 12f;

		[Header("Roaming monster")]
		[Tooltip("Available monster models. All share the same AI + Animator; only meshes/skins differ. Swap freely without touching code.")]
		public List<MonsterVariant> monsterVariants = new List<MonsterVariant>();

		[Tooltip("FOV cone half-handled by BaseMonster; applied to each RoamingMonster at spawn. Full angle in degrees (120 = 60 each side).")]
		public float monsterFovAngle = 110f;

		[Tooltip("How far the monster can spot a player.")]
		public float monsterFovRange = 16f;

		[Tooltip("Patrol/roam speed (m/s). Applied to the NavMeshAgent + prefab — see BACKROOMS_SETUP.md (BaseMonster's own speed fields are private).")]
		public float monsterRoamSpeed = 3f;

		[Tooltip("Chase speed (m/s) once a player is spotted.")]
		public float monsterChaseSpeed = 6f;

		[Tooltip("Speed value where the locomotion blend tree is fully WALK (x) and fully RUN (y). Drives the Animator 'Speed'/'Blend' param. Tune so feet don't slide.")]
		public Vector2 walkRunBlendThresholds = new Vector2(0f, 1f);

		[Tooltip("On a watcher scream the nearest monster heads to the alert spot for this long, then loses interest and returns to roaming. Brief default 30s.")]
		public float monsterAlertChaseDuration = 30f;

		[Tooltip("How close (metres) a monster must be to CATCH a player (trigger the jumpscare + downed). Applied to BaseMonster.jumpscareTriggerDistance at spawn so a mis-set prefab can't catch from across the room. ~arm's reach.")]
		public float monsterCatchDistance = 1.8f;

		[Header("Down & revive")]
		[Tooltip("Seconds a caught player stays downed before bleeding out (dying) if no teammate revives them.")]
		public float bleedOutSeconds = 30f;

		[Tooltip("How close a teammate must be to revive a downed player (metres).")]
		public float reviveRange = 1.6f;

		[Tooltip("Hold the interact this long, in range, to complete a revive.")]
		public float reviveHoldSeconds = 3f;

		[Header("Escape")]
		[Tooltip("Intensity the bright end-of-corridor light ramps to when the door powers.")]
		public float endLightIntensity = 8f;

		[Tooltip("After all keycards are in and the door powers, it stays SHUT until a player is within this distance, then slides open.")]
		public float doorProximityRadius = 4f;

		[Tooltip("Seconds for the double door to slide fully open.")]
		public float doorSlideDuration = 2f;

		private void OnValidate()
		{
			if (lobbyMax < lobbyMin)
			{
				lobbyMax = lobbyMin;
			}
			if (keycardCount <= 0)
			{
				keycardCount = 1;
			}
		}
	}
}
