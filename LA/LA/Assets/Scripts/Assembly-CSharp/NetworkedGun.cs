using LethalApeR.Gameplay.BeTheMonster;
using Photon.Pun;
using UnityEngine;

public class NetworkedGun : MonoBehaviourPun, IPunObservable
{
	public GameObject objectToEnable;

	public bool isLeftHanded;

	private bool sprayingLocal;

	private bool sprayingRemote;

	private void Update()
	{
		if (base.photonView.IsMine)
		{
			bool flag = TriggerHeld();
			if (flag != sprayingLocal)
			{
				sprayingLocal = flag;
				objectToEnable.SetActive(flag);
			}
		}
	}

	public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
	{
		if (stream.IsWriting)
		{
			stream.SendNext(sprayingLocal);
			return;
		}
		bool flag = (bool)stream.ReceiveNext();
		if (flag != sprayingRemote)
		{
			sprayingRemote = flag;
			objectToEnable.SetActive(flag);
		}
	}

	private static bool TriggerHeld()
	{
		return VRInputController.Instance.LeftTriggerValue > 0.5f;
	}
}
