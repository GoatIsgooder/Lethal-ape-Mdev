using System.Reflection;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class OpenURLFromBaseEvent : MonoBehaviour
	{
		public void OpenUrl(string url)
		{
			if (!string.IsNullOrWhiteSpace(url))
			{
				Application.OpenURL(url.Trim());
			}
		}
	}
}
