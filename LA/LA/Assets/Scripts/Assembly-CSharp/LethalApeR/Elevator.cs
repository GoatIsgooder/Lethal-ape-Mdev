using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using GorillaLocomotion;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	[DefaultExecutionOrder(-200)]
	[DisallowMultipleComponent]
	public class Elevator : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		public const byte RequestEventCode = 125;

		private const string KeyPrefix = "elv:";

		[Header("Floors")]
		[Tooltip("Stops the car's pivot travels to. Any order: up and down follow their heights.")]
		public List<Transform> floors = new List<Transform>();

		[Tooltip("Floor the car rests at until someone calls it. -1 = the floor nearest where it's placed.")]
		public int startFloor = -1;

		[Header("Motion")]
		[Min(0.1f)]
		public float moveSpeed = 2f;

		[Tooltip("m/s². Gentle ramps keep riders comfortable in VR.")]
		[Min(0.05f)]
		public float acceleration = 0.8f;

		[Tooltip("Seconds the car stays at a floor before it accepts the next trip.")]
		[Min(0f)]
		public float arrivalDwell = 1f;

		[Header("Audio")]
		public AudioSource elevatorMoveAmbience;

		public AudioSource arrivalChime;

		[Header("Network")]
		[Tooltip("Room-property key. Empty = the hierarchy path, which is identical on every client.")]
		public string elevatorId;

		private MovingPlatform _platform;

		private string _key;

		private int _from;

		private int _to;

		private int _startMs;

		private bool _hasTrip;

		private TravelProfile _profile;

		private bool _wasMoving;

		public int CurrentFloor => _to;

		public bool IsMoving
		{
			get
			{
				if (_hasTrip)
				{
					return Elapsed() < _profile.Duration;
				}
				return false;
			}
		}

		private void Awake()
		{
			Rigidbody rigidbody = GetComponent<Rigidbody>();
			if (rigidbody == null)
			{
				rigidbody = base.gameObject.AddComponent<Rigidbody>();
			}
			rigidbody.isKinematic = true;
			rigidbody.useGravity = false;
			_platform = GetComponent<MovingPlatform>();
			if (_platform == null)
			{
				_platform = base.gameObject.AddComponent<MovingPlatform>();
			}
			_platform.externallyDriven = true;
			_key = "elv:" + (string.IsNullOrEmpty(elevatorId) ? HierarchyPath(base.transform) : elevatorId);
			_from = (_to = ResolveStartFloor());
		}

		public override void OnEnable()
		{
			base.OnEnable();
			if (PhotonNetwork.InRoom)
			{
				ReadRoomState();
			}
		}

		private int ResolveStartFloor()
		{
			if (floors.Count == 0)
			{
				return 0;
			}
			if (startFloor >= 0 && startFloor < floors.Count && floors[startFloor] != null)
			{
				return startFloor;
			}
			int result = 0;
			float num = float.MaxValue;
			for (int i = 0; i < floors.Count; i++)
			{
				if (!(floors[i] == null))
				{
					float sqrMagnitude = (floors[i].position - base.transform.position).sqrMagnitude;
					if (sqrMagnitude < num)
					{
						num = sqrMagnitude;
						result = i;
					}
				}
			}
			return result;
		}

		public void ToggleElevator(bool goUp)
		{
			int num = NextFloor(goUp);
			if (num >= 0)
			{
				RequestFloor(num);
			}
		}

		public void RequestFloor(int floor)
		{
			if (IsValidFloor(floor))
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.IsMasterClient)
				{
					Authorize(floor);
					return;
				}
				PhotonNetwork.RaiseEvent(125, new object[2] { _key, floor }, new RaiseEventOptions
				{
					Receivers = ReceiverGroup.MasterClient
				}, SendOptions.SendReliable);
			}
		}

		private int NextFloor(bool goUp)
		{
			if (!IsValidFloor(_to))
			{
				return -1;
			}
			float y = floors[_to].position.y;
			int result = -1;
			float num = (goUp ? float.MaxValue : float.MinValue);
			for (int i = 0; i < floors.Count; i++)
			{
				if (floors[i] == null)
				{
					continue;
				}
				float y2 = floors[i].position.y;
				if (Mathf.Abs(y2 - y) < 0.01f)
				{
					continue;
				}
				if (goUp)
				{
					if (y2 > y && y2 < num)
					{
						num = y2;
						result = i;
					}
				}
				else if (y2 < y && y2 > num)
				{
					num = y2;
					result = i;
				}
			}
			return result;
		}

		private void Authorize(int floor)
		{
			if (!IsValidFloor(floor) || _to == floor || (_hasTrip && Elapsed() < _profile.Duration + arrivalDwell) || (floors[floor].position - floors[_to].position).sqrMagnitude < 0.0001f)
			{
				return;
			}
			int[] array = new int[3]
			{
				_to,
				floor,
				PlatformClock.NowMs
			};
			Apply(array);
			if (PhotonNetwork.InRoom)
			{
				PhotonNetwork.CurrentRoom.SetCustomProperties(new Hashtable { { _key, array } });
			}
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code == 125 && PhotonNetwork.IsMasterClient && photonEvent.CustomData is object[] array && array.Length >= 2 && array[0] is string text && text == _key && array[1] is int floor)
			{
				Authorize(floor);
			}
		}

		public override void OnJoinedRoom()
		{
			ReadRoomState();
		}

		public override void OnRoomPropertiesUpdate(Hashtable changed)
		{
			if (changed != null && changed.TryGetValue(_key, out var value) && value is int[] trip)
			{
				Apply(trip);
			}
		}

		private void ReadRoomState()
		{
			Room currentRoom = PhotonNetwork.CurrentRoom;
			if (currentRoom != null && currentRoom.CustomProperties.TryGetValue(_key, out var value) && value is int[] trip)
			{
				Apply(trip);
				return;
			}
			_from = _to;
			_hasTrip = false;
		}

		private void Apply(int[] trip)
		{
			if (trip != null && trip.Length >= 3 && IsValidFloor(trip[0]) && IsValidFloor(trip[1]))
			{
				_from = trip[0];
				_to = trip[1];
				_startMs = trip[2];
				_profile = new TravelProfile(Vector3.Distance(floors[_from].position, floors[_to].position), moveSpeed, acceleration);
				_hasTrip = true;
			}
		}

		private float Elapsed()
		{
			float num = PlatformClock.SecondsSince(_startMs);
			if (!(num < -5f))
			{
				return num;
			}
			return float.MaxValue;
		}

		private bool IsValidFloor(int i)
		{
			if (i >= 0 && i < floors.Count)
			{
				return floors[i] != null;
			}
			return false;
		}

		private void Update()
		{
			if (IsValidFloor(_to))
			{
				_platform.MoveNow(CarPosition());
			}
			UpdateAudio();
		}

		private Vector3 CarPosition()
		{
			Vector3 position = floors[_to].position;
			if (!_hasTrip || !(_profile.Distance > 0f))
			{
				return position;
			}
			float num = _profile.DistanceAt(Elapsed());
			return Vector3.Lerp(floors[_from].position, position, num / _profile.Distance);
		}

		private void UpdateAudio()
		{
			bool isMoving = IsMoving;
			if (isMoving == _wasMoving)
			{
				return;
			}
			_wasMoving = isMoving;
			if (elevatorMoveAmbience != null)
			{
				if (isMoving)
				{
					elevatorMoveAmbience.Play();
					return;
				}
				elevatorMoveAmbience.Stop();
			}
			else if (isMoving)
			{
				return;
			}
			if (arrivalChime != null)
			{
				arrivalChime.Play();
			}
		}

		private static string HierarchyPath(Transform t)
		{
			string text = t.name;
			Transform parent = t.parent;
			while (parent != null)
			{
				text = parent.name + "/" + text;
				parent = parent.parent;
			}
			return t.gameObject.scene.name + ":" + text;
		}

		private void OnDrawGizmosSelected()
		{
			for (int i = 0; i < floors.Count; i++)
			{
				if (!(floors[i] == null))
				{
					Gizmos.color = ((i == startFloor) ? Color.green : Color.yellow);
					Gizmos.DrawWireSphere(floors[i].position, 0.3f);
				}
			}
		}
	}
}
