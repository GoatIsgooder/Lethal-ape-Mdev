using System.Collections.Generic;

namespace LethalApeR.Gameplay.Banshee
{
	public interface IBansheePlayerSource
	{
		void Collect(List<BansheeAvatar> into);
	}
}
