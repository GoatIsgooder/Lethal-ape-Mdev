using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmCyberGlobals : MonoBehaviour
	{
		[SerializeField]
		private Transform pulseOrigin;

		[Tooltip("Must match the materials' Pulse Interval so the clock wraps on a ring boundary.")]
		[SerializeField]
		[Min(0.1f)]
		private float pulseInterval = 5f;

		private static readonly int RevealCenterId = Shader.PropertyToID("_BtmRevealCenter");

		private static readonly int PulseOriginId = Shader.PropertyToID("_BtmPulseOrigin");

		private static readonly int PulseClockId = Shader.PropertyToID("_BtmPulseClock");

		private static readonly int HandLId = Shader.PropertyToID("_BtmHandL");

		private static readonly int HandRId = Shader.PropertyToID("_BtmHandR");

		private Vector3 _burstOrigin;

		private float _burstUntil = -1f;

		private float _clock;

		public static BtmCyberGlobals Instance { get; private set; }

		private void OnEnable()
		{
			Instance = this;
		}

		private void OnDisable()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void Burst(Vector3 worldPoint)
		{
			_burstOrigin = worldPoint;
			_burstUntil = Time.time + pulseInterval;
			_clock = 0f;
		}

		private void LateUpdate()
		{
			_clock = (_clock + Time.deltaTime) % pulseInterval;
			Shader.SetGlobalFloat(PulseClockId, _clock);
			Vector3 origin = ((Time.time < _burstUntil) ? _burstOrigin : ((pulseOrigin != null) ? pulseOrigin : base.transform).position);
			Shader.SetGlobalVector(PulseOriginId, origin);
			if (!GorillaLocomotion.Player.HasInstance)
			{
				Shader.SetGlobalVector(RevealCenterId, Vector4.zero);
				Shader.SetGlobalVector(HandLId, Vector4.zero);
				Shader.SetGlobalVector(HandRId, Vector4.zero);
				return;
			}
			GorillaLocomotion.Player player = GorillaLocomotion.Player.Instance;
			Vector3 head = ((player.headCollider != null) ? player.headCollider.transform : player.transform).position;
			Shader.SetGlobalVector(RevealCenterId, new Vector4(head.x, head.y, head.z, 1f));
			Shader.SetGlobalVector(HandLId, Point(player.leftHandFollower));
			Shader.SetGlobalVector(HandRId, Point(player.rightHandFollower));
		}

		private static Vector4 Point(Transform t)
		{
			if (t == null)
			{
				return Vector4.zero;
			}
			Vector3 position = t.position;
			return new Vector4(position.x, position.y, position.z, 1f);
		}
	}
}
