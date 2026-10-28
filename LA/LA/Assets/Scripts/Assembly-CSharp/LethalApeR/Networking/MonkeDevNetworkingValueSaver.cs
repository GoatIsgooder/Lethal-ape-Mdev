using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingValueSaver : MonoBehaviour
	{
		public static void SaveDictionary(string location, Dictionary<string, string> value)
		{
			PlayerPrefs.SetString(location, string.Join(",", value.Keys));
			foreach (KeyValuePair<string, string> item in value)
			{
				PlayerPrefs.SetString(location + item.Key, item.Value.ToString());
			}
		}

		public static Dictionary<string, string> GetDictionary(string location)
		{
			string[] array = PlayerPrefs.GetString(location).Split(',');
			Dictionary<string, string> dictionary = new Dictionary<string, string>(array.Length);
			foreach (string text in array)
			{
				dictionary[text] = PlayerPrefs.GetString(location + text);
			}
			return dictionary;
		}
	}
}
