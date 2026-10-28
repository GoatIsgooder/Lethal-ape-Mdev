using LethalApeR.Networking;
using UnityEngine;

public class AutoConnect : MonoBehaviour
{
	private void Start()
	{
		MonkeDevNetworkingManager.Connect();
	}
}
