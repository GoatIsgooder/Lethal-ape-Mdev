using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Scrap
{
	public class Grinder : MonoBehaviour
	{
		[Header("Where the grind happens (sparks / sound). Defaults to this transform.")]
		[SerializeField]
		private Transform mouth;

		[Header("Mouth detection")]
		[Tooltip("Layers the mouth scans for scrap. Auto-set to the 'Grabbable' layer at runtime if left as Nothing, so the mouth only eats scrap, not the player rig.")]
		[SerializeField]
		private LayerMask sellLayers;

		[Tooltip("Fallback half-size of the mouth box when 'mouth' has no BoxCollider to read.")]
		[SerializeField]
		private float mouthRadius = 1.4f;

		[Tooltip("How often (seconds) the mouth scans for scrap. 0.05 = 20Hz, plenty.")]
		[SerializeField]
		private float scanInterval = 0.05f;

		[Tooltip("Multiplayer only: how long (s) a piece you DON'T own may sit in the mouth before this grinder claims ownership to sell it. Lets its current owner sell it first (avoids ownership thrash). 0 = claim instantly.")]
		[SerializeField]
		private float claimDelay = 0.4f;

		[Header("FX")]
		[SerializeField]
		private ParticleSystem sparks;

		[SerializeField]
		private Animator grinderAnimator;

		[SerializeField]
		private string grindTrigger = "Grind";

		[Tooltip("Brief emissive/heat flash light. Optional.")]
		[SerializeField]
		private Light flashLight;

		[SerializeField]
		private float flashIntensity = 4f;

		[SerializeField]
		private float flashDecay = 8f;

		[Header("Audio (3D, NOT spatialized — Meta spatializer mutes in editor)")]
		[Tooltip("Auto-created on this object at runtime if left empty.")]
		[SerializeField]
		private AudioSource grindSource;

		[Tooltip("Plays the moment a piece of scrap drops INTO the mouth (the 'clunk').")]
		[SerializeField]
		private AudioClip impactClip;

		[Range(0f, 1f)]
		[SerializeField]
		private float impactVolume = 0.85f;

		[SerializeField]
		private Vector2 impactPitchJitter = new Vector2(0.92f, 1.08f);

		[Tooltip("Plays when the piece is actually SOLD (the grind/crush). Falls back to the impact clip if left empty.")]
		[SerializeField]
		private AudioClip grindClip;

		[Range(0f, 1f)]
		[SerializeField]
		private float grindVolume = 0.9f;

		[SerializeField]
		private Vector2 pitchJitter = new Vector2(0.9f, 1.12f);

		[Header("Haptics (seller only)")]
		[Range(0f, 1f)]
		[SerializeField]
		private float hapticAmplitude = 0.9f;

		[SerializeField]
		private float hapticDuration = 0.16f;

		private readonly Collider[] _overlap = new Collider[32];

		private readonly HashSet<ScrapPickup> _inMouth = new HashSet<ScrapPickup>();

		private readonly HashSet<ScrapPickup> _current = new HashSet<ScrapPickup>();

		private readonly HashSet<ScrapPickup> _requested = new HashSet<ScrapPickup>();

		private readonly HashSet<ScrapPickup> _claimRequested = new HashSet<ScrapPickup>();

		private readonly Dictionary<ScrapPickup, float> _enteredAt = new Dictionary<ScrapPickup, float>();

		private readonly List<ScrapPickup> _exited = new List<ScrapPickup>();

		private BoxCollider _mouthBox;

		private float _nextScan;

		private float _flash;

		private void Awake()
		{
			if (mouth == null)
			{
				mouth = base.transform;
			}
			_mouthBox = mouth.GetComponent<BoxCollider>();
			if ((int)sellLayers == 0)
			{
				int num = LayerMask.NameToLayer("Grabbable");
				sellLayers = ((num >= 0) ? (1 << num) : (-1));
			}
			EnsureAudioSource();
		}

		private void EnsureAudioSource()
		{
			if (!(grindSource != null))
			{
				grindSource = base.gameObject.AddComponent<AudioSource>();
				grindSource.playOnAwake = false;
				grindSource.spatialBlend = 1f;
				grindSource.spatialize = false;
				grindSource.rolloffMode = AudioRolloffMode.Linear;
				grindSource.minDistance = 2f;
				grindSource.maxDistance = 30f;
			}
		}

		private void OnEnable()
		{
			ScrapEvents.OnScrapSold += HandleScrapSold;
		}

		private void OnDisable()
		{
			ScrapEvents.OnScrapSold -= HandleScrapSold;
		}

		private void Update()
		{
			if (_flash > 0f && flashLight != null)
			{
				_flash = Mathf.Max(0f, _flash - flashDecay * Time.deltaTime);
				flashLight.intensity = _flash;
			}
			if (!(Time.time < _nextScan))
			{
				_nextScan = Time.time + Mathf.Max(0.01f, scanInterval);
				ScanMouth();
			}
		}

		private void ScanMouth()
		{
			Quaternion rotation = mouth.rotation;
			Vector3 center;
			Vector3 halfExtents;
			if (_mouthBox != null)
			{
				center = mouth.TransformPoint(_mouthBox.center);
				Vector3 lossyScale = mouth.lossyScale;
				halfExtents = Vector3.Scale(new Vector3(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z)), _mouthBox.size * 0.5f);
			}
			else
			{
				center = mouth.position;
				halfExtents = Vector3.one * mouthRadius;
			}
			int num = Physics.OverlapBoxNonAlloc(center, halfExtents, _overlap, rotation, sellLayers, QueryTriggerInteraction.Ignore);
			_current.Clear();
			for (int i = 0; i < num; i++)
			{
				Collider collider = _overlap[i];
				if (!(collider == null))
				{
					ScrapPickup componentInParent = collider.GetComponentInParent<ScrapPickup>();
					if (!(componentInParent == null) && _current.Add(componentInParent) && !_inMouth.Contains(componentInParent))
					{
						OnScrapEnteredMouth(componentInParent);
					}
				}
			}
			_exited.Clear();
			foreach (ScrapPickup item in _inMouth)
			{
				if (!_current.Contains(item))
				{
					_exited.Add(item);
				}
			}
			for (int j = 0; j < _exited.Count; j++)
			{
				_inMouth.Remove(_exited[j]);
				_requested.Remove(_exited[j]);
				_claimRequested.Remove(_exited[j]);
				_enteredAt.Remove(_exited[j]);
			}
			_inMouth.Clear();
			foreach (ScrapPickup item2 in _current)
			{
				_inMouth.Add(item2);
			}
			foreach (ScrapPickup item3 in _inMouth)
			{
				if (item3 == null || item3.State != ScrapState.InWorld || item3.IsHeld)
				{
					continue;
				}
				if (item3.IsMineOrOffline)
				{
					if (_requested.Add(item3))
					{
						ScrapManager.Instance?.LocalRequestSell(item3);
						PulseSellerHaptics();
					}
				}
				else if (PhotonNetwork.InRoom && !item3.HeldByRemoteOwner && !_claimRequested.Contains(item3))
				{
					float value;
					float num2 = (_enteredAt.TryGetValue(item3, out value) ? (Time.time - value) : 0f);
					if (!(num2 < claimDelay))
					{
						_claimRequested.Add(item3);
						item3.ClaimForSale();
					}
				}
			}
		}

		private void OnScrapEnteredMouth(ScrapPickup p)
		{
			_enteredAt[p] = Time.time;
			AudioClip audioClip = ((impactClip != null) ? impactClip : grindClip);
			if (!(audioClip == null) && !(grindSource == null))
			{
				grindSource.pitch = Random.Range(impactPitchJitter.x, impactPitchJitter.y);
				grindSource.PlayOneShot(audioClip, impactVolume);
			}
		}

		private void PulseSellerHaptics()
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(hapticAmplitude, hapticDuration);
				instance.PulseRight(hapticAmplitude, hapticDuration);
			}
		}

		private void HandleScrapSold(int payout, Vector3 worldPos, int sellerActor)
		{
			if (sparks != null)
			{
				sparks.transform.position = mouth.position;
				sparks.Play();
			}
			if (grinderAnimator != null && !string.IsNullOrEmpty(grindTrigger))
			{
				grinderAnimator.SetTrigger(grindTrigger);
			}
			AudioClip audioClip = ((grindClip != null) ? grindClip : impactClip);
			if (audioClip != null && grindSource != null)
			{
				grindSource.pitch = Random.Range(pitchJitter.x, pitchJitter.y);
				grindSource.PlayOneShot(audioClip, grindVolume);
			}
			if (flashLight != null)
			{
				_flash = flashIntensity;
				flashLight.intensity = _flash;
			}
		}
	}
}
