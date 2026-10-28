using System;
using System.Collections;
using LethalApeR.Gameplay.ApeGames;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnGhostWristPanel : MonoBehaviour
	{
		[Tooltip("Panel mesh, texts and the three buttons. Active only while the local ghost is up.")]
		public GameObject root;

		public FnButton officeButton;

		public FnButton nextRoomButton;

		public FnButton followButton;

		public TMP_Text title;

		public TMP_Text status;

		public TMP_Text officeLabel;

		public TMP_Text nextRoomLabel;

		public TMP_Text followLabel;

		[Header("Destinations")]
		[Tooltip("NEXT ROOM stops, in order: floor points with +Z as the facing. Each one's name is shown (upper-case ASCII).")]
		public Transform[] roomAnchors = new Transform[0];

		[Tooltip("Level geometry for the FOLLOW wall probe and floor test. FnBarrier colliders are off for ghosts anyway.")]
		public LayerMask wallMask = 1;

		[Header("Feel")]
		[Tooltip("Panel position in the left hand's space (m); the living status panel uses the same wrist.")]
		public Vector3 wristOffset = new Vector3(0f, 0.06f, -0.05f);

		[Tooltip("FOLLOW wall probe radius (m).")]
		public float probeRadius = 0.2f;

		[Tooltip("FOLLOW takes the first side of the target with at least this much room (m), else the roomiest.")]
		public float minFollowRoom = 0.7f;

		[Tooltip("Seconds between accepted presses.")]
		public float pressCooldown = 0.6f;

		private const float SpawnClearRadius = 0.75f;

		private const int LabelChars = 18;

		private const string GuardFallbackFormat = "GUARD {0}";

		private static readonly float[] FollowSides = new float[4] { 180f, 90f, -90f, 0f };

		private readonly int[] _living = new int[3];

		private readonly int[] _candidates = new int[7];

		private readonly Vector3[] _spawnPoints = new Vector3[3];

		private readonly int[] _spawnIndex = new int[3];

		private readonly Vector3[] _others = new Vector3[3];

		private int _room = -1;

		private int _follow;

		private float _nextPress;

		private bool _wasRisen;

		private Coroutine _travel;

		private void Awake()
		{
			if (!(root != base.gameObject))
			{
				Debug.LogError("[FnGhostWristPanel] root must be a child: hiding this object would stop the panel for good.", this);
				root = null;
			}
		}

		private void OnEnable()
		{
			if (officeButton != null)
			{
				officeButton.Pressed += PressOffice;
			}
			if (nextRoomButton != null)
			{
				nextRoomButton.Pressed += PressNextRoom;
			}
			if (followButton != null)
			{
				followButton.Pressed += PressFollow;
			}
			SetText(title, "YOU WERE CAUGHT");
			SetText(officeLabel, "OFFICE");
			SetText(nextRoomLabel, "NEXT ROOM");
			SetText(followLabel, "FOLLOW");
		}

		private void OnDisable()
		{
			if (officeButton != null)
			{
				officeButton.Pressed -= PressOffice;
			}
			if (nextRoomButton != null)
			{
				nextRoomButton.Pressed -= PressNextRoom;
			}
			if (followButton != null)
			{
				followButton.Pressed -= PressFollow;
			}
			if (_travel != null)
			{
				StopCoroutine(_travel);
				_travel = null;
			}
			FnLocalFade.ClearNow(this);
			_wasRisen = false;
		}

		private void LateUpdate()
		{
			bool localRisen = FnGhost.LocalRisen;
			if (_wasRisen != localRisen)
			{
				_wasRisen = localRisen;
				_room = -1;
				_follow = 0;
				SetText(status, "");
			}
			Transform leftHand = FnPlatform.LeftHand;
			Transform head = FnPlatform.Head;
			bool show = localRisen && leftHand != null && head != null;
			if (root != null && root.activeSelf != show)
			{
				root.SetActive(show);
			}
			if (show)
			{
				Vector3 position = leftHand.TransformPoint(wristOffset);
				Vector3 toPanel = position - head.position;
				if (!(toPanel.sqrMagnitude < 1E-06f))
				{
					Vector3 normalized = toPanel.normalized;
					Vector3 upwards = Vector3.Slerp(Vector3.up, head.up, Mathf.Clamp01((Mathf.Abs(normalized.y) + -0.8f) / 0.17f));
					base.transform.SetPositionAndRotation(position, Quaternion.LookRotation(normalized, upwards));
				}
			}
		}

		private bool Accept(bool isLeft)
		{
			// RE: unsure - binary touches only Application's class init on the isLeft path and then returns false; the Application member read was constant-folded
			if (isLeft && !Application.isEditor)
			{
				return false;
			}
			if (!FnGhost.LocalRisen || _travel != null || FnJumpscare.Playing || Time.unscaledTime < _nextPress)
			{
				return false;
			}
			_nextPress = Time.unscaledTime + pressCooldown;
			return true;
		}

		private void PressOffice(bool isLeft)
		{
			if (!Accept(isLeft))
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			FnOffice office = ((instance != null && instance.office != null) ? instance.office : FnOffice.Instance);
			Transform spawn = ((office != null) ? PickSpawn(office, instance) : null);
			if (spawn == null)
			{
				Refuse(officeButton);
				return;
			}
			SetText(status, "OFFICE");
			Travel(spawn.position, spawn.eulerAngles.y);
		}

		private void PressNextRoom(bool isLeft)
		{
			if (!Accept(isLeft))
			{
				return;
			}
			if (roomAnchors != null && roomAnchors.Length > 0)
			{
				int length = roomAnchors.Length;
				for (int i = 0; i < length; i++)
				{
					_room = (_room + 1) % length;
					Transform anchor = roomAnchors[_room];
					if (!(anchor == null))
					{
						SetText(status, FnGhostRules.PanelLabel(anchor.name, LabelChars));
						Travel(anchor.position, anchor.eulerAngles.y);
						return;
					}
				}
			}
			Refuse(nextRoomButton);
		}

		private void PressFollow(bool isLeft)
		{
			if (!Accept(isLeft))
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			int livingCount = ((instance != null) ? Math.Min(instance.LivingGuards(_living), _living.Length) : 0);
			int animMask = 0;
			for (int i = 0; i < FnAnimView.Count; i++)
			{
				if (FnAnimView.Get(i).Active && FnAnimView.Root((FnAnim)i) != null)
				{
					animMask |= 1 << i;
				}
			}
			int count = FnGhostRules.FollowCandidates(_living, livingCount, animMask, FnGame.LocalActor, _candidates);
			for (int j = 0; j < count; j++)
			{
				_follow = FnGhostRules.NextFollowTarget(_candidates, count, _follow);
				if (TryTarget(_follow, out var head, out var forward, out var label))
				{
					Vector3 facing;
					Vector3 spot = FollowSpot(head, forward, out facing);
					SetText(status, string.Format("FOLLOWING {0}", label));
					Travel(FloorBelow(spot), FnGhostRules.Yaw(facing));
					return;
				}
			}
			_follow = 0;
			Refuse(followButton);
		}

		private void Refuse(FnButton button)
		{
			if (button != null)
			{
				button.FlashRefused();
			}
			SetText(status, "UNAVAILABLE");
		}

		private Transform PickSpawn(FnOffice office, FnNight night)
		{
			Transform[] slotSpawns = office.slotSpawns;
			if (slotSpawns == null || slotSpawns.Length < 1)
			{
				return null;
			}
			int spawnCount = 0;
			for (int i = 0; i < slotSpawns.Length && spawnCount < _spawnPoints.Length; i++)
			{
				if (!(slotSpawns[i] == null))
				{
					_spawnPoints[spawnCount] = slotSpawns[i].position;
					_spawnIndex[spawnCount] = i;
					spawnCount++;
				}
			}
			if (spawnCount == 0)
			{
				return null;
			}
			int otherCount = 0;
			int preferred = -1;
			if (night != null)
			{
				int localActor = FnGame.LocalActor;
				for (int j = 0; j < night.GuardSlots && otherCount < _others.Length; j++)
				{
					int actor = night.GuardActor(j);
					if (actor > 0 && actor != localActor && FnGame.TryGetHead(actor, out var head))
					{
						_others[otherCount++] = head;
					}
				}
				int localSlot = night.LocalSlot;
				for (int k = 0; k < spawnCount; k++)
				{
					if (_spawnIndex[k] == localSlot)
					{
						preferred = k;
					}
				}
			}
			int pick = FnGhostRules.FreestSpawn(_spawnPoints, spawnCount, _others, otherCount, preferred, SpawnClearRadius);
			if (pick < 0)
			{
				return null;
			}
			return slotSpawns[_spawnIndex[pick]];
		}

		private bool TryTarget(int target, out Vector3 head, out Vector3 forward, out string label)
		{
			head = Vector3.zero;
			forward = Vector3.forward;
			label = "";
			if (target == 0)
			{
				return false;
			}
			if (target > 0)
			{
				AgNetSync avatar = FnGame.Avatar(target);
				if (avatar == null || avatar.Head == null)
				{
					return false;
				}
				head = avatar.Head.position;
				forward = avatar.Head.forward;
				FnNight instance = FnNight.Instance;
				int slot = -1;
				string name = "";
				if (instance != null)
				{
					slot = instance.SlotOfActor(target);
					if (slot >= 0)
					{
						name = instance.GuardName(slot);
					}
				}
				label = FnGhostRules.PanelLabel(name, LabelChars);
				if (label.Length == 0)
				{
					label = string.Format(GuardFallbackFormat, slot + 1);
				}
				return true;
			}
			FnAnimPose pose = FnAnimView.Get(FnGhostRules.AnimOf(target));
			Transform animRoot = FnAnimView.Root(FnGhostRules.AnimOf(target));
			if (!pose.Active || animRoot == null)
			{
				return false;
			}
			Vector3 headPosition = pose.HeadPosition;
			if (headPosition == Vector3.zero)
			{
				headPosition = animRoot.position + Vector3.up * 1.6f;
			}
			head = headPosition;
			forward = Quaternion.Euler(0f, pose.Yaw, 0f) * Vector3.forward;
			label = FnStrings.AnimName(FnGhostRules.AnimOf(target));
			return true;
		}

		private Vector3 FollowSpot(Vector3 head, Vector3 forward, out Vector3 facing)
		{
			FnSettings.GhostSettings ghost = FnGame.Settings.ghost;
			Vector3 flat = FnGhostRules.FlatForward(forward);
			facing = flat;
			Vector3 best = head;
			float bestRoom = -1f;
			for (int i = 0; i < FollowSides.Length; i++)
			{
				Vector3 direction = Quaternion.AngleAxis(FollowSides[i], Vector3.up) * flat;
				RaycastHit hitInfo;
				float hitDistance = (Physics.SphereCast(head, probeRadius, direction, out hitInfo, ghost.followBackDistance + ghost.followWallMargin, wallMask, QueryTriggerInteraction.Ignore) ? hitInfo.distance : (-1f));
				float room = FnGhostRules.FollowRoom(ghost.followBackDistance, hitDistance, ghost.followWallMargin);
				if (room > bestRoom)
				{
					best = FnGhostRules.FollowPoint(head, -direction, ghost.followBackDistance, hitDistance, ghost.followWallMargin);
					bestRoom = room;
					if (room >= Mathf.Min(minFollowRoom, ghost.followBackDistance))
					{
						break;
					}
				}
			}
			if (bestRoom > 0.05f)
			{
				facing = FnGhostRules.FlatForward(head - best);
			}
			return best;
		}

		private Vector3 FloorBelow(Vector3 point)
		{
			if (Physics.Raycast(point + Vector3.up * 0.1f, Vector3.down, out var hitInfo, 4f, wallMask, QueryTriggerInteraction.Ignore))
			{
				return hitInfo.point;
			}
			return point + Vector3.up * -1.5f;
		}

		private void Travel(Vector3 floor, float yaw)
		{
			if (base.isActiveAndEnabled)
			{
				_travel = StartCoroutine(TravelRoutine(floor, yaw));
			}
		}

		private IEnumerator TravelRoutine(Vector3 floor, float yaw)
		{
			float fade = FnGame.Settings.ghost.teleportFadeSeconds;
			yield return FnLocalFade.Out(this, fade);
			if (FnGhost.LocalRisen)
			{
				FnPlatform.Teleport(floor, yaw);
			}
			yield return null;
			yield return FnLocalFade.In(this, fade);
			_travel = null;
		}

		private static void SetText(TMP_Text text, string value)
		{
			if (!(text == null) && !(text.text == value))
			{
				text.text = value;
			}
		}
	}
}
