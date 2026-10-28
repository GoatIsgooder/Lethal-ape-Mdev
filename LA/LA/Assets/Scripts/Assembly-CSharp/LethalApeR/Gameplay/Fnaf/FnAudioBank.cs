using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnAudioBank : ScriptableObject
	{
		[Header("Office")]
		public AudioClip[] doorSlam = new AudioClip[0];

		public AudioClip doorOpen;

		public AudioClip lightOn;

		public AudioClip lightOff;

		[Tooltip("Hum of a lit hall light (loop).")]
		public AudioClip lightBuzzLoop;

		[Tooltip("One knuckle rap on a steel door; a knock burst plays several, one per rap.")]
		public AudioClip[] bang = new AudioClip[0];

		[Tooltip("A two-fisted slam on a steel door (Endo, or a high-level animatronic's last burst).")]
		public AudioClip[] bangHeavy = new AudioClip[0];

		[Tooltip("A pressed button that the master refused (jammed, no power, cooldown).")]
		public AudioClip denied;

		public AudioClip jammed;

		public AudioClip buttonPress;

		[Tooltip("The office desk fan's motor hum (loop).")]
		public AudioClip officeFanLoop;

		[Header("Animatronics")]
		[Tooltip("Servo whine while an animatronic moves (loop, distance-gated).")]
		public AudioClip servoLoop;

		public AudioClip[] footsteps = new AudioClip[0];

		[Tooltip("The legless crawlers' plants (Sandman, Ash): hand slaps and body drags. Falls back to footsteps when empty.")]
		public AudioClip[] crawlDrag = new AudioClip[0];

		[Tooltip("Head-snap servo jerk.")]
		public AudioClip[] servoJerk = new AudioClip[0];

		[Tooltip("At an open door during the warning window (loop).")]
		public AudioClip breathingLoop;

		[Tooltip("Bear laughs when he starts moving.")]
		public AudioClip[] bearLaugh = new AudioClip[0];

		[Tooltip("Blackout: Bear at the west door.")]
		public AudioClip musicBox;

		[Tooltip("Chicken's pots and pans; heard on the audio-only kitchen camera.")]
		public AudioClip[] kitchenClatter = new AudioClip[0];

		public AudioClip endoShriek;

		[Tooltip("An animatronic powering down at 6 AM.")]
		public AudioClip powerDown;

		public AudioClip stare;

		[Tooltip("The crouch before a leap at a perched guard: hydraulic pressure building.")]
		public AudioClip jumpCharge;

		[Tooltip("A leap leaving the floor: the pneumatic kick.")]
		public AudioClip[] jumpLaunch = new AudioClip[0];

		[Tooltip("A leap coming down: a heavy metal body hitting the floor.")]
		public AudioClip[] jumpLand = new AudioClip[0];

		[Header("Stings and music")]
		[Tooltip("Local: an animatronic snapped onto you.")]
		public AudioClip spottedSting;

		[Tooltip("Local 2D: the jumpscare.")]
		public AudioClip jumpscareSting;

		[Tooltip("Local: layered in while something chases you or is within ~6 m (loop).")]
		public AudioClip chaseMusicLoop;

		public AudioClip heartbeatLoop;

		public AudioClip nightAmbienceLoop;

		public AudioClip hubAmbienceLoop;

		public AudioClip nightStartSting;

		public AudioClip sixAmChime;

		public AudioClip powerOut;

		[Header("Tasks and tools")]
		public AudioClip breakerPull;

		public AudioClip breakerWrong;

		[Tooltip("Loud: the fuse box coming back on.")]
		public AudioClip breakerClunk;

		public AudioClip batteryPickup;

		public AudioClip batteryDeliver;

		public AudioClip flashlightClick;

		public AudioClip flashlightDead;

		[Tooltip("The kid's laugh played at a camera by the LURE button.")]
		public AudioClip lureLaugh;

		public AudioClip cameraSwitch;

		[Tooltip("CCTV static (loop, while the monitor shows static).")]
		public AudioClip staticLoop;

		[Header("Hub")]
		public AudioClip padTick;

		public AudioClip padGo;

		public AudioClip padReject;

		public AudioClip keypadBeep;

		public AudioClip keypadError;

		[Header("Specimen tubes")]
		[Tooltip("A crack running through a tube's glass as its occupant wakes (one per stage of the crack).")]
		public AudioClip[] tubeCrack = new AudioClip[0];

		[Tooltip("The tube bursting. Heard across the building: it tells everyone that one is loose.")]
		public AudioClip[] tubeShatter = new AudioClip[0];

		[Tooltip("The tank's fluid hitting the floor.")]
		public AudioClip tubeSplash;

		[Header("Ghost")]
		public AudioClip ghostRise;

		[Tooltip("Faint whispers for ghosts' own ambience (loop).")]
		public AudioClip ghostAmbienceLoop;

		public static AudioClip Pick(AudioClip[] clips)
		{
			if (clips == null || clips.Length == 0)
			{
				return null;
			}
			AudioClip audioClip = clips[Random.Range(0, clips.Length)];
			if (audioClip != null)
			{
				return audioClip;
			}
			return clips[0];
		}
	}
}
