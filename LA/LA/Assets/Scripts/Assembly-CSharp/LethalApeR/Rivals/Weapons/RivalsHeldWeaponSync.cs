using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using LethalApeR.Rivals.Combat;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Rivals.Weapons
{
	[Obfuscation(Exclude = true)]
	public class RivalsHeldWeaponSync : MonoBehaviourPunCallbacks
	{
		private class Attachment
		{
			public int actor;

			public bool left;

			public string id;

			public GameObject go;

			public Transform parent;

			public bool stale;
		}

		private const string PropLeft = "rvlsHL";

		private const string PropRight = "rvlsHR";

		private const float ReconcileInterval = 0.5f;

		private const float RepublishInterval = 2f;

		private static RivalsHeldWeaponSync _instance;

		private static Weapon _heldLeft;

		private static Weapon _heldRight;

		private static float _nextRepublish;

		private readonly List<Attachment> _attachments = new List<Attachment>();

		private float _nextReconcile;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] RivalsHeldWeaponSync");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<RivalsHeldWeaponSync>();
			}
		}

		public static void LocalGrabbed(Weapon weapon, XRNode node)
		{
			if (weapon == null)
			{
				return;
			}
			if (node == XRNode.LeftHand)
			{
				if (_heldRight == weapon)
				{
					_heldRight = null;
				}
				_heldLeft = weapon;
			}
			else
			{
				if (_heldLeft == weapon)
				{
					_heldLeft = null;
				}
				_heldRight = weapon;
			}
			Publish();
		}

		public static void LocalReleased(Weapon weapon)
		{
			if (weapon == null)
			{
				return;
			}
			bool flag = false;
			if (_heldLeft == weapon)
			{
				_heldLeft = null;
				flag = true;
			}
			if (_heldRight == weapon)
			{
				_heldRight = null;
				flag = true;
			}
			if (flag)
			{
				Publish();
			}
		}

		private static void Publish()
		{
			if (PhotonNetwork.InRoom)
			{
				_nextRepublish = Time.time + 2f;
				Hashtable hashtable = new Hashtable();
				hashtable[PropLeft] = BuildHandPayload(_heldLeft, left: true);
				hashtable[PropRight] = BuildHandPayload(_heldRight, left: false);
				PhotonNetwork.LocalPlayer.SetCustomProperties(hashtable);
			}
		}

		private static object BuildHandPayload(Weapon w, bool left)
		{
			if (w == null || w.Data == null)
			{
				return string.Empty;
			}
			Vector3 vector = Vector3.zero;
			Quaternion quaternion = Quaternion.identity;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Transform transform = ((manager != null) ? (left ? manager.LeftHand : manager.RightHand) : null);
			if (transform != null)
			{
				vector = transform.InverseTransformPoint(w.transform.position);
				quaternion = Quaternion.Inverse(transform.rotation) * w.transform.rotation;
			}
			return new object[3]
			{
				WeaponDatabase.IdOf(w.Data),
				vector,
				quaternion
			};
		}

		private void Update()
		{
			if ((_heldLeft != null || _heldRight != null) && PhotonNetwork.InRoom && Time.time >= _nextRepublish)
			{
				Publish();
			}
			if (!(Time.time < _nextReconcile))
			{
				_nextReconcile = Time.time + 0.5f;
				Reconcile();
			}
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
		{
			if (changedProps != null && (changedProps.ContainsKey(PropLeft) || changedProps.ContainsKey(PropRight)))
			{
				Reconcile();
			}
		}

		public override void OnLeftRoom()
		{
			_heldRight = null;
			_heldLeft = null;
			Reconcile();
		}

		private void Reconcile()
		{
			foreach (Attachment attachment in _attachments)
			{
				attachment.stale = true;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (PhotonNetwork.InRoom && manager != null && manager.Players != null)
			{
				foreach (MonkeDevNetworkingPlayer player in manager.Players)
				{
					if (player == null || !player.isActiveAndEnabled)
					{
						continue;
					}
					PhotonView photonView = player.photonView;
					if (!(photonView == null) && photonView.ViewID != 0 && !photonView.IsMine && photonView.Owner != null)
					{
						PlayerHealth component = player.GetComponent<PlayerHealth>();
						bool flag = component == null || component.IsAlive;
						Hashtable customProperties = photonView.Owner.CustomProperties;
						EnsureHand(photonView.OwnerActorNr, left: true, flag ? customProperties[PropLeft] : null, player.LeftHand);
						EnsureHand(photonView.OwnerActorNr, left: false, flag ? customProperties[PropRight] : null, player.RightHand);
					}
				}
			}
			for (int num = _attachments.Count - 1; num >= 0; num--)
			{
				if (_attachments[num].stale)
				{
					if (_attachments[num].go != null)
					{
						Object.Destroy(_attachments[num].go);
					}
					_attachments.RemoveAt(num);
				}
			}
		}

		private void EnsureHand(int actor, bool left, object payload, Transform hand)
		{
			if (!(payload is object[] array) || array.Length < 3 || !(array[0] is string text) || text.Length == 0 || hand == null)
			{
				return;
			}
			Vector3 localPosition = (Vector3)array[1];
			Quaternion localRotation = (Quaternion)array[2];
			for (int i = 0; i < _attachments.Count; i++)
			{
				Attachment attachment = _attachments[i];
				if (attachment.actor != actor || attachment.left != left)
				{
					continue;
				}
				if (attachment.go != null && attachment.id == text && attachment.parent == hand)
				{
					attachment.stale = false;
					attachment.go.transform.localPosition = localPosition;
					attachment.go.transform.localRotation = localRotation;
					return;
				}
				if (attachment.go != null)
				{
					Object.Destroy(attachment.go);
				}
				_attachments.RemoveAt(i);
				break;
			}
			GameObject gameObject = SpawnDisplayModel(text);
			if (!(gameObject == null))
			{
				gameObject.transform.SetParent(hand, worldPositionStays: false);
				gameObject.transform.localPosition = localPosition;
				gameObject.transform.localRotation = localRotation;
				_attachments.Add(new Attachment
				{
					actor = actor,
					left = left,
					id = text,
					go = gameObject,
					parent = hand,
					stale = false
				});
			}
		}

		private static GameObject SpawnDisplayModel(string id)
		{
			WeaponDatabase weaponDatabase = ((GunUnlocker.Instance != null) ? GunUnlocker.Instance.Database : null);
			WeaponData weaponData = ((weaponDatabase != null) ? weaponDatabase.GetById(id) : null);
			if (weaponData == null)
			{
				return null;
			}
			GameObject gameObject = ((weaponData.modelPrefab != null) ? weaponData.modelPrefab : weaponData.grabbablePrefab);
			if (gameObject == null)
			{
				return null;
			}
			GameObject gameObject2 = Object.Instantiate(gameObject);
			gameObject2.name = "HeldGun_" + id;
			Strip(gameObject2);
			return gameObject2;
		}

		private static void Strip(GameObject go)
		{
			MonoBehaviour[] componentsInChildren = go.GetComponentsInChildren<MonoBehaviour>(includeInactive: true);
			foreach (MonoBehaviour monoBehaviour in componentsInChildren)
			{
				if (monoBehaviour != null)
				{
					monoBehaviour.enabled = false;
				}
			}
			Collider[] componentsInChildren2 = go.GetComponentsInChildren<Collider>(includeInactive: true);
			for (int i = 0; i < componentsInChildren2.Length; i++)
			{
				componentsInChildren2[i].enabled = false;
			}
			Rigidbody[] componentsInChildren3 = go.GetComponentsInChildren<Rigidbody>(includeInactive: true);
			foreach (Rigidbody obj in componentsInChildren3)
			{
				obj.isKinematic = true;
				obj.detectCollisions = false;
				obj.useGravity = false;
				obj.interpolation = RigidbodyInterpolation.None;
			}
			AudioSource[] componentsInChildren4 = go.GetComponentsInChildren<AudioSource>(includeInactive: true);
			for (int i = 0; i < componentsInChildren4.Length; i++)
			{
				componentsInChildren4[i].enabled = false;
			}
			LineRenderer[] componentsInChildren5 = go.GetComponentsInChildren<LineRenderer>(includeInactive: true);
			for (int i = 0; i < componentsInChildren5.Length; i++)
			{
				componentsInChildren5[i].enabled = false;
			}
			TMP_Text[] componentsInChildren6 = go.GetComponentsInChildren<TMP_Text>(includeInactive: true);
			for (int i = 0; i < componentsInChildren6.Length; i++)
			{
				componentsInChildren6[i].enabled = false;
			}
		}
	}
}
