using System.Reflection;
using LALocomotion;
using Locomotion.Scripts;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(Grabbable))]
	[RequireComponent(typeof(Rigidbody))]
	public class ScrapPickup : MonoBehaviourPun, IPunObservable, IRemoteGrabGuard
	{
		[Header("Data")]
		[Tooltip("Catalog entry that defines this pickup's sell value + scaling. Required.")]
		[SerializeField]
		private ScrapItemData data;

		[Header("Optional")]
		[Tooltip("World-space TMP that shows this piece's sell value while it sits in the world.")]
		[SerializeField]
		private TMP_Text valueLabel;

		[Tooltip("{0} is the value.")]
		[SerializeField]
		private string valueFormat = "${0:N0}";

		private Rigidbody _rb;

		private Collider[] _colliders;

		private Grabbable _grabbable;

		private ScrapManager _manager;

		private Vector3 _netPos;

		private Quaternion _netRot;

		private bool _hasNet;

		private bool _ownerHolding;

		private bool _remoteHeld;

		private GrabInteractor[] _interactorsCache;

		private float _nextInteractorRescan;

		private LAGrabbable _la;

		public int ScrapId { get; private set; } = -1;

		public int SellValue { get; private set; }

		public ScrapState State { get; private set; }

		public ScrapItemData Data => data;

		private bool HeldByLaHand
		{
			get
			{
				if (_la != null)
				{
					return _la.IsHeld;
				}
				return false;
			}
		}

		public bool IsHeld
		{
			get
			{
				if (HeldByLaHand)
				{
					return true;
				}
				return FindHoldingInteractor() != null;
			}
		}

		public bool IsMineOrOffline
		{
			get
			{
				if (!PhotonNetwork.InRoom || base.photonView == null)
				{
					return true;
				}
				return base.photonView.IsMine;
			}
		}

		public Rigidbody Body => _rb;

		private bool IsRemote
		{
			get
			{
				if (PhotonNetwork.InRoom && base.photonView != null)
				{
					return !base.photonView.IsMine;
				}
				return false;
			}
		}

		public bool IsSellable => State == ScrapState.InWorld;

		public bool HeldByRemoteOwner
		{
			get
			{
				if (IsRemote)
				{
					return _remoteHeld;
				}
				return false;
			}
		}

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_colliders = GetComponentsInChildren<Collider>(true);
			_grabbable = GetComponent<Grabbable>();
			_la = GetComponent<LAGrabbable>();
			if (_grabbable != null)
			{
				_grabbable.onGrab.AddListener(OnLocalGrabbed);
			}
			_netPos = base.transform.position;
			_netRot = base.transform.rotation;
		}

		private void OnDestroy()
		{
			if (_grabbable != null)
			{
				_grabbable.onGrab.RemoveListener(OnLocalGrabbed);
			}
		}

		public void Init(ScrapManager manager, int scrapId, int sellValue)
		{
			_manager = manager;
			ScrapId = scrapId;
			SellValue = sellValue;
			if (valueLabel != null)
			{
				valueLabel.text = string.Format(valueFormat, sellValue);
			}
		}

		private void OnLocalGrabbed()
		{
			if (State != ScrapState.InWorld)
			{
				return;
			}
			if (PhotonNetwork.InRoom && base.photonView != null && !base.photonView.IsMine)
			{
				base.photonView.RequestOwnership();
			}
			if (HeldByLaHand)
			{
				_la.SetReleasedKinematic(false);
			}
			else if (_rb != null)
			{
				_rb.isKinematic = false;
			}
		}

		public void ClaimForSale()
		{
			if (State == ScrapState.InWorld && PhotonNetwork.InRoom && base.photonView != null && !base.photonView.IsMine)
			{
				base.photonView.RequestOwnership();
			}
		}

		public void ConfigureFor(ScrapState state)
		{
			State = state;
			switch (state)
			{
			case ScrapState.Pooled:
			case ScrapState.Consumed:
				if (HeldByLaHand)
				{
					_la.Holder.Release(false);
				}
				ForceReleaseIfHeld();
				if (valueLabel != null)
				{
					valueLabel.gameObject.SetActive(false);
				}
				base.gameObject.SetActive(false);
				break;
			case ScrapState.InWorld:
				base.gameObject.SetActive(true);
				SetColliders(true);
				if (_rb != null)
				{
					_rb.isKinematic = IsRemote;
				}
				if (valueLabel != null)
				{
					valueLabel.gameObject.SetActive(true);
					valueLabel.text = string.Format(valueFormat, SellValue);
				}
				break;
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext(base.transform.position);
				stream.SendNext(base.transform.rotation);
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

		private void Update()
		{
			if (State != ScrapState.InWorld)
			{
				return;
			}
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
					base.transform.position = Vector3.Lerp(base.transform.position, _netPos, 0.25f);
					base.transform.rotation = Quaternion.Slerp(base.transform.rotation, _netRot, 0.25f);
				}
			}
			else
			{
				_ownerHolding = IsHeld;
			}
		}

		private void SetColliders(bool enabled)
		{
			if (_colliders == null)
			{
				return;
			}
			Collider[] colliders = _colliders;
			foreach (Collider collider in colliders)
			{
				if (collider != null)
				{
					collider.enabled = enabled;
				}
			}
		}

		private void ForceReleaseIfHeld()
		{
			if (_interactorsCache == null)
			{
				return;
			}
			GrabInteractor[] interactorsCache = _interactorsCache;
			foreach (GrabInteractor grabInteractor in interactorsCache)
			{
				if (grabInteractor != null && grabInteractor.IsGrabbing && grabInteractor.HeldTransform == base.transform)
				{
					grabInteractor.ForceRelease();
				}
			}
		}

		private GrabInteractor FindHoldingInteractor()
		{
			bool flag = _interactorsCache == null || _interactorsCache.Length == 0;
			if (!flag)
			{
				GrabInteractor[] interactorsCache = _interactorsCache;
				for (int i = 0; i < interactorsCache.Length; i++)
				{
					if (interactorsCache[i] == null)
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
			GrabInteractor[] interactorsCache2 = _interactorsCache;
			foreach (GrabInteractor grabInteractor in interactorsCache2)
			{
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (grabInteractor.HeldRigidbody == _rb)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform == base.transform)
					{
						return grabInteractor;
					}
					if (grabInteractor.HeldTransform != null && grabInteractor.HeldTransform.IsChildOf(base.transform))
					{
						return grabInteractor;
					}
				}
			}
			return null;
		}
	}
}
