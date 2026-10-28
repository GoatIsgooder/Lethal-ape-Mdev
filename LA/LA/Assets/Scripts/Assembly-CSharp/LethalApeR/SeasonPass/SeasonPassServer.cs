using System;
using System.Collections.Generic;
using LethalApeR.PlayFab;
using Newtonsoft.Json.Linq;
using QauthSdk;
using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassServer
	{
		[Serializable]
		private class StoredState
		{
			public int[] claimed;

			public int xp;

			public bool premium;

			public int[] owed;

			public DailyRecord[] daily;

			public string[] challenges;
		}

		[Serializable]
		private class DailyRecord
		{
			public int day;

			public string[] ids;
		}

		public const string Function = "ClaimSeasonReward";

		public const string QuestFunction = "ClaimSeasonQuest";

		public const string PremiumKey = "SeasonPassPremium";

		private static bool _syncing;

		public static bool Busy { get; private set; }

		public static int ClaimingLevel { get; private set; }

		public static string ClaimingQuest { get; private set; }

		public static bool DevSimulateClaims => false;

		public static event Action StateChanged;

		public static string StateKey(string seasonId)
		{
			return "SeasonPass_" + seasonId;
		}

		public static async void Sync()
		{
			SeasonPassService service = SeasonPassService.Instance;
			if (service == null || _syncing || !Qauth.IsLoggedIn)
			{
				return;
			}
			_syncing = true;
			string key = StateKey(service.Season.seasonId);
			Dictionary<string, QauthSave> data;
			try
			{
				data = await Qauth.Saves.PullAsync();
			}
			catch (Exception ex)
			{
				_syncing = false;
				Debug.LogWarning("[SeasonPass] Server state read failed: " + ex.Message);
				return;
			}
			_syncing = false;
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null)
			{
				return;
			}
			StoredState storedState = Parse(Value(data, key));
			instance.ApplyServerState(storedState.claimed, storedState.xp, storedState.premium || IsTrue(Value(data, "SeasonPassPremium")));
			string[] daily = null;
			if (storedState.daily != null)
			{
				for (int i = 0; i < storedState.daily.Length; i++)
				{
					DailyRecord dailyRecord = storedState.daily[i];
					if (dailyRecord != null && dailyRecord.day == instance.DayNumber)
					{
						daily = dailyRecord.ids;
					}
				}
			}
			instance.ApplyServerQuests(instance.DayNumber, daily, storedState.challenges);
			SeasonPassPreview.Apply(IsTrue(Value(data, "SeasonPassPreview")));
			if (storedState.owed != null && storedState.owed.Length != 0)
			{
				Claim(0, null);
			}
		}

		public static void Claim(int level, Action<bool, string> done)
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null)
			{
				done?.Invoke(arg1: false, "Season data is missing.");
				return;
			}
			if (Busy)
			{
				done?.Invoke(arg1: false, "A claim is already going through.");
				return;
			}
			if (!Qauth.IsLoggedIn)
			{
				done?.Invoke(arg1: false, "Can't reach the server right now.");
				return;
			}
			Busy = true;
			ClaimingLevel = level;
			SeasonPassServer.StateChanged?.Invoke();
			Run("ClaimSeasonReward", new Dictionary<string, object>
			{
				{
					"Season",
					instance.Season.seasonId
				},
				{ "Level", level }
			}, delegate(QauthCloudResult result)
			{
				Busy = false;
				ClaimingLevel = 0;
				Handle(level, result, done);
				SeasonPassServer.StateChanged?.Invoke();
			}, delegate(Exception error)
			{
				Busy = false;
				ClaimingLevel = 0;
				Debug.LogWarning("[SeasonPass] ClaimSeasonReward request failed: " + error.Message);
				done?.Invoke(arg1: false, "The claim didn't go through. Try again.");
				SeasonPassServer.StateChanged?.Invoke();
			});
		}

		private static void Handle(int level, QauthCloudResult result, Action<bool, string> done)
		{
			object value;
			if (!result.Ok)
			{
				bool flag = result.Error == "UNKNOWN_FUNCTION";
				Debug.LogError(flag ? "[SeasonPass] ClaimSeasonReward is not on the server's Cloud Script." : ("[SeasonPass] ClaimSeasonReward threw: " + result.Error));
				done?.Invoke(arg1: false, flag ? "Claims aren't switched on yet." : "The claim didn't go through. Try again.");
				return;
			}
			if (!(ToPlain(result.Result) is IDictionary<string, object> dictionary))
			{
				Debug.LogError("[SeasonPass] ClaimSeasonReward returned no payload.");
				done?.Invoke(arg1: false, "The claim didn't go through. Try again.");
				return;
			}
			SeasonPassService instance = SeasonPassService.Instance;
			ApplyReplyState(instance, dictionary);
			if (dictionary.TryGetValue("balance", out value) && value != null)
			{
				LocalProfileManager.Instance?.SeedCurrency(ToInt(value));
			}
			if (GetBool(dictionary, "inventoryChanged") || dictionary.ContainsKey("settled"))
			{
				RefreshInventory();
			}
			bool flag2 = LineupIsStale(level, dictionary);
			if (GetBool(dictionary, "success"))
			{
				if (GetBool(dictionary, "pending"))
				{
					LogServerErrors(result);
				}
				done?.Invoke(arg1: true, GetBool(dictionary, "pending") ? "Claimed. It's on its way and shows up shortly." : null);
				return;
			}
			string text = GetString(dictionary, "error");
			if (text == "not_configured")
			{
				Debug.LogError("[SeasonPass] Title Internal Data " + StateKey((instance != null) ? instance.Season.seasonId : "?") + " is missing or broken. Paste the Dev Panel's server config.");
			}
			else if (text == "item_missing")
			{
				if (!flag2)
				{
					Debug.LogError(string.Format("[SeasonPass] Catalog item '{0}' (level {1}) doesn't exist in catalog Main yet.", GetString(dictionary, "item"), level));
				}
			}
			else
			{
				Debug.LogWarning($"[SeasonPass] Claim of level {level} refused: {text}");
				if (text == "server_error")
				{
					LogServerErrors(result);
				}
			}
			done?.Invoke(arg1: false, Explain(text, level));
		}

		private static void LogServerErrors(QauthCloudResult result)
		{
			if (!(result.Raw?["logs"] is JArray jArray))
			{
				return;
			}
			foreach (JToken item in jArray)
			{
				if (item is JObject jObject && (string)jObject["level"] == "Error")
				{
					Debug.LogError("[SeasonPass] Server: " + (string)jObject["message"]);
				}
			}
		}

		private static bool LineupIsStale(int level, IDictionary<string, object> reply)
		{
			if (level < 1 || !reply.ContainsKey("kind"))
			{
				return false;
			}
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null)
			{
				return false;
			}
			SeasonPassLevel seasonPassLevel = instance.Season.GetLevel(level);
			if (seasonPassLevel == null)
			{
				return false;
			}
			SeasonPassReward reward = seasonPassLevel.reward;
			if (reward == null)
			{
				return false;
			}
			string text = ((reward.kind != SeasonRewardKind.Cosmetic) ? (reward.kind.ToString().ToLowerInvariant() + " " + reward.amount) : reward.itemId);
			string text2 = GetString(reply, "kind");
			string text3 = ((text2 == "cosmetic") ? GetString(reply, "item") : (text2 + " " + GetInt(reply, "amount")));
			if (string.Equals(text, text3, StringComparison.Ordinal))
			{
				return false;
			}
			Debug.LogError(string.Format("[SeasonPass] The server's lineup is out of date: level {0} is '{1}' there but '{2}' in ActiveSeason. ", level, text3, text) + "Dev Panel > Copy Server Config, then paste it over Title Internal Data " + StateKey(instance.Season.seasonId) + ".");
			return true;
		}

		private static string Explain(string error, int level)
		{
			switch (error)
			{
			case "not_configured":
				return "Claims aren't set up on the server yet.";
			case "busy":
				return "The server is busy. Give it a few seconds and try again.";
			case "needs_premium":
				return "This reward needs Premium.";
			case "premium_unknown":
				return "Couldn't check your Premium right now. Try again in a moment.";
			case "not_reached":
				return $"Reach level {level} first.";
			case "item_missing":
				return "This reward isn't in the store yet. Nothing was used up.";
			case "not_live":
				return "Claims open when the season starts.";
			case "coming_soon":
				return "This reward arrives in an update.";
			default:
				return "The claim didn't go through. Try again.";
			}
		}

		public static void ClaimQuest(SeasonQuestDefinition quest, Action<bool, string> done)
		{
			SeasonPassService instance = SeasonPassService.Instance;
			if (instance == null || quest == null)
			{
				done?.Invoke(arg1: false, "Season data is missing.");
				return;
			}
			if (Busy)
			{
				done?.Invoke(arg1: false, "A claim is already going through.");
				return;
			}
			if (!Qauth.IsLoggedIn)
			{
				done?.Invoke(arg1: false, "Can't reach the server right now.");
				return;
			}
			Busy = true;
			ClaimingQuest = quest.questId;
			SeasonPassServer.StateChanged?.Invoke();
			Run("ClaimSeasonQuest", new Dictionary<string, object>
			{
				{
					"Season",
					instance.Season.seasonId
				},
				{ "Quest", quest.questId },
				{ "Day", instance.DayNumber }
			}, delegate(QauthCloudResult result)
			{
				Busy = false;
				ClaimingQuest = null;
				HandleQuest(quest, result, done);
				SeasonPassServer.StateChanged?.Invoke();
			}, delegate(Exception error)
			{
				Busy = false;
				ClaimingQuest = null;
				Debug.LogWarning("[SeasonPass] ClaimSeasonQuest request failed: " + error.Message);
				done?.Invoke(arg1: false, "The claim didn't go through. Try again.");
				SeasonPassServer.StateChanged?.Invoke();
			});
		}

		private static void HandleQuest(SeasonQuestDefinition quest, QauthCloudResult result, Action<bool, string> done)
		{
			if (!result.Ok)
			{
				bool flag = result.Error == "UNKNOWN_FUNCTION";
				Debug.LogError(flag ? "[SeasonPass] ClaimSeasonQuest is not on the server's Cloud Script." : ("[SeasonPass] ClaimSeasonQuest threw: " + result.Error));
				done?.Invoke(arg1: false, flag ? "Quest claims aren't switched on yet." : "The claim didn't go through. Try again.");
				return;
			}
			if (!(ToPlain(result.Result) is IDictionary<string, object> dictionary))
			{
				Debug.LogError("[SeasonPass] ClaimSeasonQuest returned no payload.");
				done?.Invoke(arg1: false, "The claim didn't go through. Try again.");
				return;
			}
			SeasonPassService instance = SeasonPassService.Instance;
			ApplyReplyState(instance, dictionary);
			if (GetBool(dictionary, "success"))
			{
				instance?.MarkQuestClaimed(quest);
				done?.Invoke(arg1: true, null);
				return;
			}
			string text = GetString(dictionary, "error");
			if (text == "not_configured")
			{
				Debug.LogError("[SeasonPass] Title Internal Data " + StateKey((instance != null) ? instance.Season.seasonId : "?") + " has no quests. Paste the Dev Panel's server config.");
			}
			else if (text == "unknown_quest")
			{
				Debug.LogError("[SeasonPass] The server's config doesn't know quest '" + quest.questId + "'. Dev Panel > Copy Server Config, then paste it over Title Internal Data.");
			}
			else if (text == "server_error")
			{
				Debug.LogWarning("[SeasonPass] Claim of quest " + quest.questId + " refused: " + text);
				LogServerErrors(result);
			}
			else
			{
				Debug.LogWarning("[SeasonPass] Claim of quest " + quest.questId + " refused: " + text);
			}
			done?.Invoke(arg1: false, ExplainQuest(text));
		}

		private static string ExplainQuest(string error)
		{
			if (error == "not_live")
			{
				return "Quests count while the season is live.";
			}
			if (error == "not_today")
			{
				return "Today's quests just changed. Check the new ones.";
			}
			if (error == "unknown_quest" || error == "not_configured")
			{
				return "Quest claims aren't set up on the server yet.";
			}
			if (!(error == "busy"))
			{
				return "The claim didn't go through. Try again.";
			}
			return "The server is busy. Give it a few seconds and try again.";
		}

		private static void ApplyReplyState(SeasonPassService service, IDictionary<string, object> reply)
		{
			if (service != null)
			{
				if (reply.ContainsKey("claimed"))
				{
					service.ApplyServerState(GetInts(reply, "claimed"), GetInt(reply, "xp"), GetBool(reply, "premium"));
				}
				if (reply.ContainsKey("challenges"))
				{
					service.ApplyServerQuests(GetInt(reply, "questDay"), GetStrings(reply, "dailyQuests"), GetStrings(reply, "challenges"));
				}
			}
		}

		private static void RefreshInventory()
		{
			LocalProfileManager instance = LocalProfileManager.Instance;
			if (instance == null)
			{
				return;
			}
			instance.FetchInventory(delegate(bool ok)
			{
				if (ok)
				{
					PlayFabManager.Instance?.NotifyInventoryUpdated();
					WardrobeManager.RefreshAll();
				}
			});
		}

		private static async void Run(string function, object args, Action<QauthCloudResult> onResult, Action<Exception> onError)
		{
			QauthCloudResult result;
			try
			{
				result = await Qauth.CloudScript.RunAsync(function, args);
			}
			catch (Exception obj)
			{
				onError?.Invoke(obj);
				return;
			}
			onResult?.Invoke(result);
		}

		private static object ToPlain(JToken token)
		{
			if (token == null)
			{
				return null;
			}
			switch (token.Type)
			{
			case JTokenType.Object:
			{
				Dictionary<string, object> dictionary = new Dictionary<string, object>();
				foreach (JProperty item in ((JObject)token).Properties())
				{
					dictionary[item.Name] = ToPlain(item.Value);
				}
				return dictionary;
			}
			case JTokenType.Array:
			{
				List<object> list = new List<object>();
				foreach (JToken item2 in (JArray)token)
				{
					list.Add(ToPlain(item2));
				}
				return list;
			}
			case JTokenType.Null:
			case JTokenType.Undefined:
				return null;
			default:
				return ((JValue)token).Value;
			}
		}

		private static string Value(Dictionary<string, QauthSave> data, string key)
		{
			if (data == null || !data.TryGetValue(key, out var value) || value == null)
			{
				return null;
			}
			return value.Data;
		}

		private static StoredState Parse(string json)
		{
			if (string.IsNullOrEmpty(json))
			{
				return new StoredState();
			}
			try
			{
				return JsonUtility.FromJson<StoredState>(json) ?? new StoredState();
			}
			catch (Exception ex)
			{
				Debug.LogWarning("[SeasonPass] Server state is unreadable (" + ex.Message + ").");
				return new StoredState();
			}
		}

		private static bool IsTrue(string value)
		{
			if (string.IsNullOrEmpty(value))
			{
				return false;
			}
			string text = value.Trim().Trim('"');
			if (!(text == "1") && !text.Equals("true", StringComparison.OrdinalIgnoreCase))
			{
				return text.Equals("yes", StringComparison.OrdinalIgnoreCase);
			}
			return true;
		}

		private static bool GetBool(IDictionary<string, object> reply, string key)
		{
			if (reply.TryGetValue(key, out var value) && value is bool)
			{
				return (bool)value;
			}
			return false;
		}

		private static string GetString(IDictionary<string, object> reply, string key)
		{
			if (!reply.TryGetValue(key, out var value))
			{
				return null;
			}
			return value as string;
		}

		private static int GetInt(IDictionary<string, object> reply, string key)
		{
			if (!reply.TryGetValue(key, out var value))
			{
				return 0;
			}
			return ToInt(value);
		}

		private static int ToInt(object value)
		{
			try
			{
				return (value != null) ? Convert.ToInt32(value) : 0;
			}
			catch
			{
				return 0;
			}
		}

		private static List<int> GetInts(IDictionary<string, object> reply, string key)
		{
			List<int> list = new List<int>();
			if (reply.TryGetValue(key, out var value) && value is IEnumerable<object> enumerable)
			{
				foreach (object item in enumerable)
				{
					list.Add(ToInt(item));
				}
			}
			return list;
		}

		private static List<string> GetStrings(IDictionary<string, object> reply, string key)
		{
			List<string> list = new List<string>();
			if (reply.TryGetValue(key, out var value) && value is IEnumerable<object> enumerable)
			{
				foreach (object item in enumerable)
				{
					if (item is string item2)
					{
						list.Add(item2);
					}
				}
			}
			return list;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Busy = false;
			ClaimingLevel = 0;
			ClaimingQuest = null;
			SeasonPassServer.StateChanged = null;
			_syncing = false;
		}
	}
}
