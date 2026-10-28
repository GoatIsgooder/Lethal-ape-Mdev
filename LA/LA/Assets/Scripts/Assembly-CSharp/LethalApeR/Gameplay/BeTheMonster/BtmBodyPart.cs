using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(10450)]
	public sealed class BtmBodyPart : MonoBehaviour
	{
		private struct Pending
		{
			public int Monster;

			public int Victim;

			public int Key;

			public int Bone;

			public bool Left;

			public Vector3 Offset;

			public Quaternion Turn;

			public float Size;

			public float Until;
		}

		public const int BodyKey = 0;

		public const int HeadKey = 1;

		private const int PieceKeys = 2;

		private const int RanksPerBone = 8;

		private const float SinkSeconds = 1.6f;

		private const float SinkDepth = 0.45f;

		private const float MaxTrackedSpeed = 25f;

		private const float MaxThrowSpeed = 14f;

		private const float PendingSeconds = 1.5f;

		public static readonly List<BtmBodyPart> All = new List<BtmBodyPart>();

		private static readonly List<Pending> Waiting = new List<Pending>();

		private readonly List<Mesh> _meshes = new List<Mesh>();

		private Rigidbody[] _bones = Array.Empty<Rigidbody>();

		private float _dropSeconds = 10f;

		private float _expiresAt = float.PositiveInfinity;

		private bool _retiring;

		private float _retireAt;

		private Transform _hand;

		private int _holder;

		private int _heldAs;

		private Rigidbody _held;

		private RigidbodyInterpolation _heldInterpolation;

		private Vector3 _offset;

		private Quaternion _turn;

		private Vector3 _lastPosition;

		private Quaternion _lastRotation;

		private Vector3 _velocity;

		private Vector3 _spin;

		public int Victim { get; private set; } = -1;

		public int Key { get; private set; }

		public bool Held => _held;

		public bool Retiring => _retiring;

		public float Size { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			All.Clear();
			Waiting.Clear();
		}

		public void Init(int victim, int key, Rigidbody[] bones, float dropSeconds, float size)
		{
			Victim = victim;
			Key = key;
			_bones = bones ?? Array.Empty<Rigidbody>();
			_dropSeconds = dropSeconds;
			Size = size;
		}

		public void Arm(float lifetime)
		{
			_expiresAt = Time.time + lifetime;
		}

		public void Own(Mesh mesh)
		{
			if (mesh)
			{
				_meshes.Add(mesh);
			}
		}

		public int BoneOf(Rigidbody body)
		{
			if (!body)
			{
				return -1;
			}
			return Array.IndexOf(_bones, body);
		}

		public void Forget(Rigidbody body)
		{
			int bone = BoneOf(body);
			if (bone >= 0)
			{
				_bones[bone] = null;
			}
		}

		public static int PieceKey(int bone, int rank)
		{
			return PieceKeys + bone * RanksPerBone + Mathf.Clamp(rank, 0, RanksPerBone - 1);
		}

		private static int PieceBone(int key)
		{
			return (key - PieceKeys) / RanksPerBone;
		}

		private void OnEnable()
		{
			if (!All.Contains(this))
			{
				All.Add(this);
			}
		}

		private void OnDisable()
		{
			All.Remove(this);
		}

		private void OnDestroy()
		{
			foreach (Mesh mesh in _meshes)
			{
				if (mesh)
				{
					Destroy(mesh);
				}
			}
			_meshes.Clear();
		}

		public static void ClearAll()
		{
			for (int i = All.Count - 1; i >= 0; i--)
			{
				if (All[i])
				{
					Destroy(All[i].gameObject);
				}
			}
			All.Clear();
			Waiting.Clear();
		}

		private void Update()
		{
			if (_retiring)
			{
				Sink();
			}
			else if (!_held && Time.time >= _expiresAt)
			{
				Retire();
			}
		}

		public void Retire()
		{
			if (_retiring || _held)
			{
				return;
			}
			_retiring = true;
			_retireAt = Time.time;
			Rigidbody[] bodies = GetComponentsInChildren<Rigidbody>();
			foreach (Rigidbody body in bodies)
			{
				body.isKinematic = true;
				body.interpolation = RigidbodyInterpolation.None;
			}
			Collider[] colliders = GetComponentsInChildren<Collider>();
			foreach (Collider collider in colliders)
			{
				collider.enabled = false;
			}
		}

		private void Sink()
		{
			if (Time.time - _retireAt >= SinkSeconds)
			{
				Destroy(gameObject);
				return;
			}
			transform.position += Vector3.down * (Time.deltaTime * SinkDepth / SinkSeconds);
		}

		public bool Hold(Transform hand, int holder, int bone, Vector3 offset, Quaternion turn)
		{
			if (_retiring || !hand)
			{
				return false;
			}
			Rigidbody body = (bone >= 0 && bone < _bones.Length) ? _bones[bone] : null;
			if (!body)
			{
				body = FirstBone();
			}
			if (!body)
			{
				return false;
			}
			if (_held)
			{
				Let(Vector3.zero, Vector3.zero);
			}
			_hand = hand;
			_holder = holder;
			_heldAs = Key;
			_held = body;
			_offset = offset;
			_turn = turn;
			_heldInterpolation = body.interpolation;
			body.interpolation = RigidbodyInterpolation.None;
			body.isKinematic = true;
			Place();
			_lastPosition = body.position;
			_lastRotation = body.rotation;
			_velocity = Vector3.zero;
			_spin = Vector3.zero;
			return true;
		}

		public bool HeldBy(Transform hand)
		{
			if (_held)
			{
				return _hand == hand;
			}
			return false;
		}

		public bool HeldPose(out int bone, out Vector3 position, out Quaternion rotation, out Vector3 velocity, out Vector3 spin)
		{
			bone = BoneOf(_held);
			position = (_held ? _held.position : default(Vector3));
			rotation = (_held ? _held.rotation : Quaternion.identity);
			velocity = _velocity;
			spin = _spin;
			return _held;
		}

		public void Let(Vector3 velocity, Vector3 spin)
		{
			Rigidbody held = _held;
			_held = null;
			_hand = null;
			_holder = 0;
			if (!held)
			{
				return;
			}
			held.isKinematic = false;
			held.interpolation = _heldInterpolation;
			velocity = Vector3.ClampMagnitude(velocity, MaxThrowSpeed);
			Rigidbody[] bodies = GetComponentsInChildren<Rigidbody>();
			foreach (Rigidbody body in bodies)
			{
				if (!body.isKinematic)
				{
					body.linearVelocity = velocity;
				}
			}
			held.angularVelocity = spin;
			_expiresAt = Time.time + _dropSeconds;
			BtmGoreLanding[] landings = GetComponentsInChildren<BtmGoreLanding>();
			foreach (BtmGoreLanding landing in landings)
			{
				landing.Rearm();
			}
			BtmGorePiece[] pieces = GetComponentsInChildren<BtmGorePiece>();
			foreach (BtmGorePiece piece in pieces)
			{
				piece.Rearm();
			}
		}

		private Rigidbody FirstBone()
		{
			for (int i = 0; i < _bones.Length; i++)
			{
				if (_bones[i])
				{
					return _bones[i];
				}
			}
			return null;
		}

		private bool Target(out Vector3 position, out Quaternion rotation)
		{
			position = default(Vector3);
			rotation = Quaternion.identity;
			if (!_hand)
			{
				return false;
			}
			rotation = _hand.rotation * _turn;
			position = _hand.position + _hand.rotation * _offset;
			return true;
		}

		private void Place()
		{
			if (Target(out var position, out var rotation))
			{
				_held.transform.SetPositionAndRotation(position, rotation);
			}
		}

		private void LateUpdate()
		{
			if (!_held)
			{
				return;
			}
			if (!_hand || !_hand.gameObject.activeInHierarchy)
			{
				Let(_velocity, _spin);
				return;
			}
			Place();
			float deltaTime = Time.deltaTime;
			if (deltaTime <= 1E-05f)
			{
				return;
			}
			Vector3 velocity = (_held.position - _lastPosition) / deltaTime;
			if (velocity.sqrMagnitude < MaxTrackedSpeed * MaxTrackedSpeed)
			{
				_velocity = Vector3.Lerp(_velocity, velocity, 0.5f);
			}
			else
			{
				_velocity = Vector3.zero;
			}
			(_held.rotation * Quaternion.Inverse(_lastRotation)).ToAngleAxis(out var angle, out var axis);
			if (angle > 180f)
			{
				angle -= 360f;
			}
			Vector3 spin = (float.IsFinite(axis.x) ? (axis * (angle * Mathf.Deg2Rad / deltaTime)) : Vector3.zero);
			if (spin.sqrMagnitude < 900f)
			{
				_spin = Vector3.Lerp(_spin, spin, 0.5f);
			}
			_lastPosition = _held.position;
			_lastRotation = _held.rotation;
		}

		private void FixedUpdate()
		{
			if (_held && Target(out var position, out var rotation))
			{
				_held.MovePosition(position);
				_held.MoveRotation(rotation);
			}
		}

		public static BtmBodyPart Find(int victim, int key, float size = 0f)
		{
			if (victim < 0)
			{
				return null;
			}
			BtmBodyPart closest = null;
			BtmBodyPart largest = null;
			foreach (BtmBodyPart part in All)
			{
				if (!part || part.Victim != victim || part._retiring)
				{
					continue;
				}
				if (part.Key == key)
				{
					return part;
				}
				if (key >= PieceKeys && part.Key >= PieceKeys)
				{
					if (PieceBone(part.Key) == PieceBone(key) && (!closest || Mathf.Abs(part.Size - size) < Mathf.Abs(closest.Size - size)))
					{
						closest = part;
					}
					if (!largest || part.Size > largest.Size)
					{
						largest = part;
					}
				}
			}
			if (!closest)
			{
				return largest;
			}
			return closest;
		}

		public static void PickedUp(int monster, int victim, int key, int bone, bool left, Vector3 offset, Quaternion turn, float size)
		{
			if (!TryPickUp(monster, victim, key, bone, left, offset, turn, size))
			{
				Waiting.Add(new Pending
				{
					Monster = monster,
					Victim = victim,
					Key = key,
					Bone = bone,
					Left = left,
					Offset = offset,
					Turn = turn,
					Size = size,
					Until = Time.time + PendingSeconds
				});
			}
		}

		public static void Dropped(int monster, int victim, int key, Vector3 position, Quaternion rotation, Vector3 velocity, Vector3 spin)
		{
			for (int i = Waiting.Count - 1; i >= 0; i--)
			{
				if (Waiting[i].Monster == monster && Waiting[i].Victim == victim && Waiting[i].Key == key)
				{
					Waiting.RemoveAt(i);
				}
			}
			foreach (BtmBodyPart part in All)
			{
				if (part && part.Victim == victim && part._held && part._holder == monster && part._heldAs == key)
				{
					part._held.position = position;
					part._held.rotation = rotation;
					part._held.transform.SetPositionAndRotation(position, rotation);
					part.Let(velocity, spin);
					break;
				}
			}
		}

		public static void RetryWaiting()
		{
			for (int i = Waiting.Count - 1; i >= 0; i--)
			{
				Pending pending = Waiting[i];
				if (Time.time > pending.Until || TryPickUp(pending.Monster, pending.Victim, pending.Key, pending.Bone, pending.Left, pending.Offset, pending.Turn, pending.Size))
				{
					Waiting.RemoveAt(i);
				}
			}
		}

		private static bool TryPickUp(int monster, int victim, int key, int bone, bool left, Vector3 offset, Quaternion turn, float size)
		{
			BtmBodyPart part = Find(victim, key, size);
			if (!part || part._held)
			{
				return false;
			}
			BtmMonsterHand hand = BtmMonsterHand.Of(monster, left);
			if (!hand)
			{
				return false;
			}
			if (!part.Hold(hand.transform, monster, bone, offset, turn))
			{
				return false;
			}
			part._heldAs = key;
			return true;
		}
	}
}
