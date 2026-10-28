using UnityEngine;

namespace LethalApeR.Social.UI
{
	public interface IFingerReceiver
	{
		void FingerEnter(Collider finger, bool leftHand);

		void FingerExit(Collider finger);
	}
}
