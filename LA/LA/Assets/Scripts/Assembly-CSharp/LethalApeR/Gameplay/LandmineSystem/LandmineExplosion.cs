using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using UnityEngine;
using UnityEngine.AI;

namespace LethalApeR.Gameplay.LandmineSystem
{
	public class LandmineExplosion : MonoBehaviour
	{
		[Tooltip("Optional — auto-fetched if left null.")]
		public NavMeshObstacle navObstacle;

		[Header("Particles")]
		[Tooltip("Optional material for the explosion burst. If null, a runtime material is built using whatever particle/additive shader the build includes.")]
		public Material particleMaterial;

		public int burstCount = 80;

		public float particleDurationMin = 0.4f;

		public float particleDurationMax = 1f;

		public float particleSpeedMin = 4f;

		public float particleSpeedMax = 12f;

		public float particleSizeMin = 0.25f;

		public float particleSizeMax = 0.7f;

		public Color particleColorStart = new Color(1f, 0.9f, 0.5f, 1f);

		public Color particleColorMid = new Color(1f, 0.4f, 0.1f, 0.8f);

		public Color particleColorEnd = new Color(0.15f, 0.15f, 0.15f, 0f);

		[Header("Light")]
		[Tooltip("Optional — auto-fetched if left null. The prefab intensity is captured as the flash peak.")]
		public Light explosionLight;

		[Tooltip("Seconds to ramp from 0 to peak intensity (fast rise of the flash).")]
		public float lightFadeIn = 0.05f;

		[Tooltip("Seconds to fall from peak back to 0 (ease-out, so the glow lingers like a real fireball).")]
		public float lightFadeOut = 1.2f;

		[Header("Player effect radii")]
		[Tooltip("Within this radius the local player dies and is teleported to spawn. Should be smaller than the knockback radius passed to Trigger.")]
		public float killRadius = 1.5f;

		[Tooltip("Delay between starting the death flash and TeleportToSpawn — the white pop covers the cut.")]
		public float killTeleportDelay = 0.15f;

		[Tooltip("Duration of the standard knockback flashbang (white flash + bloom decay).")]
		public float knockbackFlashDuration = 2.5f;

		[Tooltip("Duration of the death flashbang (white pop + red-tinted recovery).")]
		public float deathFlashDuration = 4f;

		private readonly List<BaseMonster> _stoppedMonsters = new List<BaseMonster>();

		private ParticleSystem _ps;

		private float _lightPeakIntensity;

		private void Awake()
		{
			if (navObstacle == null)
			{
				navObstacle = GetComponent<NavMeshObstacle>();
			}
			if (navObstacle != null)
			{
				navObstacle.enabled = false;
			}
			if (explosionLight == null)
			{
				explosionLight = GetComponent<Light>();
			}
			if (explosionLight != null)
			{
				_lightPeakIntensity = explosionLight.intensity;
				explosionLight.intensity = 0f;
				explosionLight.enabled = false;
			}
			SetupParticleSystem();
		}

		private void SetupParticleSystem()
		{
			_ps = GetComponent<ParticleSystem>();
			if (_ps == null)
			{
				_ps = base.gameObject.AddComponent<ParticleSystem>();
			}
			_ps.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
			ParticleSystem.MainModule main = _ps.main;
			main.duration = 1.2f;
			main.loop = false;
			main.playOnAwake = false;
			main.startLifetime = new ParticleSystem.MinMaxCurve(particleDurationMin, particleDurationMax);
			main.startSpeed = new ParticleSystem.MinMaxCurve(particleSpeedMin, particleSpeedMax);
			main.startSize = new ParticleSystem.MinMaxCurve(particleSizeMin, particleSizeMax);
			main.startColor = new ParticleSystem.MinMaxGradient(particleColorStart, particleColorMid);
			main.gravityModifier = new ParticleSystem.MinMaxCurve(0.4f);
			main.maxParticles = Mathf.Max(200, burstCount * 2);
			main.simulationSpace = ParticleSystemSimulationSpace.World;
			main.stopAction = ParticleSystemStopAction.None;
			ParticleSystem.EmissionModule emission = _ps.emission;
			emission.enabled = true;
			emission.rateOverTime = 0f;
			emission.SetBursts(new ParticleSystem.Burst[1]
			{
				new ParticleSystem.Burst(0f, (float)burstCount)
			});
			ParticleSystem.ShapeModule shape = _ps.shape;
			shape.enabled = true;
			shape.shapeType = ParticleSystemShapeType.Sphere;
			shape.radius = 0.2f;
			shape.radiusThickness = 0f;
			ParticleSystem.ColorOverLifetimeModule colorOverLifetime = _ps.colorOverLifetime;
			colorOverLifetime.enabled = true;
			Gradient gradient = new Gradient();
			gradient.SetKeys(new GradientColorKey[3]
			{
				new GradientColorKey(particleColorStart, 0f),
				new GradientColorKey(particleColorMid, 0.4f),
				new GradientColorKey(particleColorEnd, 1f)
			}, new GradientAlphaKey[3]
			{
				new GradientAlphaKey(particleColorStart.a, 0f),
				new GradientAlphaKey(particleColorMid.a, 0.4f),
				new GradientAlphaKey(particleColorEnd.a, 1f)
			});
			colorOverLifetime.color = new ParticleSystem.MinMaxGradient(gradient);
			ParticleSystem.SizeOverLifetimeModule sizeOverLifetime = _ps.sizeOverLifetime;
			sizeOverLifetime.enabled = true;
			sizeOverLifetime.size = new ParticleSystem.MinMaxCurve(1f, new AnimationCurve(new Keyframe(0f, 0.25f), new Keyframe(0.2f, 1f), new Keyframe(1f, 0.1f)));
			ParticleSystem.LimitVelocityOverLifetimeModule limitVelocityOverLifetime = _ps.limitVelocityOverLifetime;
			limitVelocityOverLifetime.enabled = true;
			limitVelocityOverLifetime.limit = 4f;
			limitVelocityOverLifetime.dampen = 0.3f;
			ParticleSystemRenderer component = GetComponent<ParticleSystemRenderer>();
			if (component != null && component.sharedMaterial == null)
			{
				component.sharedMaterial = ((particleMaterial != null) ? particleMaterial : BuildFallbackParticleMaterial());
			}
		}

		private static Material BuildFallbackParticleMaterial()
		{
			Shader shader = Shader.Find("Legacy Shaders/Particles/Additive") ?? Shader.Find("Particles/Standard Unlit") ?? Shader.Find("Universal Render Pipeline/Particles/Unlit") ?? Shader.Find("Sprites/Default");
			if (shader == null)
			{
				return null;
			}
			Material material = new Material(shader);
			material.name = "LandmineExplosion_Runtime";
			if (material.HasProperty("_TintColor"))
			{
				material.SetColor("_TintColor", new Color(1f, 0.6f, 0.2f, 0.5f));
			}
			if (material.HasProperty("_BaseColor"))
			{
				material.SetColor("_BaseColor", Color.white);
			}
			if (material.HasProperty("_Color"))
			{
				material.SetColor("_Color", Color.white);
			}
			return material;
		}

		public void Trigger(float force, float radius, float upMod, float monsterStopDuration, float lifetime)
		{
			if (navObstacle != null)
			{
				navObstacle.enabled = true;
				navObstacle.carving = true;
			}
			if (_ps != null)
			{
				_ps.Clear(true);
				_ps.Play(true);
			}
			if (explosionLight != null)
			{
				StartCoroutine(FlashLight());
			}
			HandleLocalPlayer(force, radius, upMod);
			PushNearbyRigidbodies(force, radius, upMod);
			if (PhotonNetwork.IsMasterClient || !PhotonNetwork.InRoom)
			{
				StopNearbyMonsters(radius, monsterStopDuration);
			}
			StartCoroutine(DespawnAfter(lifetime));
		}

		private void HandleLocalPlayer(float force, float radius, float upMod)
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null || instance.playerRigidBody == null)
			{
				return;
			}
			Rigidbody playerRigidBody = instance.playerRigidBody;
			Vector3 vector = playerRigidBody.position - base.transform.position;
			float magnitude = vector.magnitude;
			if (magnitude > radius)
			{
				return;
			}
			if (magnitude <= killRadius)
			{
				LandmineFlashbang.Spawn(LandmineFlashbang.Style.Death, deathFlashDuration);
				StartCoroutine(KillAfterDelay(killTeleportDelay));
				return;
			}
			Vector3 vector2 = ((magnitude > 0.01f) ? (vector / magnitude) : Vector3.up);
			float num = Mathf.Clamp01(magnitude / radius);
			Vector3 normalized = (vector2 + Vector3.up * upMod).normalized;
			playerRigidBody.AddForce(normalized * force * (1f - num), ForceMode.VelocityChange);
			LandmineFlashbang.Spawn(LandmineFlashbang.Style.Knockback, knockbackFlashDuration);
		}

		private IEnumerator KillAfterDelay(float delay)
		{
			yield return new WaitForSeconds(delay);
			if (GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.TeleportToSpawn();
			}
		}

		private void PushNearbyRigidbodies(float force, float radius, float upMod)
		{
			Vector3 position = base.transform.position;
			Collider[] array = Physics.OverlapSphere(position, radius, -1, QueryTriggerInteraction.Ignore);
			HashSet<Rigidbody> hashSet = new HashSet<Rigidbody>();
			for (int i = 0; i < array.Length; i++)
			{
				Rigidbody attachedRigidbody = array[i].attachedRigidbody;
				if (!(attachedRigidbody == null) && !attachedRigidbody.isKinematic && hashSet.Add(attachedRigidbody) && (!(GorillaLocomotion.Player.Instance != null) || !(attachedRigidbody == GorillaLocomotion.Player.Instance.playerRigidBody)))
				{
					attachedRigidbody.AddExplosionForce(force * 10f, position, radius, upMod, ForceMode.Impulse);
				}
			}
		}

		private void StopNearbyMonsters(float radius, float duration)
		{
			if (MonsterManager.Instance == null)
			{
				return;
			}
			Vector3 position = base.transform.position;
			foreach (BaseMonster monster in MonsterManager.Instance.Monsters)
			{
				if (!(monster == null) && !(monster.agent == null) && !(Vector3.Distance(monster.transform.position, position) > radius) && monster.agent.isOnNavMesh)
				{
					monster.agent.isStopped = true;
					monster.agent.velocity = Vector3.zero;
					_stoppedMonsters.Add(monster);
				}
			}
			if (_stoppedMonsters.Count > 0)
			{
				StartCoroutine(ResumeMonstersAfter(duration));
			}
		}

		private IEnumerator ResumeMonstersAfter(float duration)
		{
			yield return new WaitForSeconds(duration);
			foreach (BaseMonster stoppedMonster in _stoppedMonsters)
			{
				if (!(stoppedMonster == null) && !(stoppedMonster.agent == null) && stoppedMonster.agent.isOnNavMesh)
				{
					stoppedMonster.agent.isStopped = false;
				}
			}
			_stoppedMonsters.Clear();
		}

		private IEnumerator FlashLight()
		{
			explosionLight.intensity = 0f;
			explosionLight.enabled = true;
			if (lightFadeIn > 0f)
			{
				float t = 0f;
				while (t < lightFadeIn)
				{
					t += Time.deltaTime;
					explosionLight.intensity = Mathf.Lerp(0f, _lightPeakIntensity, t / lightFadeIn);
					yield return null;
				}
			}
			explosionLight.intensity = _lightPeakIntensity;
			if (lightFadeOut > 0f)
			{
				float t = 0f;
				while (t < lightFadeOut)
				{
					t += Time.deltaTime;
					float num = 1f - t / lightFadeOut;
					explosionLight.intensity = _lightPeakIntensity * num * num;
					yield return null;
				}
			}
			explosionLight.intensity = 0f;
			explosionLight.enabled = false;
		}

		private IEnumerator DespawnAfter(float lifetime)
		{
			yield return new WaitForSeconds(lifetime);
			if (navObstacle != null)
			{
				navObstacle.enabled = false;
			}
			base.gameObject.SetActive(false);
		}
	}
}
