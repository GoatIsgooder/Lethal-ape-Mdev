using System.Collections;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	public class DoorManager : MonoBehaviourPun
	{
		public Transform doorTransform;

		public Vector3 openLocalPosition;

		public Vector3 closedLocalPosition;

		public float duration = 1f;

		public float afterMoveDuration = 1f;

		public float rpcCooldown = 0.5f;

		public AudioSource closeSFX;

		public AudioSource openSFX;

		public bool isOpen;

		private Coroutine _slide;

		private float _lastRequestTime;

		private bool _sliding;

		private bool _contextMenuTarget;

		private Vector3 PoseFor(bool open)
		{
			if (!open)
			{
				return closedLocalPosition;
			}
			return openLocalPosition;
		}

		private AudioSource SfxFor(bool open)
		{
			if (!open)
			{
				return closeSFX;
			}
			return openSFX;
		}

		private void Start()
		{
			doorTransform.localPosition = PoseFor(isOpen);
		}

		private void OnTriggerEnter(Collider other)
		{
			if (!isOpen && other.TryGetComponent<BaseMonster>(out var _))
			{
				TryActivate(targetOpen: true);
			}
		}

		[ContextMenu("Toggle Door Test")]
		private void ToggleFromContextMenu()
		{
			_contextMenuTarget = !_contextMenuTarget;
			TryActivate(_contextMenuTarget);
		}

		public void TryActivate(bool targetOpen)
		{
			if (!_sliding && isOpen != targetOpen && !(Time.time - _lastRequestTime < rpcCooldown))
			{
				_lastRequestTime = Time.time;
				if (PhotonNetwork.IsMasterClient)
				{
					BroadcastToggle(targetOpen);
					return;
				}
				base.photonView.RPC("RPC_RequestToggle", RpcTarget.MasterClient, targetOpen);
			}
		}

		private void BroadcastToggle(bool targetOpen)
		{
			base.photonView.RPC("RPC_ToggleDoor", RpcTarget.AllBuffered, targetOpen);
		}

		[PunRPC]
		private void RPC_RequestToggle(bool targetOpen, PhotonMessageInfo info)
		{
			if (PhotonNetwork.IsMasterClient)
			{
				BroadcastToggle(targetOpen);
			}
		}

		[PunRPC]
		private void RPC_ToggleDoor(bool targetOpen)
		{
			if (_slide != null)
			{
				StopCoroutine(_slide);
			}
			isOpen = targetOpen;
			_slide = StartCoroutine(Slide(targetOpen));
		}

		private IEnumerator Slide(bool open)
		{
			_sliding = true;
			SfxFor(open).Play();
			Vector3 from = doorTransform.localPosition;
			Vector3 to = PoseFor(open);
			for (float t = 0f; t < duration; t += Time.deltaTime)
			{
				doorTransform.localPosition = Vector3.Lerp(from, to, t / duration);
				yield return null;
			}
			doorTransform.localPosition = to;
			yield return new WaitForSeconds(afterMoveDuration);
			_slide = null;
			SfxFor(open).Stop();
			_sliding = false;
		}
	}
}
