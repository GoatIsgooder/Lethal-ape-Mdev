using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class BtmPotionLiquid : MonoBehaviour
	{
		[SerializeField]
		private Renderer liquid;

		[Tooltip("Spring stiffness of the surface; higher = faster, tighter slosh.")]
		[SerializeField]
		[Min(1f)]
		private float stiffness = 95f;

		[Tooltip("Damping of the slosh; ~2*sqrt(stiffness) is critically damped.")]
		[SerializeField]
		[Min(0f)]
		private float damping = 5.5f;

		[Tooltip("Tilt impulse per m/s of velocity change.")]
		[SerializeField]
		[Min(0f)]
		private float velocityKick = 3.2f;

		[Tooltip("Tilt impulse per rad/s of spin change.")]
		[SerializeField]
		[Min(0f)]
		private float spinKick = 0.05f;

		[SerializeField]
		[Range(0.05f, 1.5f)]
		private float maxTilt = 0.85f;

		private static readonly int WobbleXId = Shader.PropertyToID("_WobbleX");

		private static readonly int WobbleZId = Shader.PropertyToID("_WobbleZ");

		private const float TeleportDistance = 1.5f;

		private const float RestEpsilon = 0.0004f;

		private MaterialPropertyBlock _mpb;

		private Transform _tr;

		private Vector3 _lastPos;

		private Quaternion _lastRot;

		private Vector3 _lastVel;

		private Vector3 _lastSpin;

		private Vector2 _tilt;

		private Vector2 _tiltVel;

		private bool _applied;

		private void Awake()
		{
			_tr = base.transform;
			_mpb = new MaterialPropertyBlock();
		}

		private void OnEnable()
		{
			ResetMotion();
		}

		private void OnDisable()
		{
			_tilt = Vector2.zero;
			_tiltVel = Vector2.zero;
			if (_applied)
			{
				Apply();
			}
		}

		private void ResetMotion()
		{
			_lastPos = _tr.position;
			_lastRot = _tr.rotation;
			_lastVel = Vector3.zero;
			_lastSpin = Vector3.zero;
		}

		private void LateUpdate()
		{
			if (liquid == null)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			if (!(deltaTime > 1E-05f))
			{
				return;
			}
			Vector3 position = _tr.position;
			Quaternion rotation = _tr.rotation;
			if ((position - _lastPos).sqrMagnitude > TeleportDistance * TeleportDistance)
			{
				_lastPos = position;
				_lastRot = rotation;
				_lastVel = Vector3.zero;
				_lastSpin = Vector3.zero;
				return;
			}
			float num = Mathf.Min(deltaTime, 1f / 30f);
			Vector3 vector = (position - _lastPos) / num;
			(rotation * Quaternion.Inverse(_lastRot)).ToAngleAxis(out var angle, out var axis);
			if (angle > 180f)
			{
				angle -= 360f;
			}
			Vector3 vector2 = (float.IsFinite(axis.x) ? (axis * (angle * Mathf.Deg2Rad / num)) : Vector3.zero);
			Vector3 vector3 = vector - _lastVel;
			Vector3 vector4 = vector2 - _lastSpin;
			_lastPos = position;
			_lastRot = rotation;
			_lastVel = vector;
			_lastSpin = vector2;
			_tiltVel += new Vector2(vector3.x * velocityKick + vector4.z * spinKick, vector3.z * velocityKick - vector4.x * spinKick);
			_tiltVel += (-stiffness * _tilt - _tiltVel * damping) * num;
			_tilt += _tiltVel * num;
			if (_tilt.sqrMagnitude > maxTilt * maxTilt)
			{
				_tilt = _tilt.normalized * maxTilt;
				_tiltVel *= 0.5f;
			}
			if (_tilt.sqrMagnitude < RestEpsilon * RestEpsilon && _tiltVel.sqrMagnitude < RestEpsilon)
			{
				_tilt = Vector2.zero;
				_tiltVel = Vector2.zero;
				if (_applied)
				{
					Apply();
					_applied = false;
				}
			}
			else
			{
				Apply();
				_applied = true;
			}
		}

		private void Apply()
		{
			liquid.GetPropertyBlock(_mpb);
			_mpb.SetFloat(WobbleXId, _tilt.x);
			_mpb.SetFloat(WobbleZId, _tilt.y);
			liquid.SetPropertyBlock(_mpb);
		}
	}
}
