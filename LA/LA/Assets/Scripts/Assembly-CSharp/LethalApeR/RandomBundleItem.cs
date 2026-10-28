using System;
using System.Reflection;
using UnityEngine;

namespace LethalApeR
{
	[Serializable]
	[Obfuscation(Exclude = true)]
	public class RandomBundleItem
	{
		public string playfabItemId;

		public GameObject cosmeticObject;

		public string displayName;
	}
}
