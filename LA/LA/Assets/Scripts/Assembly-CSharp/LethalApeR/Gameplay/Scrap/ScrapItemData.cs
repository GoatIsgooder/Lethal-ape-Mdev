using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	[CreateAssetMenu(fileName = "Scrap_", menuName = "Slop/Scrap/Scrap Item")]
	public class ScrapItemData : ScriptableObject
	{
		[Tooltip("Shown on the grinder payout / shop. Display only.")]
		public string displayName = "Scrap";

		[Tooltip("Base sell value before any scaling.")]
		[Min(1f)]
		public int baseValue = 5;

		[Header("Per-pickup variation")]
		[Tooltip("When on, each placed copy rolls a value within the scale range below (deterministic per lobby) so some sell higher and some lower.")]
		public bool canScale;

		[Tooltip("Multiplier range applied to baseValue when canScale is on. x = cheapest multiplier, y = richest.")]
		public Vector2 scaleRange = new Vector2(0.7f, 1.4f);

		public int RollValue(int seed)
		{
			if (!canScale)
			{
				return Mathf.Max(1, baseValue);
			}
			float num = Mathf.Lerp(scaleRange.x, scaleRange.y, Hash01(seed));
			return Mathf.Max(1, Mathf.RoundToInt(num * (float)baseValue));
		}

		private static float Hash01(int seed)
		{
			uint num = (uint)seed ^ 0xA3C59AC3u;
			num *= 2654435769u;
			num ^= num >> 16;
			num *= 2654435769u;
			num ^= num >> 16;
			num *= 2654435769u;
			return (float)(num & 0xFFFFFF) / 16777216f;
		}
	}
}
