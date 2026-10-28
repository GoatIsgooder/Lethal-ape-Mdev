using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(10350)]
	public class BtmMonsterHand : MonoBehaviourPun
	{
		private static readonly Collider[] Nearby = new Collider[16];

		private static readonly List<Collider> RigSolids = new List<Collider>();

		private static readonly List<Collider> PartColliders = new List<Collider>();

		private static readonly List<Collider> RigColliders = new List<Collider>();

		private const float ClearSeconds = 2f;

		private BtmBodyPart _carried;

		private BtmBodyPart _brushedPart;

		private Rigidbody _brushedBone;

		private float _brushedAt = float.NegativeInfinity;

		private const float GrabTimeLimit = 10f;

		private const float HoldHapticInterval = 0.2f;

		private const float GrabRetryInterval = 0.25f;

		private const float KillRepeat = 1f;

		public BtmMonsterHand otherHand;

		public string detectTag = "";

		public bool isLeftHand;

		[Tooltip("The chainsaw this trigger sits on, if any: then the hand only cuts. It never grabs, and the revving bar kills.")]
		public BtmChainsawFx saw;

		public bool wantsToGrabPlayer;

		public bool isGrabbing;

		public MonkeDevNetworkingPlayer grabbedPlayer;

		private SphereCollider _fist;

		private float _authoredRadius = -1f;

		private bool _reachResolved;

		private Transform _wrist;

		private Transform _reachTarget;

		private Vector3 _lastReach;

		private bool _hasLastReach;

		private float _nextGrabTime;

		private float _grabStartTime;

		private float _nextHoldHaptic;

		private MonkeDevNetworkingPlayer _touched;

		private float _touchedAt = float.NegativeInfinity;

		private int _fistFrame = -1;

		private Vector3 _fistFrom;

		private Vector3 _fistTo;

		private int _lastKilled = -1;

		private float _lastKillTime;

		private Vector3 _lastBladeTip;

		private Vector3 _lastBladeMid;

		private bool _hasLastBlade;

		private int _bladeFrame = -1;

		private Vector3 _bladeStart;

		private Vector3 _bladeTip;

		private Vector3 _reachStart;

		private Vector3 _reachTip;

		private Vector3 _reachMid;

		private Vector3 _sweptTipFrom;

		private Vector3 _sweptMidFrom;

		private float _bladeRadius;

		private bool _bladeSwept;

		public static readonly List<BtmMonsterHand> SawHands = new List<BtmMonsterHand>();

		public static readonly List<BtmMonsterHand> FistHands = new List<BtmMonsterHand>();

		private readonly Dictionary<MonkeDevNetworkingPlayer, CapsuleCollider> _bodies = new Dictionary<MonkeDevNetworkingPlayer, CapsuleCollider>();

		public bool IsCarrying => _carried;

		public Vector3 FistCenter
		{
			get
			{
				if (!_fist)
				{
					_fist = GetComponent<SphereCollider>();
				}
				if (_fist)
				{
					return transform.TransformPoint(_fist.center);
				}
				return transform.position;
			}
		}

		public float FistRadius
		{
			get
			{
				if (!_fist)
				{
					_fist = GetComponent<SphereCollider>();
				}
				if (!_fist)
				{
					return 0.1f;
				}
				Vector3 scale = transform.lossyScale;
				return _fist.radius * Mathf.Max(Mathf.Abs(scale.x), Mathf.Max(Mathf.Abs(scale.y), Mathf.Abs(scale.z)));
			}
		}

		public static BtmMonsterHand Of(int actor, bool left)
		{
			foreach (BtmMonsterHand hand in FistHands)
			{
				if (hand && hand.isLeftHand == left && hand.photonView != null && hand.photonView.OwnerActorNr == actor)
				{
					return hand;
				}
			}
			return null;
		}

		private void Carry()
		{
			if ((object)_carried != null)
			{
				if (!_carried || !_carried.HeldBy(transform) || !wantsToGrabPlayer)
				{
					DropCarried();
				}
				return;
			}
			if (BtmBodyPart.All.Count == 0 || isGrabbing)
			{
				return;
			}
			if (Touching(out var part, out var bone))
			{
				_brushedPart = part;
				_brushedBone = bone;
				_brushedAt = Time.time;
			}
			if (wantsToGrabPlayer && _brushedPart && _brushedBone && !(Time.time - _brushedAt > BtmGrabReach.ContactGrace) && !_brushedPart.Held && !_brushedPart.Retiring)
			{
				PickUp(_brushedPart, _brushedBone);
				_brushedPart = null;
			}
		}

		private bool Touching(out BtmBodyPart part, out Rigidbody bone)
		{
			part = null;
			bone = null;
			float best = float.MaxValue;
			float radius = FistRadius;
			int mask = 1 << BtmCorpse.RagdollLayer;
			Probe(FistCenter, radius, mask, ref part, ref bone, ref best);
			if (_fistFrame == Time.frameCount)
			{
				Probe(_fistTo, radius, mask, ref part, ref bone, ref best);
			}
			return part;
		}

		private static void Probe(Vector3 at, float radius, int mask, ref BtmBodyPart part, ref Rigidbody bone, ref float best)
		{
			int count = Physics.OverlapSphereNonAlloc(at, radius, Nearby, mask, QueryTriggerInteraction.Ignore);
			for (int i = 0; i < count; i++)
			{
				Collider collider = Nearby[i];
				Rigidbody body = collider.attachedRigidbody;
				if (!body)
				{
					continue;
				}
				BtmBodyPart candidate = body.GetComponentInParent<BtmBodyPart>();
				if (!candidate || candidate.Held || candidate.Retiring || candidate.BoneOf(body) < 0)
				{
					continue;
				}
				float distance = (collider.ClosestPoint(at) - at).sqrMagnitude;
				if (!(distance >= best))
				{
					best = distance;
					part = candidate;
					bone = body;
				}
			}
		}

		private void PickUp(BtmBodyPart part, Rigidbody bone)
		{
			Transform hand = transform;
			Vector3 offset = Quaternion.Inverse(hand.rotation) * (bone.position - hand.position);
			Quaternion turn = Quaternion.Inverse(hand.rotation) * bone.rotation;
			int boneIndex = part.BoneOf(bone);
			if (!part.Hold(hand, 0, boneIndex, offset, turn))
			{
				return;
			}
			_carried = part;
			IgnoreRig(part, ignore: true);
			Pulse(0.5f, 0.12f);
			if (part.Victim >= 0)
			{
				BTMGameManager instance = BTMGameManager.Instance;
				if (instance && PhotonNetwork.InRoom)
				{
					instance.photonView.RPC("RPC_PickUpPart", RpcTarget.Others, part.Victim, part.Key, boneIndex, isLeftHand, offset, turn, part.Size);
				}
			}
		}

		private void DropCarried()
		{
			BtmBodyPart part = _carried;
			_carried = null;
			if (!part || !part.HeldBy(transform) || !part.HeldPose(out var _, out var position, out var rotation, out var velocity, out var spin))
			{
				return;
			}
			part.Let(velocity, spin);
			if (isActiveAndEnabled)
			{
				StartCoroutine(CollideWithRigOnceClear(part));
			}
			Pulse(0.2f, 0.06f);
			if (part.Victim >= 0)
			{
				BTMGameManager instance = BTMGameManager.Instance;
				if (instance && PhotonNetwork.InRoom)
				{
					instance.photonView.RPC("RPC_DropPart", RpcTarget.Others, part.Victim, part.Key, position, rotation, velocity, spin);
				}
			}
		}

		private static IEnumerator CollideWithRigOnceClear(BtmBodyPart part)
		{
			float until = Time.time + ClearSeconds;
			while (part && !part.Held && Time.time < until)
			{
				if (!OverlapsRig(part))
				{
					IgnoreRig(part, ignore: false);
					yield break;
				}
				yield return null;
			}
		}

		private static void IgnoreRig(BtmBodyPart part, bool ignore)
		{
			if (!part || !CollectRigSolids())
			{
				return;
			}
			part.GetComponentsInChildren(true, PartColliders);
			foreach (Collider solid in RigSolids)
			{
				foreach (Collider collider in PartColliders)
				{
					if (solid && collider)
					{
						Physics.IgnoreCollision(solid, collider, ignore);
					}
				}
			}
		}

		private static bool OverlapsRig(BtmBodyPart part)
		{
			if (!CollectRigSolids())
			{
				return false;
			}
			part.GetComponentsInChildren(PartColliders);
			foreach (Collider solid in RigSolids)
			{
				if (!solid || !solid.enabled || !solid.gameObject.activeInHierarchy)
				{
					continue;
				}
				Bounds bounds = solid.bounds;
				bounds.Expand(0.05f);
				foreach (Collider collider in PartColliders)
				{
					if (collider && collider.enabled && bounds.Intersects(collider.bounds))
					{
						return true;
					}
				}
			}
			return false;
		}

		private static bool CollectRigSolids()
		{
			RigSolids.Clear();
			if (!GorillaLocomotion.Player.HasInstance || !GorillaLocomotion.Player.Instance)
			{
				return false;
			}
			GorillaLocomotion.Player.Instance.GetComponentsInChildren(true, RigColliders);
			foreach (Collider collider in RigColliders)
			{
				if (collider.isTrigger)
				{
					continue;
				}
				Rigidbody body = collider.attachedRigidbody;
				if (!body || !(body != GorillaLocomotion.Player.Instance.playerRigidBody))
				{
					RigSolids.Add(collider);
				}
			}
			return RigSolids.Count > 0;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			SawHands.Clear();
			FistHands.Clear();
		}

		public void SetReachMultiplier(float multiplier)
		{
			if (!_fist)
			{
				_fist = GetComponent<SphereCollider>();
			}
			if (!_fist)
			{
				Debug.LogWarning("[BtmMonsterHand] " + name + ": no SphereCollider, reach powerup skipped.", this);
				return;
			}
			if (_authoredRadius < 0f)
			{
				_authoredRadius = _fist.radius;
			}
			_fist.radius = _authoredRadius * Mathf.Max(0.1f, multiplier);
		}

		internal static bool LocalIsLiveMonster()
		{
			int actor = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
			BTMGameManager instance = BTMGameManager.Instance;
			if (!instance)
			{
				return false;
			}
			if (instance.roomProperties.roundActive && instance.roomProperties.currentMonsters != null)
			{
				return Array.IndexOf(instance.roomProperties.currentMonsters, actor) >= 0;
			}
			return false;
		}

		internal static bool IsLiveSurvivor(MonkeDevNetworkingPlayer p)
		{
			if (!p || p.photonView == null || p.photonView.IsMine)
			{
				return false;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (!instance)
			{
				return false;
			}
			RoundProperties props = instance.roomProperties;
			int actor = p.photonView.OwnerActorNr;
			if (!props.roundActive || props.activePlayers == null)
			{
				return false;
			}
			if (Array.IndexOf(props.activePlayers, actor) < 0)
			{
				return false;
			}
			if (props.currentMonsters != null && Array.IndexOf(props.currentMonsters, actor) >= 0)
			{
				return false;
			}
			GameModePlayer gameModePlayer = p.gameModePlayer;
			if (gameModePlayer == null)
			{
				return true;
			}
			if (!gameModePlayer.isEliminated)
			{
				return !gameModePlayer.isMonster;
			}
			return false;
		}

		private void OnTriggerStay(Collider other)
		{
			if (photonView.IsMine && other.CompareTag(detectTag))
			{
				MonkeDevNetworkingPlayer victim = other.GetComponentInParent<MonkeDevNetworkingPlayer>();
				if (victim)
				{
					Touch(victim);
				}
			}
		}

		private void LateUpdate()
		{
			if (!photonView.IsMine || MonkeDevNetworkingManager.Manager == null)
			{
				return;
			}
			List<MonkeDevNetworkingPlayer> players = MonkeDevNetworkingManager.Manager.Players;
			bool reached = ResolveReach();
			if (reached && !saw)
			{
				SweepFist(players);
			}
			SweepBlade(players, reached);
			if (!saw)
			{
				Carry();
			}
		}

		private void SweepFist(List<MonkeDevNetworkingPlayer> players)
		{
			Vector3 fist = transform.TransformPoint(_fist.center);
			Vector3 reach = BtmGrabReach.FistAtTarget(fist, _wrist.position, _wrist.rotation, _reachTarget.position, _reachTarget.rotation);
			Vector3 from = reach;
			if (_hasLastReach && !((reach - _lastReach).sqrMagnitude > BtmGrabReach.MaxSweep))
			{
				from = _lastReach;
			}
			_lastReach = reach;
			_hasLastReach = true;
			_fistFrom = from;
			_fistTo = reach;
			_fistFrame = Time.frameCount;
			float radius = FistRadius;
			for (int i = players.Count - 1; i >= 0; i--)
			{
				if (i >= players.Count)
				{
					continue;
				}
				MonkeDevNetworkingPlayer player = players[i];
				if (!player || player.photonView == null || player.photonView.IsMine)
				{
					continue;
				}
				CapsuleCollider body = BodyOf(player);
				if (body && body.enabled && body.gameObject.activeInHierarchy)
				{
					BtmGrabReach.Segment(body, out var a, out var b, out var bodyRadius);
					float reachRadius = radius + bodyRadius;
					if (!(BtmGrabReach.SegmentDistanceSqr(from, reach, a, b) > reachRadius * reachRadius))
					{
						Touch(player);
					}
				}
			}
		}

		private void SweepBlade(List<MonkeDevNetworkingPlayer> players, bool reached)
		{
			if (!saw || !saw.Revving)
			{
				_hasLastBlade = false;
				_bladeFrame = -1;
				return;
			}
			saw.Blade(out _bladeStart, out _bladeTip, out _bladeRadius);
			if (reached)
			{
				_reachStart = BtmGrabReach.FistAtTarget(_bladeStart, _wrist.position, _wrist.rotation, _reachTarget.position, _reachTarget.rotation);
				_reachTip = BtmGrabReach.FistAtTarget(_bladeTip, _wrist.position, _wrist.rotation, _reachTarget.position, _reachTarget.rotation);
			}
			else
			{
				_reachStart = _bladeStart;
				_reachTip = _bladeTip;
			}
			_reachMid = (_reachStart + _reachTip) * 0.5f;
			_bladeSwept = _hasLastBlade && (_reachTip - _lastBladeTip).sqrMagnitude <= BtmGrabReach.MaxSweep;
			_sweptTipFrom = _lastBladeTip;
			_sweptMidFrom = _lastBladeMid;
			_bladeFrame = Time.frameCount;
			if (LocalIsLiveMonster())
			{
				for (int i = players.Count - 1; i >= 0; i--)
				{
					if (i >= players.Count)
					{
						continue;
					}
					MonkeDevNetworkingPlayer player = players[i];
					if (!player || player.photonView == null || player.photonView.IsMine)
					{
						continue;
					}
					CapsuleCollider body = BodyOf(player);
					if (body && body.enabled && body.gameObject.activeInHierarchy)
					{
						BtmGrabReach.Segment(body, out var a, out var b, out var bodyRadius);
						if (BladeTouches(a, b, bodyRadius) && IsLiveSurvivor(player))
						{
							Kill(player, bySaw: true);
						}
					}
				}
			}
			_lastBladeTip = _reachTip;
			_lastBladeMid = _reachMid;
			_hasLastBlade = true;
		}

		public bool BladeTouches(Vector3 a, Vector3 b, float radius)
		{
			if (_bladeFrame != Time.frameCount)
			{
				return false;
			}
			float reach = _bladeRadius + radius;
			float reachSqr = reach * reach;
			if (BtmGrabReach.SegmentDistanceSqr(_bladeStart, _bladeTip, a, b) <= reachSqr)
			{
				return true;
			}
			if (BtmGrabReach.SegmentDistanceSqr(_reachStart, _reachTip, a, b) <= reachSqr)
			{
				return true;
			}
			if (!_bladeSwept)
			{
				return false;
			}
			if (BtmGrabReach.SegmentDistanceSqr(_sweptTipFrom, _reachTip, a, b) <= reachSqr)
			{
				return true;
			}
			return BtmGrabReach.SegmentDistanceSqr(_sweptMidFrom, _reachMid, a, b) <= reachSqr;
		}

		public bool FistTouches(Vector3 a, Vector3 b, float radius)
		{
			float reach = FistRadius + radius;
			Vector3 center = FistCenter;
			float reachSqr = reach * reach;
			if (BtmGrabReach.SegmentDistanceSqr(center, center, a, b) <= reachSqr)
			{
				return true;
			}
			if (_fistFrame != Time.frameCount)
			{
				return false;
			}
			return BtmGrabReach.SegmentDistanceSqr(_fistFrom, _fistTo, a, b) <= reachSqr;
		}

		private bool ResolveReach()
		{
			if (!_reachResolved)
			{
				_reachResolved = true;
				_fist = GetComponent<SphereCollider>();
				BtmGrabReach.FindReachTarget(photonView.transform, transform, out _wrist, out _reachTarget);
			}
			if (_fist && _wrist)
			{
				return _reachTarget;
			}
			return false;
		}

		private CapsuleCollider BodyOf(MonkeDevNetworkingPlayer player)
		{
			if (_bodies.TryGetValue(player, out var body) && (bool)body)
			{
				return body;
			}
			body = null;
			CapsuleCollider[] capsules = player.GetComponentsInChildren<CapsuleCollider>(true);
			foreach (CapsuleCollider capsule in capsules)
			{
				if (capsule.CompareTag(detectTag))
				{
					body = capsule;
					break;
				}
			}
			_bodies[player] = body;
			return body;
		}

		private void Touch(MonkeDevNetworkingPlayer victim)
		{
			if (!saw && !_carried && IsLiveSurvivor(victim) && LocalIsLiveMonster() && (!isGrabbing || !(victim == grabbedPlayer)))
			{
				_touched = victim;
				_touchedAt = Time.time;
				if (wantsToGrabPlayer)
				{
					TryGrab(victim);
				}
			}
		}

		private void Update()
		{
			if (!photonView.IsMine)
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			bool wasWanting = wantsToGrabPlayer;
			if (!saw && instance)
			{
				wantsToGrabPlayer = BtmGrabReach.Gripping(wantsToGrabPlayer, isLeftHand ? instance.LeftGripValue : instance.RightGripValue);
				if (!wasWanting && wantsToGrabPlayer && !isGrabbing && !_carried && _touched && !(Time.time - _touchedAt > BtmGrabReach.ContactGrace) && IsLiveSurvivor(_touched) && LocalIsLiveMonster())
				{
					TryGrab(_touched);
				}
			}
			else
			{
				wantsToGrabPlayer = false;
			}
			if (!isGrabbing || !grabbedPlayer)
			{
				return;
			}
			if (!IsLiveSurvivor(grabbedPlayer))
			{
				Drop();
				return;
			}
			if (!grabbedPlayer.IsBeingGrabbed)
			{
				isGrabbing = false;
				grabbedPlayer = null;
				return;
			}
			if (!wantsToGrabPlayer || Time.time - _grabStartTime >= GrabTimeLimit)
			{
				ReleaseAndKill();
			}
			else if (!(Time.time < _nextHoldHaptic))
			{
				_nextHoldHaptic = Time.time + HoldHapticInterval;
				Pulse(0.15f, 0.05f);
			}
		}

		private void TryGrab(MonkeDevNetworkingPlayer victim)
		{
			if (!isGrabbing && !(Time.time < _nextGrabTime) && (!otherHand || !otherHand.isGrabbing || !(otherHand.grabbedPlayer == victim)) && (bool)victim && !victim.IsBeingGrabbed)
			{
				Pulse(0.6f, 0.18f);
				_nextGrabTime = Time.time + GrabRetryInterval;
				victim.GrabPlayer(photonView.OwnerActorNr, isLeftHand);
				grabbedPlayer = victim;
				isGrabbing = true;
				_grabStartTime = Time.time;
				_nextHoldHaptic = Time.time + HoldHapticInterval;
			}
		}

		private void Drop()
		{
			MonkeDevNetworkingPlayer player = grabbedPlayer;
			isGrabbing = false;
			grabbedPlayer = null;
			if (player)
			{
				player.ReleasePlayer();
			}
		}

		private void ReleaseAndKill()
		{
			MonkeDevNetworkingPlayer victim = grabbedPlayer;
			Drop();
			if (victim && IsLiveSurvivor(victim))
			{
				Kill(victim);
			}
		}

		private void Kill(MonkeDevNetworkingPlayer victim, bool bySaw = false)
		{
			if (!BTMGameManager.Instance || !victim)
			{
				return;
			}
			int actor = victim.photonView.OwnerActorNr;
			if (actor == _lastKilled && Time.time - _lastKillTime < KillRepeat)
			{
				return;
			}
			_lastKilled = actor;
			_lastKillTime = Time.time;
			if (!bySaw)
			{
				Pulse(0.8f, 0.2f);
			}
			if (victim.IsBeingGrabbed && victim.GrabberActorId == photonView.OwnerActorNr)
			{
				victim.ReleasePlayer();
			}
			if (isGrabbing && grabbedPlayer == victim)
			{
				isGrabbing = false;
				grabbedPlayer = null;
			}
			BTMGameManager.Instance.photonView.RPC(bySaw ? "RPC_SawKill" : "RPC_EliminatePlayer", RpcTarget.All, actor, photonView.OwnerActorNr);
		}

		private void OnEnable()
		{
			List<BtmMonsterHand> list = (saw ? SawHands : FistHands);
			if (!list.Contains(this))
			{
				list.Add(this);
			}
		}

		private void OnDisable()
		{
			SawHands.Remove(this);
			FistHands.Remove(this);
			_touched = null;
			_hasLastReach = false;
			_hasLastBlade = false;
			_bladeFrame = -1;
			_fistFrame = -1;
			_bodies.Clear();
			if ((bool)photonView && photonView.IsMine && isGrabbing)
			{
				Drop();
			}
			if ((bool)photonView && photonView.IsMine)
			{
				DropCarried();
			}
			_brushedPart = null;
		}

		private void Pulse(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (instance)
			{
				if (isLeftHand)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}
	}
}
