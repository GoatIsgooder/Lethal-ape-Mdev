using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgHammer : MonoBehaviour
	{
		public Transform headPoint;

		public float hitRadius = 0.18f;

		private const int SampleCount = 8;

		private const float TeleportSpikeMeters = 2f;

		private const float WeakTellInterval = 0.35f;

		private const float VictimBodyHeight = 1.1f;

		private const float VictimRadius = 0.3f;

		private const float FullPowerMultiplier = 3f;

		private readonly Vector3[] _samplePos = new Vector3[8];

		private readonly float[] _sampleTime = new float[8];

		private int _sampleHead;

		private int _sampleFill;

		private readonly Dictionary<int, float> _lastHitTime = new Dictionary<int, float>();

		private readonly List<AgNetSync> _roster = new List<AgNetSync>();

		private bool _isLocal;

		private AgNetSync _avatar;

		private float _nextWeakTellTime;

		public static AgHammer LocalInstance { get; private set; }

		private void Awake()
		{
			PhotonView componentInParent = GetComponentInParent<PhotonView>();
			if (componentInParent != null && componentInParent.IsMine)
			{
				LocalInstance = this;
			}
			if (base.gameObject.activeSelf)
			{
				base.gameObject.SetActive(false);
			}
		}

		private void OnDestroy()
		{
			if (LocalInstance == this)
			{
				LocalInstance = null;
			}
		}

		public void Configure(bool isLocal)
		{
			_isLocal = isLocal;
			if (headPoint == null)
			{
				headPoint = base.transform;
			}
			if (_avatar == null)
			{
				_avatar = GetComponentInParent<AgNetSync>();
			}
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(true);
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].enabled = false;
			}
			if (_isLocal)
			{
				LocalInstance = this;
				base.enabled = true;
				ResetSamples();
				_lastHitTime.Clear();
			}
			else
			{
				base.enabled = false;
			}
		}

		private void LateUpdate()
		{
			if (!_isLocal || headPoint == null)
			{
				return;
			}
			Vector3 position = headPoint.position;
			Vector3 vector = ((_sampleFill > 0) ? _samplePos[(_sampleHead - 1 + 8) % 8] : position);
			bool flag = true;
			if ((position - vector).sqrMagnitude > 4f)
			{
				ResetSamples();
				flag = false;
			}
			_samplePos[_sampleHead] = position;
			_sampleTime[_sampleHead] = Time.time;
			_sampleHead = (_sampleHead + 1) % 8;
			if (_sampleFill < 8)
			{
				_sampleFill++;
			}
			if (flag)
			{
				SweepForHits(vector, position);
			}
		}

		private Vector3 SampledVelocity()
		{
			if (_sampleFill < 2)
			{
				return Vector3.zero;
			}
			int num = (_sampleHead - 1 + 8) % 8;
			int num2 = (_sampleHead - _sampleFill + 8) % 8;
			float num3 = _sampleTime[num] - _sampleTime[num2];
			if (num3 <= 0.0001f)
			{
				return Vector3.zero;
			}
			return (_samplePos[num] - _samplePos[num2]) / num3;
		}

		private void SweepForHits(Vector3 from, Vector3 to)
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || instance.settings == null || instance.Props == null || instance.Props.phase != AgPhase.Round || instance.Props.round != ApeGamesManager.FinalRoundIndex|| !ApeGamesManager.IsLocalAlive() || PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			AgSettings.FinalFight finalFight = instance.settings.finalFight;
			float num = Mathf.Max(hitRadius, 0.02f);
			AgNetSync.CollectAll(_roster);
			float num2 = (num + 0.3f) * (num + 0.3f);
			for (int i = 0; i < _roster.Count; i++)
			{
				AgNetSync agNetSync = _roster[i];
				if (agNetSync == null)
				{
					continue;
				}
				int actorNumber2 = agNetSync.ActorNumber;
				if (actorNumber2 < 1 || actorNumber2 == actorNumber || !instance.IsAlive(actorNumber2) || (_lastHitTime.TryGetValue(actorNumber2, out var value) && Time.time - value < finalFight.hitCooldownSeconds))
				{
					continue;
				}
				Vector3 position = ((agNetSync.Head != null) ? agNetSync.Head : agNetSync.transform).position;
				if (!(SqrSegmentDistance(from, to, position, position - Vector3.up * 1.1f) > num2))
				{
					TryLand(instance, finalFight, actorNumber2, position);
				}
			}
		}

		private void TryLand(ApeGamesManager mgr, AgSettings.FinalFight ff, int actor, Vector3 victimHead)
		{
			Vector3 vector = SampledVelocity();
			float num = Mathf.Max(ff.minHammerSpeed, 0.01f);
			float magnitude = vector.magnitude;
			if (magnitude < num)
			{
				if (Time.time >= _nextWeakTellTime)
				{
					_nextWeakTellTime = Time.time + 0.35f;
					AgHaptics.Right(0.08f, 0.04f);
				}
				return;
			}
			float num2 = Mathf.Clamp01((magnitude - num) / (num * (3f - 1f)));
			Vector3 attacker = ((_avatar != null && _avatar.Head != null) ? _avatar.Head.position : base.transform.position);
			Vector3 vector2 = FlingDirection(vector, victimHead, attacker, ff.flingUpBias);
			float num3 = Mathf.Min(Mathf.Lerp(ff.knockbackSpeed, ff.maxKnockbackSpeed, num2), ff.maxKnockbackSpeed);
			_lastHitTime[actor] = Time.time;
			mgr.ReportHammerHit(actor, vector2 * num3);
			AgHaptics.Right(Mathf.Lerp(0.35f, 1f, num2), Mathf.Lerp(0.09f, 0.18f, num2));
		}

		public static Vector3 FlingDirection(Vector3 swing, Vector3 victimHead, Vector3 attacker, float upBias)
		{
			Vector3 vector = victimHead - attacker;
			vector.y = 0f;
			Vector3 vector2 = new Vector3(swing.x, 0f, swing.z);
			bool flag = vector.sqrMagnitude > 0.0001f;
			Vector3 vector3 = (flag ? vector.normalized : Vector3.zero);
			Vector3 vector4 = ((vector2.sqrMagnitude > 0.0001f) ? vector2.normalized : (flag ? vector3 : Vector3.forward));
			if (flag)
			{
				Vector3 vector5 = vector4 * 0.7f + vector3 * 0.3f;
				if (Vector3.Dot(vector5, vector3) <= 0f)
				{
					vector5 = vector3;
				}
				vector5.y = 0f;
				vector4 = ((vector5.sqrMagnitude >= 0.0001f) ? vector5 : vector3);
			}
			else
			{
				Vector3 vector6 = new Vector3(vector4.x, 0f, vector4.z);
				if (vector6.sqrMagnitude >= 0.0001f)
				{
					vector4 = vector6;
				}
			}
			// RE: unsure - blend/flatten branch structure reconstructed from folded selects; results match the binary
			return (vector4.normalized + Vector3.up * Mathf.Max(upBias, 0f)).normalized;
		}

		public static float SqrSegmentDistance(Vector3 p1, Vector3 q1, Vector3 p2, Vector3 q2)
		{
			Vector3 vector = q1 - p1;
			Vector3 vector2 = q2 - p2;
			Vector3 vector3 = p1 - p2;
			float num = Vector3.Dot(vector, vector);
			float num2 = Vector3.Dot(vector2, vector2);
			float num3 = Vector3.Dot(vector2, vector3);
			if (num <= 1E-06f && num2 <= 1E-06f)
			{
				return Vector3.Dot(vector3, vector3);
			}
			float num4;
			float num5;
			if (num <= 1E-06f)
			{
				num4 = 0f;
				num5 = Mathf.Clamp01(num3 / num2);
			}
			else
			{
				float num6 = Vector3.Dot(vector, vector3);
				if (num2 <= 1E-06f)
				{
					num5 = 0f;
					num4 = Mathf.Clamp01((0f - num6) / num);
				}
				else
				{
					float num7 = Vector3.Dot(vector, vector2);
					float num8 = num * num2 - num7 * num7;
					num4 = ((num8 > 1E-06f) ? Mathf.Clamp01((num7 * num3 - num6 * num2) / num8) : 0f);
					num5 = (num7 * num4 + num3) / num2;
					if (num5 < 0f)
					{
						num5 = 0f;
						num4 = Mathf.Clamp01((0f - num6) / num);
					}
					else if (num5 > 1f)
					{
						num5 = 1f;
						num4 = Mathf.Clamp01((num7 - num6) / num);
					}
				}
			}
			Vector3 vector4 = p1 + vector * num4;
			Vector3 vector5 = p2 + vector2 * num5;
			return (vector4 - vector5).sqrMagnitude;
		}

		private void ResetSamples()
		{
			_sampleHead = 0;
			_sampleFill = 0;
		}

		private void OnDisable()
		{
			ResetSamples();
			_lastHitTime.Clear();
		}
	}
}
