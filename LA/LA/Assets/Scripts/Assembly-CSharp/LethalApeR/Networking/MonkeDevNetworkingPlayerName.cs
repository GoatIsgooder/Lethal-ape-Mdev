using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Networking
{
	public class MonkeDevNetworkingPlayerName : MonoBehaviourPun
	{
		[Tooltip("Height of the name tag above the head")]
		public float Offset = 0.17f;

		public Transform Head;

		private const float FaceViewerSpeed = 10f;

		private Vector3 _lift;

		private void Awake()
		{
			_lift = new Vector3(0f, Offset, 0f);
		}

		private void Update()
		{
			Transform transform = base.transform;
			transform.position = Head.position + _lift;
			if (base.photonView.IsMine)
			{
				transform.rotation = Flatten(Quaternion.LookRotation(Head.forward, Vector3.up));
				return;
			}
			Quaternion b = Flatten(Quaternion.LookRotation(MonkeDevNetworkingManager.Manager.Head.position - transform.position, Vector3.up));
			transform.rotation = Quaternion.Slerp(transform.rotation, b, Time.deltaTime * 10f);
		}

		private static Quaternion Flatten(Quaternion q)
		{
			return new Quaternion(0f, q.y, 0f, q.w);
		}
	}
}
