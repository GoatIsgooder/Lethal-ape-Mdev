using System.Collections.Generic;

namespace LethalApeR.Gameplay.Pumpkin
{
	public interface IPumpkinAvatarSource
	{
		void Collect(List<PumpkinAvatar> into);

		bool TryFind(int actor, out PumpkinAvatar avatar);
	}
}
