using System;
using System.Text;
using UnityEngine;

namespace LethalApeR
{
	public class DiscordButton : MonoBehaviour
	{
		public string base64Url;

		[Tooltip("Seconds before the button can open the link again.")]
		[SerializeField]
		[Min(0f)]
		private float cooldown = 3f;

		private float _readyAt;

		private void OnTriggerEnter(Collider other)
		{
			if (!(Time.unscaledTime < _readyAt) && other.CompareTag("HandTag"))
			{
				_readyAt = Time.unscaledTime + cooldown;
				string text = Decode(base64Url);
				if (text != null)
				{
					Application.OpenURL(text);
				}
			}
		}

		private static string Decode(string encoded)
		{
			if (string.IsNullOrEmpty(encoded))
			{
				return null;
			}
			try
			{
				string text = Encoding.UTF8.GetString(Convert.FromBase64String(encoded));
				return (text.Length > 0) ? text : null;
			}
			catch (FormatException)
			{
				Debug.LogError("[DiscordButton] base64Url is not valid base64.");
				return null;
			}
		}
	}
}
