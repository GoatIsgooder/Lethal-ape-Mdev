using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnBatteries : MonoBehaviour
	{
		[Tooltip("Spawn points, index = the spawn id in fnBtA (a contract scene table).")]
		public Transform[] spawns = new Transform[0];

		[Tooltip("Pickup visuals, index = battery id. Needs at least the max battery count.")]
		public GameObject[] pickups = new GameObject[4];

		[Tooltip("Shown on the local left hand while this client carries a cell.")]
		public GameObject localHeld;

		public Vector3 heldLocalOffset = new Vector3(0f, -0.04f, 0.06f);

		[Tooltip("A hand this close to a cell takes it (m).")]
		public float touchRadius = 0.22f;

		public LayerMask floorMask = 1;

		private float _nextRequest;

		private int _lastCarried = -1;

		public Vector3 SpawnPosition(int spawn)
		{
			if (spawn >= 0 && spawn < spawns.Length && spawns[spawn] != null)
			{
				return spawns[spawn].position;
			}
			return transform.position;
		}

		public Vector3 FloorBelow(Vector3 point)
		{
			if (Physics.Raycast(point + Vector3.up * 0.2f, Vector3.down, out var hitInfo, 6f, floorMask, QueryTriggerInteraction.Ignore))
			{
				return hitInfo.point + Vector3.up * 0.08f;
			}
			return point;
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active)
			{
				for (int i = 0; i < pickups.Length; i++)
				{
					if (pickups[i] != null && pickups[i].activeSelf)
					{
						pickups[i].SetActive(false);
					}
				}
				if (localHeld != null && localHeld.activeSelf)
				{
					localHeld.SetActive(false);
				}
				return;
			}
			for (int j = 0; j < pickups.Length; j++)
			{
				GameObject gameObject = pickups[j];
				if (gameObject == null)
				{
					continue;
				}
				FnBatteryState fnBatteryState = instance.BatteryState(j);
				bool flag = (fnBatteryState == FnBatteryState.AtSpawn || fnBatteryState == FnBatteryState.Dropped) & (j < instance.BatteryCount);
				if (gameObject.activeSelf != flag)
				{
					gameObject.SetActive(flag);
				}
				if (flag)
				{
					gameObject.transform.position = instance.BatteryWorldPosition(j);
				}
			}
			int num = instance.BatteryCarriedBy(FnGame.LocalActor);
			if (num != _lastCarried)
			{
				FnAudioBank audio = FnGame.Audio;
				if (audio != null && num >= 0)
				{
					FnAudio.Flat(audio.batteryPickup, 0.8f);
				}
				if (audio != null && num < 0 && _lastCarried >= 0 && instance.BatteryState(_lastCarried) == FnBatteryState.Delivered)
				{
					FnAudio.Flat(audio.batteryDeliver, 0.9f);
				}
				_lastCarried = num;
			}
			if (localHeld != null)
			{
				Transform leftHand = FnPlatform.LeftHand;
				bool flag2 = num >= 0 && leftHand != null;
				if (localHeld.activeSelf != flag2)
				{
					localHeld.SetActive(flag2);
				}
				if (flag2)
				{
					localHeld.transform.SetPositionAndRotation(leftHand.TransformPoint(heldLocalOffset), leftHand.rotation);
				}
			}
			if (num >= 0 || !instance.LocalIsAlive || instance.Phase != FnPhase.Night || Time.time < _nextRequest)
			{
				return;
			}
			Transform leftHand2 = FnPlatform.LeftHand;
			Transform rightHand = FnPlatform.RightHand;
			float num2 = touchRadius * touchRadius;
			for (int k = 0; k < instance.BatteryCount && k < pickups.Length; k++)
			{
				if (pickups[k] == null || !pickups[k].activeSelf)
				{
					continue;
				}
				Vector3 position = pickups[k].transform.position;
				if ((leftHand2 != null && (leftHand2.position - position).sqrMagnitude <= num2) || (rightHand != null && (rightHand.position - position).sqrMagnitude <= num2))
				{
					_nextRequest = Time.time + 0.5f;
					instance.RequestPickBattery(k);
					break;
				}
			}
		}
	}
}
