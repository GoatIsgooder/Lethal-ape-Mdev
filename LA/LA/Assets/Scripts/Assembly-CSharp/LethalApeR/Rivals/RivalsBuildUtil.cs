using UnityEngine;

namespace LethalApeR.Rivals
{
	public static class RivalsBuildUtil
	{
		public static void Destroy(Object o)
		{
			if (!(o == null))
			{
				if (Application.isPlaying)
				{
					Object.Destroy(o);
				}
				else
				{
					Object.DestroyImmediate(o);
				}
			}
		}
	}
}
