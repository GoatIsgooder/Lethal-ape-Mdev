using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingColourChanger : MonoBehaviour
	{
		public Color Colour;

		public void ChangeColour(Color Colour)
		{
			MonkeDevNetworkingManager.SetColour(Colour);
		}
	}
}
