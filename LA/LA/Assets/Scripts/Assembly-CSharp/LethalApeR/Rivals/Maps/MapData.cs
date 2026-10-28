using UnityEngine;

namespace LethalApeR.Rivals.Maps
{
	[CreateAssetMenu(fileName = "MapData", menuName = "LethalApeR/Rivals/Map")]
	public class MapData : ScriptableObject
	{
		[Header("Identity")]
		public string displayName = "New Arena";

		[TextArea]
		public string description;

		public Sprite thumbnail;

		[Header("Loading")]
		[Tooltip("Scene name to load (must be in Build Settings). // TODO: switch to an Addressable key if the project adopts Addressables.")]
		public string sceneName;

		[Header("Suitability")]
		[Min(1f)]
		public int recommendedPlayers = 8;

		[Min(1f)]
		public int minPlayers = 2;

		[Min(1f)]
		public int maxPlayers = 16;

		private void OnValidate()
		{
			if (string.IsNullOrWhiteSpace(sceneName))
			{
				Debug.LogWarning("[MapData] '" + base.name + "' has no sceneName set — it can't be loaded.", this);
			}
			if (string.IsNullOrWhiteSpace(displayName))
			{
				displayName = base.name;
			}
			maxPlayers = Mathf.Max(maxPlayers, minPlayers);
		}
	}
}
