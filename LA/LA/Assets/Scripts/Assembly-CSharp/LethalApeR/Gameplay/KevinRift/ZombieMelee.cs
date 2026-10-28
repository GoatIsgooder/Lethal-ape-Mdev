using System;
using System.Collections.Generic;
using LALocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Gameplay.Pumpkin;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class ZombieMelee : MonoBehaviour
	{
		private struct Tracked
		{
			public Matrix4x4 lastToWorld;

			public bool item;

			public int frame;
		}

		[Tooltip("Slower than this into the body and it's a touch, not a hit (m/s).")]
		public float minSpeed = 2.5f;

		[Tooltip("Hits this fast or faster do the most damage (m/s).")]
		public float fullSpeed = 6.5f;

		public float minDamage = 25f;

		public float maxDamage = 40f;

		[Tooltip("Damage multiplier for a held prop (a pipe or a sledge beats a palm).")]
		public float itemMultiplier = 1.3f;

		[Tooltip("The same hand can't hit the same zombie again for this long (s).")]
		public float cooldown = 0.3f;

		[Range(0f, 1f)]
		public float hapticMin = 0.45f;

		public AudioClip[] impactClips = new AudioClip[0];

		[NonSerialized]
		public KevinRiftDirector director;

		private readonly Dictionary<Collider, Tracked> _tracked = new Dictionary<Collider, Tracked>();

		private readonly List<Collider> _stale = new List<Collider>();

		private readonly float[,] _ready = new float[2, 8];

		private AudioSource _audio;

		private void Update()
		{
			if (director == null || director.Phase != RiftPhase.Waves || director.horde == null || director.horde.LivingCount == 0)
			{
				if (_tracked.Count > 0)
				{
					_tracked.Clear();
				}
				return;
			}
			LAPlayer player = LAPlayer.Instance;
			if (player == null || !player.isActiveAndEnabled)
			{
				return;
			}
			float dt = Time.deltaTime;
			if (dt <= 1E-05f)
			{
				return;
			}
			int frame = Time.frameCount;
			Sweep(player.leftHand, true, frame, dt);
			Sweep(player.rightHand, false, frame, dt);
			if (frame % 30 != 0)
			{
				return;
			}
			_stale.Clear();
			foreach (KeyValuePair<Collider, Tracked> pair in _tracked)
			{
				if (pair.Key == null || frame - pair.Value.frame > 30)
				{
					_stale.Add(pair.Key);
				}
			}
			for (int i = 0; i < _stale.Count; i++)
			{
				_tracked.Remove(_stale[i]);
			}
		}

		private void Sweep(LAHand hand, bool left, int frame, float dt)
		{
			if (hand?.contacts == null)
			{
				return;
			}
			for (int i = 0; i < hand.contacts.Count; i++)
			{
				Collider c = hand.contacts[i].collider;
				if (c == null || !c.enabled || !c.gameObject.activeInHierarchy)
				{
					continue;
				}
				Matrix4x4 now = c.transform.localToWorldMatrix;
				if (_tracked.TryGetValue(c, out var tracked) && frame - tracked.frame < 3)
				{
					TestHits(c, left, in tracked, now, dt);
					tracked.lastToWorld = now;
					tracked.frame = frame;
					_tracked[c] = tracked;
				}
				else
				{
					_tracked[c] = new Tracked
					{
						lastToWorld = now,
						item = c.GetComponentInParent<LAGrabbable>() != null,
						frame = frame
					};
				}
			}
		}

		private void TestHits(Collider c, bool left, in Tracked tracked, Matrix4x4 now, float dt)
		{
			ZombieHorde horde = director.horde;
			Bounds bounds = c.bounds;
			Vector3 centre = bounds.center;
			float radius = bounds.extents.magnitude;
			int row = left ? 0 : 1;
			for (int i = 0; i < ZombieHorde.MaxSlots; i++)
			{
				ZombieView view = horde.View(i);
				if (view == null || !view.Alive || Time.time < _ready[row, i])
				{
					continue;
				}
				PumpkinBody body = view.Body;
				Vector3 near = PumpkinRig.ClosestOnSegment(centre, body.torsoTop, body.torsoBottom);
				float reach = radius + body.torsoRadius + 0.3f;
				if ((centre - near).sqrMagnitude > reach * reach)
				{
					continue;
				}
				Vector3 point = Closest(c, near);
				Vector3 inward = PumpkinRig.ClosestOnSegment(point, body.torsoTop, body.torsoBottom) - point;
				float gap = inward.magnitude - body.torsoRadius;
				float headGap = (body.head - point).magnitude - body.headRadius;
				if (headGap < gap)
				{
					inward = body.head - point;
					gap = headGap;
				}
				if (gap > 0.04f)
				{
					continue;
				}
				Vector3 local = now.inverse.MultiplyPoint3x4(point);
				Vector3 velocity = (point - tracked.lastToWorld.MultiplyPoint3x4(local)) / dt;
				Vector3 normal = (inward.sqrMagnitude > 1E-06f) ? inward.normalized : (view.Centre - point).normalized;
				float speed = Vector3.Dot(velocity, normal);
				if (!(speed < minSpeed))
				{
					float strength = Mathf.InverseLerp(minSpeed, fullSpeed, speed);
					float multiplier = tracked.item ? itemMultiplier : 1f;
					_ready[row, i] = Time.time + cooldown;
					Vector3 direction = velocity.normalized;
					int damage = Mathf.Clamp(Mathf.RoundToInt(Mathf.Lerp(minDamage, maxDamage, strength) * multiplier), 1, 255);
					Land(view, left, point, direction, damage, tracked.item, strength);
				}
			}
		}

		private void Land(ZombieView view, bool left, Vector3 point, Vector3 direction, int damage, bool item, float strength)
		{
			view.LocalHitFlash();
			VRInputController instance = VRInputController.Instance;
			if (instance != null)
			{
				float amplitude = Mathf.Lerp(hapticMin, 1f, strength);
				if (left)
				{
					instance.PulseLeft(amplitude, 0.07f);
				}
				else
				{
					instance.PulseRight(amplitude, 0.07f);
				}
			}
			if (impactClips.Length != 0)
			{
				if (_audio == null)
				{
					_audio = base.gameObject.AddComponent<AudioSource>();
					_audio.playOnAwake = false;
					_audio.spatialBlend = 1f;
					_audio.spatialize = false;
					_audio.minDistance = 1f;
					_audio.maxDistance = 15f;
					_audio.rolloffMode = AudioRolloffMode.Logarithmic;
				}
				_audio.transform.position = point;
				_audio.PlayOneShot(impactClips[UnityEngine.Random.Range(0, impactClips.Length)], Mathf.Lerp(0.6f, 1f, strength));
			}
			ZombieDamage cause = item ? ZombieDamage.Item : ZombieDamage.Hand;
			if (director.IsAuthority)
			{
				director.OnMeleeReport(RiftPlayers.LocalActor, director.Epoch, view.NetId, (byte)damage, cause, left, RiftLocalHand(left, point), direction);
			}
			else
			{
				KevinRiftNet.SendMelee(director.Epoch, view.NetId, (byte)damage, cause, left, point, direction);
			}
		}

		private static Vector3 RiftLocalHand(bool left, Vector3 fallback)
		{
			if (RiftPlayers.TryGetLocal(out var avatar))
			{
				return avatar.Hand(left);
			}
			return fallback;
		}

		private static Vector3 Closest(Collider c, Vector3 point)
		{
			if (c is BoxCollider || c is SphereCollider || c is CapsuleCollider || (c is MeshCollider meshCollider && meshCollider.convex))
			{
				return c.ClosestPoint(point);
			}
			return c.bounds.ClosestPoint(point);
		}
	}
}
