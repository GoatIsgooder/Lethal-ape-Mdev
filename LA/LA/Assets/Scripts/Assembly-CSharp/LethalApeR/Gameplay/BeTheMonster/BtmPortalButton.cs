using System.Reflection;
using LethalApeR.SceneFlow;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmPortalButton : BaseButton
	{
		[SerializeField]
		private string sceneName = "BeTheMonster";

		public override void OnButtonPressed(bool isLeft)
		{
			if (!SceneTransition.IsBusy)
			{
				Debug.Log(string.Format("[BtmPortalButton] Pressed — leaving room (InRoom={0}) and loading '{1}'", PhotonNetwork.InRoom, sceneName));
				SceneTransition.Go(sceneName, new SceneTransition.Options
				{
					fadeOut = 0.35f,
					fadeIn = 0.5f,
					leaveRoom = true
				});
			}
		}
	}
}
