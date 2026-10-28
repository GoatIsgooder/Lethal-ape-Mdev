using System.Collections;
using LethalApeR.Gameplay.LandmineSystem;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Weather
{
	[DisallowMultipleComponent]
	public class ThunderZone : MonoBehaviour
	{
		[Header("Zone")]
		[SerializeField]
		private Vector3 zoneSize = new Vector3(120f, 40f, 120f);

		[SerializeField]
		private float strikeHeightMin = 25f;

		[SerializeField]
		private float strikeHeightMax = 45f;

		[SerializeField]
		private bool onlyWhenInside;

		[SerializeField]
		private float audibleRange = 400f;

		[Header("Timing")]
		[SerializeField]
		private float intervalMin = 8f;

		[SerializeField]
		private float intervalMax = 26f;

		[Header("Flash")]
		[SerializeField]
		private Light flashLight;

		[SerializeField]
		private float flashIntensity = 6f;

		[SerializeField]
		private float flashDuration = 0.22f;

		[SerializeField]
		[Range(1f, 5f)]
		private int flickerCount = 3;

		[SerializeField]
		private float flashFalloffRange = 250f;

		[SerializeField]
		private bool flashOnlyOutside = true;

		[SerializeField]
		private bool flashOnlyInsideZone = true;

		[SerializeField]
		private float skyProbeDistance = 20f;

		[Header("Bolt")]
		[SerializeField]
		private ParticleSystem strikeEffect;

		[SerializeField]
		private float boltDistanceScale = 0.0035f;

		[SerializeField]
		private ParticleSystem groundEffect;

		[SerializeField]
		private ParticleSystem groundSparks;

		[SerializeField]
		private LayerMask groundMask = -1;

		[SerializeField]
		private float groundProbeDistance = 200f;

		[Header("Lethal")]
		[SerializeField]
		private bool killPlayers = true;

		[SerializeField]
		[Range(0f, 1f)]
		private float killChance = 0.25f;

		[SerializeField]
		private float killRadius = 8f;

		[SerializeField]
		private float deathFlashDuration = 4f;

		[SerializeField]
		private float killTeleportDelay = 0.15f;

		[Header("Thunder")]
		[SerializeField]
		private AudioSource thunderSource;

		[SerializeField]
		private AudioClip[] thunderClips;

		[SerializeField]
		private bool useTravelDelay = true;

		[SerializeField]
		private float speedOfSound = 343f;

		[SerializeField]
		private float volumeNear = 1f;

		[SerializeField]
		private float volumeFar = 0.25f;

		[SerializeField]
		private float pitchNear = 1f;

		[SerializeField]
		private float pitchFar = 0.75f;

		[Header("Sync")]
		[SerializeField]
		private bool syncAcrossClients = true;

		[SerializeField]
		private int seed = 1337;

		[Header("Gizmo")]
		[SerializeField]
		private bool drawGizmo = true;

		private int _lastFiredSlot = int.MinValue;

		private float _baseFlashIntensity;

		private Coroutine _flash;

		private float AverageInterval => Mathf.Max(0.5f, (intervalMin + intervalMax) * 0.5f);

		private double SharedTime
		{
			get
			{
				if (syncAcrossClients && PhotonNetwork.InRoom)
				{
					return PhotonNetwork.Time;
				}
				return Time.timeSinceLevelLoadAsDouble;
			}
		}

		private void Awake()
		{
			if (flashLight != null)
			{
				_baseFlashIntensity = flashLight.intensity;
				flashLight.enabled = false;
			}
			if (thunderSource != null)
			{
				thunderSource.playOnAwake = false;
				thunderSource.loop = false;
			}
			if (thunderSource == null && flashLight == null)
			{
				Debug.LogError(base.name + ": ThunderZone has neither a flash Light nor a thunder AudioSource assigned, so it cannot do anything.", this);
			}
		}

		private void OnEnable()
		{
			_lastFiredSlot = CurrentSlot(SharedTime);
		}

		private void Update()
		{
			double sharedTime = SharedTime;
			int num = CurrentSlot(sharedTime);
			if (num <= _lastFiredSlot)
			{
				return;
			}
			if (num - _lastFiredSlot > 2)
			{
				_lastFiredSlot = num - 1;
			}
			for (int i = _lastFiredSlot + 1; i <= num; i++)
			{
				if (StrikeTime(i) <= sharedTime)
				{
					_lastFiredSlot = i;
					Strike(i);
				}
			}
		}

		private int CurrentSlot(double t)
		{
			return Mathf.FloorToInt((float)(t / (double)AverageInterval));
		}

		private double StrikeTime(int slot)
		{
			float averageInterval = AverageInterval;
			float num = Mathf.Clamp01(Mathf.Abs(intervalMax - intervalMin) / (averageInterval * 2f));
			return (float)slot * averageInterval + num * (Hash01(slot, 0) * averageInterval);
		}

		private void Strike(int slot)
		{
			Vector3 vector = StrikePosition(slot);
			Transform transform = LocalHead();
			float num = 0f;
			if (transform != null)
			{
				num = Vector3.Distance(transform.position, vector);
			}
			RaycastHit hitInfo;
			bool flag = Physics.Raycast(vector, Vector3.down, out hitInfo, groundProbeDistance, groundMask, QueryTriggerInteraction.Ignore);
			FireFlash(num, transform);
			FireBolt(vector, num);
			if (flag)
			{
				FireGroundImpact(hitInfo, num);
				TryKillLocalPlayer(slot, hitInfo.point, transform);
			}
			if ((!onlyWhenInside || !(transform != null) || Contains(transform.position)) && !(num > audibleRange))
			{
				StartCoroutine(PlayClap(slot, vector, num));
			}
		}

		private Vector3 StrikePosition(int slot)
		{
			float x = Mathf.Lerp((0f - zoneSize.x) * 0.5f, zoneSize.x * 0.5f, Hash01(slot, 1));
			float y = Mathf.Lerp(strikeHeightMin, strikeHeightMax, Hash01(slot, 3));
			float z = Mathf.Lerp((0f - zoneSize.z) * 0.5f, zoneSize.z * 0.5f, Hash01(slot, 2));
			return base.transform.TransformPoint(new Vector3(x, y, z));
		}

		private bool HeadCanSeeSky(Transform head)
		{
			if (head == null)
			{
				return true;
			}
			return !Physics.Raycast(head.position + Vector3.up * 0.1f, Vector3.up, skyProbeDistance, groundMask, QueryTriggerInteraction.Ignore);
		}

		private void FireFlash(float dist, Transform head)
		{
			if (flashLight == null || (flashOnlyInsideZone && (head == null || !Contains(head.position))) || (flashOnlyOutside && !HeadCanSeeSky(head)))
			{
				return;
			}
			float num = 1f;
			if (flashFalloffRange > 0f)
			{
				num = Mathf.Clamp01(1f - dist / flashFalloffRange);
				if (num <= 0.01f)
				{
					return;
				}
			}
			if (_flash != null)
			{
				StopCoroutine(_flash);
			}
			_flash = StartCoroutine(FlashRoutine(num * flashIntensity));
		}

		private void FireBolt(Vector3 pos, float dist)
		{
			if (!(strikeEffect == null) && (!(flashFalloffRange > 0f) || !(dist > flashFalloffRange)))
			{
				Transform transform = strikeEffect.transform;
				transform.position = pos;
				transform.rotation = Quaternion.identity;
				transform.localScale = Vector3.one * (1f + Mathf.Max(0f, boltDistanceScale) * dist);
				strikeEffect.Clear(true);
				strikeEffect.Play(true);
			}
		}

		private void FireGroundImpact(RaycastHit hit, float dist)
		{
			if (flashFalloffRange > 0f && dist > flashFalloffRange)
			{
				return;
			}
			if (groundEffect != null)
			{
				Transform transform = groundEffect.transform;
				transform.position = hit.point + hit.normal * 0.05f;
				transform.rotation = Quaternion.FromToRotation(Vector3.forward, hit.normal);
				groundEffect.Clear(true);
				groundEffect.Play(true);
			}
			if (groundSparks != null)
			{
				Transform transform2 = groundSparks.transform;
				transform2.position = hit.point + hit.normal * 0.1f;
				transform2.rotation = Quaternion.FromToRotation(Vector3.up, hit.normal);
				groundSparks.Clear(true);
				groundSparks.Play(true);
			}
		}

		private void TryKillLocalPlayer(int slot, Vector3 strikePos, Transform head)
		{
			if (killPlayers && !(head == null) && !(Hash01(slot, 6) >= killChance) && !(Vector3.Distance(head.position, strikePos) > Mathf.Max(0.1f, killRadius)) && Contains(head.position))
			{
				LandmineFlashbang.Spawn(LandmineFlashbang.Style.Death, deathFlashDuration);
				StartCoroutine(TeleportToSpawnAfter(killTeleportDelay));
			}
		}

		private IEnumerator TeleportToSpawnAfter(float delay)
		{
			if (delay > 0f)
			{
				yield return new WaitForSeconds(delay);
			}
			if (GorillaLocomotion.Player.Instance != null)
			{
				GorillaLocomotion.Player.Instance.TeleportToSpawn();
			}
		}

		private IEnumerator FlashRoutine(float peak)
		{
			int flickers = Mathf.Max(1, flickerCount);
			float dur = Mathf.Max(0.02f, flashDuration);
			float elapsed = 0f;
			flashLight.enabled = true;
			while (elapsed < dur)
			{
				float num = elapsed / dur;
				float num2 = num * (float)flickers;
				float num3 = ((num2 - Mathf.Floor(num2) < 0.55f) ? 1f : 0.12f);
				flashLight.intensity = num3 * ((1f - num) * peak);
				elapsed += Time.deltaTime;
				yield return null;
			}
			flashLight.intensity = _baseFlashIntensity;
			flashLight.enabled = false;
			_flash = null;
		}

		private IEnumerator PlayClap(int slot, Vector3 pos, float dist)
		{
			if (thunderSource == null || thunderClips == null || thunderClips.Length == 0)
			{
				yield break;
			}
			if (useTravelDelay)
			{
				float num = dist / Mathf.Max(1f, speedOfSound);
				if (num > 0f)
				{
					yield return new WaitForSeconds(num);
				}
				if (thunderSource == null)
				{
					yield break;
				}
			}
			float t = ((audibleRange > 0f) ? Mathf.Clamp01(dist / audibleRange) : 0f);
			thunderSource.transform.position = pos;
			thunderSource.pitch = Mathf.Lerp(pitchNear, pitchFar, t);
			AudioClip audioClip = thunderClips[Mathf.Clamp(Mathf.FloorToInt(Hash01(slot, 4) * (float)thunderClips.Length), 0, thunderClips.Length - 1)];
			if (audioClip != null)
			{
				thunderSource.PlayOneShot(audioClip, Mathf.Lerp(volumeNear, volumeFar, t));
			}
		}

		private bool Contains(Vector3 worldPos)
		{
			Vector3 vector = base.transform.InverseTransformPoint(worldPos);
			if (Mathf.Abs(vector.x) <= zoneSize.x * 0.5f && Mathf.Abs(vector.y) <= zoneSize.y * 0.5f)
			{
				return Mathf.Abs(vector.z) <= zoneSize.z * 0.5f;
			}
			return false;
		}

		private static Transform LocalHead()
		{
			if (!(MonkeDevNetworkingManager.Manager != null))
			{
				return null;
			}
			return MonkeDevNetworkingManager.Manager.Head;
		}

		private float Hash01(int slot, int salt)
		{
			uint num = (uint)(slot * 73856093) ^ (uint)(salt * 19349663) ^ (uint)(seed * 83492791);
			num ^= num >> 13;
			num *= 1540483477;
			num ^= num >> 15;
			return (float)(num & 0xFFFFFF) / 16777215f;
		}
	}
}
