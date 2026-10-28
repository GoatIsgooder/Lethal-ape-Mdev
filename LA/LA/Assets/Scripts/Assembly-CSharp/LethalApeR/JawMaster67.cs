using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR
{
	public class JawMaster67 : MonoBehaviour
	{
		public SkinnedMeshRenderer skinnedMeshRenderer;

		public int shapeKeyIndex;

		[Header("Audio Source (Optional - for local audio)")]
		public AudioSource audioSource;

		[Header("Photon Voice Integration")]
		[Tooltip("Player whose Photon Voice speaker drives the jaw. Found in parents when left empty.")]
		public MonkeDevNetworkingPlayer networkPlayer;

		[Header("Animation Settings")]
		public float maxShapeKeyValue = 100f;

		public float minVolumeThreshold = 0.0003f;

		public float maxVolumeThreshold = 0.03f;

		public float lerpSpeed = 15f;

		[Header("Distance Gate")]
		[Tooltip("Past this range from the local listener the jaw ignores audio and eases shut, skipping the GetOutputData lock. 0 turns the gate off.")]
		public float maxDistance = 12f;

		[Tooltip("Seconds between range checks and voice-source lookups (never below 0.05).")]
		public float distanceCheckInterval = 0.25f;

		private const float MinWeightChange = 0.05f;

		private const float MinCheckInterval = 0.05f;

		private readonly float[] pcm = new float[256];

		private float jawWeight;

		private float writtenWeight = -1f;

		private AudioSource liveSource;

		private Transform listener;

		private float nextGateTime;

		private bool nearListener = true;

		public float NormalizedVolume
		{
			get
			{
				if (!(maxShapeKeyValue > 0f))
				{
					return 0f;
				}
				return Mathf.Clamp01(jawWeight / maxShapeKeyValue);
			}
		}

		private void Start()
		{
			BindNetworkPlayer();
		}

		private void OnEnable()
		{
			BindNetworkPlayer();
		}

		private void OnDisable()
		{
			if (!base.gameObject.activeInHierarchy)
			{
				ResetForPool();
			}
		}

		public void ResetForPool()
		{
			jawWeight = 0f;
			writtenWeight = 0f;
			liveSource = null;
			listener = null;
			nextGateTime = 0f;
			nearListener = true;
			if (skinnedMeshRenderer != null)
			{
				skinnedMeshRenderer.SetBlendShapeWeight(shapeKeyIndex, 0f);
			}
		}

		private void Update()
		{
			if (skinnedMeshRenderer == null)
			{
				return;
			}
			float unscaledTime = Time.unscaledTime;
			if (unscaledTime >= nextGateTime)
			{
				nextGateTime = unscaledTime + Mathf.Max(distanceCheckInterval, MinCheckInterval);
				nearListener = ListenerInRange();
				if (liveSource == null)
				{
					liveSource = LocateVoiceSource();
				}
			}
			float value = 0f;
			if (nearListener && liveSource != null)
			{
				value = MeanAmplitude(liveSource);
			}
			float num = Mathf.InverseLerp(minVolumeThreshold, maxVolumeThreshold, value);
			jawWeight = Mathf.Lerp(jawWeight, num * maxShapeKeyValue, lerpSpeed * Time.deltaTime);
			PushWeight(jawWeight);
		}

		private void BindNetworkPlayer()
		{
			if (networkPlayer == null)
			{
				networkPlayer = GetComponentInParent<MonkeDevNetworkingPlayer>();
			}
		}

		private void PushWeight(float weight)
		{
			if (!(Mathf.Abs(weight - writtenWeight) < MinWeightChange))
			{
				writtenWeight = weight;
				skinnedMeshRenderer.SetBlendShapeWeight(shapeKeyIndex, weight);
			}
		}

		private bool ListenerInRange()
		{
			if (maxDistance <= 0f)
			{
				return true;
			}
			if (listener == null)
			{
				listener = FindListener();
				if (listener == null)
				{
					return true;
				}
			}
			return (base.transform.position - listener.position).sqrMagnitude <= maxDistance * maxDistance;
		}

		private static Transform FindListener()
		{
			Transform transform = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null);
			if (transform != null)
			{
				return transform;
			}
			Camera main = Camera.main;
			if (!(main != null))
			{
				return null;
			}
			return main.transform;
		}

		private AudioSource LocateVoiceSource()
		{
			if (networkPlayer != null && networkPlayer.photonView != null && !networkPlayer.photonView.IsMine)
			{
				if (!(networkPlayer.PhotonVoiceSpeaker != null))
				{
					return null;
				}
				return networkPlayer.PhotonVoiceSpeaker.GetComponent<AudioSource>();
			}
			if (!(audioSource != null))
			{
				return null;
			}
			return audioSource;
		}

		private float MeanAmplitude(AudioSource source)
		{
			if (source.clip != null && !source.isPlaying)
			{
				return 0f;
			}
			source.GetOutputData(pcm, 0);
			float num = 0f;
			for (int i = 0; i < pcm.Length; i++)
			{
				num += Mathf.Abs(pcm[i]);
			}
			return num / (float)pcm.Length;
		}
	}
}
