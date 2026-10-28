namespace LethalApe.SDK
{
	public static class SdkInfo
	{
		public const string DisplayName = "LethalApe SDK";

		public const string PackageName = "com.monkedev.lethalapesdk";

		public const string GameName = "LethalApe";

		public const string GamePackageId = "com.SigmaCatStudios.LethalApe";

		public const string LocalMapsFolder = "CustomMaps";

		public const string Version = "0.1.0";

		public const int ManifestFormat = 1;

		public const string RequiredUnityVersion = "6000.4.2f1";

		public static int Major => ParseMajor(Version);

		public static int ParseMajor(string version)
		{
			if (string.IsNullOrEmpty(version))
			{
				return -1;
			}
			int num = version.IndexOf('.');
			if (num >= 0)
			{
				version = version.Substring(0, num);
			}
			if (!int.TryParse(version, out var result))
			{
				return -1;
			}
			return result;
		}
	}
}
