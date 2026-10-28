using System.Collections.Generic;
using LethalApeR.Gameplay.ApeGames;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	[RequireComponent(typeof(AgNetSync))]
	public class FnGuardAvatar : MonoBehaviour
	{
		private const byte KindBody = 0;

		private const byte KindName = 1;

		private const byte KindSkeleton = 2;

		private const byte KindNone = 255;

		private const float IdleSweepSeconds = 0.5f;

		[Header("Ghost look")]
		[Tooltip("Subtrees whose renderers hide while this guard is a ghost. Leave empty: every renderer on the avatar.")]
		public Transform[] hideRoots = new Transform[0];

		[Tooltip("Skeleton model skinned to the ape's bones, normally inactive. Shown only to other ghosts.")]
		public GameObject skeletonRoot;

		[Tooltip("Head/PlayerName: name text, build logos and tag cosmetics. Ghosts see it on ghosts; the living never do.")]
		public Transform nameTagRoot;

		[Tooltip("Colliders under these are off on other clients while this guard is a ghost. Empty = the whole avatar.")]
		public Transform[] colliderRoots = new Transform[0];

		[Header("Hand props (other guards only)")]
		[Tooltip("Unlit additive cone (Fnaf/LightCone) under RightHand, normally inactive. Never a Light.")]
		public GameObject flashlightCone;

		[Tooltip("Battery cell under LeftHand, normally inactive.")]
		public GameObject batteryModel;

		private readonly List<Renderer> _scanRenderers = new List<Renderer>(64);

		private readonly List<Collider> _scanColliders = new List<Collider>(16);

		private readonly List<Collider> _scanTemp = new List<Collider>(16);

		private readonly List<Light> _scanLights = new List<Light>(4);

		private Light[] _lights = new Light[0];

		private AgNetSync _sync;

		private Renderer[] _renderers = new Renderer[0];

		private byte[] _kinds = new byte[0];

		private Collider[] _colliders = new Collider[0];

		private bool[] _colliderWasOn = new bool[0];

		private bool _collidersOff;

		private int _scannedCount = -1;

		private float _nextIdleSweep;

		private float _nextVoiceLookup;

		private bool _warnedVoice;

		private FnGhostVoice _ghostVoice;

		public FnAvatarLook Look { get; private set; }

		private void Awake()
		{
			_sync = GetComponent<AgNetSync>();
		}

		private void OnEnable()
		{
			_scannedCount = -1;
			_nextIdleSweep = 0f;
		}

		private void OnDisable()
		{
			for (int i = 0; i < _renderers.Length; i++)
			{
				if (_renderers[i] != null && _renderers[i].forceRenderingOff)
				{
					_renderers[i].forceRenderingOff = false;
				}
			}
			SetColliders(false);
			DetachVoice();
			Look = FnAvatarLook.Ape;
		}

		private void LateUpdate()
		{
			if (_sync == null)
			{
				return;
			}
			if (transform.hierarchyCount != _scannedCount)
			{
				Rescan();
			}
			DarkenCosmeticLights();
			FnNight night = FnNight.Instance;
			int actor = _sync.ActorNumber;
			if (night == null || !night.Active || actor <= 0)
			{
				if (!(Time.unscaledTime < _nextIdleSweep))
				{
					_nextIdleSweep = Time.unscaledTime + 0.5f;
					Apply(FnAvatarLook.Ape, false, false, false);
					ApplyVoice(FnVoiceMode.Plain, 1f, false);
				}
				return;
			}
			_nextIdleSweep = 0f;
			FnSettings settings = FnGame.Settings;
			bool isMine = _sync.IsMine;
			FnPhase phase = night.Phase;
			bool inPlay = phase <= FnPhase.Lost;
			bool isGhost = false;
			double since = double.MaxValue;
			if (inPlay && night.IsGhost(actor))
			{
				isGhost = true;
				double guardTime = night.GuardTime(night.SlotOfActor(actor));
				if (guardTime > 0.0)
				{
					since = FnClock.Since(guardTime);
				}
			}
			bool ghostShown = isGhost && !(since < (double)(Mathf.Max(0f, settings.catches.lungeSeconds) + Mathf.Max(0f, settings.catches.caughtFadeSeconds)));
			bool viewerGhost = FnGhost.LocalIsGhost || night.LocalIsGhost;
			FnAvatarLook ghostLook = viewerGhost ? FnAvatarLook.Skeleton : FnAvatarLook.Hidden;
			bool asLiving = !inPlay || !ghostShown;
			FnAvatarLook look = asLiving ? FnAvatarLook.Ape : ghostLook;
			bool cone = false;
			bool cell = false;
			if (!isMine && asLiving)
			{
				cone = night.IsAliveGuard(actor) && FnProps.PlayerBool(_sync.Owner, "fnFl");
				cell = night.BatteryCarriedBy(actor) >= 0;
			}
			Apply(look, cone, cell, ghostShown && !isMine);
			if (isMine)
			{
				ApplyVoice(FnVoiceMode.Plain, 1f, false);
				return;
			}
			FnSettings.GhostSettings ghost = settings.ghost;
			float distance = ListenerDistance();
			bool listenerAlive = !viewerGhost && night.LocalIsAlive;
			FnVoiceMode heard = (ghost.whispers && distance < ghost.voiceSilentBeyond) ? FnVoiceMode.Scrambled : FnVoiceMode.Silent;
			FnVoiceMode mode = (ghostShown && listenerAlive) ? heard : FnVoiceMode.Plain;
			float gain = 1f;
			if (distance > ghost.voiceFullWithin)
			{
				gain = 0f;
				if (distance < ghost.voiceSilentBeyond)
				{
					gain = 1f - (distance - ghost.voiceFullWithin) / (ghost.voiceSilentBeyond - ghost.voiceFullWithin);
				}
			}
			ApplyVoice(mode, gain, ghostShown);
		}

		private void DarkenCosmeticLights()
		{
			for (int i = 0; i < _lights.Length; i++)
			{
				Light light = _lights[i];
				if (light == null)
				{
					_scannedCount = -1;
				}
				else if (light.enabled)
				{
					light.enabled = false;
				}
			}
		}

		private void Apply(FnAvatarLook look, bool cone, bool cell, bool collidersOff)
		{
			Look = look;
			for (int i = 0; i < _renderers.Length; i++)
			{
				Renderer renderer = _renderers[i];
				if (renderer == null)
				{
					_scannedCount = -1;
					continue;
				}
				bool off;
				switch (_kinds[i])
				{
				case KindName:
					off = look == FnAvatarLook.Hidden;
					break;
				case KindSkeleton:
					off = look != FnAvatarLook.Skeleton;
					break;
				default:
					off = look != FnAvatarLook.Ape;
					break;
				}
				if (renderer.forceRenderingOff != off)
				{
					renderer.forceRenderingOff = off;
				}
			}
			SetActive(skeletonRoot, look == FnAvatarLook.Skeleton);
			SetActive(flashlightCone, cone);
			SetActive(batteryModel, cell);
			SetColliders(collidersOff);
		}

		private float ListenerDistance()
		{
			Transform head = FnPlatform.Head;
			Transform other = _sync.Head;
			if (head != null && other != null)
			{
				return Vector3.Distance(head.position, other.position);
			}
			return float.MaxValue;
		}

		private void ApplyVoice(FnVoiceMode mode, float gain, bool needed)
		{
			if (mode == FnVoiceMode.Plain)
			{
				DetachVoice();
				return;
			}
			if (_ghostVoice == null && !(Time.unscaledTime < _nextVoiceLookup))
			{
				_nextVoiceLookup = Time.unscaledTime + 1f;
				AudioSource voiceSource = _sync.VoiceSource;
				if (voiceSource != null)
				{
					_ghostVoice = voiceSource.GetComponent<FnGhostVoice>();
					if (_ghostVoice == null)
					{
						_ghostVoice = voiceSource.gameObject.AddComponent<FnGhostVoice>();
					}
				}
			}
			if (_ghostVoice != null)
			{
				_ghostVoice.Apply(mode, gain);
			}
			else if (needed && !_warnedVoice && !(_sync.VoiceSource == null))
			{
				_warnedVoice = true;
				Debug.LogWarning("[FnGuardAvatar] A ghost's voice has no Speaker to scramble: the living hear it plainly.", this);
			}
		}

		private void DetachVoice()
		{
			if (!(_ghostVoice == null))
			{
				_ghostVoice.Apply(FnVoiceMode.Plain, 1f);
				Object.Destroy(_ghostVoice);
				_ghostVoice = null;
				_nextVoiceLookup = 0f;
			}
		}

		private void Rescan()
		{
			SetColliders(false);
			_scannedCount = transform.hierarchyCount;
			GetComponentsInChildren(true, _scanLights);
			if (_lights.Length != _scanLights.Count)
			{
				_lights = new Light[_scanLights.Count];
			}
			for (int i = 0; i < _scanLights.Count; i++)
			{
				_lights[i] = _scanLights[i];
			}
			_scanLights.Clear();
			GetComponentsInChildren(true, _scanRenderers);
			int count = 0;
			for (int j = 0; j < _scanRenderers.Count; j++)
			{
				if (KindOf(_scanRenderers[j].transform) != KindNone)
				{
					count++;
				}
			}
			if (_renderers.Length != count)
			{
				_renderers = new Renderer[count];
				_kinds = new byte[count];
			}
			int n = 0;
			for (int k = 0; k < _scanRenderers.Count; k++)
			{
				Renderer renderer = _scanRenderers[k];
				byte kind = KindOf(renderer.transform);
				if (kind != KindNone)
				{
					_renderers[n] = renderer;
					_kinds[n] = kind;
					n++;
				}
			}
			_scanRenderers.Clear();
			_scanColliders.Clear();
			if (colliderRoots != null && colliderRoots.Length != 0)
			{
				for (int l = 0; l < colliderRoots.Length; l++)
				{
					if (!(colliderRoots[l] == null))
					{
						colliderRoots[l].GetComponentsInChildren(true, _scanTemp);
						_scanColliders.AddRange(_scanTemp);
					}
				}
				_scanTemp.Clear();
			}
			else
			{
				GetComponentsInChildren(true, _scanColliders);
			}
			if (_colliders.Length != _scanColliders.Count)
			{
				_colliders = new Collider[_scanColliders.Count];
				_colliderWasOn = new bool[_scanColliders.Count];
			}
			_scanColliders.CopyTo(_colliders);
			_scanColliders.Clear();
		}

		private byte KindOf(Transform t)
		{
			if (skeletonRoot != null && t.IsChildOf(skeletonRoot.transform))
			{
				return KindSkeleton;
			}
			if (nameTagRoot != null && t.IsChildOf(nameTagRoot))
			{
				return KindName;
			}
			if (hideRoots == null || hideRoots.Length == 0)
			{
				return KindBody;
			}
			for (int i = 0; i < hideRoots.Length; i++)
			{
				if (hideRoots[i] != null && t.IsChildOf(hideRoots[i]))
				{
					return KindBody;
				}
			}
			return KindNone;
		}

		private void SetColliders(bool off)
		{
			if (off)
			{
				if (!_collidersOff)
				{
					_collidersOff = true;
					for (int i = 0; i < _colliders.Length; i++)
					{
						_colliderWasOn[i] = _colliders[i] != null && _colliders[i].enabled;
					}
				}
				for (int j = 0; j < _colliders.Length; j++)
				{
					Collider collider = _colliders[j];
					if (collider != null && collider.enabled)
					{
						collider.enabled = false;
					}
				}
			}
			else
			{
				if (!_collidersOff)
				{
					return;
				}
				_collidersOff = false;
				for (int k = 0; k < _colliders.Length; k++)
				{
					Collider collider2 = _colliders[k];
					if (collider2 != null && _colliderWasOn[k] && !collider2.enabled)
					{
						collider2.enabled = true;
					}
				}
			}
		}

		private static void SetActive(GameObject go, bool active)
		{
			if (go != null && go.activeSelf != active)
			{
				go.SetActive(active);
			}
		}
	}
}
