using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	public class KickHammerRPCReciver : MonoBehaviour
	{
		public KickHammer leftKick;

		public KickHammer rightKick;

		[PunRPC]
		public void RPC_SetKickActive(bool isLeftHand, bool setActive)
		{
			if (isLeftHand)
			{
				leftKick.SetKickActive(setActive);
			}
			else
			{
				rightKick.SetKickActive(setActive);
			}
		}
	}
}
