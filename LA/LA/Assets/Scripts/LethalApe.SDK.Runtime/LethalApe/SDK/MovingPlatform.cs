using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Movement/Moving Platform")]
	[DisallowMultipleComponent]
	public sealed class MovingPlatform : MapComponent
	{
		[SerializeField]
		[Tooltip("Path points as offsets from the platform's starting position, in the parent's space. The first point is normally zero.")]
		private Vector3[] points = new Vector3[2]
		{
			Vector3.zero,
			new Vector3(0f, 0f, 4f)
		};

		[SerializeField]
		[Min(0.05f)]
		[Tooltip("Top speed in m/s.")]
		private float speed = 1.5f;

		[SerializeField]
		[Min(0.05f)]
		[Tooltip("How quickly it speeds up and slows down, in m/s².")]
		private float acceleration = 2f;

		[SerializeField]
		[Tooltip("On: travels back along the path at the end. Off: loops from the last point back to the first.")]
		private bool pingPong = true;

		[SerializeField]
		[Min(0f)]
		[Tooltip("Seconds it waits at each end.")]
		private float pauseAtEnds = 0.75f;

		[SerializeField]
		[Tooltip("Spin around an axis as well as travelling.")]
		private bool rotate;

		[SerializeField]
		private Vector3 rotationAxis = Vector3.up;

		[SerializeField]
		[Range(-180f, 180f)]
		[Tooltip("Degrees per second.")]
		private float rotationSpeed = 30f;

		[SerializeField]
		[Tooltip("Off: it waits until a Logic Trigger starts it.")]
		private bool startActive = true;

		public Vector3[] Points => points;

		public float Speed => speed;

		public float Acceleration => acceleration;

		public bool PingPong => pingPong;

		public float PauseAtEnds => pauseAtEnds;

		public bool Rotate => rotate;

		public Vector3 RotationAxis => rotationAxis;

		public float RotationSpeed => rotationSpeed;

		public bool StartActive => startActive;
	}
}
