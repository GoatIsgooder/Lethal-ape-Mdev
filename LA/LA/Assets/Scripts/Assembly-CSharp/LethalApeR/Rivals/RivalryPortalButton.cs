using LethalApeR.SceneFlow;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class RivalryPortalButton : BaseButton
	{
		[Header("Portal")]
		[Tooltip("Scene to load. Must be in Build Settings.")]
		[SerializeField]
		private string sceneName = "Rivalry";

		public override void OnButtonPressed(bool isLeft)
		{
			if (!SceneTransition.IsBusy)
			{
				Debug.Log(string.Format("[RivalryPortalButton] Pressed — leaving room (InRoom={0}) and loading '{1}'", PhotonNetwork.InRoom, sceneName));
				SceneTransition.Go(sceneName);
			}
		}
	}
}
