using System.Reflection;
using LethalApeR.SceneFlow;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class BackroomsPortalButton : BaseButton
	{
		[SerializeField]
		private string sceneName = "Backrooms";

		public override void OnButtonPressed(bool isLeft)
		{
			if (!SceneTransition.IsBusy)
			{
				Debug.Log(string.Format("[BackroomsPortalButton] Pressed — leaving room (InRoom={0}) and loading '{1}'", PhotonNetwork.InRoom, sceneName));
				SceneTransition.Go(sceneName);
			}
		}
	}
}
