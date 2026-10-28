using System;
using UnityEngine;

namespace LethalApeR.MonsterIndex
{
	[CreateAssetMenu(menuName = "Slop/Monster Index Data", fileName = "MonsterIndexData")]
	public sealed class MonsterIndexData : ScriptableObject
	{
		public MonsterIndexEntry[] entries = Array.Empty<MonsterIndexEntry>();

		[Header("Baked by the builder")]
		[Tooltip("Every entry's thumbnail in one texture, so the list draws in a single batch.")]
		public Texture2D thumbnails;
	}
}
