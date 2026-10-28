using UnityEngine;

namespace LethalApeR.Rendering
{
	public static class MirrorLayer
	{
		public const string Name = "MIRROR";

		public static int Index => LayerMask.NameToLayer(Name);

		public static int Mask
		{
			get
			{
				int index = Index;
				if (index >= 0)
				{
					return 1 << index;
				}
				return 0;
			}
		}
	}
}
