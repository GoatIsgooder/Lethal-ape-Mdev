using System;
using System.Collections.Generic;
using System.Reflection;
using ExitGames.Client.Photon;
using LALocomotion;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using PlatformClock = GorillaLocomotion.PlatformClock;
using LethalApeR.Gameplay.Monsters;

namespace LethalApeR.Gameplay.Pumpkin
{
	[Obfuscation(Exclude = true)]
	public class PumpkinNet : MonoBehaviourPunCallbacks, IOnEventCallback
	{
		private sealed class Held
		{
			public object left = string.Empty;

			public object right = string.Empty;
		}

		private sealed class Proxy
		{
			public int actor;

			public bool left;

			public string kind;

			public PumpkinLauncher launcher;

			public Transform parent;

			public bool stale;

			public bool twoHanded;

			public Transform supportHand;

			public Vector3 attachPosition;

			public Quaternion attachRotation = Quaternion.identity;

			public Vector3 supportPosition;

			public LAGrabbable.TwoHandGrip grip;
		}

		private struct Dying
		{
			public PumpkinLauncher launcher;

			public Vector3 scale;

			public float age;
		}

		private sealed class Sender
		{
			public float lastFireLeft = -100f;

			public float lastFireRight = -100f;

			public int rejections;
		}

		public const string PropLeft = "pkL";

		public const string PropRight = "pkR";

		private const float ReconcileInterval = 0.5f;

		private const float GripCheckInterval = 0.5f;

		private const float GripMoveTolerance = 0.01f;

		private const float GripTurnTolerance = 2f;

		private const float ProxyShrinkTime = 0.15f;

		private static readonly Dictionary<string, PumpkinLauncherKind> Kinds = new Dictionary<string, PumpkinLauncherKind>();

		private static PumpkinLauncher _heldLeft;

		private static PumpkinLauncher _heldRight;

		private static object _publishedLeft = string.Empty;

		private static object _publishedRight = string.Empty;

		private static float _nextGripCheck;

		private static readonly Dictionary<int, Held> RemoteHeld = new Dictionary<int, Held>();

		private static readonly List<int> HeldScratch = new List<int>();

		private static readonly List<Proxy> Proxies = new List<Proxy>();

		private static readonly List<Dying> DyingProxies = new List<Dying>();

		private static Transform _assembly;

		private static float _nextReconcile;

		private const int TwoHandedLength = 10;

		public const byte EventCode = 132;

		private const byte OpFire = 0;

		private const byte OpRide = 1;

		private const byte OpBurst = 2;

		public const float MaxLag = 0.5f;

		private const float MaxFireReach = 2.5f;

		private const float MaxBreechOffset = 1.5f;

		private const float MinFireIntervalShare = 0.75f;

		private const int MaxLiveShots = 4;

		private const int MaxClockSkewMs = 3000;

		private const float RideClaimWindow = 1.5f;

		private const float RideReach = 3f;

		private const float ShotTimeout = 10f;

		private const int MaxRejectLogs = 3;

		private static PumpkinNet _instance;

		private static readonly Dictionary<long, PumpkinShot> Shots = new Dictionary<long, PumpkinShot>();

		private static readonly List<long> ShotScratch = new List<long>();

		private static readonly Dictionary<int, Sender> Senders = new Dictionary<int, Sender>();

		private static readonly RaiseEventOptions ToOthers = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.Others
		};

		private static int _seq;

		public static Action<object[]> SendOverride { get; set; }

		public static int LocalActor
		{
			get
			{
				if (!PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
				{
					return 0;
				}
				return PhotonNetwork.LocalPlayer.ActorNumber;
			}
		}

		private static bool Online
		{
			get
			{
				if (SendOverride == null)
				{
					return PhotonNetwork.InRoom;
				}
				return true;
			}
		}

		public static void RegisterKind(PumpkinLauncherKind kind)
		{
			if (!(kind == null) && !string.IsNullOrEmpty(kind.id) && !(kind.prefab == null))
			{
				Kinds[kind.id] = kind;
			}
		}

		public static void LocalGrabbed(PumpkinLauncher launcher, bool left)
		{
			if (launcher == null || launcher.IsProxy)
			{
				return;
			}
			if (left)
			{
				if (_heldRight == launcher)
				{
					_heldRight = null;
				}
				_heldLeft = launcher;
			}
			else
			{
				if (_heldLeft == launcher)
				{
					_heldLeft = null;
				}
				_heldRight = launcher;
			}
			PublishHeld();
		}

		public static void LocalReleased(PumpkinLauncher launcher)
		{
			if (launcher == null)
			{
				return;
			}
			bool changed = false;
			if (_heldLeft == launcher)
			{
				_heldLeft = null;
				changed = true;
			}
			if (_heldRight == launcher)
			{
				_heldRight = null;
				changed = true;
			}
			if (changed)
			{
				PublishHeld();
			}
		}

		private static void PublishHeld()
		{
			_publishedLeft = HandPayload(_heldLeft, true);
			_publishedRight = HandPayload(_heldRight, false);
			_nextGripCheck = Time.time + GripCheckInterval;
			if (PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null)
			{
				PhotonNetwork.LocalPlayer.SetCustomProperties(new Hashtable
				{
					[PropLeft] = _publishedLeft,
					[PropRight] = _publishedRight
				});
			}
		}

		private static object HandPayload(PumpkinLauncher launcher, bool left)
		{
			if (launcher == null || launcher.kind == null || string.IsNullOrEmpty(launcher.kind.id))
			{
				return string.Empty;
			}
			Transform hand = PumpkinRig.SyncedHand(left);
			if (hand == null)
			{
				return string.Empty;
			}
			Transform t = launcher.transform;
			string id = launcher.kind.id;
			Vector3 position = hand.InverseTransformPoint(t.position);
			Quaternion rotation = Quaternion.Inverse(hand.rotation) * t.rotation;
			LAGrabbable grabbable = launcher.Grabbable;
			Transform otherHand = null;
			if (grabbable != null && grabbable.IsTwoHanded && grabbable.Holder.isLeft == left)
			{
				otherHand = PumpkinRig.SyncedHand(!left);
			}
			if (otherHand == null)
			{
				return new object[3] { id, position, rotation };
			}
			Transform anchor = grabbable.Holder.AttachPoint;
			Transform support = grabbable.Support.AttachPoint;
			LAGrabbable.TwoHandGrip grip = grabbable.Grip;
			return new object[10]
			{
				id,
				position,
				rotation,
				hand.InverseTransformPoint(anchor.position),
				Quaternion.Inverse(hand.rotation) * anchor.rotation,
				otherHand.InverseTransformPoint(support.position),
				grip.anchor,
				grip.aim,
				grip.roll,
				grip.rollInHand
			};
		}

		private static void CheckGrip()
		{
			if (!(Time.time < _nextGripCheck) && (!(_heldLeft == null) || !(_heldRight == null)))
			{
				_nextGripCheck = Time.time + GripCheckInterval;
				if (GripMoved(_publishedLeft, HandPayload(_heldLeft, true)) || GripMoved(_publishedRight, HandPayload(_heldRight, false)))
				{
					PublishHeld();
				}
			}
		}

		private static bool GripMoved(object published, object now)
		{
			object[] a = published as object[];
			object[] b = now as object[];
			if (a == null || b == null)
			{
				return a == null != (b == null);
			}
			if (a.Length != b.Length || !object.Equals(a[0], b[0]))
			{
				return true;
			}
			for (int i = ((a.Length >= TwoHandedLength) ? 3 : 1); i < a.Length; i++)
			{
				if (a[i] is Vector3 p)
				{
					if (b[i] is Vector3 q && (p - q).sqrMagnitude > GripMoveTolerance * GripMoveTolerance)
					{
						return true;
					}
				}
				else if (a[i] is Quaternion r && b[i] is Quaternion s && Quaternion.Angle(r, s) > GripTurnTolerance)
				{
					return true;
				}
			}
			return false;
		}

		public static void ApplyRemoteHeld(int actor, object left, object right)
		{
			if (actor >= 1 && actor != LocalActor)
			{
				if (!RemoteHeld.TryGetValue(actor, out var held))
				{
					held = new Held();
					RemoteHeld[actor] = held;
				}
				held.left = left ?? string.Empty;
				held.right = right ?? string.Empty;
				ReconcileProxies();
			}
		}

		public static void ForgetRemoteHeld(int actor)
		{
			RemoteHeld.Remove(actor);
			ReconcileProxies();
		}

		private static void ReadAllHeld()
		{
			RemoteHeld.Clear();
			Player[] others = PhotonNetwork.PlayerListOthers;
			if (others != null)
			{
				foreach (Player player in others)
				{
					if (player != null)
					{
						Held held = new Held();
						held.left = player.CustomProperties[PropLeft] ?? string.Empty;
						held.right = player.CustomProperties[PropRight] ?? string.Empty;
						RemoteHeld[player.ActorNumber] = held;
					}
				}
			}
			ReconcileProxies();
		}

		private static void ClearRemoteHeld()
		{
			RemoteHeld.Clear();
			ReconcileProxies();
		}

		public static PumpkinLauncher ProxyLauncher(int actor, bool left)
		{
			for (int i = 0; i < Proxies.Count; i++)
			{
				Proxy proxy = Proxies[i];
				if (proxy.actor == actor && proxy.left == left && proxy.launcher != null)
				{
					return proxy.launcher;
				}
			}
			return null;
		}

		private static void UpdateHeld()
		{
			CheckGrip();
			if (Time.time >= _nextReconcile)
			{
				ReconcileProxies();
			}
			UpdateDying(Time.deltaTime);
		}

		private static void ReconcileProxies()
		{
			_nextReconcile = Time.time + ReconcileInterval;
			for (int i = 0; i < Proxies.Count; i++)
			{
				Proxies[i].stale = true;
			}
			HeldScratch.Clear();
			foreach (KeyValuePair<int, Held> pair in RemoteHeld)
			{
				HeldScratch.Add(pair.Key);
			}
			IPumpkinAvatarSource avatars = PumpkinRig.Avatars;
			for (int j = 0; j < HeldScratch.Count; j++)
			{
				int actor = HeldScratch[j];
				if (avatars.TryFind(actor, out var avatar))
				{
					Held held = RemoteHeld[actor];
					EnsureProxy(actor, true, held.left, avatar.leftHand, avatar.rightHand);
					EnsureProxy(actor, false, held.right, avatar.rightHand, avatar.leftHand);
				}
			}
			for (int k = Proxies.Count - 1; k >= 0; k--)
			{
				if (Proxies[k].stale)
				{
					Retire(Proxies[k].launcher);
					Proxies.RemoveAt(k);
				}
			}
		}

		private static void EnsureProxy(int actor, bool left, object payload, Transform hand, Transform otherHand)
		{
			if (!(payload is object[] data) || data.Length < 3 || !(data[0] is string id) || string.IsNullOrEmpty(id) || hand == null || !(data[1] is Vector3 position) || !(data[2] is Quaternion rotation) || !Kinds.TryGetValue(id, out var kind) || kind == null || kind.prefab == null || position.sqrMagnitude > 4f)
			{
				return;
			}
			Proxy proxy = null;
			for (int i = 0; i < Proxies.Count; i++)
			{
				Proxy existing = Proxies[i];
				if (existing.actor == actor && existing.left == left)
				{
					if (existing.launcher != null && existing.kind == id && existing.parent == hand)
					{
						proxy = existing;
					}
					else
					{
						Retire(existing.launcher);
						Proxies.RemoveAt(i);
					}
					break;
				}
			}
			if (proxy == null)
			{
				PumpkinLauncher launcher = BuildProxy(kind);
				launcher.transform.SetParent(hand, false);
				proxy = new Proxy
				{
					actor = actor,
					left = left,
					kind = id,
					launcher = launcher,
					parent = hand
				};
				Proxies.Add(proxy);
			}
			proxy.stale = false;
			proxy.launcher.transform.localPosition = position;
			proxy.launcher.transform.localRotation = rotation;
			proxy.twoHanded = otherHand != null && ReadTwoHanded(data, proxy);
			proxy.supportHand = (proxy.twoHanded ? otherHand : null);
		}

		private static bool ReadTwoHanded(object[] data, Proxy proxy)
		{
			if (data.Length < TwoHandedLength || !(data[3] is Vector3 attachPosition) || !(data[4] is Quaternion attachRotation) || !(data[5] is Vector3 supportPosition) || !(data[6] is Vector3 anchor) || !(data[7] is Vector3 aim) || !(data[8] is Vector3 roll) || !(data[9] is Vector3 rollInHand))
			{
				return false;
			}
			if (!Finite(attachPosition) || !Finite(supportPosition) || !Finite(anchor) || !Finite(aim) || !Finite(roll) || !Finite(rollInHand))
			{
				return false;
			}
			if (attachPosition.sqrMagnitude > 0.25f || supportPosition.sqrMagnitude > 0.25f || anchor.sqrMagnitude > 4f || aim.sqrMagnitude < 0.25f || roll.sqrMagnitude < 0.25f || rollInHand.sqrMagnitude < 0.25f)
			{
				return false;
			}
			proxy.attachPosition = attachPosition;
			proxy.attachRotation = attachRotation;
			proxy.supportPosition = supportPosition;
			proxy.grip = new LAGrabbable.TwoHandGrip
			{
				anchor = anchor,
				aim = aim,
				roll = roll,
				rollInHand = rollInHand
			};
			return true;
		}

		private void LateUpdate()
		{
			for (int i = 0; i < Proxies.Count; i++)
			{
				Proxy proxy = Proxies[i];
				if (proxy.twoHanded && !(proxy.launcher == null) && !(proxy.parent == null) && !(proxy.supportHand == null))
				{
					Vector3 anchorPosition = proxy.parent.TransformPoint(proxy.attachPosition);
					Quaternion anchorRotation = proxy.parent.rotation * proxy.attachRotation;
					Pose pose = proxy.launcher.Grabbable.TwoHandedPose(in proxy.grip, anchorPosition, anchorRotation, proxy.supportHand.TransformPoint(proxy.supportPosition));
					proxy.launcher.transform.SetPositionAndRotation(pose.position, pose.rotation);
				}
			}
		}

		private static PumpkinLauncher BuildProxy(PumpkinLauncherKind kind)
		{
			if (_assembly == null)
			{
				GameObject assembly = new GameObject("[Pumpkin proxy assembly]");
				assembly.SetActive(false);
				UnityEngine.Object.DontDestroyOnLoad(assembly);
				_assembly = assembly.transform;
			}
			PumpkinLauncher launcher = UnityEngine.Object.Instantiate(kind.prefab, _assembly, false);
			launcher.name = kind.prefab.name + " (remote)";
			launcher.MakeProxy();
			return launcher;
		}

		private static void Retire(PumpkinLauncher launcher)
		{
			if (!(launcher == null))
			{
				launcher.Retire();
				DyingProxies.Add(new Dying
				{
					launcher = launcher,
					scale = launcher.transform.localScale
				});
			}
		}

		private static void UpdateDying(float dt)
		{
			for (int i = DyingProxies.Count - 1; i >= 0; i--)
			{
				Dying dying = DyingProxies[i];
				if (dying.launcher == null)
				{
					DyingProxies.RemoveAt(i);
					continue;
				}
				dying.age += dt;
				float t = dying.age / ProxyShrinkTime;
				if (t < 1f)
				{
					float k = 1f - t;
					dying.launcher.transform.localScale = dying.scale * (k * k);
					DyingProxies[i] = dying;
				}
				else
				{
					dying.launcher.ReleaseRounds();
					UnityEngine.Object.Destroy(dying.launcher.gameObject);
					DyingProxies.RemoveAt(i);
				}
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (!(_instance != null))
			{
				GameObject go = new GameObject("[Auto] PumpkinNet");
				UnityEngine.Object.DontDestroyOnLoad(go);
				_instance = go.AddComponent<PumpkinNet>();
			}
		}

		private static long Key(int actor, int seq)
		{
			return ((long)actor << 32) | (uint)seq;
		}

		public static PumpkinShot FindShot(int shooter, int seq)
		{
			if (!Shots.TryGetValue(Key(shooter, seq), out var shot))
			{
				return null;
			}
			return shot;
		}

		public static PumpkinShot BeginLocalShot(bool left, Vector3 origin, Vector3 breech, Vector3 direction)
		{
			PumpkinShot shot = new PumpkinShot
			{
				shooter = LocalActor,
				seq = ++_seq,
				left = left,
				origin = origin,
				breech = breech,
				direction = direction.normalized,
				serverMs = PlatformClock.NowMs,
				isLocal = true,
				startedAt = Time.time
			};
			Shots[Key(shot.shooter, shot.seq)] = shot;
			if (Online)
			{
				Send(new object[7] { OpFire, shot.seq, left, origin, breech, shot.direction, shot.serverMs });
			}
			return shot;
		}

		public static void SendRide(PumpkinShot shot, bool left, Vector3 offset)
		{
			if (shot != null && Online)
			{
				Send(new object[5] { OpRide, shot.shooter, shot.seq, left, offset });
			}
		}

		public static void SendBurst(PumpkinShot shot, Vector3 point, Vector3 normal)
		{
			if (shot != null && Online)
			{
				Send(new object[5] { OpBurst, shot.shooter, shot.seq, point, normal });
			}
		}

		private static void Send(object[] payload)
		{
			if (SendOverride != null)
			{
				SendOverride(payload);
				return;
			}
			PhotonNetwork.RaiseEvent(EventCode, payload, ToOthers, SendOptions.SendReliable);
		}

		public static void Forget(PumpkinShot shot)
		{
			if (shot == null)
			{
				return;
			}
			long key = Key(shot.shooter, shot.seq);
			if (Shots.TryGetValue(key, out var existing) && existing == shot)
			{
				Shots.Remove(key);
			}
			shot.projectile = null;
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code == EventCode)
			{
				Receive(photonEvent.Sender, photonEvent.CustomData as object[]);
			}
		}

		public static void Receive(int sender, object[] data)
		{
			if (sender < 1 || sender == LocalActor)
			{
				return;
			}
			if (data == null || data.Length < 1 || !(data[0] is byte op))
			{
				Reject(sender, "a malformed message");
				return;
			}
			switch (op)
			{
			case OpFire:
				ReceiveFire(sender, data);
				break;
			case OpRide:
				ReceiveRide(sender, data);
				break;
			case OpBurst:
				ReceiveBurst(sender, data);
				break;
			default:
				Reject(sender, "an unknown op " + op);
				break;
			}
		}

		private static void ReceiveFire(int sender, object[] d)
		{
			if (d.Length < 7 || !(d[1] is int seq) || !(d[2] is bool left) || !(d[3] is Vector3 origin) || !(d[4] is Vector3 breech) || !(d[5] is Vector3 direction) || !(d[6] is int serverMs) || !Finite(origin) || !Finite(breech) || !Finite(direction))
			{
				Reject(sender, "a malformed shot");
				return;
			}
			float sqr = direction.sqrMagnitude;
			if (sqr < 0.81f || sqr > 1.21f)
			{
				Reject(sender, "a shot with a bad direction");
				return;
			}
			long key = Key(sender, seq);
			if (Shots.ContainsKey(key))
			{
				return;
			}
			PumpkinLauncher launcher = ProxyLauncher(sender, left);
			if (launcher == null)
			{
				Reject(sender, "a shot with no launcher in that hand");
				return;
			}
			if (!PumpkinRig.Avatars.TryFind(sender, out var avatar) || avatar.Hand(left) == null)
			{
				Reject(sender, "a shot with no body");
				return;
			}
			float reach = avatar.scale * MaxFireReach;
			if ((origin - avatar.Hand(left).position).sqrMagnitude > reach * reach || (breech - origin).sqrMagnitude > MaxBreechOffset * MaxBreechOffset)
			{
				Reject(sender, "a shot from out of reach");
				return;
			}
			if (launcher.onlyWhereMonstersRoam && MonsterExclusionZone.Contains(avatar.head.position) && MonsterExclusionZone.Contains(origin))
			{
				Reject(sender, "a shot from inside the lobby");
				return;
			}
			int skew = PlatformClock.NowMs - serverMs;
			if (skew < -MaxClockSkewMs || skew > MaxClockSkewMs)
			{
				Reject(sender, "a shot stamped " + skew + " ms off");
				return;
			}
			Sender state = StateOf(sender);
			float last = left ? state.lastFireLeft : state.lastFireRight;
			if (Time.time - last < launcher.reloadTime * MinFireIntervalShare || LiveShots(sender) >= MaxLiveShots)
			{
				Reject(sender, "shots faster than the reload");
				return;
			}
			if (left)
			{
				state.lastFireLeft = Time.time;
			}
			else
			{
				state.lastFireRight = Time.time;
			}
			PumpkinShot shot = new PumpkinShot
			{
				shooter = sender,
				seq = seq,
				left = left,
				origin = origin,
				breech = breech,
				direction = direction / Mathf.Sqrt(sqr),
				serverMs = serverMs,
				startedAt = Time.time
			};
			Shots[key] = shot;
			launcher.FireRemote(shot);
			if (shot.projectile == null)
			{
				Shots.Remove(key);
			}
		}

		private static void ReceiveRide(int sender, object[] d)
		{
			if (d.Length < 5 || !(d[1] is int shooter) || !(d[2] is int seq) || !(d[3] is bool left) || !(d[4] is Vector3 offset) || !Finite(offset))
			{
				Reject(sender, "a malformed ride");
				return;
			}
			PumpkinShot shot = FindShot(shooter, seq);
			if (shot == null || shot.projectile == null)
			{
				return;
			}
			if (shooter == sender || Time.time - shot.startedAt > RideClaimWindow || offset.sqrMagnitude > 1f)
			{
				Reject(sender, "a ride it can't have");
				return;
			}
			if (!PumpkinRig.Avatars.TryFind(sender, out var avatar) || avatar.Hand(left) == null || (avatar.Hand(left).position - shot.origin).sqrMagnitude > RideReach * RideReach * avatar.scale * avatar.scale)
			{
				Reject(sender, "a ride from out of reach");
				return;
			}
			shot.projectile.OnRideClaim(sender, left, offset);
		}

		private static void ReceiveBurst(int sender, object[] d)
		{
			if (d.Length < 5 || !(d[1] is int shooter) || !(d[2] is int seq) || !(d[3] is Vector3 point) || !(d[4] is Vector3 normal) || !Finite(point) || !Finite(normal))
			{
				Reject(sender, "a malformed burst");
				return;
			}
			PumpkinProjectile projectile = FindShot(shooter, seq)?.projectile;
			if (projectile == null || projectile.Current != PumpkinProjectile.State.Flying)
			{
				return;
			}
			if (!projectile.AcceptsBurstFrom(sender, point))
			{
				Reject(sender, "a burst it doesn't decide");
				return;
			}
			projectile.BurstFromNetwork(point, normal);
		}

		private static int LiveShots(int shooter)
		{
			int count = 0;
			foreach (KeyValuePair<long, PumpkinShot> pair in Shots)
			{
				if (pair.Value.shooter == shooter && pair.Value.projectile != null && pair.Value.projectile.Current == PumpkinProjectile.State.Flying)
				{
					count++;
				}
			}
			return count;
		}

		private static Sender StateOf(int actor)
		{
			if (!Senders.TryGetValue(actor, out var state))
			{
				state = new Sender();
				Senders[actor] = state;
			}
			return state;
		}

		private static void Reject(int sender, string what)
		{
			Sender state = StateOf(sender);
			if (state.rejections++ < MaxRejectLogs)
			{
				Debug.LogWarning("[PumpkinNet] Ignored " + what + " from actor " + sender + ".");
			}
		}

		private static bool Finite(Vector3 v)
		{
			if (!float.IsNaN(v.x) && !float.IsNaN(v.y) && !float.IsNaN(v.z) && !float.IsInfinity(v.x) && !float.IsInfinity(v.y))
			{
				return !float.IsInfinity(v.z);
			}
			return false;
		}

		private void Update()
		{
			UpdateHeld();
			if (Time.frameCount % 64 == 0)
			{
				DropStaleShots();
			}
		}

		private static void DropStaleShots()
		{
			ShotScratch.Clear();
			foreach (KeyValuePair<long, PumpkinShot> pair in Shots)
			{
				if (pair.Value.projectile == null || Time.time - pair.Value.startedAt > ShotTimeout)
				{
					ShotScratch.Add(pair.Key);
				}
			}
			for (int i = 0; i < ShotScratch.Count; i++)
			{
				Shots.Remove(ShotScratch[i]);
			}
		}

		public override void OnJoinedRoom()
		{
			Shots.Clear();
			Senders.Clear();
			ReadAllHeld();
			PublishHeld();
		}

		public override void OnLeftRoom()
		{
			Shots.Clear();
			Senders.Clear();
			ClearRemoteHeld();
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			if (otherPlayer != null)
			{
				Senders.Remove(otherPlayer.ActorNumber);
				ForgetRemoteHeld(otherPlayer.ActorNumber);
			}
		}

		public override void OnPlayerPropertiesUpdate(Player targetPlayer, Hashtable changedProps)
		{
			if (targetPlayer != null && !targetPlayer.IsLocal && (changedProps.ContainsKey(PropLeft) || changedProps.ContainsKey(PropRight)))
			{
				ApplyRemoteHeld(targetPlayer.ActorNumber, targetPlayer.CustomProperties[PropLeft], targetPlayer.CustomProperties[PropRight]);
			}
		}
	}
}
