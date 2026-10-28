namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnStrings
	{
		public const string Solo = "SOLO";

		public const string Duo = "DUO";

		public const string Trio = "TRIO";

		public const string PadEmptySlot = "- open -";

		public const string TerminalHeader = "MONKE LABS  NIGHT SHIFT";

		public const string SoloShift = "SOLO SHIFT";

		public const string DuoShift = "DUO SHIFT";

		public const string TrioShift = "TRIO SHIFT";

		public const string PadStepUp = "STEP UP TO CLOCK IN";

		public const string Ready = "CLOCKED IN";

		public const string NotReady = "PUNCH IN";

		public const string CctvBrand = "MONKE LABS  SECURITY";

		public const string KeyPunch = "PUNCH";

		public const string KeyMode = "MODE";

		public const string KeyNight = "NIGHT";

		public const string PadWaitingFormat = "WAITING {0}/{1}";

		public const string PadReadyFormat = "READY {0}/{1}";

		public const string PadStartingFormat = "STARTING {0}";

		public const string PadLeaving = "HEADING IN...";

		public const string NightSelectorFormat = "< NIGHT {0} >";

		public const string DifficultyDefault = "DEFAULT";

		public const string DifficultyNightmare = "NIGHTMARE";

		public const string NightmareLocked = "NIGHTMARE LOCKED";

		public const string NightmareRequirementFormat = "NIGHTMARE: SURVIVE NIGHT {0}";

		public const string NeedPlayersFormat = "{0} - NEED {1}";

		public const string NeedPlayersNightmareFormat = "{0} NIGHTMARE - NEED {1}";

		public const string BoardTitle = "SHIFTS OPEN";

		public const string BoardAllFull = "ALL SHIFTS CREWED";

		public const string BoardIdle = "STEP ON A PAD TO CLOCK IN";

		public const string ExitLabel = "EXIT";

		public const string BadgeLA = "LA";

		public const string BadgeLAR = "LAR";

		public const string PadFull = "SHIFT FULL";

		public const string PadLocked = "SHIFT STARTING";

		public const string NightLocked = "NIGHT LOCKED";

		public const string PartyTitle = "PARTY CODE";

		public const string PartyNew = "NEW";

		public const string PartyJoin = "JOIN";

		public const string PartyLeave = "PUBLIC";

		public const string PartyClear = "CLR";

		public const string PartyInFormat = "PARTY {0}";

		public const string PartyPublic = "PUBLIC HUB";

		public const string PartyEnterCode = "ENTER 5 DIGITS";

		public const string PartyJoining = "JOINING...";

		public const string NightTitleFormat = "NIGHT {0}";

		public const string NightmareTitleFormat = "NIGHTMARE {0}";

		public const string TwelveAm = "12 AM";

		public const string HourFormat = "{0} AM";

		public const string SixAm = "6 AM";

		public const string PowerFormat = "POWER {0}%";

		public const string UsageLabel = "USAGE";

		public const string PowerOut = "POWER OUT";

		public const string GatheringFormat = "WAITING FOR CREW {0}/{1}";

		public const string Briefing = "STAY IN THE OFFICE. KEEP THE POWER UP. SURVIVE UNTIL 6 AM.";

		public const string CalibratingMic = "CALIBRATING MIC - STAY QUIET";

		public const string Door = "DOOR";

		public const string Light = "LIGHT";

		public const string West = "WEST";

		public const string East = "EAST";

		public const string Jammed = "JAMMED";

		public const string NoSignal = "NO SIGNAL";

		public const string AudioOnly = "AUDIO ONLY";

		public const string CameraOffline = "CAMERA OFFLINE";

		public const string Lure = "LURE";

		public const string LureCooldownFormat = "LURE {0}s";

		public const string LureFailed = "LURE FAILED";

		public const string BreakerTitle = "BREAKER ORDER";

		public const string BreakerUsesFormat = "RESETS LEFT {0}";

		public const string ChargerTitle = "CHARGER";

		public const string BatteryHeld = "BATTERY";

		public const string BatteryNone = "-";

		public const string FlashlightLabel = "LIGHT";

		public const string NoiseLabel = "NOISE";

		public const string RejectNoPower = "NO POWER";

		public const string RejectJammed = "JAMMED";

		public const string RejectCooldown = "WAIT";

		public const string RejectNotInOffice = "FROM INSIDE ONLY";

		public const string RejectTooFar = "TOO FAR";

		public const string RejectBlackout = "POWER OUT";

		public const string RejectScrambled = "SIGNAL LOST";

		public const string RejectUnavailable = "UNAVAILABLE";

		public const string RejectWrongPhase = "NOT NOW";

		public const string GhostTitle = "YOU WERE CAUGHT";

		public const string GhostOffice = "OFFICE";

		public const string GhostNextRoom = "NEXT ROOM";

		public const string GhostFollow = "FOLLOW";

		public const string GhostFollowingFormat = "FOLLOWING {0}";

		public const string ResultsSurvived = "YOU SURVIVED";

		public const string ResultsLost = "THE SHIFT IS OVER";

		public const string ResultsNightFormat = "NIGHT {0}";

		public const string ResultsNightmareFormat = "NIGHTMARE {0}";

		public const string ResultsSurvivor = "SURVIVED";

		public const string ResultsCaught = "CAUGHT";

		public const string ResultsLeft = "LEFT";

		public const string ResultsAbsent = "NO SHOW";

		public const string ResultsPowerFormat = "POWER LEFT {0}%";

		public const string ResultsBatteriesFormat = "BATTERIES {0}";

		public const string ResultsTimeFormat = "{0}:{1:00}";

		public const string ResultsUnlockFormat = "NIGHT {0} UNLOCKED";

		public const string ResultsNightmareUnlockFormat = "NIGHTMARE {0} UNLOCKED";

		public const string ResultsNightmareUnlocked = "NIGHTMARE UNLOCKED";

		public const string ReturningToHub = "RETURNING TO THE PIZZERIA...";

		public const string CaptionBangWest = "[BANGING - WEST DOOR]";

		public const string CaptionBangEast = "[BANGING - EAST DOOR]";

		public const string CaptionFootsteps = "[FOOTSTEPS]";

		public const string CaptionMusicBox = "[MUSIC BOX]";

		public const string CaptionLaugh = "[LAUGHTER]";

		public const string CaptionClatter = "[KITCHEN CLATTER]";

		public const string PortalLabel = "FIVE NIGHTS";

		public const string ExitCaption = "BACK TO LOBBY";

		public static string AnimName(FnAnim anim)
		{
			return anim switch
			{
				FnAnim.Bear => "SANDMAN",
				FnAnim.Bunny => "GUS",
				FnAnim.Chicken => "ASH",
				_ => "ENDO",
			};
		}

		public static string SizeName(int padSize)
		{
			if (padSize <= 2)
			{
				if (padSize != 2)
				{
					return "SOLO";
				}
				return "DUO";
			}
			return "TRIO";
		}

		public static string PadTitle(int padSize)
		{
			if (padSize <= 2)
			{
				if (padSize != 2)
				{
					return "SOLO SHIFT";
				}
				return "DUO SHIFT";
			}
			return "TRIO SHIFT";
		}

		public static string NightTitle(int night, FnDifficulty difficulty)
		{
			return string.Format((difficulty == FnDifficulty.Nightmare) ? "NIGHTMARE {0}" : "NIGHT {0}", night);
		}

		public static string Hour(int hour)
		{
			if (hour < 1)
			{
				return "12 AM";
			}
			if (hour >= 6)
			{
				return "6 AM";
			}
			return string.Format("{0} AM", hour);
		}

		public static string Reject(FnReject reason)
		{
			return reason switch
			{
				FnReject.NoPower => "NO POWER",
				FnReject.Jammed => "JAMMED",
				FnReject.Cooldown => "WAIT",
				FnReject.NotInOffice => "FROM INSIDE ONLY",
				FnReject.TooFar => "TOO FAR",
				FnReject.WrongPhase => "NOT NOW",
				FnReject.Scrambled => "SIGNAL LOST",
				FnReject.Full => "SHIFT FULL",
				FnReject.Locked => "SHIFT STARTING",
				FnReject.NightLocked => "NIGHT LOCKED",
				FnReject.Blackout => "POWER OUT",
				FnReject.DifficultyLocked => "NIGHTMARE LOCKED",
				_ => "UNAVAILABLE",
			};
		}
	}
}
