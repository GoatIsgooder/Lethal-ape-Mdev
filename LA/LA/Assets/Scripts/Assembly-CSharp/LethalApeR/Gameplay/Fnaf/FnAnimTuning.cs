using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[Serializable]
	public class FnAnimTuning
	{
		public string displayName = "Bunny";

		[Tooltip("The door this animatronic comes to.")]
		public FnDoorSide side;

		[Tooltip("AI level at 12 AM, index 0 = Night 1 (0 = does not move that night).")]
		public int[] nightLevels = new int[6] { 3, 5, 8, 10, 12, 15 };

		[Tooltip("Seconds between movement opportunities (a 1-20 roll against the level).")]
		public float movementInterval = 5f;

		public Vector2 walkSpeed = new Vector2(1.2f, 1.8f);

		public Vector2 runSpeed = new Vector2(3.2f, 4.6f);

		public Vector2 sightRange = new Vector2(9f, 16f);

		[Tooltip("Half-angle of the sight cone (degrees).")]
		public float sightHalfAngle = 55f;

		[Tooltip("Sight range multiplier for a target nobody has lit (no flashlight, no hall light).")]
		[Range(0.1f, 1f)]
		public float darkSightFactor = 0.7f;

		[Tooltip("Hearing radius multiplier.")]
		public float hearing = 1f;

		[Tooltip("Seconds to fill the spot meter with a target at max range.")]
		public float secondsToSpot = 1.4f;

		[Tooltip("Seconds for a full spot meter to drain with nothing in view.")]
		public float secondsToForget = 2.5f;

		[Tooltip("Spot rate multiplier at point blank.")]
		public float closeRangeBoost = 3f;

		[Tooltip("Spot meter must drain below this before a chase can end by losing sight.")]
		[Range(0f, 1f)]
		public float releaseThreshold = 0.35f;

		[Tooltip("A chase ends after this long out of sight (s).")]
		public float loseSightSeconds = 3.5f;

		[Tooltip("A chase ends after this long regardless (s, level 0 / 20).")]
		public Vector2 maxChaseSeconds = new Vector2(14f, 26f);

		[Tooltip("Searching around the last known position (s, random in range).")]
		public Vector2 searchSeconds = new Vector2(5f, 8f);

		[Tooltip("Warning window at an open door before stepping in (s, level 0 / 20).")]
		public Vector2 doorWarningSeconds = new Vector2(4f, 2f);

		[Tooltip("Knock bursts per visit to a closed door (level 0 / 20). Then one last look and it walks away: a closed door always holds.")]
		public Vector2 knockBursts = new Vector2(2f, 4f);

		[Tooltip("Raps in one burst (random in range): knock-knock-knock.")]
		public Vector2 knockRaps = new Vector2(2f, 4f);

		[Tooltip("Quiet between knock bursts, listening at the door (s, random in range).")]
		public Vector2 bangInterval = new Vector2(1.4f, 2.6f);

		[Tooltip("After knocking at the office it won't come back for this long (s, level 0 / 20).")]
		public Vector2 officeCooldown = new Vector2(60f, 20f);

		[Tooltip("Chance a successful movement roll advances on the office instead of a new patrol leg.")]
		[Range(0f, 1f)]
		public float advanceBias = 0.45f;

		[Tooltip("Named graph nodes this animatronic prefers when picking patrol legs (empty = anywhere).")]
		public string[] favouriteNodes = new string[0];

		[Tooltip("Where it starts the night and returns to when repelled.")]
		public string homeNode = "Stage";

		public static FnAnimTuning Bear()
		{
			return new FnAnimTuning
			{
				displayName = "Bear",
				side = FnDoorSide.East,
				nightLevels = new int[6] { 0, 0, 4, 7, 10, 14 },
				movementInterval = 3f,
				walkSpeed = new Vector2(1.1f, 1.6f),
				runSpeed = new Vector2(2.6f, 3.6f),
				sightRange = new Vector2(10f, 16f),
				sightHalfAngle = 50f,
				darkSightFactor = 0.8f,
				hearing = 1f,
				knockBursts = new Vector2(2f, 3f),
				knockRaps = new Vector2(2f, 3f),
				bangInterval = new Vector2(1.8f, 2.8f),
				homeNode = "Stage"
			};
		}

		public static FnAnimTuning Bunny()
		{
			return new FnAnimTuning
			{
				displayName = "Bunny",
				side = FnDoorSide.West,
				nightLevels = new int[6] { 3, 5, 8, 10, 12, 15 },
				movementInterval = 4.97f,
				walkSpeed = new Vector2(1.5f, 2.2f),
				runSpeed = new Vector2(3.6f, 5f),
				sightRange = new Vector2(8f, 14f),
				sightHalfAngle = 55f,
				darkSightFactor = 0.45f,
				hearing = 1.6f,
				knockBursts = new Vector2(2f, 4f),
				knockRaps = new Vector2(3f, 4f),
				bangInterval = new Vector2(1.2f, 2f),
				homeNode = "Stage"
			};
		}

		public static FnAnimTuning Chicken()
		{
			return new FnAnimTuning
			{
				displayName = "Chicken",
				side = FnDoorSide.East,
				nightLevels = new int[6] { 2, 4, 7, 9, 12, 15 },
				movementInterval = 4.98f,
				walkSpeed = new Vector2(0.9f, 1.3f),
				runSpeed = new Vector2(2.8f, 3.8f),
				sightRange = new Vector2(12f, 20f),
				sightHalfAngle = 65f,
				darkSightFactor = 0.85f,
				hearing = 0.9f,
				knockBursts = new Vector2(2f, 4f),
				knockRaps = new Vector2(2f, 3f),
				bangInterval = new Vector2(1.5f, 2.4f),
				favouriteNodes = new string[1] { "Kitchen" },
				homeNode = "Stage"
			};
		}

		public static FnAnimTuning Endo()
		{
			return new FnAnimTuning
			{
				displayName = "Endo",
				side = FnDoorSide.West,
				nightLevels = new int[6] { 0, 0, 0, 6, 9, 13 },
				movementInterval = 5.01f,
				walkSpeed = new Vector2(1.2f, 1.6f),
				runSpeed = new Vector2(5.5f, 7f),
				sightRange = new Vector2(9f, 15f),
				sightHalfAngle = 60f,
				darkSightFactor = 0.9f,
				hearing = 1f,
				knockBursts = new Vector2(1f, 1f),
				knockRaps = new Vector2(3f, 3f),
				homeNode = "Cove"
			};
		}
	}
}
