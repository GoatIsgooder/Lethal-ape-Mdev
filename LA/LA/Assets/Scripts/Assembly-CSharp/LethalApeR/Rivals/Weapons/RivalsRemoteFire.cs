using System.Reflection;
using ExitGames.Client.Photon;
using LethalApeR.Rivals.Pooling;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Rivals.Weapons
{
	[Obfuscation(Exclude = true)]
	public class RivalsRemoteFire : MonoBehaviour, IOnEventCallback
	{
		public const byte FireEventCode = 77;

		private static RivalsRemoteFire _instance;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject gameObject = new GameObject("[Auto] RivalsRemoteFire");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<RivalsRemoteFire>();
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

		public static void NotifyFired(WeaponData data, Vector3 from, Vector3 to)
		{
			if (!(data == null) && PhotonNetwork.InRoom)
			{
				object[] eventContent = new object[3]
				{
					WeaponDatabase.IdOf(data),
					from,
					to
				};
				RaiseEventOptions raiseEventOptions = new RaiseEventOptions
				{
					Receivers = ReceiverGroup.Others
				};
				PhotonNetwork.RaiseEvent(77, eventContent, raiseEventOptions, SendOptions.SendUnreliable);
			}
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code != 77 || !(photonEvent.CustomData is object[] array) || array.Length < 3)
			{
				return;
			}
			WeaponDatabase weaponDatabase = ((GunUnlocker.Instance != null) ? GunUnlocker.Instance.Database : null);
			WeaponData weaponData = ((weaponDatabase != null) ? weaponDatabase.GetById(array[0] as string) : null);
			if (weaponData == null)
			{
				return;
			}
			Vector3 vector = (Vector3)array[1];
			Vector3 vector2 = (Vector3)array[2];
			Vector3 vector3 = vector2 - vector;
			if (weaponData.tracerPrefab != null && vector3.sqrMagnitude > 1E-06f)
			{
				GameObject gameObject = Object.Instantiate(weaponData.tracerPrefab, vector, Quaternion.LookRotation(vector3.normalized));
				if (gameObject != null)
				{
					Tracer tracer = gameObject.GetComponent<Tracer>();
					if (tracer == null)
					{
						tracer = gameObject.AddComponent<Tracer>();
					}
					tracer.Fly(vector, vector2, weaponData.tracerSpeed);
				}
			}
			if (weaponData.muzzleFlashPrefab != null)
			{
				SimplePool.SpawnTimed(weaponData.muzzleFlashPrefab, vector, (vector3.sqrMagnitude > 1E-06f) ? Quaternion.LookRotation(vector3.normalized) : Quaternion.identity, 0.1f);
			}
			if (weaponData.fireSfx != null)
			{
				AudioSource.PlayClipAtPoint(weaponData.fireSfx, vector, weaponData.sfxVolume);
			}
		}
	}
}
