using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR
{
	[RequireComponent(typeof(ParticleSystem))]
	public class NeonGhostSwarm : MonoBehaviour
	{
		public enum FlightPattern
		{
			Orbit = 0,
			FigureEight = 1,
			Spiral = 2,
			Wander = 3
		}

		private struct Ghost
		{
			public FlightPattern pattern;

			public Vector3 center;

			public Vector3 radii;

			public Quaternion plane;

			public float rate;

			public float phase;

			public float seed;

			public int pose;

			public float facing;

			public float nextWarp;

			public float warpStart;

			public bool jumped;
		}

		[Header("Swarm")]
		[SerializeField]
		[Range(1f, 16f)]
		private int ghostCount = 6;

		[SerializeField]
		private Vector3 areaExtents = new Vector3(2.5f, 1.2f, 2.5f);

		[SerializeField]
		private float ghostSize = 0.65f;

		[SerializeField]
		private float speed = 1f;

		[SerializeField]
		private int seed;

		[Header("Afterimages")]
		[SerializeField]
		[Range(0f, 3f)]
		private int echoes = 2;

		[SerializeField]
		private float echoDelay = 0.09f;

		[SerializeField]
		private Color tint = new Color(1f, 1f, 1f, 1f);

		[SerializeField]
		private Color echoTint = new Color(0.55f, 0.35f, 1f, 1f);

		[Header("Warping")]
		[SerializeField]
		private Vector2 warpInterval = new Vector2(4f, 9f);

		[SerializeField]
		private float warpDuration = 0.55f;

		private ParticleSystem _ps;

		private ParticleSystem.Particle[] _particles;

		private readonly List<Vector4> _custom = new List<Vector4>();

		private Ghost[] _ghosts;

		private Camera _cam;

		private void Awake()
		{
			_ps = GetComponent<ParticleSystem>();
			ParticleSystem.MainModule main = _ps.main;
			main.simulationSpace = ParticleSystemSimulationSpace.World;
			main.startSize3D = true;
			main.maxParticles = 64;
			ParticleSystem.EmissionModule emission = _ps.emission;
			emission.enabled = false;
			ParticleSystem.CustomDataModule customData = _ps.customData;
			customData.enabled = true;
			customData.SetMode(ParticleSystemCustomData.Custom1, ParticleSystemCustomDataMode.Vector);
			customData.SetVectorComponentCount(ParticleSystemCustomData.Custom1, 4);
			ParticleSystemRenderer component = GetComponent<ParticleSystemRenderer>();
			component.renderMode = ParticleSystemRenderMode.Billboard;
			component.alignment = ParticleSystemRenderSpace.View;
			component.sortMode = ParticleSystemSortMode.None;
			component.SetActiveVertexStreams(new List<ParticleSystemVertexStream>
			{
				ParticleSystemVertexStream.Position,
				ParticleSystemVertexStream.Color,
				ParticleSystemVertexStream.UV,
				ParticleSystemVertexStream.Custom1XYZW
			});
			Build();
		}

		private void OnEnable()
		{
			if (_ps != null && !_ps.isPlaying)
			{
				_ps.Play();
			}
		}

		private void OnValidate()
		{
			if (Application.isPlaying && _ps != null)
			{
				Build();
			}
		}

		private void Build()
		{
			System.Random rng = new System.Random((seed != 0) ? seed : GetStableSeed());
			_ghosts = new Ghost[ghostCount];
			float time = Time.time;
			for (int i = 0; i < ghostCount; i++)
			{
				Vector3 radii = new Vector3(areaExtents.x * Range(rng, 0.45f, 0.8f), areaExtents.y * Range(rng, 0.4f, 0.9f), areaExtents.z * Range(rng, 0.45f, 0.8f));
				Vector3 vector = areaExtents - radii;
				Vector3 center = new Vector3(Range(rng, 0f - vector.x, vector.x), Range(rng, 0f - vector.y, vector.y) * 0.5f, Range(rng, 0f - vector.z, vector.z));
				Quaternion plane = Quaternion.Euler(Range(rng, -12f, 12f), Range(rng, 0f, 360f), Range(rng, -12f, 12f));
				float num = Range(rng, 0.45f, 0.75f);
				if (rng.NextDouble() < 0.5)
				{
					num = 0f - num;
				}
				_ghosts[i] = new Ghost
				{
					pattern = (FlightPattern)(i % 4),
					center = center,
					radii = radii,
					plane = plane,
					rate = num,
					phase = Range(rng, 0f, 100f),
					seed = (float)rng.NextDouble(),
					pose = rng.Next(4),
					facing = 1f,
					nextWarp = time + Range(rng, warpInterval.x * 0.3f, warpInterval.y),
					warpStart = -1f,
					jumped = false
				};
			}
			int num2 = ghostCount * (1 + echoes);
			_particles = new ParticleSystem.Particle[num2];
			_custom.Clear();
			for (int j = 0; j < num2; j++)
			{
				_custom.Add(Vector4.zero);
			}
		}

		private int GetStableSeed()
		{
			Vector3 position = transform.position;
			return Mathf.RoundToInt(position.x * 73.1f) ^ Mathf.RoundToInt(position.y * 151.7f) ^ Mathf.RoundToInt(position.z * 291.3f) ^ 0x5EED;
		}

		private static float Range(System.Random rng, float a, float b)
		{
			return a + (b - a) * (float)rng.NextDouble();
		}

		private static Vector3 PathPoint(ref Ghost g, float ph)
		{
			Vector3 a;
			switch (g.pattern)
			{
			case FlightPattern.Orbit:
				a = new Vector3(Mathf.Cos(ph), Mathf.Sin(ph * 2f) * 0.3f, Mathf.Sin(ph));
				break;
			case FlightPattern.FigureEight:
				a = new Vector3(Mathf.Sin(ph), Mathf.Sin(ph * 3f) * 0.35f, Mathf.Sin(ph * 2f) * 0.6f);
				break;
			case FlightPattern.Spiral:
			{
				float num = 0.35f + (Mathf.Sin(ph * 0.31f) * 0.5f + 0.5f) * 0.65f;
				a = new Vector3(Mathf.Cos(ph) * num, Mathf.Sin(ph * 0.5f), Mathf.Sin(ph) * num);
				break;
			}
			default:
				a = new Vector3((Mathf.Sin(ph) + Mathf.Sin(ph * 2.3f + 1f) * 0.5f) / 1.5f, Mathf.Sin(ph * 1.7f + 2f) * 0.6f, (Mathf.Cos(ph * 0.8f) + Mathf.Sin(ph * 1.9f) * 0.5f) / 1.5f);
				break;
			}
			return g.center + g.plane * Vector3.Scale(a, g.radii);
		}

		private void LateUpdate()
		{
			if (_ghosts == null)
			{
				return;
			}
			if (_cam == null || !_cam.isActiveAndEnabled)
			{
				_cam = Camera.main;
			}
			Vector3 rhs = ((_cam != null) ? _cam.transform.right : Vector3.right);
			float time = Time.time;
			float deltaTime = Time.deltaTime;
			float x = transform.lossyScale.x;
			float num = Mathf.Max(deltaTime, 0.0001f);
			int num2 = 0;
			for (int i = 0; i < _ghosts.Length; i++)
			{
				ref Ghost reference = ref _ghosts[i];
				if (reference.warpStart < 0f && time >= reference.nextWarp)
				{
					reference.warpStart = time;
					reference.jumped = false;
				}
				float num3 = 0f;
				if (reference.warpStart >= 0f)
				{
					float num4 = (time - reference.warpStart) / warpDuration;
					if (num4 < 1f)
					{
						float num5 = 1f - Mathf.Abs(num4 * 2f - 1f);
						num3 = num5 * num5 * (3f - 2f * num5);
						if (num4 >= 0.5f && !reference.jumped)
						{
							reference.phase += UnityEngine.Random.Range(1.2f, 3.5f) * Mathf.Sign(reference.rate);
							reference.pose = (reference.pose + UnityEngine.Random.Range(0, 3) + 1) & 3;
							reference.jumped = true;
						}
					}
					else
					{
						reference.warpStart = -1f;
						reference.nextWarp = time + UnityEngine.Random.Range(warpInterval.x, warpInterval.y);
					}
				}
				float num6 = reference.phase + time * reference.rate * speed;
				Vector3 position = PathPoint(ref reference, num6);
				Vector3 vector = transform.TransformPoint(position);
				float num7 = Vector3.Dot((transform.TransformPoint(PathPoint(ref reference, num6 + reference.rate * speed * num)) - vector) / num, rhs);
				if (Mathf.Abs(num7) > 0.05f)
				{
					reference.facing = Mathf.MoveTowards(reference.facing, Mathf.Sign(num7), num * 5.5f);
				}
				float num8 = Mathf.Clamp(num7 * -18f, -28f, 28f);
				for (int j = 0; j <= echoes; j++)
				{
					Vector3 position2 = ((j == 0) ? vector : transform.TransformPoint(PathPoint(ref reference, num6 - echoDelay * (float)j * reference.rate * speed)));
					float num9 = ((j == 0) ? 1f : (0.42f / (float)j));
					Color color = Color.Lerp(tint, echoTint, (j == 0) ? 0f : ((float)j * 0.5f / (float)Mathf.Max(1, echoes) + 0.5f));
					color.a = num9 * (1f - num3 * ((j == 0) ? 0.85f : 1f));
					float num10 = ghostSize * x * (1f + (float)j * 0.07f);
					Vector2 vector2 = new Vector2(1f - num3 * 0.55f, 1f + num3 * 0.9f);
					_particles[num2] = new ParticleSystem.Particle
					{
						position = position2,
						startColor = color,
						startSize3D = new Vector3(vector2.x * num10, vector2.y * num10, num10),
						rotation = num8 + Mathf.Sin(time * 2.1f + reference.seed * 20f) * 6f,
						remainingLifetime = 1000f,
						startLifetime = 1000f,
						randomSeed = (uint)(i * 4 + j + 1)
					};
					_custom[num2] = new Vector4(Mathf.Clamp01(num3 + (float)j * 0.12f), reference.seed, reference.facing, reference.pose);
					num2++;
				}
			}
			if (!_ps.isPlaying)
			{
				_ps.Play();
			}
			_ps.SetParticles(_particles, num2, 0);
			if (_ps.particleCount == num2)
			{
				_ps.SetCustomParticleData(_custom, ParticleSystemCustomData.Custom1);
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.3f, 0.5f, 1f, 0.6f);
			Gizmos.matrix = transform.localToWorldMatrix;
			Gizmos.DrawWireCube(Vector3.zero, areaExtents * 2f);
		}
	}
}
