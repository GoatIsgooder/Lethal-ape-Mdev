using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class ScrapSpawnPoint : MonoBehaviour
	{
		public enum Archetype
		{
			ScrapBits = 0,
			ItemStack = 1
		}

		[Tooltip("What the populate tool drops here. Purely a build-time hint.")]
		public Archetype archetype;

		[Tooltip("The pre-placed pickups parented under this point. Auto-filled from children if left empty.")]
		[SerializeField]
		private ScrapPickup[] pickups;

		public int Index { get; private set; } = -1;

		public ScrapPickup[] Pickups
		{
			get
			{
				if (pickups == null || pickups.Length == 0)
				{
					pickups = GetComponentsInChildren<ScrapPickup>(true);
				}
				return pickups;
			}
		}

		public void SetIndex(int index)
		{
			Index = index;
		}
	}
}
