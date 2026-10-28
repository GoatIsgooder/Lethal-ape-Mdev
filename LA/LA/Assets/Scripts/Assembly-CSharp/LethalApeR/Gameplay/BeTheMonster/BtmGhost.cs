using System.Collections.Generic;
using LethalApeR.Gameplay.Fnaf;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Voice.Unity;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DisallowMultipleComponent]
	public class BtmGhost : MonoBehaviour
	{
		private const byte KindBody = 0;

		private const byte KindName = 1;

		private const byte KindSkeleton = 2;

		private static readonly int GhostSeeAllId = Shader.PropertyToID("_GhostSeeAll");

		[SerializeField]
		private MonkeDevNetworkingPlayer player;

		[Tooltip("Ghost skeleton with its own armature and arm IK, normally inactive. Shown only while a ghost.")]
		[SerializeField]
		private GameObject skeleton;

		[Tooltip("Head/PlayerName: name text and tag cosmetics. Only viewers who see ghosts plainly see it on a ghost.")]
		[SerializeField]
		private Transform nameTag;

		[Header("Living survivors")]
		[Tooltip("Past this the skeleton is not drawn at all; the shader has faded it out from 1.5 m to 3 m already.")]
		[SerializeField]
		private float hideBeyond = 3.25f;

		[SerializeField]
		private float voiceFullWithin = 3f;

		[SerializeField]
		private float voiceSilentBeyond = 8f;

		[Header("Owner")]
		[SerializeField]
		private float gravity = 2.45f;

		[SerializeField]
		private float drag = 0.8f;

		[Header("Map")]
		[Tooltip("Grows the map's renderer extent on every side, so a ghost on a roof is still in the map.")]
		[SerializeField]
		private float mapMargin = 2f;

		private static readonly Dictionary<GameObject, Bounds> MapBounds = new Dictionary<GameObject, Bounds>();

		private static int _frameResolved = -1;

		private static BtmGhostViewer _localViewer;

		private static MapData _currentMap;

		private static bool _currentMapBounded;

		private static Bounds _currentMapBounds;

		private static float _appliedSeeAll = -1f;

		private readonly List<Renderer> _scanRenderers = new List<Renderer>(64);

		private Renderer[] _renderers = new Renderer[0];

		private byte[] _kinds = new byte[0];

		private Collider[] _colliders = new Collider[0];

		private bool[] _colliderWasOn = new bool[0];

		private int _scannedCount = -1;

		private bool _applied;

		private bool _appliedGhost;

		private BtmGhostViewer _appliedViewer;

		private bool _appliedSkeletonShown;

		private bool _appliedHeld;

		private Vector3 _holdAt;

		private float _holdUntil = -1f;

		private const float HoldRadius = 2.5f;

		private bool _collidersOff;

		private bool _voiceTouched;

		private FnGhostVoice _voice;

		private bool _motion;

		private float _savedDamping;

		public static bool LocalIsDead { get; private set; }

		public static bool LocalIsGhost { get; private set; }

		public bool IsGhost { get; private set; }

		private bool IsMine => player != null && player.photonView != null && player.photonView.IsMine;

		public static MapData CurrentMap => _currentMap;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			MapBounds.Clear();
			_frameResolved = -1;
			_currentMap = null;
			_appliedSeeAll = -1f;
			LocalIsDead = false;
			LocalIsGhost = false;
		}

		private void OnEnable()
		{
			_scannedCount = -1;
			_applied = false;
		}

		private void OnDisable()
		{
			for (int i = 0; i < _renderers.Length; i++)
			{
				if (_renderers[i] != null && _renderers[i].forceRenderingOff)
				{
					_renderers[i].forceRenderingOff = false;
				}
			}
			SetColliders(false);
			DetachVoice();
			_voiceTouched = false;
			IsGhost = false;
			_applied = false;
			EndMotion();
			if (IsMine)
			{
				LocalIsDead = false;
				LocalIsGhost = false;
				SetSeeAll(0f);
			}
		}

		private void LateUpdate()
		{
			if (player == null || player.photonView == null)
			{
				EndMotion();
				return;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance == null)
			{
				if (_applied && (_appliedGhost || _appliedHeld))
				{
					Apply(false, BtmGhostViewer.Plain, false, false);
				}
				if (IsMine)
				{
					ExitLocal();
				}
				return;
			}
			ResolveFrame(instance);
			bool roundActive = instance.roomProperties.roundActive;
			bool dead = BtmGhostRules.IsDead(player.photonView.OwnerActorNr, roundActive, instance.roomProperties.originalActivePlayers, instance.roomProperties.activePlayers, instance.roomProperties.escapedPlayers, instance.roomProperties.currentMonsters);
			bool isMine = IsMine;
			Vector3 head = HeadPosition(isMine);
			bool ghost = false;
			if (dead)
			{
				bool inMap = _currentMapBounded && BtmGhostRules.InMap(_currentMapBounds, head, mapMargin);
				ghost = BtmGhostRules.PresentsAsGhost(dead, inMap, BtmSpawnArea.Contains(head));
			}
			BtmGhostViewer viewer = (isMine ? BtmGhostViewer.Plain : _localViewer);
			float distance = (isMine ? 0f : DistanceToListener(head));
			bool skeletonShown = ghost && BtmGhostRules.SkeletonVisible(viewer, distance, hideBeyond);
			bool held = _holdUntil > 0f && Time.time < _holdUntil && (head - _holdAt).sqrMagnitude < HoldRadius * HoldRadius;
			if (!held)
			{
				_holdUntil = -1f;
			}
			if (base.transform.hierarchyCount != _scannedCount)
			{
				Rescan();
			}
			if (!_applied || _appliedGhost != ghost || _appliedViewer != viewer || _appliedSkeletonShown != skeletonShown || _appliedHeld != held)
			{
				Apply(ghost, viewer, skeletonShown, held);
			}
			if (isMine)
			{
				UpdateLocal(roundActive, dead, ghost);
				return;
			}
			EndMotion();
			ApplyVoice(dead, viewer, distance);
		}

		private static void ResolveFrame(BTMGameManager manager)
		{
			if (_frameResolved == Time.frameCount)
			{
				return;
			}
			_frameResolved = Time.frameCount;
			bool roundActive = manager.roomProperties.roundActive;
			string currentMap = manager.roomProperties.currentMap;
			_localViewer = ((PhotonNetwork.LocalPlayer != null) ? BtmGhostRules.Viewer(PhotonNetwork.LocalPlayer.ActorNumber, roundActive, manager.roomProperties.activePlayers, manager.roomProperties.currentMonsters) : BtmGhostViewer.Plain);
			_currentMap = null;
			if (roundActive && !string.IsNullOrEmpty(currentMap))
			{
				List<MapData> maps = manager.roomSettings.maps;
				for (int i = 0; i < maps.Count; i++)
				{
					if (maps[i] != null && maps[i].sceneId == currentMap)
					{
						_currentMap = maps[i];
						break;
					}
				}
			}
			_currentMapBounded = _currentMap != null && _currentMap.mapObject != null && TryGetBounds(_currentMap.mapObject, out _currentMapBounds);
		}

		private static bool TryGetBounds(GameObject map, out Bounds bounds)
		{
			if (MapBounds.TryGetValue(map, out bounds))
			{
				return true;
			}
			if (!map.activeInHierarchy)
			{
				return false;
			}
			Renderer[] renderers = map.GetComponentsInChildren<Renderer>();
			bool any = false;
			foreach (Renderer renderer in renderers)
			{
				if (renderer is MeshRenderer || renderer is SkinnedMeshRenderer)
				{
					if (any)
					{
						bounds.Encapsulate(renderer.bounds);
					}
					else
					{
						bounds = renderer.bounds;
					}
					any = true;
				}
			}
			if (!any)
			{
				return false;
			}
			MapBounds[map] = bounds;
			return true;
		}

		private Vector3 HeadPosition(bool mine)
		{
			if (mine && GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance.headCollider != null)
			{
				return GorillaLocomotion.Player.Instance.headCollider.transform.position;
			}
			if (player.Head != null)
			{
				return player.Head.position;
			}
			return base.transform.position;
		}

		private static float DistanceToListener(Vector3 head)
		{
			Transform listener = ((GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance.headCollider != null) ? GorillaLocomotion.Player.Instance.headCollider.transform : null);
			if (listener != null)
			{
				return Vector3.Distance(listener.position, head);
			}
			return float.MaxValue;
		}

		public void HoldBodyHidden(Vector3 at, float seconds)
		{
			_holdAt = at;
			_holdUntil = Time.time + Mathf.Max(0f, seconds);
		}

		private void Apply(bool ghost, BtmGhostViewer viewer, bool skeletonShown, bool held)
		{
			_applied = true;
			_appliedGhost = ghost;
			_appliedViewer = viewer;
			_appliedSkeletonShown = skeletonShown;
			_appliedHeld = held;
			IsGhost = ghost;
			bool skeletonOff = !skeletonShown;
			bool nameOff = (ghost && !BtmGhostRules.NameVisible(viewer)) || held;
			bool bodyOff = ghost || held;
			for (int i = 0; i < _renderers.Length; i++)
			{
				Renderer renderer = _renderers[i];
				if (renderer == null)
				{
					_scannedCount = -1;
					continue;
				}
				byte kind = _kinds[i];
				bool off = ((kind == KindSkeleton) ? skeletonOff : ((kind == KindName) ? nameOff : bodyOff));
				if (renderer.forceRenderingOff != off)
				{
					renderer.forceRenderingOff = off;
				}
			}
			bool showSkeleton = ghost && viewer != BtmGhostViewer.Monster;
			if (skeleton != null && skeleton.activeSelf != showSkeleton)
			{
				skeleton.SetActive(showSkeleton);
			}
			SetColliders(BtmGhostRules.CollidersOff(ghost, IsMine));
		}

		private void ApplyVoice(bool dead, BtmGhostViewer viewer, float distance)
		{
			FnVoiceMode mode = BtmGhostRules.VoiceMode(dead, viewer, distance, voiceSilentBeyond);
			if (mode == FnVoiceMode.Plain)
			{
				if (_voiceTouched)
				{
					DetachVoice();
				}
				_voiceTouched = false;
				return;
			}
			if (_voice == null)
			{
				_voice = AttachVoice();
			}
			if (!(_voice == null))
			{
				_voiceTouched = true;
				float gain = 1f;
				if (distance > voiceFullWithin)
				{
					gain = 0f;
					if (distance < voiceSilentBeyond)
					{
						gain = 1f - (distance - voiceFullWithin) / (voiceSilentBeyond - voiceFullWithin);
					}
				}
				_voice.Apply(mode, gain);
			}
		}

		private FnGhostVoice AttachVoice()
		{
			Speaker speaker = ((player != null && player.PhotonVoiceSpeaker != null) ? player.PhotonVoiceSpeaker : GetComponentInChildren<Speaker>(true));
			if (speaker == null)
			{
				return null;
			}
			FnGhostVoice voice = speaker.GetComponent<FnGhostVoice>();
			if (voice != null)
			{
				return voice;
			}
			return speaker.gameObject.AddComponent<FnGhostVoice>();
		}

		private void DetachVoice()
		{
			if (!(_voice == null))
			{
				_voice.Apply(FnVoiceMode.Plain, 1f);
				Object.Destroy(_voice);
				_voice = null;
			}
		}

		private void UpdateLocal(bool roundActive, bool dead, bool ghost)
		{
			LocalIsDead = dead;
			LocalIsGhost = ghost;
			if (ghost)
			{
				BeginMotion();
			}
			else
			{
				EndMotion();
			}
			SetSeeAll((_localViewer == BtmGhostViewer.Survivor) ? 0f : 1f);
		}

		private void ExitLocal()
		{
			EndMotion();
			LocalIsDead = false;
			LocalIsGhost = false;
			SetSeeAll(0f);
		}

		private static void SetSeeAll(float value)
		{
			if (!Mathf.Approximately(value, _appliedSeeAll))
			{
				_appliedSeeAll = value;
				Shader.SetGlobalFloat(GhostSeeAllId, value);
			}
		}

		private void BeginMotion()
		{
			if (_motion || !GorillaLocomotion.Player.HasInstance)
			{
				return;
			}
			Rigidbody playerRigidBody = GorillaLocomotion.Player.Instance.playerRigidBody;
			if (!(playerRigidBody == null))
			{
				_motion = true;
				_savedDamping = playerRigidBody.linearDamping;
				RigHold.Take(this, RigHold.What.Gravity);
				playerRigidBody.linearDamping = drag;
			}
		}

		private void EndMotion()
		{
			if (!_motion)
			{
				return;
			}
			_motion = false;
			RigHold.Give(this, RigHold.What.Gravity);
			if (GorillaLocomotion.Player.HasInstance)
			{
				Rigidbody playerRigidBody = GorillaLocomotion.Player.Instance.playerRigidBody;
				if (!(playerRigidBody == null))
				{
					playerRigidBody.linearDamping = _savedDamping;
				}
			}
		}

		private void FixedUpdate()
		{
			if (_motion && GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				Rigidbody playerRigidBody = instance.playerRigidBody;
				if (!(playerRigidBody == null) && !playerRigidBody.isKinematic && !RigHold.Anyone(RigHold.What.Movement))
				{
					float scale = Mathf.Max(instance.CurrentScale, 0.01f);
					playerRigidBody.AddForce(Vector3.down * (gravity * scale * Time.fixedDeltaTime), ForceMode.VelocityChange);
				}
			}
		}

		public static bool ReturnLocalToMap()
		{
			if (!LocalIsGhost || !LocalDeadNow())
			{
				return false;
			}
			if (_currentMap == null || _currentMap.survivoursTp == null || !GorillaLocomotion.Player.HasInstance)
			{
				return false;
			}
			GorillaLocomotion.Player.Instance.TeleportPlayerRaw(_currentMap.survivoursTp.GetRandomPointInDisc(), Quaternion.identity, false, true);
			return true;
		}

		public static bool LocalDeadNow()
		{
			BTMGameManager instance = BTMGameManager.Instance;
			Photon.Realtime.Player localPlayer = PhotonNetwork.LocalPlayer;
			if (instance == null || localPlayer == null)
			{
				return false;
			}
			return BtmGhostRules.IsDead(localPlayer.ActorNumber, instance.roomProperties.roundActive, instance.roomProperties.originalActivePlayers, instance.roomProperties.activePlayers, instance.roomProperties.escapedPlayers, instance.roomProperties.currentMonsters);
		}

		private void Rescan()
		{
			SetColliders(false);
			_scannedCount = base.transform.hierarchyCount;
			for (int i = 0; i < _renderers.Length; i++)
			{
				if (_renderers[i] != null && _renderers[i].forceRenderingOff)
				{
					_renderers[i].forceRenderingOff = false;
				}
			}
			GetComponentsInChildren(true, _scanRenderers);
			if (_scanRenderers.Count != _renderers.Length)
			{
				_renderers = new Renderer[_scanRenderers.Count];
				_kinds = new byte[_scanRenderers.Count];
			}
			for (int j = 0; j < _scanRenderers.Count; j++)
			{
				Renderer renderer = _scanRenderers[j];
				_renderers[j] = renderer;
				_kinds[j] = KindOf(renderer.transform);
			}
			_scanRenderers.Clear();
			_colliders = GetComponentsInChildren<Collider>(true);
			_colliderWasOn = new bool[_colliders.Length];
			_applied = false;
		}

		private byte KindOf(Transform t)
		{
			if (skeleton != null && t.IsChildOf(skeleton.transform))
			{
				return KindSkeleton;
			}
			if (nameTag != null && t.IsChildOf(nameTag))
			{
				return KindName;
			}
			return KindBody;
		}

		private void SetColliders(bool off)
		{
			if (off)
			{
				if (!_collidersOff)
				{
					_collidersOff = true;
					for (int i = 0; i < _colliders.Length; i++)
					{
						_colliderWasOn[i] = _colliders[i] != null && _colliders[i].enabled;
					}
				}
				for (int j = 0; j < _colliders.Length; j++)
				{
					Collider collider = _colliders[j];
					if (collider != null && collider.enabled)
					{
						collider.enabled = false;
					}
				}
			}
			else
			{
				if (!_collidersOff)
				{
					return;
				}
				_collidersOff = false;
				for (int k = 0; k < _colliders.Length; k++)
				{
					Collider collider2 = _colliders[k];
					if (collider2 != null && _colliderWasOn[k] && !collider2.enabled)
					{
						collider2.enabled = true;
					}
				}
			}
		}
	}
}
