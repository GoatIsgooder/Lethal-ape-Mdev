using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class PowerDoorController : MonoBehaviourPunCallbacks
	{
		[Header("Config")]
		[SerializeField]
		private BackroomsConfig config;

		[Header("Refs")]
		[Tooltip("The clean two-panel sliding escape door. Preferred over the legacy DoorManager.")]
		[SerializeField]
		private BackroomsSlidingDoor slidingDoor;

		[Tooltip("Legacy single-panel door (fallback if slidingDoor is unassigned).")]
		[SerializeField]
		private DoorManager door;

		[Tooltip("World anchor the player-proximity radius is measured from (defaults to this transform).")]
		[SerializeField]
		private Transform doorCenter;

		[Tooltip("The bright light at the end of the corridor; ramps up as the door powers.")]
		[SerializeField]
		private Light endLight;

		[Tooltip("Looping power-up hum. Spatialize = OFF (Meta XR spatializer silences ON sources in editor).")]
		[SerializeField]
		private AudioSource powerHum;

		private Coroutine _ramp;

		private Coroutine _proximity;

		private bool _powered;

		private bool _doorOpened;

		private bool CanRpc => PhotonNetwork.InRoom && photonView != null && photonView.ViewID != 0;

		private void Awake()
		{
			if (endLight != null)
			{
				endLight.intensity = 0f;
			}
		}

		public void MasterBeginPower()
		{
			if (CanRpc)
			{
				photonView.RPC("RPC_BeginPower", RpcTarget.All);
			}
			else
			{
				RPC_BeginPower();
			}
		}

		public void MasterResetForNewRound()
		{
			if (CanRpc)
			{
				photonView.RPC("RPC_ResetPower", RpcTarget.All);
			}
			else
			{
				RPC_ResetPower();
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_BeginPower()
		{
			if (_ramp != null)
			{
				StopCoroutine(_ramp);
			}
			_ramp = StartCoroutine(RampRoutine());
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ResetPower()
		{
			if (_ramp != null)
			{
				StopCoroutine(_ramp);
				_ramp = null;
			}
			if (_proximity != null)
			{
				StopCoroutine(_proximity);
				_proximity = null;
			}
			_powered = false;
			_doorOpened = false;
			if (endLight != null)
			{
				endLight.intensity = 0f;
			}
			if (powerHum != null && powerHum.isPlaying)
			{
				powerHum.Stop();
			}
			if (PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				SetDoorOpen(false);
			}
		}

		public override void OnMasterClientSwitched(Player newMaster)
		{
			if (_powered && !_doorOpened && PhotonNetwork.IsMasterClient)
			{
				StartProximityWait();
			}
		}

		private IEnumerator RampRoutine()
		{
			float dur = (config != null) ? Mathf.Max(0.1f, config.doorPowerRampDuration) : 6f;
			float target = (config != null) ? config.endLightIntensity : 8f;
			if (powerHum != null && !powerHum.isPlaying)
			{
				powerHum.Play();
			}
			float t = 0f;
			while (t < dur)
			{
				t += Time.deltaTime;
				if (endLight != null)
				{
					endLight.intensity = Mathf.Lerp(0f, target, Mathf.Clamp01(t / dur));
				}
				yield return null;
			}
			if (endLight != null)
			{
				endLight.intensity = target;
			}
			_ramp = null;
			_powered = true;
			if (PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				StartProximityWait();
			}
		}

		private void StartProximityWait()
		{
			if (!_doorOpened)
			{
				if (_proximity != null)
				{
					StopCoroutine(_proximity);
				}
				_proximity = StartCoroutine(ProximityWaitRoutine());
			}
		}

		private IEnumerator ProximityWaitRoutine()
		{
			float radius = (config != null) ? config.doorProximityRadius : 4f;
			while (!AnyPlayerWithin(radius))
			{
				yield return null;
			}
			SetDoorOpen(true);
			_proximity = null;
			_doorOpened = true;
		}

		private void SetDoorOpen(bool open)
		{
			if (slidingDoor != null)
			{
				slidingDoor.MasterSetOpen(open);
			}
			else if (door != null)
			{
				door.TryActivate(open);
			}
		}

		private bool AnyPlayerWithin(float radius)
		{
			IReadOnlyList<Transform> targets = ChaseTargetRegistry.Targets;
			Vector3 vector = ((slidingDoor != null) ? slidingDoor.DoorwayCenter : ((doorCenter != null) ? doorCenter : transform).position);
			float num = radius * radius;
			for (int i = 0; i < targets.Count; i++)
			{
				if (targets[i] != null && (targets[i].position - vector).sqrMagnitude <= num)
				{
					return true;
				}
			}
			return false;
		}
	}
}
