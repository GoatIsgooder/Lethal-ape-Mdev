using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[CreateAssetMenu(menuName = "Slop/BTM/Tech Tree Item", fileName = "BtmItem")]
	public class BtmItemDefinition : ScriptableObject
	{
		[Tooltip("Save key. Never change it once shipped, or players lose the unlock.")]
		public string id;

		public string displayName;

		[TextArea(2, 4)]
		public string description;

		[Header("Placement")]
		public BtmBranch branch;

		[Tooltip("Which loadout this item belongs to (for slot unlocks: which loadout gains the slot).")]
		public BtmRole role;

		public BtmItemKind kind;

		public BtmItemDefinition[] prerequisites;

		[Header("Economy")]
		[Min(0f)]
		public int cost = 100;

		[Header("Effect")]
		public BtmEffect effect;

		[Tooltip("Seconds the effect lasts once used.")]
		[Min(0f)]
		public float duration = 12f;

		[Tooltip("Effect strength. Multipliers for speed/reach/crank, gravity fraction for Featherfall, reveal interval for Bloodhound, speed multiplier for Roar.")]
		public float magnitude = 1f;

		[Min(1f)]
		public int chargesPerRound = 1;

		[Header("Look")]
		public Color tint = Color.white;

		[Tooltip("The object stocked into the chest orb and used mid-round.")]
		public GameObject heldPrefab;

		public bool IsEquipable => kind != BtmItemKind.SlotUnlock;

		public string DurationLabel
		{
			get
			{
				if (!(duration > 0f))
				{
					return "";
				}
				return string.Format("{0:0}s", duration);
			}
		}
	}
}
