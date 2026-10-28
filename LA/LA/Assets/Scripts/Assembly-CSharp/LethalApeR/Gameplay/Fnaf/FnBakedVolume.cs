using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[Serializable]
	public class FnBakedVolume
	{
		public Vector3 min;

		public Vector3 size = Vector3.one;

		public Texture3D sh0;

		public Texture3D sh1;

		public Texture3D sh2;

		[Tooltip("Power-out bake (night map only).")]
		public Texture3D darkSh0;

		[Tooltip("Power-out bake (night map only).")]
		public Texture3D darkSh1;

		[Tooltip("Power-out bake (night map only).")]
		public Texture3D darkSh2;

		public bool IsBaked
		{
			get
			{
				if (sh0 != null && sh1 != null)
				{
					return sh2 != null;
				}
				return false;
			}
		}

		public bool HasDark
		{
			get
			{
				if (darkSh0 != null && darkSh1 != null)
				{
					return darkSh2 != null;
				}
				return false;
			}
		}
	}
}
