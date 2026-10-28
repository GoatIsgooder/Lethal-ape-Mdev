using System.Reflection;
using Locomotion.Scripts;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class Keycard : MonoBehaviourPun, IPunObservable
	{
		[Tooltip("Index in KeycardManager.keycards. Set by the editor builder.")]
		public int cardId;

		[Tooltip("This card's colour, matched against a slot when enforceColorMatch is on.")]
		public KeycardColor color;

		private Rigidbody _rb;

		private Collider[] _colliders;

		private Grabbable _grabbable;

		private Vector3 _netPos;

		private Quaternion _netRot;

		private bool _hasNet;

		public KeycardState State { get; private set; }

		public int HolderActor { get; private set; } = -1;

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_colliders = GetComponentsInChildren<Collider>(true);
			_grabbable = GetComponent<Grabbable>();
			if (_grabbable != null)
			{
				_grabbable.onGrab.AddListener(OnLocalGrabbed);
			}
			_netPos = transform.position;
			_netRot = transform.rotation;
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
			if (State == KeycardState.InVent)
			{
				KeycardManager.Instance?.LocalRequestPickup(this);
			}
		}

		public void ConfigureFor(KeycardState state, int holderActor, Vector3 pos, Quaternion rot, Transform placedParent)
		{
			State = state;
			HolderActor = holderActor;
			int localActor = (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : 1;
			bool notLocalHolder = !(state == KeycardState.Held && localActor == holderActor);
			switch (state)
			{
			case KeycardState.Pooled:
				LocalForceReleaseIfHeld();
				transform.SetParent(null, true);
				gameObject.SetActive(false);
				break;
			case KeycardState.InVent:
				gameObject.SetActive(true);
				transform.SetParent(null, true);
				SnapTo(pos, rot);
				SetColliders(true);
				SetKinematic(true);
				break;
			case KeycardState.Held:
				gameObject.SetActive(true);
				transform.SetParent(null, true);
				if (notLocalHolder)
				{
					LocalForceReleaseIfHeld();
					SetColliders(false);
					SetKinematic(true);
				}
				else
				{
					SetColliders(true);
					SetKinematic(false);
				}
				break;
			case KeycardState.Placed:
				LocalForceReleaseIfHeld();
				gameObject.SetActive(true);
				SnapTo(pos, rot);
				if (placedParent != null)
				{
					transform.SetParent(placedParent, true);
				}
				SetColliders(false);
				SetKinematic(true);
				break;
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext(transform.position);
				stream.SendNext(transform.rotation);
			}
			else
			{
				_netPos = (Vector3)stream.ReceiveNext();
				_netRot = (Quaternion)stream.ReceiveNext();
				_hasNet = true;
			}
		}

		private void Update()
		{
			if ((!(photonView != null) || !photonView.IsMine) && _hasNet && State == KeycardState.Held)
			{
				transform.position = Vector3.Lerp(transform.position, _netPos, 0.25f);
				transform.rotation = Quaternion.Slerp(transform.rotation, _netRot, 0.25f);
			}
		}

		private void SnapTo(Vector3 pos, Quaternion rot)
		{
			transform.SetPositionAndRotation(pos, rot);
			_netPos = pos;
			_netRot = rot;
			_hasNet = true;
		}

		private void SetKinematic(bool kinematic)
		{
			if (!(_rb == null))
			{
				_rb.isKinematic = kinematic;
				if (kinematic)
				{
					_rb.linearVelocity = Vector3.zero;
					_rb.angularVelocity = Vector3.zero;
				}
			}
		}

		private void SetColliders(bool enabled)
		{
			if (_colliders == null)
			{
				return;
			}
			for (int i = 0; i < _colliders.Length; i++)
			{
				if (_colliders[i] != null)
				{
					_colliders[i].enabled = enabled;
				}
			}
		}

		private void LocalForceReleaseIfHeld()
		{
			GrabInteractor[] grabInteractors = KeycardManager.GrabInteractors;
			if (grabInteractors == null)
			{
				return;
			}
			for (int i = 0; i < grabInteractors.Length; i++)
			{
				GrabInteractor grabInteractor = grabInteractors[i];
				if (grabInteractor != null && grabInteractor.IsGrabbing && grabInteractor.HeldTransform == transform)
				{
					grabInteractor.ForceRelease();
				}
			}
		}
	}
}
