using LethalApeR;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApe.Assets.Scripts
{
	public class ComputerButton : BaseButton
	{
		public Color colorSwitch;

		public override void OnButtonPressed(bool isLeft)
		{
			Computer instance = Computer.Instance;
			if (!(instance == null))
			{
				string key = base.gameObject.name.ToUpper();
				if (!TryHandleCommand(instance, key))
				{
					instance.HandleInput(key);
				}
				instance.UpdateUI();
				instance.RenderCamera();
			}
		}

		private static bool TryHandleCommand(Computer terminal, string key)
		{
			if (key == "NAME")
			{
				terminal.SwitchTab("name");
				return true;
			}
			if (key == "ROOM")
			{
				terminal.SwitchTab("room");
				return true;
			}
			if (key == "COLOR")
			{
				terminal.SwitchTab("color");
				return true;
			}
			if (key == "SETTINGS")
			{
				terminal.SwitchTab("settings");
				return true;
			}
			if (key == "JOINPUBLIC")
			{
				MonkeDevNetworkingManager.JoinRandomRoom(MonkeDevNetworkingManager.Manager.DefaultQueue);
				terminal.UpdateUI();
				return true;
			}
			if (key == "LEAVEROOM")
			{
				if (PhotonNetwork.InRoom)
				{
					PhotonNetwork.LeaveRoom();
				}
				return true;
			}
			return false;
		}
	}
}
