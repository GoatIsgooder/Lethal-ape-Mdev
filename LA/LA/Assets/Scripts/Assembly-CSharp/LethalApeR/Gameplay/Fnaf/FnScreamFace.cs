using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnScreamFace : MonoBehaviour
	{
		public Transform head;

		public Transform leftArm;

		public Transform rightArm;

		[Tooltip("Optional. Chatters about its local X (the hinge on the monster rigs) on top of the authored pose.")]
		public Transform jaw;

		[Tooltip("Shudder amplitude (degrees).")]
		public float shudder = 3f;

		[Tooltip("Shudder rate (Hz).")]
		public float rate = 13f;

		[Tooltip("Jaw chatter amplitude (degrees, opening only: it never closes past the authored pose).")]
		public float jawChatter = 6f;

		[Tooltip("Which way about local X opens the mouth (+1 or -1); the face builder measures it.")]
		public float jawSign = 1f;

		private Quaternion _head;

		private Quaternion _left;

		private Quaternion _right;

		private Quaternion _jaw;

		private bool _captured;

		private float _seed;

		private void OnEnable()
		{
			if (!_captured)
			{
				_captured = true;
				if (head != null)
				{
					_head = head.localRotation;
				}
				if (leftArm != null)
				{
					_left = leftArm.localRotation;
				}
				if (rightArm != null)
				{
					_right = rightArm.localRotation;
				}
				if (jaw != null)
				{
					_jaw = jaw.localRotation;
				}
			}
			_seed = Random.value * 50f;
		}

		private void OnDisable()
		{
			if (_captured)
			{
				if (head != null)
				{
					head.localRotation = _head;
				}
				if (leftArm != null)
				{
					leftArm.localRotation = _left;
				}
				if (rightArm != null)
				{
					rightArm.localRotation = _right;
				}
				if (jaw != null)
				{
					jaw.localRotation = _jaw;
				}
			}
		}

		private void LateUpdate()
		{
			float t = Time.unscaledTime * rate;
			if (head != null)
			{
				head.localRotation = _head * Quaternion.Euler(Shake(t, 0f), Shake(t, 7f), Shake(t, 13f) * 0.6f);
			}
			if (leftArm != null)
			{
				leftArm.localRotation = _left * Quaternion.Euler(Shake(t, 19f), 0f, Shake(t, 23f));
			}
			if (rightArm != null)
			{
				rightArm.localRotation = _right * Quaternion.Euler(Shake(t, 29f), 0f, Shake(t, 31f));
			}
			if (jaw != null)
			{
				float x = Mathf.PerlinNoise(t * 1.7f, _seed + 37f) * jawChatter * jawSign;
				jaw.localRotation = _jaw * Quaternion.Euler(x, 0f, 0f);
			}
		}

		private float Shake(float t, float offset)
		{
			return shudder * ((Mathf.PerlinNoise(t, _seed + offset) - 0.5f) * 2f);
		}
	}
}
