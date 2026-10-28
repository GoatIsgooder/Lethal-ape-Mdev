using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmItemRuntime : MonoBehaviourPunCallbacks
	{
		private sealed class ActiveEffect
		{
			public BtmItemDefinition item;

			public float start;

			public float end;

			public float nextTick;
		}

		[Header("Impact FX")]
		[SerializeField]
		private BtmImpactFx potionSplashPrefab;

		[SerializeField]
		private BtmSmokeCloud smokeCloudPrefab;

		[SerializeField]
		[Min(1f)]
		private int splashPoolSize = 4;

		[SerializeField]
		[Min(1f)]
		private int smokePoolSize = 3;

		[Header("Audio (3D rolloff, never spatialized)")]
		[SerializeField]
		private AudioClip[] glassBreakClips;

		[SerializeField]
		[Range(0f, 1f)]
		private float glassBreakVolume = 0.85f;

		[SerializeField]
		private AudioClip smokeBurstClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float smokeBurstVolume = 0.9f;

		[SerializeField]
		private AudioClip roarClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float roarVolume = 1f;

		[SerializeField]
		private AudioClip effectEndClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float effectEndVolume = 0.35f;

		[SerializeField]
		[Min(1f)]
		private float impactMaxDistance = 28f;

		[SerializeField]
		[Min(1f)]
		private float roarMaxDistance = 55f;

		[SerializeField]
		[Min(1f)]
		private int voicePoolSize = 6;

		[Header("Roar")]
		[SerializeField]
		private Color roarRevealColor = new Color(1f, 0.16f, 0.08f, 1f);

		[Tooltip("Survivors within this range feel the roar as a low controller rumble.")]
		[SerializeField]
		[Min(0f)]
		private float roarRumbleRange = 18f;

		[Header("Bloodhound")]
		[SerializeField]
		private Color bloodhoundRevealColor = new Color(1f, 0.45f, 0.1f, 1f);

		[SerializeField]
		[Min(0.5f)]
		private float bloodhoundBlink = 2.5f;

		[Header("Smoke hit on a monster")]
		[SerializeField]
		[Min(0f)]
		private float smokeStunSeconds = 1f;

		[SerializeField]
		[Min(0f)]
		private float smokeSlowSeconds = 3f;

		[SerializeField]
		[Range(0.2f, 1f)]
		private float smokeSlowMultiplier = 0.55f;

		[Header("Feel")]
		[Tooltip("Seconds to ease arm reach in/out — a step change while a hand is planted shoves the body.")]
		[SerializeField]
		[Min(0.05f)]
		private float reachRampSeconds = 0.6f;

		[Tooltip("Edge overlay starts pulsing this many seconds before an effect runs out.")]
		[SerializeField]
		[Min(0f)]
		private float expiryWarning = 3f;

		[Tooltip("Peak strength of the power-up edge glow. Keep it under 1 — it lives in your peripheral vision for up to 30s.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float edgePeak = 0.8f;

		private readonly List<ActiveEffect> _effects = new List<ActiveEffect>(4);

		private readonly List<BtmItemDefinition> _stockScratch = new List<BtmItemDefinition>(3);

		private readonly Dictionary<int, BtmGhostProjectile> _ghosts = new Dictionary<int, BtmGhostProjectile>();

		private BtmImpactFx[] _splashPool;

		private BtmSmokeCloud[] _smokePool;

		private int _splashNext;

		private int _smokeNext;

		private AudioSource[] _voices;

		private int _voiceNext;

		private BtmRole _role;

		private bool _inRound;

		private bool _playing;

		private double _playStart;

		private Coroutine _prepRoutine;

		private bool _frozenByUs;

		private float _stunUntil;

		private bool _prepHold;

		private bool _holdSnapping;

		private Vector3 _holdPosition;

		private float _slowUntil;

		private bool _jumpApplied;

		private float _baseJumpMultiplier;

		private float _baseMaxJumpSpeed;

		private float _currentReach = 1f;

		private float _appliedGrabReach = 1f;

		private float _featherfall;

		public static BtmItemRuntime Instance { get; private set; }

		public BtmRole LocalRole => _role;

		public bool IsPlaying => _playing;

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Destroy(this);
				return;
			}
			Instance = this;
			BuildPools();
		}

		private void Start()
		{
			BTMGameManager instance = BTMGameManager.Instance;
			if (!(instance == null))
			{
				instance.OnRoundEnded += HandleRoundEnded;
				instance.OnLocalPlayerEliminated += HandleLocalEliminated;
			}
		}

		private void OnDestroy()
		{
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance != null)
			{
				instance.OnRoundEnded -= HandleRoundEnded;
				instance.OnLocalPlayerEliminated -= HandleLocalEliminated;
			}
			if (Instance == this)
			{
				ClearLocal();
				Instance = null;
			}
		}

		private void HandleRoundEnded(int[] winners, string map)
		{
			ClearLocal();
		}

		private void HandleLocalEliminated()
		{
			ClearLocal();
		}

		public override void OnEnable()
		{
			base.OnEnable();
			Player.Teleported += HandleRigTeleported;
		}

		public override void OnDisable()
		{
			Player.Teleported -= HandleRigTeleported;
			base.OnDisable();
		}

		private void HandleRigTeleported(Player player)
		{
			if (_prepHold && !_holdSnapping)
			{
				_holdPosition = player.transform.position;
			}
		}

		public override void OnLeftRoom()
		{
			ClearLocal();
		}

		public static void BeginRoundPrep(BtmRole role, double playStart, double roundStamp)
		{
			if (Instance != null)
			{
				Instance.StartPrep(role, playStart);
			}
		}

		public static void ClearLocalRound()
		{
			if (Instance != null)
			{
				Instance.ClearLocal();
			}
		}

		public static void PlayRemoteUse(int actor, BtmItemDefinition item, Vector3 position)
		{
			if (!(Instance == null))
			{
				Instance.DropGhost(actor);
				Instance.PlayUseFx(item, position, localUse: false);
			}
		}

		public static void SpawnRemoteGhost(int actor, BtmItemDefinition item, Vector3 position, Vector3 velocity)
		{
			if (!(Instance == null) && !(item.heldPrefab == null))
			{
				Instance.DropGhost(actor);
				BtmGhostProjectile btmGhostProjectile = BtmGhostProjectile.Spawn(item.heldPrefab, position, velocity);
				if (!(btmGhostProjectile == null))
				{
					BtmVisualCopy.ApplyTint(btmGhostProjectile.gameObject, item.tint);
					Instance._ghosts[actor] = btmGhostProjectile;
				}
			}
		}

		public bool CanUse(BtmItemDefinition item)
		{
			if (item == null || !_playing || item.role != _role || PhotonNetwork.Time < _playStart)
			{
				return false;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance == null)
			{
				return false;
			}
			if (PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			if (_role == BtmRole.Monster)
			{
				return Array.IndexOf(instance.roomProperties.currentMonsters ?? Array.Empty<int>(), PhotonNetwork.LocalPlayer.ActorNumber) >= 0;
			}
			return BTMGameManager.IsLocalSurvivor();
		}

		public bool UseLocal(BtmItemDefinition item, Vector3 position)
		{
			if (!CanUse(item))
			{
				return false;
			}
			PlayUseFx(item, position, localUse: true);
			ApplyEffect(item);
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.RequestItemUse(item, position);
			}
			return true;
		}

		public void ApplySmokeHit()
		{
			if (_playing && _role == BtmRole.Monster)
			{
				float time = Time.time;
				_stunUntil = Mathf.Max(_stunUntil, time + smokeStunSeconds);
				_slowUntil = Mathf.Max(_slowUntil, time + smokeStunSeconds + smokeSlowSeconds);
				if (BtmScreenFx.Instance != null)
				{
					BtmScreenFx.Instance.Flash();
				}
				VRInputController instance = VRInputController.Instance;
				if (instance != null)
				{
					instance.PulseLeft(0.8f, 0.25f);
					instance.PulseRight(0.8f, 0.25f);
				}
			}
		}

		private void StartPrep(BtmRole role, double playStart)
		{
			ClearLocal();
			_role = role;
			_playStart = playStart;
			_inRound = true;
			if ((float)(playStart - PhotonNetwork.Time) > 0.25f)
			{
				SetFrozen(frozen: true);
				_prepHold = true;
				if (BtmLoadoutBox.Instance != null)
				{
					BtmLoadoutBox.Instance.Open(role, playStart);
				}
			}
			_prepRoutine = StartCoroutine(PrepRoutine());
		}

		private IEnumerator PrepRoutine()
		{
			while (_inRound && PhotonNetwork.InRoom && PhotonNetwork.Time < _playStart)
			{
				yield return null;
			}
			_prepRoutine = null;
			if (!_inRound)
			{
				yield break;
			}
			if (BtmLoadoutBox.Instance != null)
			{
				BtmLoadoutBox.Instance.Close();
			}
			_prepHold = false;
			SetFrozen(frozen: false);
			_playing = true;
			_stockScratch.Clear();
			int slotCount = BtmProgress.SlotCount(_role);
			for (int i = 0; i < slotCount; i++)
			{
				_stockScratch.Add(BtmProgress.GetLoadout(_role, i));
			}
			BtmTechTreeCatalog catalog = BtmTechTreeCatalog.Instance;
			List<byte> list = new List<byte>(slotCount);
			foreach (BtmItemDefinition item in _stockScratch)
			{
				if (catalog != null)
				{
					int index = catalog.IndexOf(item);
					if (index >= 0 && index <= 255)
					{
						list.Add((byte)index);
					}
				}
			}
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.DeclareLoadout(list.ToArray());
			}
			if (BtmItemOrbs.Instance != null)
			{
				BtmItemOrbs.Instance.Stock(_stockScratch);
			}
		}

		private void SetFrozen(bool frozen)
		{
			if (frozen)
			{
				if (Player.HasInstance)
				{
					Player instance = Player.Instance;
					RigHold.Take(this, RigHold.What.Movement);
					if (instance.playerRigidBody != null && !instance.playerRigidBody.isKinematic)
					{
						instance.playerRigidBody.linearVelocity = Vector3.zero;
					}
					_frozenByUs = true;
					_holdPosition = instance.transform.position;
				}
			}
			else if (_frozenByUs)
			{
				RigHold.Give(this, RigHold.What.Movement);
				_frozenByUs = false;
			}
		}

		private void LateUpdate()
		{
			if (!_prepHold || !_frozenByUs || !Player.HasInstance)
			{
				return;
			}
			Player instance = Player.Instance;
			if ((instance.transform.position - _holdPosition).sqrMagnitude > 0.0001f)
			{
				_holdSnapping = true;
				try
				{
					instance.TeleportPlayerRaw(_holdPosition, Quaternion.identity, setRotation: false, resetVelocity: true);
				}
				finally
				{
					_holdSnapping = false;
				}
			}
		}

		private void ClearLocal()
		{
			_prepHold = false;
			if (_prepRoutine != null)
			{
				StopCoroutine(_prepRoutine);
				_prepRoutine = null;
			}
			_inRound = false;
			_playing = false;
			if (BtmLoadoutBox.Instance != null)
			{
				BtmLoadoutBox.Instance.Close();
			}
			if (BtmItemOrbs.Instance != null)
			{
				BtmItemOrbs.Instance.ClearAll();
			}
			_effects.Clear();
			_stunUntil = 0f;
			_slowUntil = 0f;
			_featherfall = 0f;
			ApplyModifiers(1f, 1f, 1f, instant: true);
			SetFrozen(frozen: false);
			foreach (KeyValuePair<int, BtmGhostProjectile> ghost in _ghosts)
			{
				if (ghost.Value != null)
				{
					Destroy(ghost.Value.gameObject);
				}
			}
			_ghosts.Clear();
			if (BtmScreenFx.Instance != null)
			{
				BtmScreenFx.Instance.ClearAll();
			}
		}

		private void ApplyEffect(BtmItemDefinition item)
		{
			float time = Time.time;
			switch (item.effect)
			{
			case BtmEffect.None:
			case BtmEffect.SmokeGrenade:
			case BtmEffect.ExtraSlot:
				return;
			case BtmEffect.Roar:
				if (BtmPingSystem.Instance != null)
				{
					BtmPingSystem.Instance.BeginLocalReveal(item.duration, roarRevealColor);
				}
				break;
			}
			foreach (ActiveEffect effect in _effects)
			{
				if (effect.item.effect == item.effect)
				{
					effect.item = item;
					effect.end = Mathf.Max(effect.end, time + item.duration);
					return;
				}
			}
			_effects.Add(new ActiveEffect
			{
				item = item,
				start = time,
				end = time + item.duration,
				nextTick = time
			});
		}

		private void Update()
		{
			float speed = SkinSpeed();
			if (_effects.Count == 0 && !(_stunUntil > 0f) && !(_slowUntil > 0f) && !_jumpApplied && Mathf.Approximately(speed, 1f) && Mathf.Approximately(_currentReach, 1f) && Mathf.Approximately(_appliedGrabReach, 1f))
			{
				return;
			}
			float time = Time.time;
			float reach = 1f;
			float grabReach = 1f;
			float featherfall = 0f;
			ActiveEffect newest = null;
			for (int num = _effects.Count - 1; num >= 0; num--)
			{
				ActiveEffect activeEffect = _effects[num];
				if (time >= activeEffect.end)
				{
					_effects.RemoveAt(num);
					PlayLocal(effectEndClip, effectEndVolume);
					continue;
				}
				float magnitude = activeEffect.item.magnitude;
				switch (activeEffect.item.effect)
				{
				case BtmEffect.MoveSpeed:
				case BtmEffect.Roar:
					speed *= Mathf.Clamp(magnitude, 1f, 1.6f);
					break;
				case BtmEffect.ArmReach:
					reach *= Mathf.Clamp(magnitude, 1f, 1.6f);
					break;
				case BtmEffect.GrabReach:
					grabReach *= Mathf.Clamp(magnitude, 1f, 2f);
					break;
				case BtmEffect.Featherfall:
					featherfall = Mathf.Max(featherfall, Mathf.Clamp01(magnitude));
					break;
				case BtmEffect.Bloodhound:
					if (time >= activeEffect.nextTick)
					{
						activeEffect.nextTick = time + Mathf.Max(bloodhoundBlink + 0.5f, magnitude);
						if (BtmPingSystem.Instance != null)
						{
							BtmPingSystem.Instance.BeginLocalReveal(bloodhoundBlink, bloodhoundRevealColor);
						}
					}
					break;
				}
				if (newest == null || activeEffect.start > newest.start)
				{
					newest = activeEffect;
				}
			}
			if (time < _slowUntil)
			{
				speed *= smokeSlowMultiplier;
			}
			else
			{
				_slowUntil = 0f;
			}
			if (time >= _stunUntil)
			{
				_stunUntil = 0f;
			}
			if (Player.HasInstance && _playing && _role == BtmRole.Monster)
			{
				if (time < _stunUntil)
				{
					RigHold.Take(this, RigHold.What.Movement);
					_frozenByUs = true;
				}
				else if (_frozenByUs)
				{
					SetFrozen(frozen: false);
				}
			}
			_featherfall = featherfall;
			ApplyModifiers(speed, reach, grabReach, instant: false);
			UpdateScreenEdge(newest, time);
		}

		private void FixedUpdate()
		{
			if (!Player.HasInstance)
			{
				return;
			}
			Rigidbody playerRigidBody = Player.Instance.playerRigidBody;
			if (!(playerRigidBody == null) && !playerRigidBody.isKinematic)
			{
				if (_playing && _role == BtmRole.Monster && Time.time < _stunUntil)
				{
					Vector3 linearVelocity = playerRigidBody.linearVelocity;
					playerRigidBody.linearVelocity = new Vector3(0f, Mathf.Min(linearVelocity.y, 0f), 0f);
				}
				if (_featherfall > 0f)
				{
					playerRigidBody.AddForce(-Physics.gravity * (_featherfall * Time.fixedDeltaTime), ForceMode.VelocityChange);
				}
			}
		}

		private void ApplyModifiers(float speed, float reach, float grabReach, bool instant)
		{
			bool skinDrives = _role == BtmRole.Monster && BtmMonsterSkin.LocalDriverActive;
			BtmMonsterSkin.PerkSpeedMultiplier = (skinDrives ? speed : 1f);
			SetRigSpeed(skinDrives ? 1f : speed);
			float maxDelta = (instant ? 1f : (Time.deltaTime / reachRampSeconds * 0.6f));
			_currentReach = Mathf.MoveTowards(_currentReach, reach, maxDelta);
			if (Player.HasInstance)
			{
				Player.Instance.armReachMultiplier = _currentReach;
			}
			if (!Mathf.Approximately(_appliedGrabReach, grabReach))
			{
				_appliedGrabReach = grabReach;
				ApplyGrabReach(grabReach);
			}
		}

		private float SkinSpeed()
		{
			if (!_playing || _role != BtmRole.Monster)
			{
				return 1f;
			}
			GameModePlayer localPlayer = GameModePlayer.LocalPlayer;
			if (localPlayer != null)
			{
				return localPlayer.CurrentSpeedMultiplier;
			}
			return 1f;
		}

		public static bool TryGetRigBase(out float jumpMultiplier, out float maxJumpSpeed)
		{
			BtmItemRuntime instance = Instance;
			if (instance != null && instance._jumpApplied)
			{
				jumpMultiplier = instance._baseJumpMultiplier;
				maxJumpSpeed = instance._baseMaxJumpSpeed;
				return true;
			}
			jumpMultiplier = 0f;
			maxJumpSpeed = 0f;
			return false;
		}

		private void SetRigSpeed(float multiplier)
		{
			if (!Player.HasInstance)
			{
				return;
			}
			Player instance = Player.Instance;
			if (Mathf.Abs(multiplier - 1f) > 0.001f)
			{
				if (!_jumpApplied)
				{
					_baseJumpMultiplier = instance.jumpMultiplier;
					_baseMaxJumpSpeed = instance.maxJumpSpeed;
					_jumpApplied = true;
				}
				instance.jumpMultiplier = _baseJumpMultiplier * multiplier;
				instance.maxJumpSpeed = _baseMaxJumpSpeed * multiplier;
			}
			else if (_jumpApplied)
			{
				instance.jumpMultiplier = _baseJumpMultiplier;
				instance.maxJumpSpeed = _baseMaxJumpSpeed;
				_jumpApplied = false;
			}
		}

		private static void ApplyGrabReach(float perk)
		{
			GameModePlayer localPlayer = GameModePlayer.LocalPlayer;
			if (localPlayer != null)
			{
				localPlayer.SetReachPerk(perk);
			}
		}

		private void UpdateScreenEdge(ActiveEffect newest, float now)
		{
			BtmScreenFx instance = BtmScreenFx.Instance;
			if (instance == null)
			{
				return;
			}
			if (newest == null)
			{
				instance.SetEdge(Color.clear, 0f);
				return;
			}
			float remaining = newest.end - now;
			float strength = Mathf.Clamp01((now - newest.start) / 0.35f) * Mathf.Clamp01(remaining * 2f) * edgePeak;
			if (remaining < expiryWarning)
			{
				strength *= 0.6f + 0.4f * Mathf.Abs(Mathf.Sin((expiryWarning - remaining) * Mathf.PI * 1.5f));
			}
			instance.SetEdge(newest.item.tint, strength);
		}

		private void PlayUseFx(BtmItemDefinition item, Vector3 position, bool localUse)
		{
			switch (item.effect)
			{
			case BtmEffect.Roar:
				PlayAt(roarClip, position, roarVolume, roarMaxDistance);
				if (!localUse)
				{
					RumbleIfNear(position);
				}
				break;
			case BtmEffect.SmokeGrenade:
				SpawnSmoke(position);
				PlayAt(smokeBurstClip, position, smokeBurstVolume, impactMaxDistance);
				break;
			default:
				if (item.kind == BtmItemKind.Potion)
				{
					SpawnSplash(position, item.tint);
					PlayAt(PickGlass(), position, glassBreakVolume, impactMaxDistance);
				}
				break;
			}
		}

		private void RumbleIfNear(Vector3 position)
		{
			if (BTMGameManager.IsLocalSurvivor() && Player.HasInstance)
			{
				float num = Vector3.Distance(((Player.Instance.headCollider != null) ? Player.Instance.headCollider.transform : Player.Instance.transform).position, position);
				if (!(num > roarRumbleRange))
				{
					float amplitude = Mathf.Lerp(0.55f, 0.12f, num / roarRumbleRange);
					VRInputController instance = VRInputController.Instance;
					if (!(instance == null))
					{
						instance.PulseLeft(amplitude, 0.6f);
						instance.PulseRight(amplitude, 0.6f);
					}
				}
			}
		}

		private AudioClip PickGlass()
		{
			if (glassBreakClips == null || glassBreakClips.Length == 0)
			{
				return null;
			}
			return glassBreakClips[UnityEngine.Random.Range(0, glassBreakClips.Length)];
		}

		private void SpawnSplash(Vector3 position, Color tint)
		{
			if (_splashPool != null && _splashPool.Length != 0)
			{
				BtmImpactFx btmImpactFx = _splashPool[_splashNext];
				_splashNext = (_splashNext + 1) % _splashPool.Length;
				if (btmImpactFx != null)
				{
					btmImpactFx.Play(position, tint);
				}
			}
		}

		private void SpawnSmoke(Vector3 position)
		{
			if (_smokePool != null && _smokePool.Length != 0)
			{
				BtmSmokeCloud btmSmokeCloud = _smokePool[_smokeNext];
				_smokeNext = (_smokeNext + 1) % _smokePool.Length;
				if (btmSmokeCloud != null)
				{
					btmSmokeCloud.Burst(position);
				}
			}
		}

		private void DropGhost(int actor)
		{
			if (_ghosts.TryGetValue(actor, out var value))
			{
				if (value != null)
				{
					Destroy(value.gameObject);
				}
				_ghosts.Remove(actor);
			}
		}

		private void BuildPools()
		{
			if (potionSplashPrefab != null)
			{
				_splashPool = new BtmImpactFx[splashPoolSize];
				for (int i = 0; i < splashPoolSize; i++)
				{
					_splashPool[i] = Instantiate(potionSplashPrefab, transform);
				}
			}
			if (smokeCloudPrefab != null)
			{
				_smokePool = new BtmSmokeCloud[smokePoolSize];
				for (int j = 0; j < smokePoolSize; j++)
				{
					_smokePool[j] = Instantiate(smokeCloudPrefab, transform);
				}
			}
			_voices = new AudioSource[voicePoolSize];
			for (int k = 0; k < voicePoolSize; k++)
			{
				GameObject gameObject = new GameObject("ItemVoice" + k);
				gameObject.transform.SetParent(transform, worldPositionStays: false);
				AudioSource audioSource = gameObject.AddComponent<AudioSource>();
				audioSource.playOnAwake = false;
				audioSource.spatialBlend = 1f;
				audioSource.spatialize = false;
				audioSource.rolloffMode = AudioRolloffMode.Linear;
				audioSource.minDistance = 1.5f;
				audioSource.dopplerLevel = 0f;
				_voices[k] = audioSource;
			}
		}

		private void PlayAt(AudioClip clip, Vector3 position, float volume, float maxDistance)
		{
			if (!(clip == null) && _voices != null && _voices.Length != 0)
			{
				AudioSource audioSource = _voices[_voiceNext];
				_voiceNext = (_voiceNext + 1) % _voices.Length;
				audioSource.transform.position = position;
				audioSource.maxDistance = maxDistance;
				audioSource.spatialBlend = 1f;
				audioSource.pitch = UnityEngine.Random.Range(0.95f, 1.05f);
				audioSource.clip = clip;
				audioSource.volume = volume;
				audioSource.Play();
			}
		}

		private void PlayLocal(AudioClip clip, float volume)
		{
			if (!(clip == null) && _voices != null && _voices.Length != 0)
			{
				AudioSource audioSource = _voices[_voiceNext];
				_voiceNext = (_voiceNext + 1) % _voices.Length;
				audioSource.spatialBlend = 0f;
				audioSource.pitch = 1f;
				audioSource.clip = clip;
				audioSource.volume = volume;
				audioSource.Play();
			}
		}
	}
}
