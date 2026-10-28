using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnOffice : MonoBehaviour
	{
		[Tooltip("Authoring box for 'inside the office'. Disabled in Awake; tested as a point in box.")]
		public BoxCollider volume;

		[Header("West (index 0) and east (index 1)")]
		public FnDoor westDoor;

		public FnDoor eastDoor;

		public FnHallLight westLight;

		public FnHallLight eastLight;

		[Tooltip("Hall spot just outside each door, where an animatronic stands.")]
		public Transform westOutside;

		public Transform eastOutside;

		[Tooltip("Step-in point in each doorway, on the wall's centre plane.")]
		public Transform westDoorway;

		public Transform eastDoorway;

		[Tooltip("Half the clear doorway width (m): the jambs an animatronic grips when it peeks in.")]
		public float doorHalfWidth = 1.05f;

		[Tooltip("From the doorway plane to the outer face of a shut door panel (m): where knuckles land.")]
		public float doorFaceOffset = 0.045f;

		public FnButton westDoorButton;

		public FnButton eastDoorButton;

		public FnButton westLightButton;

		public FnButton eastLightButton;

		[Header("Anchors")]
		[Tooltip("Slot spawns, index = roster slot.")]
		public Transform[] slotSpawns = new Transform[3];

		public Transform charger;

		public Transform monitor;

		public static FnOffice Instance { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		private void Awake()
		{
			Instance = this;
			if (volume != null && volume.enabled)
			{
				volume.enabled = false;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnEnable()
		{
			if (westDoorButton != null)
			{
				westDoorButton.Pressed += PressWestDoor;
			}
			if (eastDoorButton != null)
			{
				eastDoorButton.Pressed += PressEastDoor;
			}
			if (westLightButton != null)
			{
				westLightButton.Pressed += PressWestLight;
			}
			if (eastLightButton != null)
			{
				eastLightButton.Pressed += PressEastLight;
			}
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.Rejected += OnRejected;
			}
		}

		private void OnDisable()
		{
			if (westDoorButton != null)
			{
				westDoorButton.Pressed -= PressWestDoor;
			}
			if (eastDoorButton != null)
			{
				eastDoorButton.Pressed -= PressEastDoor;
			}
			if (westLightButton != null)
			{
				westLightButton.Pressed -= PressWestLight;
			}
			if (eastLightButton != null)
			{
				eastLightButton.Pressed -= PressEastLight;
			}
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.Rejected -= OnRejected;
			}
		}

		private static void PressWestDoor(bool _)
		{
			Request(door: true, FnDoorSide.West);
		}

		private static void PressEastDoor(bool _)
		{
			Request(door: true, FnDoorSide.East);
		}

		private static void PressWestLight(bool _)
		{
			Request(door: false, FnDoorSide.West);
		}

		private static void PressEastLight(bool _)
		{
			Request(door: false, FnDoorSide.East);
		}

		private static void Request(bool door, FnDoorSide side)
		{
			FnNight instance = FnNight.Instance;
			if (!(instance == null) && instance.LocalIsAlive)
			{
				if (door)
				{
					instance.RequestDoor(side);
				}
				else
				{
					instance.RequestLight(side);
				}
			}
		}

		private void OnRejected(FnRpc request, FnReject reason, int subject)
		{
			FnButton fnButton = request switch
			{
				FnRpc.DoorToggle => (subject == 0) ? westDoorButton : eastDoorButton,
				FnRpc.LightToggle => (subject == 0) ? westLightButton : eastLightButton,
				_ => null,
			};
			if (fnButton != null)
			{
				fnButton.FlashRefused();
			}
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (!(instance == null) && instance.Active)
			{
				if (westDoorButton != null)
				{
					westDoorButton.SetLit(instance.DoorClosed(FnDoorSide.West));
				}
				if (eastDoorButton != null)
				{
					eastDoorButton.SetLit(instance.DoorClosed(FnDoorSide.East));
				}
				if (westLightButton != null)
				{
					westLightButton.SetLit(instance.LightOn(FnDoorSide.West));
				}
				if (eastLightButton != null)
				{
					eastLightButton.SetLit(instance.LightOn(FnDoorSide.East));
				}
			}
		}

		public bool Contains(Vector3 point, float slack)
		{
			if (volume == null)
			{
				return false;
			}
			Transform transform = volume.transform;
			Vector3 vector = transform.InverseTransformPoint(point);
			Vector3 center = volume.center;
			Vector3 lossyScale = transform.lossyScale;
			Vector3 size = volume.size;
			if (Mathf.Abs(vector.x - center.x) * lossyScale.x <= size.x * 0.5f * lossyScale.x + slack && Mathf.Abs(vector.y - center.y) * lossyScale.y <= size.y * 0.5f * lossyScale.y + slack)
			{
				return Mathf.Abs(vector.z - center.z) * lossyScale.z <= size.z * 0.5f * lossyScale.z + slack;
			}
			return false;
		}

		public FnDoor Door(FnDoorSide side)
		{
			if (side != FnDoorSide.West)
			{
				return eastDoor;
			}
			return westDoor;
		}

		public FnHallLight Light(FnDoorSide side)
		{
			if (side != FnDoorSide.West)
			{
				return eastLight;
			}
			return westLight;
		}

		public Transform Outside(FnDoorSide side)
		{
			if (side != FnDoorSide.West)
			{
				return eastOutside;
			}
			return westOutside;
		}

		public Transform Doorway(FnDoorSide side)
		{
			if (side != FnDoorSide.West)
			{
				return eastDoorway;
			}
			return westDoorway;
		}

		public bool DoorFace(FnDoorSide side, out Vector3 point, out Vector3 normal)
		{
			point = (normal = Vector3.zero);
			Transform transform = Doorway(side);
			Transform transform2 = Outside(side);
			if (transform == null || transform2 == null)
			{
				return false;
			}
			normal = transform2.position - transform.position;
			normal.y = 0f;
			if (normal.sqrMagnitude < 0.0001f)
			{
				return false;
			}
			normal = normal.normalized;
			point = transform.position + normal * doorFaceOffset;
			return true;
		}

		public bool NearestDoor(Vector3 from, float range, out FnDoorSide side)
		{
			side = FnDoorSide.West;
			float num = range * range;
			bool result = false;
			for (int i = 0; i < 2; i++)
			{
				Transform transform = Doorway((FnDoorSide)i);
				if (!(transform == null))
				{
					Vector3 position = transform.position;
					float num2 = (position.x - from.x) * (position.x - from.x) + (position.z - from.z) * (position.z - from.z);
					if (num2 < num)
					{
						num = num2;
						result = true;
						side = (FnDoorSide)i;
					}
				}
			}
			return result;
		}

		public Transform SlotSpawn(int slot)
		{
			if (slotSpawns != null && slotSpawns.Length != 0)
			{
				Transform transform = slotSpawns[Mathf.Clamp(slot, 0, slotSpawns.Length - 1)];
				if (transform != null)
				{
					return transform;
				}
			}
			return base.transform;
		}
	}
}
