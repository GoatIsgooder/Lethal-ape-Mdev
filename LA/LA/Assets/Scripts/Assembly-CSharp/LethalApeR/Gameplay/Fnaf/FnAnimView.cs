using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnAnimView
	{
		private static readonly FnAnimPose[] Poses = new FnAnimPose[4];

		private static readonly Transform[] Roots = new Transform[4];

		public static int Count => 4;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			for (int i = 0; i < Poses.Length; i++)
			{
				Poses[i] = default(FnAnimPose);
				Roots[i] = null;
			}
		}

		public static FnAnimPose Get(FnAnim anim)
		{
			return Poses[(int)anim];
		}

		public static FnAnimPose Get(int index)
		{
			return Poses[index];
		}

		public static Transform Root(FnAnim anim)
		{
			return Roots[(int)anim];
		}

		public static void Set(FnAnim anim, in FnAnimPose pose)
		{
			Poses[(int)anim] = pose;
		}

		public static void SetRoot(FnAnim anim, Transform root)
		{
			Roots[(int)anim] = root;
		}

		public static void Clear(FnAnim anim)
		{
			Poses[(int)anim] = default(FnAnimPose);
			Roots[(int)anim] = null;
		}

		public static float FastestInView(Camera cam, float range)
		{
			if (cam == null)
			{
				return 0f;
			}
			Vector3 position = cam.transform.position;
			float num = range * range;
			float num2 = 0f;
			for (int i = 0; i < Poses.Length; i++)
			{
				if (!Poses[i].Active || Poses[i].Speed <= 0.01f || (Poses[i].Position - position).sqrMagnitude > num)
				{
					continue;
				}
				Vector3 vector = cam.WorldToViewportPoint(Poses[i].Position + Vector3.up * 1.2f);
				if (vector.z > 0f && vector.x >= -0.1f && vector.x <= 1.1f && vector.y >= -0.1f && vector.y <= 1.1f && Poses[i].Speed > num2)
				{
					num2 = Poses[i].Speed;
				}
			}
			return num2;
		}
	}
}
