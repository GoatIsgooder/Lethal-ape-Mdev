using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmMimicKills
	{
		public sealed class Victim
		{
			public readonly int ActorId;

			public readonly MonkeDevNetworkingPlayer.AppearanceSnapshot Look;

			public Victim(int actorId, MonkeDevNetworkingPlayer.AppearanceSnapshot look)
			{
				ActorId = actorId;
				Look = look;
			}
		}

		private static readonly string[] StrippedSlots = new string[2] { "NameTag", "MonsterSkin" };

		private static readonly Dictionary<int, Victim> LastKills = new Dictionary<int, Victim>();

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetRegistry()
		{
			LastKills.Clear();
		}

		public static void Record(int monsterActorId, MonkeDevNetworkingPlayer victim)
		{
			if (!(victim == null) && !(victim.photonView == null) && victim.photonView.Owner != null)
			{
				LastKills[monsterActorId] = new Victim(victim.photonView.OwnerActorNr, LookOf(victim));
			}
		}

		public static MonkeDevNetworkingPlayer.AppearanceSnapshot LookOf(MonkeDevNetworkingPlayer player)
		{
			if (player == null)
			{
				return null;
			}
			MonkeDevNetworkingPlayer.AppearanceSnapshot appearanceSnapshot = player.CaptureAppearance();
			Dictionary<string, string> dictionary = new Dictionary<string, string>(appearanceSnapshot.Cosmetics);
			string[] strippedSlots = StrippedSlots;
			foreach (string key in strippedSlots)
			{
				dictionary.Remove(key);
			}
			dictionary["NameTag"] = string.Empty;
			return new MonkeDevNetworkingPlayer.AppearanceSnapshot(appearanceSnapshot.Name, appearanceSnapshot.ColourJson, dictionary);
		}

		public static Victim LastKill(int monsterActorId)
		{
			if (!LastKills.TryGetValue(monsterActorId, out var value))
			{
				return null;
			}
			return value;
		}

		public static int LastKillActor(int monsterActorId)
		{
			if (!LastKills.TryGetValue(monsterActorId, out var value))
			{
				return 0;
			}
			return value.ActorId;
		}

		public static void Clear()
		{
			LastKills.Clear();
		}
	}
}
