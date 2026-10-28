using System;
using System.Collections.Generic;
using LALocomotion;
using LethalApeR.Gameplay.Monsters;
using LethalApeR.Gameplay.Pumpkin;
using Photon.Pun;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class ZombieHorde : MonoBehaviour, IPumpkinSweepTarget
	{
		private sealed class Slot
		{
			public int index;

			public byte generation;

			public bool active;

			public ZombieState state;

			public float stateTime;

			public float hp;

			public Vector3 position;

			public float yaw;

			public float speed;

			public bool runner;

			public int wave;

			public int target;

			public float nextThink;

			public float nextPath;

			public float readyAt;

			public float stunFor;

			public float lastAttackAt = -100f;

			public byte hitSeq;

			public NavMeshAgent agent;

			public Vector3 shove;

			public float shoveLeft;

			public byte Id => (byte)(index | (generation << 3));

			public bool Alive => active && state != ZombieState.None && state != ZombieState.Dying && state != ZombieState.Sinking;
		}

		private const int RecordBytes = 11;

		private readonly ZombieView[] _views = new ZombieView[8];

		private readonly bool[] _seen = new bool[8];

		private readonly byte[][] _tx = new byte[9][];

		private int _emptySends;

		public const int MaxSlots = 8;

		[Header("Zombie")]
		public ZombieView viewPrefab;

		public float maxHealth = 100f;

		[Tooltip("Shambling speed (m/s); every wave adds 6%.")]
		public float walkSpeed = 1.5f;

		[Tooltip("Sprint speed for runners (m/s); every wave adds 6%.")]
		public float runSpeed = 3.7f;

		[Tooltip("Runners sprint once their target is this close (m).")]
		public float runWithin = 16f;

		[Tooltip("Zombies notice players this far away (m).")]
		public float aggroRadius = 45f;

		[Tooltip("A zombie this close (horizontally) to its target's head starts an attack (m).")]
		public float attackRange = 1.3f;

		[Tooltip("Pause after an attack before the next (s).")]
		public float attackCooldown = 0.9f;

		[Tooltip("How far the attack lunges forward (m).")]
		public float lungeDistance = 0.7f;

		[Header("Blasts")]
		public float maxBlastStun = 2.5f;

		[Tooltip("How far a full-strength blast slides a zombie (m).")]
		public float blastShove = 2.2f;

		public float shoveTime = 0.35f;

		[Header("Agent")]
		public float agentRadius = 0.35f;

		public float agentHeight = 0.9f;

		public float acceleration = 14f;

		[NonSerialized]
		public KevinRiftDirector director;

		private readonly Slot[] _slots = new Slot[8];

		private Vector3 Origin
		{
			get
			{
				KevinRiftAnchor anchor = director != null ? director.Anchor : null;
				return anchor != null ? anchor.transform.position : Vector3.zero;
			}
		}

		internal bool LocalImmune => director == null || director.LocalImmune;

		public int ActiveCount { get; private set; }

		public int LivingCount { get; private set; }

		private bool IsHost => director != null && director.IsAuthority;

		private bool HasAgents
		{
			get
			{
				for (int i = 0; i < MaxSlots; i++)
				{
					if (_slots[i].agent != null)
					{
						return true;
					}
				}
				return false;
			}
		}

		public ZombieView View(int slot)
		{
			return _views[slot];
		}

		private void BuildViews()
		{
			for (int i = 0; i <= MaxSlots; i++)
			{
				_tx[i] = new byte[1 + i * RecordBytes];
			}
			if (viewPrefab == null)
			{
				Debug.LogError("[KevinRift] ZombieHorde has no view prefab.", this);
				return;
			}
			for (int j = 0; j < MaxSlots; j++)
			{
				ZombieView view = Instantiate(viewPrefab, transform);
				view.name = string.Format("Rift Zombie {0}", j);
				view.Init(this, j);
				_views[j] = view;
			}
		}

		public void WriteStream(PhotonStream stream)
		{
			byte[] data = Pack();
			if (data[0] != 0)
			{
				_emptySends = 0;
			}
			else
			{
				if (_emptySends >= 8)
				{
					return;
				}
				_emptySends++;
			}
			stream.SendNext(data);
		}

		public byte[] Pack()
		{
			int count = 0;
			for (int i = 0; i < MaxSlots; i++)
			{
				if (_slots[i].active)
				{
					count++;
				}
			}
			byte[] data = _tx[count];
			data[0] = (byte)count;
			Vector3 origin = Origin;
			int at = 1;
			for (int j = 0; j < MaxSlots; j++)
			{
				Slot s = _slots[j];
				if (s.active)
				{
					data[at] = s.Id;
					data[at + 1] = (byte)((int)s.state | (s.hitSeq << 4));
					WriteShort(data, at + 2, s.position.x - origin.x);
					WriteShort(data, at + 4, s.position.y - origin.y);
					WriteShort(data, at + 6, s.position.z - origin.z);
					data[at + 8] = (byte)Mathf.RoundToInt(Mathf.Repeat(s.yaw, 360f) / 360f * 256f);
					data[at + 9] = (byte)Mathf.Clamp(Mathf.RoundToInt(s.speed * 10f), 0, 255);
					data[at + 10] = (byte)Mathf.Clamp(Mathf.RoundToInt(s.hp / maxHealth * 255f), 0, 255);
					at += RecordBytes;
				}
			}
			return data;
		}

		public void ReadStream(PhotonStream stream, int sentServerMs)
		{
			if (stream.ReceiveNext() is byte[] data)
			{
				Unpack(data, sentServerMs);
			}
		}

		public void Unpack(byte[] data, int sentServerMs)
		{
			if (data == null || data.Length < 1 || IsHost)
			{
				return;
			}
			int count = Mathf.Min(data[0], MaxSlots);
			if (data.Length < 1 + count * RecordBytes)
			{
				return;
			}
			for (int i = 0; i < MaxSlots; i++)
			{
				_seen[i] = false;
			}
			Vector3 origin = Origin;
			int at = 1;
			for (int j = 0; j < count; j++)
			{
				byte id = data[at];
				byte packed = data[at + 1];
				float x = ReadShort(data, at + 2);
				float y = ReadShort(data, at + 4);
				float z = ReadShort(data, at + 6);
				byte yaw = data[at + 8];
				byte speed = data[at + 9];
				byte health = data[at + 10];
				int slot = id & 7;
				_seen[slot] = true;
				ZombieView view = _views[slot];
				if (view != null)
				{
					view.PushSnapshot((byte)(id >> 3), sentServerMs, new Vector3(origin.x + x, origin.y + y, origin.z + z), yaw / 256f * 360f, speed / 10f, (ZombieState)(packed & 0xF), (byte)(packed >> 4), health / 255f);
				}
				at += RecordBytes;
			}
			for (int k = 0; k < MaxSlots; k++)
			{
				if (!_seen[k] && _views[k] != null)
				{
					_views[k].Retire();
				}
			}
		}

		private static void WriteShort(byte[] data, int at, float metres)
		{
			int value = Mathf.Clamp(Mathf.RoundToInt(metres * 100f), -32768, 32767);
			data[at] = (byte)value;
			data[at + 1] = (byte)(value >> 8);
		}

		private static float ReadShort(byte[] data, int at)
		{
			return (float)(short)(data[at] | (data[at + 1] << 8)) / 100f;
		}

		internal void OnViewStruck(ZombieView view)
		{
			if (director != null)
			{
				director.OnLocalCaught(view);
			}
		}

		internal void OnViewEmerge(Vector3 point)
		{
			if (director != null && director.site != null)
			{
				director.site.OnZombieEmerge(point);
			}
		}

		public bool SweepPumpkin(Vector3 from, Vector3 delta, float radius, ref float first, ref Vector3 normal)
		{
			bool hit = false;
			float reach = delta.magnitude + 2f;
			float reachSqr = reach * reach;
			for (int i = 0; i < MaxSlots; i++)
			{
				ZombieView view = _views[i];
				if (!(view == null) && view.Alive && !((view.transform.position - from).sqrMagnitude > reachSqr) && PumpkinRig.Sweep(from, delta, radius, view.Body, out var t, out var n) && t < first)
				{
					first = t;
					normal = n;
					hit = true;
				}
			}
			return hit;
		}

		private void Awake()
		{
			for (int i = 0; i < MaxSlots; i++)
			{
				_slots[i] = new Slot
				{
					index = i
				};
			}
			BuildViews();
		}

		private void OnEnable()
		{
			PumpkinProjectile.AddSweepTarget(this);
		}

		private void OnDisable()
		{
			PumpkinProjectile.RemoveSweepTarget(this);
		}

		private void Update()
		{
			if (director == null)
			{
				return;
			}
			if (IsHost)
			{
				HostTick();
			}
			else if (HasAgents)
			{
				DropAgents();
			}
			CountSlots();
		}

		private void CountSlots()
		{
			int active = 0;
			int living = 0;
			if (IsHost)
			{
				for (int i = 0; i < MaxSlots; i++)
				{
					Slot s = _slots[i];
					if (s.active)
					{
						active++;
						living += s.Alive ? 1 : 0;
					}
				}
			}
			else
			{
				for (int j = 0; j < MaxSlots; j++)
				{
					if (!(_views[j] == null) && _views[j].Active)
					{
						active++;
						living += _views[j].Alive ? 1 : 0;
					}
				}
			}
			ActiveCount = active;
			LivingCount = living;
		}

		public bool HostSpawn(Vector3 point, int vortex, bool runner, int wave)
		{
			if (!IsHost)
			{
				return false;
			}
			for (int i = 0; i < MaxSlots; i++)
			{
				Slot s = _slots[i];
				if (s.active)
				{
					continue;
				}
				if (!NavMesh.SamplePosition(point, out var hit, 2.5f, -1))
				{
					return false;
				}
				NavMeshAgent agent = EnsureAgent(s);
				agent.gameObject.SetActive(true);
				agent.enabled = true;
				if (!agent.Warp(hit.position))
				{
					return false;
				}
				s.generation = (byte)((s.generation + 1) & 0x1F);
				s.active = true;
				s.hp = maxHealth;
				s.position = hit.position;
				s.runner = runner;
				s.wave = wave;
				s.target = 0;
				s.hitSeq = 0;
				s.readyAt = 0f;
				s.shoveLeft = 0f;
				KevinRiftAnchor anchor = director.Anchor;
				Vector3 away = anchor != null ? hit.position - anchor.transform.position : UnityEngine.Random.insideUnitSphere;
				if (away.x * away.x + away.z * away.z > 0.0001f)
				{
					s.yaw = Quaternion.LookRotation(new Vector3(away.x, 0f, away.z)).eulerAngles.y;
				}
				else
				{
					s.yaw = UnityEngine.Random.Range(0f, 360f);
				}
				s.nextThink = (s.nextPath = Time.time + 1.28f + (float)s.index * 0.05f);
				Go(s, ZombieState.Emerge);
				return true;
			}
			return false;
		}

		public void HostDamage(byte id, float damage, int attacker, ZombieDamage cause, Vector3 direction, float stun, float shoveScale)
		{
			if (!IsHost || !TryGetSlot(id, out var s) || !s.Alive || damage <= 0f)
			{
				return;
			}
			s.hitSeq = (byte)((s.hitSeq + 1) & 0xF);
			s.hp -= damage;
			if (director != null)
			{
				director.AddParticipant(attacker);
			}
			if (s.hp <= 0f)
			{
				Go(s, ZombieState.Dying);
				if (director != null)
				{
					director.HostBroadcastKill(s.Id, attacker, cause);
				}
			}
			else if (s.state != ZombieState.Emerge)
			{
				Vector3 flat = new Vector3(direction.x, 0f, direction.z);
				Vector3 push = flat.x * flat.x + flat.z * flat.z > 0.0001f ? flat.normalized : Vector3.zero;
				if (cause != ZombieDamage.Blast)
				{
					s.stunFor = 0.28f;
					s.shove = push * 0.35f;
				}
				else
				{
					s.stunFor = Mathf.Max(stun, 0.3f);
					s.shove = push * (blastShove * Mathf.Clamp01(shoveScale));
				}
				s.shoveLeft = shoveTime;
				Go(s, ZombieState.Stunned);
			}
		}

		internal void HostBlast(ZombieView view, in BlastInfo blast, in BlastHit hit)
		{
			if (IsHost && !(view == null))
			{
				float strength = Mathf.Clamp01(hit.strength);
				if (!(strength <= 0f))
				{
					float stun = Mathf.Min(maxBlastStun, strength * blast.stunSeconds);
					HostDamage(view.NetId, strength * maxHealth, ShooterOf(in blast), ZombieDamage.Blast, hit.direction, stun, strength);
				}
			}
		}

		private static int ShooterOf(in BlastInfo blast)
		{
			if (blast.source is PumpkinProjectile pumpkinProjectile && pumpkinProjectile.Shot != null)
			{
				PumpkinShot shot = pumpkinProjectile.Shot;
				if (shot.isLocal || shot.shooter == 0)
				{
					return RiftPlayers.LocalActor;
				}
				return shot.shooter;
			}
			if (blast.instigator != null && (object)blast.instigator == LAPlayer.Instance)
			{
				return RiftPlayers.LocalActor;
			}
			return 0;
		}

		public bool TryGetHostZombie(byte id, out Vector3 centre)
		{
			centre = default(Vector3);
			if (!IsHost)
			{
				return false;
			}
			if (!TryGetSlot(id, out var s) || !s.Alive)
			{
				return false;
			}
			centre = s.position + Vector3.up * 0.5f;
			return true;
		}

		public bool TryGetHostAttacker(byte id, out Vector3 at)
		{
			at = default(Vector3);
			if (!IsHost)
			{
				return false;
			}
			if (!TryGetSlot(id, out var s) || !s.active || Time.time - s.lastAttackAt > 1.2f)
			{
				return false;
			}
			at = s.position;
			return true;
		}

		public void HostOnVictimCaught(byte id, int victim)
		{
			if (TryGetSlot(id, out var s) && s.target == victim)
			{
				s.target = 0;
				s.nextThink = Time.time;
			}
		}

		private bool TryGetSlot(byte id, out Slot slot)
		{
			slot = _slots[id & 7];
			if (slot.active)
			{
				return slot.generation == id >> 3;
			}
			return false;
		}

		public void SinkAll()
		{
			if (IsHost)
			{
				for (int i = 0; i < MaxSlots; i++)
				{
					Slot s = _slots[i];
					if (s.active && s.state != ZombieState.Dying && s.state != ZombieState.Sinking)
					{
						Go(s, ZombieState.Sinking);
					}
				}
			}
			for (int j = 0; j < MaxSlots; j++)
			{
				if (_views[j] != null && _views[j].Active)
				{
					_views[j].ForceSink();
				}
			}
		}

		public void ClearAll()
		{
			for (int i = 0; i < MaxSlots; i++)
			{
				Free(_slots[i]);
				if (_views[i] != null)
				{
					_views[i].EndNow();
				}
			}
			DropAgents();
		}

		public void OnPhase(RiftPhase previous)
		{
			if (!(director == null))
			{
				RiftPhase phase = director.Phase;
				if (phase == RiftPhase.Off || phase == RiftPhase.Failed || phase == RiftPhase.Away)
				{
					SinkAll();
				}
			}
		}

		private void HostTick()
		{
			float dt = Time.deltaTime;
			for (int i = 0; i < MaxSlots; i++)
			{
				Slot s = _slots[i];
				if (s.active)
				{
					TickSlot(s, dt);
					if (s.active && _views[i] != null)
					{
						_views[i].SetFromHost(s.generation, s.position, s.yaw, s.speed, s.state, s.hitSeq, s.hp / maxHealth);
					}
				}
			}
		}

		private void TickSlot(Slot s, float dt)
		{
			s.stateTime += dt;
			NavMeshAgent agent = s.agent;
			bool onMesh = agent != null && agent.enabled && agent.isOnNavMesh;
			if (agent != null && agent.enabled && !onMesh)
			{
				if (NavMesh.SamplePosition(agent.transform.position, out var hit, 3f, -1))
				{
					agent.Warp(hit.position);
					onMesh = agent.isOnNavMesh;
				}
				else
				{
					onMesh = false;
				}
			}
			RiftAvatar target = default(RiftAvatar);
			bool hasTarget = s.target != 0 && director.TryGetPlayer(s.target, out target);
			switch (s.state)
			{
			case ZombieState.Emerge:
				if (s.stateTime >= 1.6f)
				{
					Go(s, ZombieState.Walk);
				}
				break;
			case ZombieState.Walk:
			case ZombieState.Run:
			case ZombieState.Idle:
			{
				if (Time.time >= s.nextThink)
				{
					s.nextThink = Time.time + 0.4f;
					s.target = ChooseTarget(s);
					hasTarget = s.target != 0 && director.TryGetPlayer(s.target, out target);
				}
				if (!hasTarget || director.IsImmune(s.target))
				{
					if (s.state != ZombieState.Idle)
					{
						Go(s, ZombieState.Idle);
					}
					break;
				}
				float dx = target.head.x - s.position.x;
				float dz = target.head.z - s.position.z;
				float flat = Mathf.Sqrt(dx * dx + dz * dz);
				float dy = target.head.y - s.position.y;
				if (flat <= attackRange && dy > -0.4f && dy < 2.2f && Time.time >= s.readyAt)
				{
					Go(s, ZombieState.Windup);
					break;
				}
				ZombieState want = (s.runner && flat < runWithin) ? ZombieState.Run : ZombieState.Walk;
				if (want != s.state)
				{
					Go(s, want);
				}
				if (onMesh && !(Time.time < s.nextPath))
				{
					s.nextPath = Time.time + ((flat < 6f) ? 0.15f : 0.35f);
					if (NavMesh.SamplePosition(target.head + Vector3.down * 0.85f, out var pathHit, 2.5f, -1))
					{
						agent.SetDestination(pathHit.position);
					}
				}
				break;
			}
			case ZombieState.Windup:
				if (hasTarget)
				{
					FaceTowards(s, target.head, 720f, dt);
				}
				if (s.stateTime >= 0.45f)
				{
					s.lastAttackAt = Time.time;
					Go(s, ZombieState.Attack);
				}
				break;
			case ZombieState.Attack:
				if (onMesh && s.stateTime < 0.3f)
				{
					float lunge = (Ease(s.stateTime / 0.3f) - Ease((s.stateTime - dt) / 0.3f)) * lungeDistance;
					agent.Move(Quaternion.Euler(0f, s.yaw, 0f) * Vector3.forward * lunge);
				}
				s.lastAttackAt = Time.time;
				if (s.stateTime >= 0.55f)
				{
					Go(s, ZombieState.Recover);
				}
				break;
			case ZombieState.Recover:
				if (s.stateTime >= 0.6f)
				{
					s.readyAt = Time.time + attackCooldown;
					Go(s, ZombieState.Walk);
				}
				break;
			case ZombieState.Stunned:
				if (s.stateTime >= s.stunFor)
				{
					Go(s, ZombieState.Walk);
				}
				break;
			case ZombieState.Dying:
				if (s.stateTime >= 2.15f)
				{
					Free(s);
				}
				break;
			case ZombieState.Sinking:
				if (s.stateTime >= 1.4f)
				{
					Free(s);
				}
				break;
			}
			if (!s.active)
			{
				return;
			}
			if (onMesh && s.shoveLeft > 0f)
			{
				float step = Mathf.Min(dt, s.shoveLeft);
				agent.Move(s.shove * (EaseOut(1f - (s.shoveLeft - step) / shoveTime) - EaseOut(1f - s.shoveLeft / shoveTime)));
				s.shoveLeft -= step;
			}
			if (agent != null && agent.enabled)
			{
				s.position = agent.transform.position;
			}
			bool moving = s.state == ZombieState.Walk || s.state == ZombieState.Run;
			Vector3 velocity = (onMesh && moving) ? agent.velocity : Vector3.zero;
			s.speed = Mathf.Sqrt(velocity.x * velocity.x + velocity.z * velocity.z);
			if (moving && s.speed > 0.2f)
			{
				FaceTowards(s, s.position + new Vector3(velocity.x, 0f, velocity.z), (s.state == ZombieState.Run) ? 540f : 300f, dt);
			}
		}

		private int ChooseTarget(Slot s)
		{
			IReadOnlyList<RiftAvatar> players = director.Players;
			int best = 0;
			float bestSqr = aggroRadius * aggroRadius;
			for (int i = 0; i < players.Count; i++)
			{
				RiftAvatar player = players[i];
				if (player.actor != 0 && !director.IsImmune(player.actor) && !MonsterExclusionZone.Contains(player.head))
				{
					float dx = player.head.x - s.position.x;
					float dz = player.head.z - s.position.z;
					float dy = Mathf.Abs(player.head.y - s.position.y) * 2f;
					float sqr = dx * dx + dz * dz + dy * dy;
					if (player.actor == s.target)
					{
						sqr *= 0.7f;
					}
					if (sqr < bestSqr)
					{
						bestSqr = sqr;
						best = player.actor;
					}
				}
			}
			return best;
		}

		private void Go(Slot s, ZombieState state)
		{
			s.state = state;
			s.stateTime = 0f;
			NavMeshAgent agent = s.agent;
			if (!(agent == null) && agent.enabled && agent.isOnNavMesh)
			{
				switch (state)
				{
				case ZombieState.Walk:
					agent.isStopped = false;
					agent.speed = walkSpeed * (1f + (float)s.wave * 0.06f);
					break;
				case ZombieState.Run:
					agent.isStopped = false;
					agent.speed = runSpeed * (1f + (float)s.wave * 0.06f);
					break;
				default:
					agent.isStopped = true;
					agent.velocity = Vector3.zero;
					break;
				}
			}
		}

		private static void FaceTowards(Slot s, Vector3 point, float degreesPerSecond, float dt)
		{
			float dx = point.x - s.position.x;
			float dz = point.z - s.position.z;
			if (!(dx * dx + dz * dz < 0.0001f))
			{
				float target = Quaternion.LookRotation(new Vector3(dx, 0f, dz)).eulerAngles.y;
				s.yaw = Mathf.MoveTowardsAngle(s.yaw, target, degreesPerSecond * dt);
			}
		}

		private static float Ease(float t)
		{
			t = Mathf.Clamp01(t);
			float inv = 1f - t;
			return 1f - inv * inv * inv;
		}

		private static float EaseOut(float t)
		{
			t = Mathf.Clamp01(t);
			float inv = 1f - t;
			return 1f - inv * inv;
		}

		private void Free(Slot s)
		{
			s.active = false;
			s.state = ZombieState.None;
			if (s.agent != null)
			{
				if (s.agent.enabled && s.agent.isOnNavMesh)
				{
					s.agent.isStopped = true;
				}
				s.agent.gameObject.SetActive(false);
			}
		}

		private NavMeshAgent EnsureAgent(Slot s)
		{
			if (s.agent != null)
			{
				return s.agent;
			}
			GameObject go = new GameObject(string.Format("Rift Zombie Agent {0}", s.index));
			go.transform.SetParent(transform, false);
			go.SetActive(false);
			NavMeshAgent agent = go.AddComponent<NavMeshAgent>();
			agent.radius = agentRadius;
			agent.height = agentHeight;
			agent.baseOffset = 0f;
			agent.acceleration = acceleration;
			agent.angularSpeed = 720f;
			agent.stoppingDistance = 0.6f;
			agent.autoBraking = true;
			agent.updateRotation = false;
			agent.obstacleAvoidanceType = ObstacleAvoidanceType.MedQualityObstacleAvoidance;
			agent.avoidancePriority = 40 + s.index * 3;
			agent.areaMask = -1;
			s.agent = agent;
			return agent;
		}

		private void DropAgents()
		{
			for (int i = 0; i < MaxSlots; i++)
			{
				Slot s = _slots[i];
				s.active = false;
				s.state = ZombieState.None;
				if (!(s.agent == null))
				{
					Destroy(s.agent.gameObject);
					s.agent = null;
				}
			}
		}
	}
}
