using System;
using System.Collections;
using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Gameplay.LandmineSystem;
using Locomotion.Scripts;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Grenade
{
	[RequireComponent(typeof(Rigidbody))]
	public class Grenade : MonoBehaviourPun, IGrabbable, IPunObservable, IPunOwnershipCallbacks
	{
		[Header("References")]
		public GrenadePin pin;

		public AudioSource audioSource;

		public GameObject explosionObject;

		[Header("Audio")]
		public AudioClip pinClickClip;

		public AudioClip fuseHissClip;

		public AudioClip explosionClip;

		[Header("Visuals — hidden on explosion")]
		public GameObject[] visualsToHide;

		[Header("Fuse")]
		public float fuseDelay = 3.5f;

		[Range(0f, 1f)]
		public float fuseHapticAmplitude = 0.65f;

		public float fuseHapticInterval = 0.35f;

		[Header("Explosion")]
		public float explosionForce = 18f;

		public float explosionRadius = 6f;

		public float killRadius = 1.5f;

		public float upwardModifier = 1.2f;

		public float monsterStopDuration = 4f;

		public float explosionLifetime = 4f;

		[Header("Testing")]
		public bool testPullPin;

		public bool testBeginFuse;

		public bool testDetonate;

		public bool testReset;

		public bool testHaptics;

		private Rigidbody _rb;

		private bool _isHeld;

		private Vector3 _spawnPos;

		private Quaternion _spawnRot;

		private Coroutine _fuseCoroutine;

		public GrenadeState State { get; private set; }

		public double FuseServerStart { get; private set; }

		public string EditorStateDisplay
		{
			get
			{
				if (State == GrenadeState.Fused)
				{
					double now = (PhotonNetwork.InRoom ? PhotonNetwork.Time : Time.timeAsDouble);
					return string.Format("Fused — {0:F1}s left", Mathf.Max(0f, fuseDelay - (float)(now - FuseServerStart)));
				}
				return State.ToString() + (_isHeld ? " (held)" : "");
			}
		}

		private void Awake()
		{
			_rb = GetComponent<Rigidbody>();
			_spawnPos = base.transform.position;
			_spawnRot = base.transform.rotation;
			if (pin != null)
			{
				pin.grenade = this;
			}
		}

		private void Start()
		{
			GorillaLocomotion.Player rig = GorillaLocomotion.Player.Instance;
			if (rig == null)
			{
				return;
			}
			if ((((int)rig.locomotionEnabledLayers >> base.gameObject.layer) & 1) != 0)
			{
				Debug.LogError("[Grenade] '" + base.name + "' is on a locomotion layer — change layer to Interactable.", this);
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>();
			foreach (Collider collider in componentsInChildren)
			{
				if (rig.headCollider != null)
				{
					Physics.IgnoreCollision(collider, rig.headCollider, true);
				}
				if (rig.bodyCollider != null)
				{
					Physics.IgnoreCollision(collider, rig.bodyCollider, true);
				}
			}
		}

		private void OnEnable()
		{
			PhotonNetwork.AddCallbackTarget(this);
		}

		private void OnDisable()
		{
			PhotonNetwork.RemoveCallbackTarget(this);
		}

		private void Update()
		{
			if (testPullPin)
			{
				testPullPin = false;
				NotifyPinPulled();
			}
			if (testBeginFuse)
			{
				testBeginFuse = false;
				BeginFuse();
			}
			if (testDetonate)
			{
				testDetonate = false;
				Detonate();
			}
			if (testReset)
			{
				testReset = false;
				DoReset();
			}
			if (testHaptics)
			{
				testHaptics = false;
				PulseBoth(0.8f, 0.3f);
			}
		}

		public void OnGrab()
		{
			_isHeld = true;
			if (PhotonNetwork.InRoom && base.photonView != null && !base.photonView.IsMine)
			{
				base.photonView.RequestOwnership();
			}
		}

		public void OnDrop()
		{
			_isHeld = false;
			if (State == GrenadeState.Primed)
			{
				BeginFuse();
			}
		}

		public void NotifyPinPulled()
		{
			if (State == GrenadeState.Safe)
			{
				int actor = (PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
				if (PhotonNetwork.InRoom && base.photonView != null)
				{
					base.photonView.RPC("RPC_PinPulled", RpcTarget.All, actor);
				}
				else
				{
					RPC_PinPulled(actor);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_PinPulled(int actorNumber)
		{
			if (State != GrenadeState.Safe)
			{
				return;
			}
			State = GrenadeState.Primed;
			if (audioSource != null && pinClickClip != null)
			{
				audioSource.PlayOneShot(pinClickClip);
			}
			if (!PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer?.ActorNumber == actorNumber)
			{
				PulseBoth(0.9f, 0.12f);
			}
		}

		private void BeginFuse()
		{
			if (State == GrenadeState.Primed)
			{
				double serverStart = (PhotonNetwork.InRoom ? PhotonNetwork.Time : Time.timeAsDouble);
				int actor = (PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
				if (PhotonNetwork.InRoom && base.photonView != null)
				{
					base.photonView.RPC("RPC_FuseStarted", RpcTarget.All, serverStart, actor);
				}
				else
				{
					RPC_FuseStarted(serverStart, actor);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_FuseStarted(double serverStart, int actorNumber)
		{
			if (State != GrenadeState.Primed)
			{
				return;
			}
			State = GrenadeState.Fused;
			FuseServerStart = serverStart;
			if (audioSource != null && fuseHissClip != null)
			{
				audioSource.clip = fuseHissClip;
				audioSource.loop = true;
				audioSource.Play();
			}
			if (!PhotonNetwork.InRoom || (base.photonView != null && base.photonView.IsMine))
			{
				StartFuseCountdown(serverStart);
			}
		}

		private void StartFuseCountdown(double serverStart)
		{
			if (_fuseCoroutine != null)
			{
				StopCoroutine(_fuseCoroutine);
			}
			double now = (PhotonNetwork.InRoom ? PhotonNetwork.Time : Time.timeAsDouble);
			float remaining = Mathf.Max(0f, fuseDelay - (float)(now - serverStart));
			_fuseCoroutine = StartCoroutine(FuseCoroutine(remaining));
		}

		public void ResumeAsOwner()
		{
			if (State == GrenadeState.Fused)
			{
				StartFuseCountdown(FuseServerStart);
			}
		}

		private IEnumerator FuseCoroutine(float duration)
		{
			float end = Time.time + duration;
			while (Time.time < end)
			{
				PulseBoth(fuseHapticAmplitude, 0.07f);
				yield return new WaitForSeconds(fuseHapticInterval);
			}
			Detonate();
		}

		private void Detonate()
		{
			if (PhotonNetwork.InRoom && base.photonView != null)
			{
				base.photonView.RPC("RPC_Detonate", RpcTarget.All);
			}
			else
			{
				RPC_Detonate();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Detonate()
		{
			if (State == GrenadeState.Exploded)
			{
				return;
			}
			State = GrenadeState.Exploded;
			if (_fuseCoroutine != null)
			{
				StopCoroutine(_fuseCoroutine);
				_fuseCoroutine = null;
			}
			if (_rb != null)
			{
				_rb.isKinematic = true;
				_rb.linearVelocity = Vector3.zero;
				_rb.angularVelocity = Vector3.zero;
			}
			if (audioSource != null)
			{
				audioSource.loop = false;
				audioSource.Stop();
				if (explosionClip != null)
				{
					audioSource.PlayOneShot(explosionClip);
				}
			}
			GameObject[] array = visualsToHide ?? Array.Empty<GameObject>();
			foreach (GameObject go in array)
			{
				if (go != null)
				{
					go.SetActive(false);
				}
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>();
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].enabled = false;
			}
			if (explosionObject != null)
			{
				explosionObject.SetActive(true);
				LandmineExplosion explosion = explosionObject.GetComponent<LandmineExplosion>();
				if (explosion != null)
				{
					explosion.Trigger(explosionForce, explosionRadius, upwardModifier, monsterStopDuration, explosionLifetime);
				}
			}
		}

		private void DoReset()
		{
			if (_fuseCoroutine != null)
			{
				StopCoroutine(_fuseCoroutine);
				_fuseCoroutine = null;
			}
			State = GrenadeState.Safe;
			FuseServerStart = 0.0;
			_isHeld = false;
			if (_rb != null)
			{
				_rb.isKinematic = true;
				_rb.linearVelocity = Vector3.zero;
				_rb.angularVelocity = Vector3.zero;
				base.transform.position = _spawnPos;
				base.transform.rotation = _spawnRot;
				_rb.isKinematic = false;
			}
			if (audioSource != null)
			{
				audioSource.loop = false;
				audioSource.Stop();
			}
			if (explosionObject != null)
			{
				explosionObject.SetActive(false);
			}
			GameObject[] array = visualsToHide ?? Array.Empty<GameObject>();
			foreach (GameObject go in array)
			{
				if (go != null)
				{
					go.SetActive(true);
				}
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>();
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].enabled = true;
			}
			if (pin != null)
			{
				pin.ResetPin();
			}
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext((int)State);
				stream.SendNext(FuseServerStart);
				return;
			}
			GrenadeState target = (GrenadeState)(int)stream.ReceiveNext();
			double fuseServerStart = (double)stream.ReceiveNext();
			if (target > State)
			{
				FuseServerStart = fuseServerStart;
				CatchUpToState(target);
			}
		}

		private void CatchUpToState(GrenadeState target)
		{
			if (target < GrenadeState.Primed)
			{
				return;
			}
			if (State < GrenadeState.Primed)
			{
				RPC_PinPulled(-1);
			}
			if (target != GrenadeState.Primed)
			{
				if (State < GrenadeState.Fused)
				{
					// RE: unsure - actorNumber argument is not materialised in the binary (callee ignores it)
					RPC_FuseStarted(FuseServerStart, -1);
				}
				if (target >= GrenadeState.Exploded && State < GrenadeState.Exploded)
				{
					RPC_Detonate();
				}
			}
		}

		void IPunOwnershipCallbacks.OnOwnershipTransfered(PhotonView targetView, Player previousOwner)
		{
			if (targetView.ViewID == base.photonView.ViewID && base.photonView.IsMine && State == GrenadeState.Fused)
			{
				StartFuseCountdown(FuseServerStart);
			}
		}

		void IPunOwnershipCallbacks.OnOwnershipRequest(PhotonView v, Player p)
		{
		}

		void IPunOwnershipCallbacks.OnOwnershipTransferFailed(PhotonView v, Player p)
		{
		}

		private static void PulseBoth(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(amplitude, duration);
				instance.PulseRight(amplitude, duration);
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(1f, 0.5f, 0.1f, 0.25f);
			Gizmos.DrawWireSphere(base.transform.position, explosionRadius);
			Gizmos.color = new Color(1f, 0.1f, 0.1f, 0.55f);
			Gizmos.DrawWireSphere(base.transform.position, killRadius);
		}
	}
}
