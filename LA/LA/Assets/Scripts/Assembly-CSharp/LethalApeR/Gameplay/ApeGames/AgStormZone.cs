using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
	public class AgStormZone : MonoBehaviour
	{
		[Header("Shape")]
		[SerializeField]
		private float startRadius = 22f;

		[SerializeField]
		private float endRadius = 3f;

		[SerializeField]
		private float height = 30f;

		[SerializeField]
		[Range(12f, 96f)]
		private int segments = 40;

		[Header("Timing")]
		[SerializeField]
		private float holdSeconds = 20f;

		[SerializeField]
		private float shrinkSeconds = 90f;

		[SerializeField]
		private AnimationCurve shrinkCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		[Header("Push")]
		[SerializeField]
		private float graceSeconds = 1.5f;

		[SerializeField]
		private float rampSeconds = 12f;

		[SerializeField]
		private float pushSpeedMin = 4f;

		[SerializeField]
		private float pushSpeedMax = 16f;

		[SerializeField]
		private float pushDown = 1.5f;

		[SerializeField]
		private float maxSpeed = 22f;

		[SerializeField]
		private float pushInterval = 0.55f;

		[Header("Feedback")]
		[SerializeField]
		private AudioSource inStormSfx;

		[SerializeField]
		private AudioSource shoveSfx;

		[SerializeField]
		private float inStormVolumeMin = 0.25f;

		[SerializeField]
		private float inStormVolumeMax = 1f;

		[SerializeField]
		private float shovePitchMin = 0.9f;

		[SerializeField]
		private float shovePitchMax = 1.3f;

		[SerializeField]
		private AgVignettePulse vignettePulse;

		[SerializeField]
		private Color pulseColor = new Color(0.55f, 0.3f, 0.95f, 1f);

		[SerializeField]
		private float pulseStrengthMin = 0.35f;

		[SerializeField]
		private float holdIntensity = 0.4f;

		[SerializeField]
		private float hapticMin = 0.35f;

		[SerializeField]
		private float hapticMax = 1f;

		[SerializeField]
		private float hapticDuration = 0.15f;

		private MeshRenderer _renderer;

		private float _radius;

		private float _outsideSince = -1f;

		private float _nextPush;

		public float Radius => _radius;

		public float Threat
		{
			get
			{
				if (_outsideSince < 0f)
				{
					return 0f;
				}
				float over = Time.time - _outsideSince - graceSeconds;
				if (over <= 0f)
				{
					return 0f;
				}
				if (rampSeconds <= 0f)
				{
					return 1f;
				}
				return Mathf.Clamp01(over / rampSeconds);
			}
		}

		private void Awake()
		{
			_renderer = GetComponent<MeshRenderer>();
			_renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
			_renderer.receiveShadows = false;
			_renderer.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
			_renderer.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
			GetComponent<MeshFilter>().sharedMesh = BuildTube(segments);
			if (vignettePulse == null)
			{
				vignettePulse = Object.FindFirstObjectByType<AgVignettePulse>();
			}
			Collider[] colliders = GetComponents<Collider>();
			for (int i = 0; i < colliders.Length; i++)
			{
				colliders[i].enabled = false;
			}
			_radius = startRadius;
			ApplyRadius();
			_renderer.enabled = false;
		}

		private void OnEnable()
		{
			LeaveStorm();
		}

		private void OnDisable()
		{
			LeaveStorm();
		}

		public void Begin()
		{
			_radius = startRadius;
			LeaveStorm();
			_nextPush = 0f;
			ApplyRadius();
			_renderer.enabled = true;
		}

		public void End()
		{
			LeaveStorm();
			if (_renderer != null)
			{
				_renderer.enabled = false;
			}
		}

		public void Tick(double elapsed)
		{
			_radius = RadiusAt(elapsed);
			ApplyRadius();
			PushLocalPlayer();
		}

		public float RadiusAt(double elapsed)
		{
			if (elapsed <= (double)holdSeconds)
			{
				return startRadius;
			}
			if (shrinkSeconds <= 0f)
			{
				return endRadius;
			}
			float t = Mathf.Clamp01((float)((elapsed - (double)holdSeconds) / (double)shrinkSeconds));
			return Mathf.Lerp(startRadius, endRadius, shrinkCurve.Evaluate(t));
		}

		private void ApplyRadius()
		{
			transform.localScale = new Vector3(_radius, height, _radius);
		}

		private void PushLocalPlayer()
		{
			Transform head = MonkeDevNetworkingManager.Manager != null ? MonkeDevNetworkingManager.Manager.Head : null;
			if (head == null)
			{
				return;
			}
			ApeGamesManager manager = ApeGamesManager.Instance;
			if (manager == null || !manager.IsLocalContestant())
			{
				LeaveStorm();
				return;
			}
			Vector3 offset = head.position - transform.position;
			offset.y = 0f;
			float distance = offset.magnitude;
			if (distance <= _radius)
			{
				LeaveStorm();
				return;
			}
			if (_outsideSince < 0f)
			{
				_outsideSince = Time.time;
				if (vignettePulse != null)
				{
					vignettePulse.SetHold(pulseColor, holdIntensity);
					vignettePulse.Pulse(pulseColor, pulseStrengthMin);
				}
			}
			if (inStormSfx != null)
			{
				if (!inStormSfx.isPlaying)
				{
					inStormSfx.Play();
				}
				inStormSfx.volume = Mathf.Lerp(inStormVolumeMin, inStormVolumeMax, Threat);
			}
			if (Time.time - _outsideSince < graceSeconds || Time.time < _nextPush)
			{
				return;
			}
			_nextPush = Time.time + pushInterval;
			float threat = Threat;
			Vector3 inward = -offset / Mathf.Max(distance, 0.0001f);
			Vector3 velocity = inward * Mathf.Lerp(pushSpeedMin, pushSpeedMax, threat) + Vector3.down * (threat * pushDown);
			if (TryGetRigVelocity(out var rigVelocity))
			{
				velocity += rigVelocity;
			}
			AgLauncher.Launch(Vector3.ClampMagnitude(velocity, maxSpeed));
			AgHaptics.Both(Mathf.Lerp(hapticMin, hapticMax, threat), hapticDuration);
			if (vignettePulse != null)
			{
				vignettePulse.Pulse(pulseColor, Mathf.Lerp(pulseStrengthMin, 1f, threat));
			}
			if (shoveSfx != null)
			{
				shoveSfx.pitch = Mathf.Lerp(shovePitchMin, shovePitchMax, threat);
				shoveSfx.Play();
			}
		}

		private void LeaveStorm()
		{
			_outsideSince = -1f;
			if (inStormSfx != null && inStormSfx.isPlaying)
			{
				inStormSfx.Stop();
			}
			if (vignettePulse != null)
			{
				vignettePulse.ClearHold();
			}
		}

		private static bool TryGetRigVelocity(out Vector3 velocity)
		{
			velocity = Vector3.zero;
			if (!Player.HasInstance)
			{
				return false;
			}
			Player player = Player.Instance;
			if (player == null || player.playerRigidBody == null || player.playerRigidBody.isKinematic || player.disableMovement)
			{
				return false;
			}
			velocity = player.playerRigidBody.linearVelocity;
			return true;
		}

		private static Mesh BuildTube(int segments)
		{
			Vector3[] vertices = new Vector3[segments * 2];
			Vector3[] normals = new Vector3[segments * 2];
			int[] triangles = new int[segments * 6];
			for (int i = 0; i < segments; i++)
			{
				float angle = (float)i / (float)segments * Mathf.PI * 2f;
				float cos = Mathf.Cos(angle);
				float sin = Mathf.Sin(angle);
				vertices[i] = new Vector3(cos, -0.5f, sin);
				vertices[i + segments] = new Vector3(cos, 0.5f, sin);
				normals[i] = new Vector3(cos, 0f, sin);
				normals[i + segments] = new Vector3(cos, 0f, sin);
				int next = (i + 1) % segments;
				int t = i * 6;
				triangles[t] = i;
				triangles[t + 1] = i + segments;
				triangles[t + 2] = next + segments;
				triangles[t + 3] = i;
				triangles[t + 4] = next + segments;
				triangles[t + 5] = next;
			}
			Mesh mesh = new Mesh();
			mesh.name = "AgStormTube";
			mesh.SetVertices(vertices);
			mesh.SetNormals(normals);
			mesh.SetTriangles(triangles, 0);
			mesh.bounds = new Bounds(Vector3.zero, new Vector3(2f, 1f, 2f));
			return mesh;
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.55f, 0.3f, 0.95f, 0.9f);
			DrawCircle(startRadius);
			Gizmos.color = new Color(0.95f, 0.3f, 0.4f, 0.9f);
			DrawCircle(endRadius);
		}

		private void DrawCircle(float radius)
		{
			Vector3 center = transform.position;
			Vector3 prev = center + new Vector3(radius, 0f, 0f);
			for (int i = 1; i <= 48; i++)
			{
				float angle = (float)i / 48f * Mathf.PI * 2f;
				Vector3 next = center + new Vector3(Mathf.Cos(angle) * radius, 0f, Mathf.Sin(angle) * radius);
				Gizmos.DrawLine(prev, next);
				prev = next;
			}
		}
	}
}
