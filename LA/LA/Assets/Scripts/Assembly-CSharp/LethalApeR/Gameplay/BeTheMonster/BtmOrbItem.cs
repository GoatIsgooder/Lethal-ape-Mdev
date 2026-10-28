using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public abstract class BtmOrbItem : MonoBehaviour
	{
		public BtmItemDefinition Item { get; private set; }

		protected BtmItemOrbs Orbs { get; private set; }

		protected int Slot { get; private set; }

		public virtual void Bind(BtmItemDefinition item, BtmItemOrbs orbs, int slot)
		{
			Item = item;
			Orbs = orbs;
			Slot = slot;
			if (item != null)
			{
				BtmVisualCopy.ApplyTint(base.gameObject, item.tint);
			}
		}

		public virtual void OnTakenOut()
		{
		}

		public virtual void OnHolstered()
		{
		}

		public abstract bool OnReleased(Vector3 velocity);

		protected void ReturnToOrb()
		{
			if (Orbs != null)
			{
				Orbs.Holster(Slot);
			}
		}

		protected void Consume()
		{
			if (Orbs != null)
			{
				Orbs.Consume(Slot);
			}
		}
	}
}
