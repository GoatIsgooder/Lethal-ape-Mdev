using System;
using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Serializable]
	[Obfuscation(Exclude = true)]
	public class AgSettings
	{
		[Serializable]
		[Obfuscation(Exclude = true)]
		public class RedLight
		{
			public float greenMin = 2f;

			public float greenMax = 4f;

			public float redSeconds = 5f;

			public float graceSeconds = 0.6f;

			public float moveThreshold = 0.2f;

			public int violationFrames = 3;

			[Header("Watcher")]
			public float wakeSeconds = 1.5f;

			public float catchRadius = 1.1f;

			public float giveUpRadius = 12f;

			public float maxChaseSeconds = 12f;
		}

		[Serializable]
		[Obfuscation(Exclude = true)]
		public class JumpRope
		{
		}

		[Serializable]
		[Obfuscation(Exclude = true)]
		public class Glass
		{
			public int rows = 12;

			public float standSeconds = 1f;

			public float brokenPushDownSpeed = 12f;

			public float overheadHeight = 10f;

			public float standYOffset = 0.05f;
		}

		[Serializable]
		[Obfuscation(Exclude = true)]
		public class HideSeek
		{
			public int generatorsRequired = 3;

			public int playersPerSeeker = 4;

			public float seekerSpawnDelay = 5f;
		}

		[Serializable]
		[Obfuscation(Exclude = true)]
		public class FinalFight
		{
			public float knockbackSpeed = 12f;

			public float maxKnockbackSpeed = 18f;

			public float minHammerSpeed = 2.5f;

			public float hitCooldownSeconds = 0.8f;

			public float flingUpBias = 0.45f;
		}

		public int minPlayers = 2;

		public float lobbyWaitSeconds = 60f;

		public float intermissionSeconds = 60f;

		public float roundSeconds = 120f;

		public float matchEndSeconds = 20f;

		public float resultsHoldSeconds = 5f;

		public float emptyMatchHoldSeconds = 5f;

		public bool skipHideSeek = true;

		public RandomizeSpawnPoint lobbySpawn;

		public RandomizeSpawnPoint restAreaSpawn;

		public RedLight redLight = new RedLight();

		public JumpRope jumpRope = new JumpRope();

		public Glass glass = new Glass();

		public HideSeek hideSeek = new HideSeek();

		public FinalFight finalFight = new FinalFight();
	}
}
