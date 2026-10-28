using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Networking;
using LethalApeR.PlayFab;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApe.Assets.Scripts
{
	public class Computer : MonoBehaviourPunCallbacks
	{
		public static Computer Instance;

		public Camera renderCam;

		public TMP_Text title;

		public TMP_Text value;

		public string currentTab = "name";

		public string currentName = "";

		public string currentRoom = "";

		public string newName = "";

		public string newRoom = "";

		public TMP_Text errorObj;

		private const string NameTab = "name";

		private const string RoomTab = "room";

		private const int MaxNameLength = 12;

		private static readonly HashSet<string> BannedTerms = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
		{
			"nigger", "nigga", "nigg", "nig", "n1gger", "n1gga", "niqqa", "niqqer", "n!gger", "n1gg3r",
			"n1qq4", "nggr", "negr", "negro", "n3gr0", "niqger", "nigr", "n1g", "nigar", "niger",
			"niggor", "n199er", "n199a", "sand nigger", "n i g g e r", "n i g g a", "faggot", "fag", "f4ggot", "f@ggot",
			"faqqot", "f4g", "f@g", "fgt", "f4gg0t", "fagget", "fagg0t", "phag", "phaget", "fagit",
			"faqq0t", "faag", "faaggot", "f a g g o t", "f a g", "dyke", "dike", "d1ke", "dykes", "queer",
			"qu33r", "tranny", "trannies", "tr4nny", "shemale", "heshe", "cunt", "c0nt", "kunt", "cvnt",
			"cnt", "cunnt", "bitch", "b1tch", "biatch", "hoe", "ho3", "h0e", "whore", "wh0re",
			"slut", "sl00t", "thot", "retard", "retarded", "r3tard", "r3t4rd", "tard", "t4rd", "retrd",
			"ritard", "mongoloid", "spaz", "spastic", "autist", "autismo", "pedo", "pedophile", "paedo", "pedoph1le",
			"p3do", "pedofile", "kiddie", "kidd1e", "childfucker", "childf***er", "childlover", "childrapist", "childmolest", "loli",
			"lolicon", "l0li", "l0l1", "shota", "shotacon", "sh0ta", "cp", "childporn", "kiddieporn", "jailbait",
			"preteen", "cheese pizza", "nazi", "n4zi", "naz1", "hitler", "h1tler", "fuhrer", "fuehrer", "kkk",
			"klan", "confederate", "swastika", "1488", "heil", "kys", "kms", "suicide", "killyourself", "killmyself",
			"k1ll", "hang yourself", "k1ll yourself", "chink", "ch1nk", "gook", "g00k", "spic", "sp1c", "beaner",
			"wetback", "towelhead", "raghead", "terrorist", "jihad", "cracker", "whitey", "honkey", "honky", "h0nky",
			"kike", "k1ke", "jew", "j3w", "hymie", "rape", "r4pe", "raping", "rapist", "molest",
			"m0lest", "cock", "c0ck", "dick", "d1ck", "pussy", "puss", "pu55y", "penis", "vagina",
			"clit", "fuck", "fuk", "f**k", "fck", "f4ck", "fuuck", "phuck", "phuq", "shit",
			"sh1t", "sht", "shyt", "crap", "piss", "p1ss", "ass", "a55", "arse", "asshole",
			"a55hole", "arsehole", "cocaine", "heroin", "meth", "fentanyl", "weed", "marijuana", "crack"
		};

		private void Awake()
		{
			Instance = this;
		}

		private void Start()
		{
			Refresh();
		}

		public override void OnJoinedRoom()
		{
			currentRoom = MonkeDevNetworkingManager.SalvageDisplayCode(PhotonNetwork.CurrentRoom.Name);
			Refresh();
		}

		public override void OnLeftRoom()
		{
			currentRoom = "none";
			Refresh();
		}

		public void HandleInput(string input)
		{
			if (input.Length == 1)
			{
				string key = input.ToUpper();
				if (IsSingleAsciiAlnum(key))
				{
					AppendToActiveField(key);
				}
			}
			else if (input.Length >= 2)
			{
				string command = input.ToUpper();
				if (command == "ENTER")
				{
					if (!Submit())
					{
						return;
					}
				}
				else
				{
					if (!(command == "BACKSPACE"))
					{
						return;
					}
					EraseFromActiveField();
				}
			}
			Refresh();
		}

		public void UpdateUI()
		{
			if (currentTab == "name")
			{
				title.text = "NAME";
				value.text = "<size=15>Current Name: " + currentName + "\n<size=10>Your current name that's being shown. \n<size=15>New name: " + newName + "\n<size=10>Click enter to apply the new name.";
			}
			else if (currentTab == "room")
			{
				title.text = "ROOM";
				value.text = "<size=15>Current Room: " + currentRoom + "\n<size=10>The room name you're in. \n<size=15>Joining room: " + newRoom + "\n<size=10>Room to join (private room)";
			}
		}

		public void SwitchTab(string newTab)
		{
			currentTab = newTab;
		}

		public void RenderCamera()
		{
			if ((bool)renderCam)
			{
				renderCam.Render();
			}
		}

		[ContextMenu("testError")]
		public void testEror()
		{
			StartCoroutine(ShowErrorMsg("ERROR: Username is not available!"));
		}

		public IEnumerator ShowErrorMsg(string msg, float duration = 2.5f)
		{
			ShowError(true, msg);
			RenderCamera();
			yield return new WaitForSeconds(duration);
			ShowError(false, null);
			UpdateUI();
			RenderCamera();
		}

		private void ShowError(bool visible, string msg)
		{
			errorObj.gameObject.SetActive(visible);
			if (visible)
			{
				errorObj.text = msg;
			}
			title.gameObject.SetActive(!visible);
			value.gameObject.SetActive(!visible);
		}

		private void Refresh()
		{
			UpdateUI();
			RenderCamera();
		}

		private bool Submit()
		{
			if (currentTab == "name")
			{
				if (string.IsNullOrEmpty(newName))
				{
					return true;
				}
				return CommitName();
			}
			if (currentTab == "room")
			{
				if (!string.IsNullOrEmpty(newRoom))
				{
					MonkeDevNetworkingManager._JoinPrivateRoom(newRoom, MonkeDevNetworkingManager.Manager.DefaultRoomLimit);
				}
				else
				{
					MonkeDevNetworkingManager.JoinRandomRoom(MonkeDevNetworkingManager.Manager.DefaultQueue);
				}
			}
			return true;
		}

		private bool CommitName()
		{
			string text = Filter(newName, true);
			if (text.Length > MaxNameLength)
			{
				text = text.Substring(0, MaxNameLength);
			}
			if (text.Length == 0)
			{
				return true;
			}
			if (IsOffensive(text))
			{
				string text2 = "VileApe" + UnityEngine.Random.Range(1000, 9999);
				currentName = text2;
				newName = "";
				ApplyUsername(text2);
				StartCoroutine(ShowErrorMsg("ERROR: Inappropriate name detected! You are now " + text2));
				UpdateUI();
				RenderCamera();
				return false;
			}
			currentName = text;
			ApplyUsername(text);
			return true;
		}

		private void ApplyUsername(string displayName)
		{
			MonkeDevNetworkingManager.SetUsername(displayName);
			if (LocalProfileManager.Instance == null)
			{
				Debug.LogError("LocalProfileManager not available — account name not synced");
				StartCoroutine(ShowErrorMsg("ERROR: Failed to update username!"));
				return;
			}
			LocalProfileManager.Instance.SetDisplayName(displayName);
			Debug.Log("Display name updated successfully: " + displayName);
		}

		private void AppendToActiveField(string key)
		{
			if (currentTab == "name")
			{
				newName += key;
			}
			else if (currentTab == "room")
			{
				newRoom += key;
			}
		}

		private void EraseFromActiveField()
		{
			if (currentTab == "name" && newName.Length > 0)
			{
				newName = newName.Remove(newName.Length - 1);
			}
			else if (currentTab == "room" && newRoom.Length > 0)
			{
				newRoom = newRoom.Remove(newRoom.Length - 1);
			}
		}

		private static bool IsOffensive(string text)
		{
			if (string.IsNullOrEmpty(text))
			{
				return false;
			}
			string text2 = text.ToLower();
			string text3 = Filter(text, false).ToLower();
			string text4 = Filter(DecodeLeet(text2), false);
			string text5 = Filter(text2, false);
			foreach (string bannedTerm in BannedTerms)
			{
				if (text3.IndexOf(bannedTerm, StringComparison.Ordinal) >= 0 || text4.IndexOf(bannedTerm, StringComparison.Ordinal) >= 0 || text5.IndexOf(bannedTerm, StringComparison.Ordinal) >= 0)
				{
					return true;
				}
			}
			return false;
		}

		private static string DecodeLeet(string text)
		{
			char[] array = text.ToCharArray();
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = array[i] switch
				{
					'0' => 'o',
					'1' => 'i',
					'3' => 'e',
					'4' => 'a',
					'5' => 's',
					'7' => 't',
					'8' => 'b',
					'9' => 'g',
					'@' => 'a',
					'$' => 's',
					'!' => 'i',
					_ => array[i],
				};
			}
			return new string(array);
		}

		private static bool IsAsciiLetter(char c)
		{
			if (c < 'a' || c > 'z')
			{
				if (c >= 'A')
				{
					return c <= 'Z';
				}
				return false;
			}
			return true;
		}

		private static bool IsAsciiAlnum(char c)
		{
			if (c < '0' || c > '9')
			{
				return IsAsciiLetter(c);
			}
			return true;
		}

		private static bool IsSingleAsciiAlnum(string s)
		{
			if (s != null && s.Length == 1)
			{
				return IsAsciiAlnum(s[0]);
			}
			return false;
		}

		private static string Filter(string text, bool allowDigits)
		{
			if (string.IsNullOrEmpty(text))
			{
				return "";
			}
			char[] array = new char[text.Length];
			int length = 0;
			for (int i = 0; i < text.Length; i++)
			{
				char c = text[i];
				if (allowDigits ? IsAsciiAlnum(c) : IsAsciiLetter(c))
				{
					array[length++] = c;
				}
			}
			return new string(array, 0, length);
		}
	}
}
