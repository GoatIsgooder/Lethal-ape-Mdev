using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[Serializable]
	public class FnSettings
	{
		[Serializable]
		public class HubSettings
		{
			[Tooltip("Seconds from the last ready to the group moving into its night room.")]
			public float countdownSeconds = 5f;

			[Tooltip("Horizontal radius around a pad that counts as standing on it (m).")]
			public float padRadius = 0.9f;

			[Tooltip("Max height of the head above the pad that still counts (m).")]
			public float padMaxHeight = 2.6f;

			[Tooltip("Seconds between claim retries while the local claim and the pad disagree.")]
			public float claimRetrySeconds = 0.75f;

			[Tooltip("A pad still locked with occupants this long after its migration is cleared (s).")]
			public float lockTimeoutSeconds = 30f;

			[Tooltip("Fade to black before leaving for a night or the hub (s).")]
			public float migrateFadeSeconds = 0.6f;

			[Tooltip("Fade back in after arriving in a room (s).")]
			public float arriveFadeSeconds = 0.8f;

			[Tooltip("Highest night the selector offers (Night 6 is a later feature).")]
			[Range(1f, 6f)]
			public int maxNight = 5;
		}

		[Serializable]
		public class NightSettings
		{
			[Tooltip("Real seconds per in-game hour. 70 makes a night about 7 minutes. Published to clients at Briefing.")]
			public float hourSeconds = 70f;

			[Tooltip("Night-room master waits this long for every member and avatar, then starts with whoever arrived (s).")]
			public float gatherTimeoutSeconds = 25f;

			[Tooltip("NIGHT N / 12 AM card, and the mic noise-floor calibration window (s).")]
			public float briefingSeconds = 10f;

			[Tooltip("6 AM: chime and the animatronics powering down (s).")]
			public float dawnSeconds = 6f;

			[Tooltip("Beat after the last guard is caught, before Results (s).")]
			public float lostSeconds = 4f;

			[Tooltip("Results panel time before everyone returns to a public hub (s).")]
			public float resultsSeconds = 10f;

			[Tooltip("Each client leaves this long after Results ends even if the master never says so (s).")]
			public float closingGraceSeconds = 2f;
		}

		[Serializable]
		public class PowerSettings
		{
			[Tooltip("Power at 12 AM (%).")]
			public float startPower = 100f;

			[Tooltip("Base drain per night, index 0 = Night 1 (%/s). 0.08 x 420 s = 34% over a 70 s-hour night.")]
			public float[] baseDrainPerNight = new float[6] { 0.08f, 0.1f, 0.12f, 0.14f, 0.16f, 0.18f };

			[Tooltip("Extra drain per usage unit: each closed door, each lit hall light, each living guard on the cameras (%/s).")]
			public float unitDrain = 0.1f;

			[Tooltip("Minimum seconds between power prop writes (at most 2 Hz). Clients extrapolate in between.")]
			public float minWriteInterval = 0.5f;

			[Tooltip("Power lost per knock burst on a closed door (%). 0 as in FNAF: the closed door's own drain is the cost.")]
			public float bangCost;

			[Tooltip("Endo's first slam on a closed door (%).")]
			public float endoHitBase = 1f;

			[Tooltip("Added to each further Endo hit in the same night (%).")]
			public float endoHitStep = 5f;

			[Tooltip("Power gained from a completed fuse-box reset (%).")]
			public float fuseGain = 15f;

			[Tooltip("Power gained per battery delivered to the office charger (%).")]
			public float batteryGain = 8f;

			[Tooltip("Bear's music box at the west door during a blackout, before the office catch (s, random in range).")]
			public Vector2 musicBoxSeconds = new Vector2(5f, 20f);
		}

		[Serializable]
		public class OfficeSettings
		{
			[Tooltip("Minimum seconds between toggles of one door (master-enforced).")]
			public float doorToggleCooldown = 0.35f;

			[Tooltip("A hall light switches itself off this long after being lit (s).")]
			public float lightAutoOff = 2.5f;

			[Tooltip("Slack when the master checks a requester is inside the office, for latency (m).")]
			public float officeSlack = 1f;

			[Tooltip("Door slam travel time (s).")]
			public float doorTravelSeconds = 0.22f;

			[Tooltip("How long a bang shakes the door (s).")]
			public float bangShakeSeconds = 0.35f;

			[Tooltip("Door shake amplitude at a bang (m). Door-local only: the camera never shakes.")]
			public float bangShakeAmount = 0.025f;
		}

		[Serializable]
		public class CameraSettings
		{
			[Tooltip("CCTV render texture width (px). Quest: keep small; the monitor is a small screen.")]
			public int renderWidth = 480;

			[Tooltip("CCTV render texture height (px).")]
			public int renderHeight = 300;

			[Tooltip("Render the CCTV camera every Nth frame. 2 = half rate, which reads as CCTV.")]
			[Range(1f, 6f)]
			public int renderEveryNthFrame = 2;

			[Tooltip("Signal drop on every channel change (s).")]
			public float signalDropSeconds = 0.35f;

			[Tooltip("Animatronic speed at which a camera watching it is fully scrambled (m/s).")]
			public float scrambleFullSpeed = 2.5f;

			[Tooltip("Scramble never quite blanks the feed.")]
			[Range(0f, 1f)]
			public float scrambleMax = 0.92f;

			[Tooltip("Static fades out this fast once the animatronic stops (per second).")]
			public float scrambleDecay = 2.5f;

			[Tooltip("The monitor only renders while the local guard's head is this close to it (m).")]
			public float monitorUseDistance = 1.6f;

			[Tooltip("Shared team cooldown between audio lures (s).")]
			public float lureCooldown = 20f;

			[Tooltip("Power cost of an audio lure (%).")]
			public float lureCost = 3f;
		}

		[Serializable]
		public class TaskSettings
		{
			[Tooltip("Fuse-box resets available per night.")]
			public int fuseUses = 2;

			[Tooltip("How close the head must be to the fuse box to pull a breaker (m).")]
			public float fuseBoxRange = 2.5f;

			[Tooltip("Batteries placed per night (random in range, from the spawn points).")]
			public Vector2Int batteryCount = new Vector2Int(3, 4);

			[Tooltip("How close the head must be to a battery to take it (m).")]
			public float batteryPickRange = 2f;

			[Tooltip("How close the head must be to the office charger to deliver (m).")]
			public float chargerRange = 2.5f;
		}

		[Serializable]
		public class FlashlightSettings
		{
			[Tooltip("Seconds of on-time from a full charge.")]
			public float batterySeconds = 120f;

			[Tooltip("Charge regained per second while inside the office (fraction of full per s).")]
			public float officeRechargePerSecond = 0.08f;

			[Tooltip("Beam reach, for the light itself and for what it attracts (m).")]
			public float range = 12f;

			[Tooltip("Spot angle of the local light (degrees).")]
			public float spotAngle = 42f;

			[Tooltip("Local light intensity. The ONLY realtime light besides one hall light.")]
			public float intensity = 2.4f;

			[Tooltip("An animatronic this far inside the beam counts as lit (degrees off-axis).")]
			public float attractHalfAngle = 18f;

			[Tooltip("Endo is repelled within this range (m).")]
			public float endoRepelRange = 8f;

			[Tooltip("Seconds of beam on Endo to send it fleeing.")]
			public float endoRepelSeconds = 1.5f;
		}

		[Serializable]
		public class NoiseSettings
		{
			[Tooltip("Rig ground speed above which a guard makes running noise (m/s).")]
			public float runSpeed = 3f;

			public float footstepRadius = 8f;

			[Tooltip("Voice hearing radius at the calibrated floor and at a shout (m).")]
			public Vector2 voiceRadius = new Vector2(4f, 14f);

			[Tooltip("Mic level above the calibrated floor that counts as a shout (CurrentAvgAmp units).")]
			public float voiceShoutAbove = 0.08f;

			[Tooltip("Margin added to the calibrated floor before voice counts (CurrentAvgAmp units).")]
			public float voiceMargin = 0.015f;

			[Tooltip("Percentile of Briefing mic levels used as the noise floor.")]
			[Range(0.5f, 1f)]
			public float voiceFloorPercentile = 0.9f;

			[Tooltip("Noise reports a client may send per second (master drops extras).")]
			public float maxReportsPerSecond = 2f;

			public float doorSlamRadius = 12f;

			public float bangRadius = 10f;

			public float breakerRadius = 16f;

			public float lureRadius = 18f;

			public float pickupRadius = 6f;

			[Tooltip("Hearing radius multiplier when level geometry blocks the line to the source.")]
			[Range(0f, 1f)]
			public float throughWallFactor = 0.5f;
		}

		[Serializable]
		public class AiSettings
		{
			[Tooltip("Senses run on this period, round-robin over animatronics (s).")]
			public float senseTickSeconds = 0.2f;

			[Tooltip("Upper bound on sight raycasts per sense tick (Quest budget).")]
			public int maxRaycastsPerTick = 12;

			[Tooltip("Pose stream rate for moving animatronics (Hz).")]
			public float poseHz = 10f;

			[Tooltip("Props snapshot rate while moving (Hz, at most 1).")]
			[Range(0.1f, 1f)]
			public float snapshotHz = 1f;

			[Tooltip("Level added per guard beyond the first (duo +2, trio +4).")]
			public int teamOffsetPerExtraGuard = 2;

			[Tooltip("In-game hours at which every level rises by one.")]
			public int[] levelBumpHours = new int[3] { 2, 3, 4 };

			[Range(1f, 20f)]
			public int levelCap = 20;

			[Tooltip("Per animatronic, indexed by FnAnim: Bear, Bunny, Chicken, Endo.")]
			public FnAnimTuning[] animatronics = new FnAnimTuning[4]
			{
				FnAnimTuning.Bear(),
				FnAnimTuning.Bunny(),
				FnAnimTuning.Chicken(),
				FnAnimTuning.Endo()
			};

			public FnAnimTuning For(FnAnim anim)
			{
				if (animatronics != null && (int)anim < animatronics.Length && animatronics[(int)anim] != null)
				{
					return animatronics[(int)anim];
				}
				return FnAnimTuning.Bunny();
			}
		}

		[Serializable]
		public class CatchSettings
		{
			[Tooltip("Horizontal reach of an animatronic's catch capsule (m).")]
			public float reachRadius = 0.8f;

			[Tooltip("Catch capsule height above the animatronic's feet (m). Perches above this are escapes.")]
			public float reachHeight = 2.6f;

			[Tooltip("Victim resends its catch report this often while the overlap holds (s).")]
			public float reportRetrySeconds = 0.5f;

			[Tooltip("Reported head may differ from the master's view by this much (m).")]
			public float headTolerance = 1.5f;

			[Tooltip("Master catches on its own after seeing a strict overlap this long with no report (s).")]
			public float backstopSeconds = 1.5f;

			[Tooltip("Upper bound on the latency slack the master grants (m).")]
			public float maxSlack = 3f;

			[Tooltip("Beat between an animatronic stepping into the doorway and the catch (s).")]
			public float doorwayCatchDelay = 0.8f;

			[Tooltip("How far in front of the HMD the lunge starts (m).")]
			public float lungeDistance = 0.8f;

			[Tooltip("Lunge duration (s, at most 1).")]
			[Range(0.2f, 1f)]
			public float lungeSeconds = 0.9f;

			[Tooltip("Fade to black after the lunge (s).")]
			public float caughtFadeSeconds = 0.6f;

			[Tooltip("Seconds in the dark before rising as a ghost.")]
			public float ghostDelaySeconds = 1.2f;

			[Tooltip("An animatronic under a perched guard it can't leap at waits this long, then gives up (s).")]
			public float perchGiveUpSeconds = 6f;

			[Header("Leaps (a perched guard, never in the office)")]
			[Tooltip("Animatronics leap at a guard perched out of reach anywhere but the office.")]
			public bool jumpEnabled = true;

			[Tooltip("Highest the feet leave the floor (m). The ceilings over the ledges keep real leaps near 2.3.")]
			public float jumpMaxHeight = 2.5f;

			[Tooltip("At the top of a leap the guard's head is this far above the animatronic's feet (m): inside the reach, with a margin.")]
			public float jumpHeadAboveFeet = 2.25f;

			[Tooltip("Extra reach across while airborne (m): the arms come up and over a ledge's lip. At the top of a leap the head is about 0.85 m above the shoulder, so the arms reach about 1.05 m across.")]
			public float jumpExtraReach = 0.25f;

			[Tooltip("The crouch before a leap at level 0 and level 20 (s): the guard's warning.")]
			public Vector2 jumpWindupSeconds = new Vector2(0.8f, 0.5f);

			[Tooltip("The grab at the top of a leap (s).")]
			public float jumpHangSeconds = 0.22f;

			[Tooltip("Landing recovery before it moves again (s).")]
			public float jumpLandSeconds = 0.4f;

			[Tooltip("Between leaps at the same guard (s).")]
			public float jumpCooldownSeconds = 1.5f;

			[Tooltip("Missed leaps at one perched guard before it goes back to waiting below.")]
			[Range(1f, 6f)]
			public int jumpMaxAttempts = 3;

			[Tooltip("Endo, which never chases, pounces at a perched guard within this distance of its sprint (m across).")]
			public float endoPounceRange = 2.5f;
		}

		[Serializable]
		public class GhostSettings
		{
			public float gravity = 2.45f;

			public float drag = 0.8f;

			public float riseSpeed = 1.2f;

			[Tooltip("Living listeners hear a ghost's gibberish at full volume inside this (m).")]
			public float voiceFullWithin = 3f;

			[Tooltip("Silent past this; the scramble DSP only runs inside it (m).")]
			public float voiceSilentBeyond = 8f;

			[Tooltip("Off = the living never hear ghosts at all.")]
			public bool whispers = true;

			[Tooltip("FOLLOW puts you this far behind the target (m).")]
			public float followBackDistance = 1.6f;

			[Tooltip("Kept clear of a wall the FOLLOW probe hits (m).")]
			public float followWallMargin = 0.3f;

			[Tooltip("Fade used by the ghost wrist-panel teleports (s).")]
			public float teleportFadeSeconds = 0.25f;
		}

		[Serializable]
		public class ComfortSettings
		{
			[Tooltip("Fade and sting only: no lunge (a local option; this is the default for new players).")]
			public bool reducedJumpscare;

			[Tooltip("No light or overlay in FNAF flashes faster than this (Hz).")]
			public float maxFlashHz = 3f;

			[Tooltip("World-space captions for directional cues (bangs west/east, footsteps).")]
			public bool subtitles = true;
		}

		[Serializable]
		public class DifficultySettings
		{
			[Tooltip("Added to every animatronic's level after the team offset, capped at levelCap. One sitting the night out (table 0) still does.")]
			[Range(0f, 20f)]
			public int levelBonus;

			[Tooltip("Walk and run speed.")]
			[Range(0.5f, 2f)]
			public float speedMultiplier = 1f;

			[Tooltip("Warning window at an open door. Below 1 = less time to shut it.")]
			[Range(0.25f, 2f)]
			public float doorWarningMultiplier = 1f;

			[Tooltip("Quiet between knock bursts at a closed door. Below 1 = quicker knocking (the visit still ends).")]
			[Range(0.25f, 2f)]
			public float bangIntervalMultiplier = 1f;

			[Tooltip("Office cooldown after a bored retreat. Below 1 = it comes back sooner.")]
			[Range(0.1f, 2f)]
			public float officeCooldownMultiplier = 1f;

			[Tooltip("Time for Endo's cove meter to fill. Below 1 = it breaks out sooner.")]
			[Range(0.25f, 2f)]
			public float coveFillMultiplier = 1f;

			[Tooltip("Time to spot a guard in view. Below 1 = spotted sooner.")]
			[Range(0.25f, 2f)]
			public float spotTimeMultiplier = 1f;

			[Tooltip("Hearing radius.")]
			[Range(0.5f, 2f)]
			public float hearingMultiplier = 1f;

			[Tooltip("Flashlight time on Endo before it flees. Above 1 = it holds out longer.")]
			[Range(0.5f, 3f)]
			public float endoRepelMultiplier = 1f;

			[Tooltip("Power drain rate: the night's base drain and every usage unit.")]
			[Range(0.5f, 2f)]
			public float powerDrainMultiplier = 1f;

			public static readonly DifficultySettings Neutral = new DifficultySettings();

			public static DifficultySettings Nightmare()
			{
				return new DifficultySettings
				{
					levelBonus = 4,
					speedMultiplier = 1.2f,
					doorWarningMultiplier = 0.75f,
					bangIntervalMultiplier = 0.8f,
					officeCooldownMultiplier = 0.6f,
					coveFillMultiplier = 0.8f,
					spotTimeMultiplier = 0.8f,
					hearingMultiplier = 1.15f,
					endoRepelMultiplier = 1.3f,
					powerDrainMultiplier = 1.15f
				};
			}
		}

		public HubSettings hub = new HubSettings();

		public NightSettings night = new NightSettings();

		public PowerSettings power = new PowerSettings();

		public OfficeSettings office = new OfficeSettings();

		public CameraSettings cameras = new CameraSettings();

		public TaskSettings tasks = new TaskSettings();

		public FlashlightSettings flashlight = new FlashlightSettings();

		public NoiseSettings noise = new NoiseSettings();

		public AiSettings ai = new AiSettings();

		public CatchSettings catches = new CatchSettings();

		public GhostSettings ghost = new GhostSettings();

		public ComfortSettings comfort = new ComfortSettings();

		[Tooltip("What a Nightmare night changes. Default nights run none of it. Only the night master's copy counts.")]
		public DifficultySettings nightmare = DifficultySettings.Nightmare();

		public DifficultySettings For(FnDifficulty difficulty)
		{
			if (difficulty == FnDifficulty.Nightmare && nightmare != null)
			{
				return nightmare;
			}
			return DifficultySettings.Neutral;
		}
	}
}
