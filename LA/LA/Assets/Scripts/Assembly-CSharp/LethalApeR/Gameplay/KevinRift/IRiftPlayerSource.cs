using System.Collections.Generic;

namespace LethalApeR.Gameplay.KevinRift
{
	public interface IRiftPlayerSource
	{
		void Collect(List<RiftAvatar> into);
	}
}
