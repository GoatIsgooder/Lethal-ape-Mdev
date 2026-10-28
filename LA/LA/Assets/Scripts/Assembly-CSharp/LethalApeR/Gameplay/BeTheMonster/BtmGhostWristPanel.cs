using System;
using System.Collections;
using System.Collections.Generic;
using GorillaLocomotion;
using LethalApeR.Gameplay.Fnaf;
using LethalApeR.Networking;
using LethalApeR.SceneFlow;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmGhostWristPanel : MonoBehaviour
	{
		public enum Action
		{
			Lobby = 0,
			Map = 1,
			Follow = 2
		}

		private const int LabelChars = 18;

		private const int MaxPlayers = 32;

		private static readonly float[] FollowSides = new float[4] { 180f, 90f, -90f, 0f };

		[Tooltip("Plate, texts and buttons. A child: switching this object itself off would stop the panel for good.")]
		[SerializeField]
		private GameObject root;

		[SerializeField]
		private TMP_Text status;

		[Header("Placement")]
		[Tooltip("Panel position in the left hand's space (m).")]
		[SerializeField]
		private Vector3 wristOffset = new Vector3(0f, 0.06f, -0.05f);

		[Tooltip("The panel opens when it is within this angle of the gaze...")]
		[SerializeField]
		private float openAngle = 38f;

		[Tooltip("...and closes past this one, so it never flickers at the edge.")]
		[SerializeField]
		private float closeAngle = 52f;

		[SerializeField]
		private float maxViewDistance = 0.75f;

		[Header("Travel")]
		[SerializeField]
		private float pressCooldown = 0.6f;

		[SerializeField]
		private float fadeOut = 0.15f;

		[SerializeField]
		private float fadeIn = 0.25f;

		[SerializeField]
		private float followDistance = 1.8f;

		[SerializeField]
		private float wallMargin = 0.35f;

		[SerializeField]
		private float probeRadius = 0.2f;

		[Tooltip("FOLLOW takes the first side of the target with at least this much room (m), else the roomiest.")]
		[SerializeField]
		private float minFollowRoom = 0.7f;

		[Tooltip("Level geometry for the FOLLOW wall probe and floor test.")]
		[SerializeField]
		private LayerMask wallMask = 1;

		[Tooltip("Rig root height above the floor on arrival, as the BTM spawn points use.")]
		[SerializeField]
		private float rootAboveFloor = 0.5f;

		private readonly int[] _candidates = new int[MaxPlayers];

		private int _follow;

		private float _nextPress;

		private bool _open;

		private bool _travelling;

		private bool _wasDead;

		private void Awake()
		{
			if (!(root != base.gameObject))
			{
				Debug.LogError("[BtmGhostWristPanel] root must be a child: hiding this object would stop the panel for good.", this);
				root = null;
			}
		}

		private void OnDisable()
		{
			_open = false;
			_travelling = false;
			if (root != null)
			{
				root.SetActive(false);
			}
		}

		private void LateUpdate()
		{
			bool dead = BTMGameManager.Instance != null && BTMGameManager.Instance.roomProperties.roundActive && BtmGhost.LocalIsDead;
			if (_wasDead != dead)
			{
				_wasDead = dead;
				_follow = 0;
				SetStatus("");
			}
			Player player = Player.HasInstance ? Player.Instance : null;
			Transform hand = player != null ? player.leftHandTransform : null;
			Transform head = player != null && player.headCollider != null ? player.headCollider.transform : null;
			_open = dead && hand != null && head != null && WristInView(hand, head);
			if (root != null && root.activeSelf != _open)
			{
				root.SetActive(_open);
			}
			if (!_open)
			{
				return;
			}
			Vector3 position = hand.TransformPoint(wristOffset);
			Vector3 toward = position - head.position;
			if (!(toward.sqrMagnitude < 1E-06f))
			{
				Vector3 normalized = toward.normalized;
				Vector3 up = Vector3.Slerp(Vector3.up, head.up, Mathf.InverseLerp(0.8f, 0.97f, Mathf.Abs(normalized.y)));
				base.transform.SetPositionAndRotation(position, Quaternion.LookRotation(normalized, up));
			}
		}

		private bool WristInView(Transform hand, Transform head)
		{
			if (_travelling)
			{
				return _open;
			}
			Vector3 toWrist = hand.TransformPoint(wristOffset) - head.position;
			float distance = toWrist.magnitude;
			if (distance < 0.0001f || distance > maxViewDistance)
			{
				return false;
			}
			return Vector3.Angle(head.forward, toWrist / distance) <= (_open ? closeAngle : openAngle);
		}

		public bool Press(Action action, bool isLeft)
		{
			// RE: unsure - binary returns false for isLeft after only an Application class init; Application.isEditor is constant false in the player build
			if (isLeft && !Application.isEditor)
			{
				return false;
			}
			if (!_open || _travelling || Time.unscaledTime < _nextPress || BTMGameManager.Instance == null)
			{
				return false;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (!instance.roomProperties.roundActive || !BtmGhost.LocalIsDead)
			{
				return false;
			}
			_nextPress = Time.unscaledTime + pressCooldown;
			switch (action)
			{
			case Action.Lobby:
				return GoToSpawn(instance.roomSettings.spawnPoint, "LOBBY");
			case Action.Map:
			{
				MapData currentMap = BtmGhost.CurrentMap;
				if (currentMap == null || currentMap.survivoursTp == null)
				{
					SetStatus("NO ROUND RUNNING");
					return true;
				}
				string label = FnGhostRules.PanelLabel(currentMap.displayName, LabelChars);
				return GoToSpawn(currentMap.survivoursTp, (label.Length > 0) ? label : "MAP");
			}
			case Action.Follow:
				FollowNext(instance.roomProperties);
				return true;
			default:
				return false;
			}
		}

		private bool GoToSpawn(RandomizeSpawnPoint spawn, string label)
		{
			if (spawn == null)
			{
				return false;
			}
			SetStatus(label);
			float? headYaw = null;
			if (spawn.forceLookDirection)
			{
				Vector3 forward = spawn.LookRotation() * Vector3.forward;
				headYaw = Mathf.Atan2(forward.x, forward.z) * 57.29578f;
			}
			Travel(spawn.GetRandomPoint(), headYaw);
			return true;
		}

		private void FollowNext(RoundProperties props)
		{
			int self = PhotonNetwork.LocalPlayer != null ? PhotonNetwork.LocalPlayer.ActorNumber : -1;
			Vector3 facing = default(Vector3);
			if (props.roundActive)
			{
				int count = BtmGhostRules.FollowCandidates(props.activePlayers, self, _candidates);
				for (int i = 0; i < count; i++)
				{
					_follow = FnGhostRules.NextFollowTarget(_candidates, count, _follow);
					MonkeDevNetworkingPlayer target = MonkeDevNetworkingManager.Manager != null ? MonkeDevNetworkingManager.Manager.GetPlayerByActorId(_follow) : null;
					if (!(target == null) && !(target.Head == null))
					{
						Vector3 spot = FollowSpot(target.Head.position, target.Head.forward, out facing);
						SetStatus("WATCHING " + NameOf(target));
						Travel(FloorBelow(spot) + Vector3.up * rootAboveFloor, Mathf.Atan2(facing.x, facing.z) * 57.29578f);
						return;
					}
				}
			}
			_follow = 0;
			SetStatus("NO ONE LEFT");
		}

		private Vector3 FollowSpot(Vector3 head, Vector3 forward, out Vector3 facing)
		{
			Vector3 flat = FnGhostRules.FlatForward(forward);
			Vector3 best = head;
			float bestRoom = -1f;
			for (int i = 0; i < FollowSides.Length; i++)
			{
				Vector3 direction = Quaternion.AngleAxis(FollowSides[i], Vector3.up) * flat;
				RaycastHit hitInfo;
				float hitDistance = Physics.SphereCast(head, probeRadius, direction, out hitInfo, followDistance + wallMargin, wallMask, QueryTriggerInteraction.Ignore) ? hitInfo.distance : -1f;
				float room = FnGhostRules.FollowRoom(followDistance, hitDistance, wallMargin);
				if (room > bestRoom)
				{
					best = FnGhostRules.FollowPoint(head, -direction, followDistance, hitDistance, wallMargin);
					bestRoom = room;
					if (room >= Mathf.Min(minFollowRoom, followDistance))
					{
						break;
					}
				}
			}
			if (bestRoom > 0.05f)
			{
				flat = FnGhostRules.FlatForward(head - best);
			}
			facing = flat;
			return best;
		}

		private Vector3 FloorBelow(Vector3 point)
		{
			RaycastHit hitInfo;
			if (Physics.Raycast(point + Vector3.up * 0.1f, Vector3.down, out hitInfo, 4f, wallMask, QueryTriggerInteraction.Ignore))
			{
				return hitInfo.point;
			}
			return point + Vector3.up * -1.5f;
		}

		private void Travel(Vector3 rootPosition, float? headYaw)
		{
			if (base.isActiveAndEnabled)
			{
				StartCoroutine(TravelRoutine(rootPosition, headYaw));
			}
		}

		private IEnumerator TravelRoutine(Vector3 rootPosition, float? headYaw)
		{
			_travelling = true;
			yield return SceneTransition.FadeOut(fadeOut);
			if (BtmGhost.LocalDeadNow())
			{
				Teleport(rootPosition, headYaw);
			}
			yield return null;
			yield return SceneTransition.FadeIn(fadeIn);
			_travelling = false;
		}

		private static void Teleport(Vector3 position, float? headYaw)
		{
			if (!Player.HasInstance || Player.Instance.headCollider == null)
			{
				return;
			}
			Player instance = Player.Instance;
			Transform rig = instance.transform;
			Transform head = instance.headCollider.transform;
			Quaternion rotation = rig.rotation;
			if (headYaw.HasValue)
			{
				float delta = Mathf.DeltaAngle(rig.eulerAngles.y, head.eulerAngles.y);
				rotation = Quaternion.Euler(0f, headYaw.Value - delta, 0f);
				rig.rotation = rotation;
			}
			Vector3 offset = head.position - rig.position;
			instance.TeleportPlayerRaw(new Vector3(position.x - offset.x, position.y, position.z - offset.z), rotation, headYaw.HasValue);
		}

		private void SetStatus(string text)
		{
			if (status != null && !(status.text == text))
			{
				status.text = text;
			}
		}

		private static string NameOf(MonkeDevNetworkingPlayer target)
		{
			string label = FnGhostRules.PanelLabel((target.photonView != null && target.photonView.Owner != null) ? target.photonView.Owner.NickName : "", 9);
			if (label.Length < 1)
			{
				return "SURVIVOR";
			}
			return label;
		}
	}
}
