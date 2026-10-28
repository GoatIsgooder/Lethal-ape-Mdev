using System.Reflection;
using LALocomotion;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Networking
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(Grabbable))]
	[RequireComponent(typeof(Rigidbody))]
	public class NetworkedGrabbable : MonoBehaviourPun, IPunObservable, IRemoteGrabGuard
	{
		private Rigidbody _rb;

		private Grabbable _grabbable;

		private Vector3 _netPos;

		private Quaternion _netRot;

		private bool _hasNet;

		private bool _ownerHolding;

		private bool _remoteHeld;

		private GrabInteractor[] _interactorsCache;

		private float _nextInteractorRescan;

		private LAGrabbable _la;

		private bool HeldByLaHand => _la != null && _la.IsHeld;

		private bool IsRemote => PhotonNetwork.InRoom && photonView != null && !photonView.IsMine;

		public bool IsHeld => HeldByLaHand || FindHoldingInteractor() != null;

		public bool HeldByRemoteOwner => IsRemote && _remoteHeld;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_grabbable = GetComponent<Grabbable>();
			_la = GetComponent<LAGrabbable>();
			if (_grabbable != null)
			{
				_grabbable.onGrab.AddListener(OnLocalGrabbed);
			}
			_netPos = transform.position;
			_netRot = transform.rotation;
		}

		private void Start()
		{
			if (_rb != null)
			{
				_rb.isKinematic = IsRemote;
			}
		}

		private void OnDestroy()
		{
			if (_grabbable != null)
			{
				_grabbable.onGrab.RemoveListener(OnLocalGrabbed);
			}
		}

		private void OnLocalGrabbed()
		{
			if (PhotonNetwork.InRoom && photonView != null && !photonView.IsMine)
			{
				photonView.RequestOwnership();
			}
			if (HeldByLaHand)
			{
				_la.SetReleasedKinematic(kinematic: false);
			}
			else if (_rb != null)
			{
				_rb.isKinematic = false;
			}
		}

		private void Update()
		{
			bool isRemote = IsRemote;
			bool flag = isRemote || HeldByLaHand;
			if (_rb != null && _rb.isKinematic != flag)
			{
				_rb.isKinematic = flag;
			}
			if (isRemote)
			{
				if (_hasNet)
				{
					transform.position = Vector3.Lerp(transform.position, _netPos, 0.25f);
					transform.rotation = Quaternion.Slerp(transform.rotation, _netRot, 0.25f);
				}
			}
			else
			{
				_ownerHolding = IsHeld;
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext(transform.position);
				stream.SendNext(transform.rotation);
				stream.SendNext(_ownerHolding);
			}
			else
			{
				_netPos = (Vector3)stream.ReceiveNext();
				_netRot = (Quaternion)stream.ReceiveNext();
				_remoteHeld = (bool)stream.ReceiveNext();
				_hasNet = true;
			}
		}

		private GrabInteractor FindHoldingInteractor()
		{
			bool flag = _interactorsCache == null || _interactorsCache.Length == 0;
			if (!flag)
			{
				for (int i = 0; i < _interactorsCache.Length; i++)
				{
					if (_interactorsCache[i] == null)
					{
						flag = true;
						break;
					}
				}
			}
			if (flag && Time.time >= _nextInteractorRescan)
			{
				_nextInteractorRescan = Time.time + 1f;
				_interactorsCache = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			}
			if (_interactorsCache == null)
			{
				return null;
			}
			GrabInteractor[] interactorsCache = _interactorsCache;
			foreach (GrabInteractor grabInteractor in interactorsCache)
			{
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (grabInteractor.HeldRigidbody == _rb)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform == transform)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform != null && grabInteractor.HeldTransform.IsChildOf(transform))
					{
						return grabInteractor;
					}
				}
			}
			return null;
		}
	}
}
