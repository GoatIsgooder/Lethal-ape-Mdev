using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	public class KickHammer : MonoBehaviour
	{
		public PhotonView playerView;

		public bool isLeftHand;

		public bool isKickActive;

		public BoxCollider detectionCollider;

		public Renderer hammerRenderer;

		public Color activatedCol;

		public Color defaultCol;

		private bool previousInput;

		private bool previousKickState;

		private void Start()
		{
			detectionCollider.enabled = false;
		}

		private void Update()
		{
			if (!playerView.IsMine || VRInputController.Instance == null)
			{
				return;
			}
			bool flag = (isLeftHand ? VRInputController.Instance.LeftTriggerValue : VRInputController.Instance.RightTriggerValue) > 0.6f;
			if (previousInput != flag)
			{
				previousInput = flag;
				if (previousKickState != flag)
				{
					previousKickState = flag;
					playerView.RPC("RPC_SetKickActive", RpcTarget.All, isLeftHand, flag);
				}
			}
		}

		public void SetKickActive(bool setActive)
		{
			detectionCollider.enabled = setActive;
			Material material = hammerRenderer.material;
			material.EnableKeyword("_EMISSION");
			material.SetColor("_EmissionColor", setActive ? activatedCol : defaultCol);
		}

		private void OnTriggerEnter(Collider other)
		{
			MonkeDevNetworkingPlayer componentInParent = other.GetComponentInParent<MonkeDevNetworkingPlayer>();
			if (componentInParent != null && !componentInParent.photonView.IsMine)
			{
				componentInParent.photonView.RPC("RPC_HammerKickQuit", componentInParent.photonView.Owner);
			}
		}
	}
}
