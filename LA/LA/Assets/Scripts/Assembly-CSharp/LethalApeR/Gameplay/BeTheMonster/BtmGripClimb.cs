using System;
using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGripClimb : MonoBehaviour
	{
		[Serializable]
		private struct Grip
		{
			public Transform from;

			public Transform to;

			[Min(0.01f)]
			public float radius;
		}

		private sealed class Hold
		{
			public BtmHand hand;

			public int grip;

			public float t;

			public Vector3 offset;
		}

		[SerializeField]
		private Grip[] grips;

		[SerializeField]
		[Range(0.3f, 1f)]
		private float gripThreshold = 0.7f;

		[SerializeField]
		[Range(0f, 0.3f)]
		private float releaseHysteresis = 0.12f;

		[Tooltip("How hard the body is pulled so the gripping hand stays on its spot (1/s).")]
		[SerializeField]
		[Min(1f)]
		private float pull = 22f;

		[SerializeField]
		[Min(0.5f)]
		private float maxSpeed = 6f;

		[SerializeField]
		[Range(0f, 1f)]
		private float releaseKeep = 0.9f;

		[SerializeField]
		private AudioClip gripClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.45f;

		private static BtmGripClimb _active;

		private readonly Hold[] _holds = new Hold[2];

		private readonly bool[] _wasDown = new bool[2];

		private AudioSource _voice;

		private Vector3 _lastVelocity;

		private void Awake()
		{
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
		}

		private void OnEnable()
		{
			Player.Teleported += HandleRigTeleported;
		}

		private void OnDisable()
		{
			Player.Teleported -= HandleRigTeleported;
			DropHolds();
		}

		private void HandleRigTeleported(Player player)
		{
			DropHolds();
		}

		private void DropHolds()
		{
			for (int i = 0; i < _holds.Length; i++)
			{
				if (_holds[i] != null)
				{
					_holds[i].hand.Resume(this);
				}
				_holds[i] = null;
			}
			if (_active == this)
			{
				_active = null;
			}
		}

		private void Update()
		{
			if (grips == null || grips.Length == 0 || (_active != this && !BtmTechTreeRoom.LocalInTree))
			{
				return;
			}
			bool flag = !Player.HasInstance || Player.Instance.disableMovement || BtmZipline.AnyRiding;
			for (int i = 0; i < _holds.Length; i++)
			{
				Hold hold = _holds[i];
				if (hold != null && (flag || !hold.hand.Present || hold.hand.HoldingSomething || hold.hand.Grip < gripThreshold - releaseHysteresis))
				{
					Release(i);
				}
			}
			for (int j = 0; j < BtmHands.Count; j++)
			{
				BtmHand btmHand = BtmHands.At(j);
				bool flag2 = btmHand.Present && btmHand.Grip >= gripThreshold;
				bool flag3 = _wasDown[j];
				_wasDown[j] = flag2;
				if (!flag && flag2 && !flag3 && !btmHand.HoldingSomething && !Holding(btmHand) && (!(_active != null) || !(_active != this)))
				{
					TryGrab(btmHand);
				}
			}
		}

		private void TryGrab(BtmHand hand)
		{
			Vector3 palm = hand.Palm;
			for (int i = 0; i < grips.Length; i++)
			{
				Grip grip = grips[i];
				if (grip.from == null)
				{
					continue;
				}
				Vector3 position = grip.from.position;
				Vector3 vector = ((grip.to != null) ? grip.to.position : position);
				float num = ClosestT(position, vector, palm);
				Vector3 offset = palm - Vector3.Lerp(position, vector, num);
				if (!(offset.sqrMagnitude > grip.radius * grip.radius))
				{
					int num2;
					if (_holds[0] == null)
					{
						num2 = 0;
					}
					else
					{
						if (_holds[1] != null)
						{
							return;
						}
						num2 = 1;
					}
					_holds[num2] = new Hold
					{
						hand = hand,
						grip = i,
						t = num,
						offset = offset
					};
					hand.Suspend(this);
					_active = this;
					if (gripClip != null)
					{
						_voice.PlayOneShot(gripClip, volume);
					}
					hand.Pulse(0.25f, 0.04f);
					return;
				}
			}
		}

		private void Release(int slot)
		{
			Hold hold = _holds[slot];
			if (hold == null)
			{
				return;
			}
			hold.hand.Resume(this);
			_holds[slot] = null;
			if (_holds[0] != null || _holds[1] != null)
			{
				return;
			}
			if (_active == this)
			{
				_active = null;
			}
			if (Player.HasInstance && !BtmZipline.AnyRiding)
			{
				Rigidbody playerRigidBody = Player.Instance.playerRigidBody;
				if (playerRigidBody != null && !playerRigidBody.isKinematic)
				{
					playerRigidBody.linearVelocity = _lastVelocity * releaseKeep;
				}
			}
		}

		private void FixedUpdate()
		{
			if (_active != this || !Player.HasInstance)
			{
				return;
			}
			Rigidbody playerRigidBody = Player.Instance.playerRigidBody;
			if (playerRigidBody == null || playerRigidBody.isKinematic)
			{
				return;
			}
			Vector3 zero = Vector3.zero;
			int num = 0;
			for (int i = 0; i < _holds.Length; i++)
			{
				Hold hold = _holds[i];
				if (hold != null && hold.hand.Present)
				{
					Grip grip = grips[hold.grip];
					Vector3 position = grip.from.position;
					Vector3 b = ((grip.to != null) ? grip.to.position : position);
					Vector3 vector = Vector3.Lerp(position, b, hold.t) + hold.offset;
					zero += vector - hold.hand.Palm;
					num++;
				}
			}
			if (num != 0)
			{
				Vector3 vector2 = Vector3.ClampMagnitude(zero / num * pull, maxSpeed);
				vector2 -= Physics.gravity * Time.fixedDeltaTime;
				playerRigidBody.linearVelocity = vector2;
				_lastVelocity = vector2;
			}
		}

		private bool Holding(BtmHand hand)
		{
			if (_holds[0] == null || _holds[0].hand != hand)
			{
				if (_holds[1] != null)
				{
					return _holds[1].hand == hand;
				}
				return false;
			}
			return true;
		}

		private static float ClosestT(Vector3 a, Vector3 b, Vector3 p)
		{
			Vector3 vector = b - a;
			float sqrMagnitude = vector.sqrMagnitude;
			if (sqrMagnitude < 1E-08f)
			{
				return 0f;
			}
			return Mathf.Clamp01(Vector3.Dot(p - a, vector) / sqrMagnitude);
		}

		private void OnDrawGizmosSelected()
		{
			if (grips == null)
			{
				return;
			}
			Gizmos.color = new Color(0.4f, 1f, 0.6f, 0.8f);
			Grip[] array = grips;
			for (int i = 0; i < array.Length; i++)
			{
				Grip grip = array[i];
				if (!(grip.from == null))
				{
					Vector3 vector = ((grip.to != null) ? grip.to.position : grip.from.position);
					Gizmos.DrawLine(grip.from.position, vector);
					Gizmos.DrawWireSphere(grip.from.position, grip.radius);
					Gizmos.DrawWireSphere(vector, grip.radius);
				}
			}
		}
	}
}
