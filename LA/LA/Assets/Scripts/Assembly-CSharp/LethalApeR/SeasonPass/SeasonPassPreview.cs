using UnityEngine;

namespace LethalApeR.SeasonPass
{
	public static class SeasonPassPreview
	{
		public const string DataKey = "SeasonPassPreview";

		private static bool _flag;

		private const bool DevSimulate = false;

		internal static void Apply(bool flag)
		{
			_flag = flag;
			SeasonPassService.Instance?.SetPreviewAccess(flag);
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_flag = false;
		}
	}
}
