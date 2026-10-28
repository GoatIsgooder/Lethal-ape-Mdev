using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Networking;
using SlopGame;
using UnityEngine;
using UnityEngine.Rendering;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DisallowMultipleComponent]
	public sealed class BtmGore : MonoBehaviour
	{
		private struct Motion
		{
			public Vector3 Last;

			public Vector3 Velocity;
		}

		private const float MaxTrackedSpeed = 25f;

		[Header("Blood")]
		public BtmBloodBurst burstPrefab;

		public BtmBloodBurst splashPrefab;

		public BtmBloodDecal decalPrefab;

		[Header("Sound")]
		public AudioClip[] crunchClips;

		public AudioClip[] splatClips;

		[Tooltip("3D settings the gore sounds play with; its own clip is never played.")]
		public AudioSource soundTemplate;

		[Range(0f, 1f)]
		public float volume = 0.8f;

		[Header("Corpses")]
		[Min(1f)]
		public int maxCorpses = 4;

		public float corpseSeconds = 20f;

		[Tooltip("A body, head or chainsaw piece a monster picked up and let go lasts this long from the drop. Held, it never goes.")]
		public float droppedSeconds = 10f;

		[Tooltip("Past this from the local camera, a kill still leaves a body but skips the sprays and splats.")]
		public float fxRange = 45f;

		[Tooltip("Floors the pools land on.")]
		public LayerMask floors = 1;

		[Tooltip("A body's head pops off the neck as it drops (BtmChainsawCutter beside this). Past the effects range it stays on.")]
		public bool popHeads = true;

		private readonly List<BtmCorpse> _corpses = new List<BtmCorpse>();

		private readonly HashSet<int> _corpsed = new HashSet<int>();

		private readonly Dictionary<MonkeDevNetworkingPlayer, Motion> _motion = new Dictionary<MonkeDevNetworkingPlayer, Motion>();

		private readonly List<MonkeDevNetworkingPlayer> _gone = new List<MonkeDevNetworkingPlayer>();

		private double _round = double.NaN;

		private Coroutine _warm;

		private static bool _shadersWarm;

		public static BtmGore Instance { get; private set; }

		private void Awake()
		{
			if ((bool)Instance && Instance != this)
			{
				UnityEngine.Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
			ClearCorpses();
		}

		public void SurvivorKilled(MonkeDevNetworkingPlayer victim, MonkeDevNetworkingPlayer killer, double round, bool bySaw = false)
		{
			if (!FirstDeath(victim, round))
			{
				return;
			}
			Vector3 bar = Vector3.zero;
			if (bySaw)
			{
				if (BtmChainsawFx.Cut(killer, victim, out bar))
				{
					return;
				}
				if (bar != Vector3.zero)
				{
					DropCorpse(victim, bar);
					return;
				}
			}
			DropCorpse(victim, ((bool)killer && (bool)killer.Head) ? killer.Head.position : (victim.Head.position - victim.Head.forward));
		}

		public void SurvivorChopped(MonkeDevNetworkingPlayer victim, MonkeDevNetworkingPlayer killer, double round, Vector3 cutNormal, Vector3 hitPoint, Vector3 hitDirection)
		{
			if (!FirstDeath(victim, round))
			{
				return;
			}
			BtmChainsawCutter component = GetComponent<BtmChainsawCutter>();
			if ((bool)component && cutNormal.sqrMagnitude > 1E-06f && component.Cut(victim, cutNormal))
			{
				if (InFxRange(hitPoint) && hitDirection.sqrMagnitude > 1E-06f)
				{
					Burst(burstPrefab, hitPoint, hitDirection.normalized);
				}
			}
			else if (hitDirection.sqrMagnitude > 1E-06f)
			{
				DropCorpse(victim, hitPoint - hitDirection.normalized);
			}
			else
			{
				DropCorpse(victim, ((bool)killer && (bool)killer.Head) ? killer.Head.position : (victim.Head.position - victim.Head.forward));
			}
		}

		private bool FirstDeath(MonkeDevNetworkingPlayer victim, double round)
		{
			if (!victim || victim.photonView == null)
			{
				return false;
			}
			if (!_round.Equals(round))
			{
				_round = round;
				_corpsed.Clear();
			}
			return _corpsed.Add(victim.photonView.OwnerActorNr);
		}

		public void DropCorpse(MonkeDevNetworkingPlayer victim, Vector3 hitFrom)
		{
			if ((bool)victim && (bool)victim.Head)
			{
				MakeRoom();
				Keep(BtmCorpse.Spawn(victim, VelocityOf(victim), hitFrom, this));
			}
		}

		public BtmCorpse DropCorpse(Transform models, SkinnedMeshRenderer body, string name, Vector3 velocity, Vector3 hitFrom)
		{
			MakeRoom();
			BtmCorpse btmCorpse = BtmCorpse.Spawn(models, body, name, velocity, hitFrom, this);
			Keep(btmCorpse);
			return btmCorpse;
		}

		private void MakeRoom()
		{
			for (int num = _corpses.Count - 1; num >= 0; num--)
			{
				if (!_corpses[num] || _corpses[num].Retiring)
				{
					_corpses.RemoveAt(num);
				}
			}
			int num2 = 0;
			while (num2 < _corpses.Count && _corpses.Count >= maxCorpses)
			{
				if ((bool)_corpses[num2].Part && _corpses[num2].Part.Held)
				{
					num2++;
					continue;
				}
				_corpses[num2].Retire();
				_corpses.RemoveAt(num2);
			}
		}

		private void Keep(BtmCorpse corpse)
		{
			if ((bool)corpse)
			{
				_corpses.Add(corpse);
				Vector3 point = (corpse.Rig.Neck ? corpse.Rig.Neck : corpse.transform).position;
				if (popHeads && InFxRange(point) && TryGetComponent<BtmChainsawCutter>(out var component))
				{
					component.Decapitate(corpse);
				}
			}
		}

		public void RoundStarting()
		{
			if (popHeads && (bool)MonkeDevNetworkingManager.Manager)
			{
				foreach (MonkeDevNetworkingPlayer player in MonkeDevNetworkingManager.Manager.Players)
				{
					if ((bool)player)
					{
						BtmCutMeshes.Preload(player);
					}
				}
			}
			if (!_shadersWarm)
			{
				if (_warm != null)
				{
					StopCoroutine(_warm);
				}
				_warm = StartCoroutine(WarmShaders());
			}
		}

		private IEnumerator WarmShaders()
		{
			yield return null;
			Camera view = Camera.main;
			if (!view)
			{
				yield break;
			}
			_shadersWarm = true;
			Mesh speck = Resources.GetBuiltinResource<Mesh>("Quad.fbx");
			ParticleSystemRenderer particleSystemRenderer = (burstPrefab ? burstPrefab.GetComponent<ParticleSystemRenderer>() : null);
			MeshRenderer meshRenderer = (decalPrefab ? decalPrefab.GetComponentInChildren<MeshRenderer>() : null);
			List<Material> materials = new List<Material>
			{
				particleSystemRenderer ? particleSystemRenderer.sharedMaterial : null,
				meshRenderer ? meshRenderer.sharedMaterial : null
			};
			BtmChainsawCutter component = GetComponent<BtmChainsawCutter>();
			if ((bool)component)
			{
				component.CollectMaterials(materials);
			}
			for (int frame = 0; frame < 2; frame++)
			{
				if (!view)
				{
					yield break;
				}
				Matrix4x4 matrix = Matrix4x4.TRS(view.transform.position + view.transform.forward * 0.3f, Quaternion.identity, Vector3.one * 0.0001f);
				foreach (Material material in materials)
				{
					if ((bool)material)
					{
						Graphics.DrawMesh(speck, matrix, material, 0, view, 0, null, ShadowCastingMode.Off, receiveShadows: false);
					}
				}
				yield return null;
			}
			_warm = null;
		}

		public void ClearCorpses()
		{
			foreach (BtmCorpse corpse in _corpses)
			{
				if ((bool)corpse)
				{
					UnityEngine.Object.Destroy(corpse.gameObject);
				}
			}
			_corpses.Clear();
			_corpsed.Clear();
			_round = double.NaN;
			BtmBodyPart.ClearAll();
			BtmChainsawCutter component = GetComponent<BtmChainsawCutter>();
			if ((bool)component)
			{
				component.ClearCuts();
			}
			BtmCutMeshes.Release();
			BtmChainsawFx.PreloadIfRunning();
		}

		private void LateUpdate()
		{
			BtmBodyPart.RetryWaiting();
			if (!MonkeDevNetworkingManager.Manager)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			foreach (MonkeDevNetworkingPlayer player in MonkeDevNetworkingManager.Manager.Players)
			{
				if (!player || !player.Head)
				{
					continue;
				}
				Vector3 position = player.Head.position;
				if (_motion.TryGetValue(player, out var value) && deltaTime > 1E-05f)
				{
					Vector3 vector = (position - value.Last) / deltaTime;
					if (vector.sqrMagnitude < MaxTrackedSpeed * MaxTrackedSpeed)
					{
						value.Velocity = Vector3.Lerp(value.Velocity, vector, 0.5f);
					}
					else
					{
						value.Velocity = Vector3.zero;
					}
				}
				value.Last = position;
				_motion[player] = value;
			}
			if (Time.frameCount % 300 != 0)
			{
				return;
			}
			foreach (MonkeDevNetworkingPlayer key in _motion.Keys)
			{
				if (!key)
				{
					_gone.Add(key);
				}
			}
			foreach (MonkeDevNetworkingPlayer item in _gone)
			{
				_motion.Remove(item);
			}
			_gone.Clear();
		}

		public Vector3 VelocityOf(MonkeDevNetworkingPlayer player)
		{
			if ((bool)player && _motion.TryGetValue(player, out var value))
			{
				return value.Velocity;
			}
			return Vector3.zero;
		}

		public bool InFxRange(Vector3 point)
		{
			Camera main = Camera.main;
			if (!main)
			{
				return true;
			}
			return (main.transform.position - point).sqrMagnitude <= fxRange * fxRange;
		}

		public BtmBloodBurst Burst(BtmBloodBurst prefab, Vector3 point, Vector3 direction, Transform follow = null)
		{
			if (!prefab)
			{
				return null;
			}
			BtmBloodBurst btmBloodBurst = (follow ? UnityEngine.Object.Instantiate(prefab, follow) : UnityEngine.Object.Instantiate(prefab));
			btmBloodBurst.Play(this, point, direction);
			return btmBloodBurst;
		}

		public void Splat(Vector3 point, Vector3 normal, float speed, ref int splashes, int maxSplashes)
		{
			Play(splatClips, point, Mathf.Clamp01(speed / 5f));
			if ((bool)decalPrefab)
			{
				UnityEngine.Object.Instantiate(decalPrefab).Place(point, normal, Mathf.Clamp(speed * 0.25f, 0.8f, 1.5f));
			}
			if ((bool)splashPrefab && splashes < maxSplashes)
			{
				splashes++;
				Burst(splashPrefab, point, normal);
			}
		}

		public BtmBloodDecal Pool(Vector3 center, float size)
		{
			if (!decalPrefab)
			{
				return null;
			}
			if (!Physics.Raycast(center + Vector3.up * 0.2f, Vector3.down, out var hitInfo, 2.5f, floors, QueryTriggerInteraction.Ignore))
			{
				return null;
			}
			BtmBloodDecal btmBloodDecal = UnityEngine.Object.Instantiate(decalPrefab);
			btmBloodDecal.Place(hitInfo.point, hitInfo.normal, size);
			btmBloodDecal.Grow(3f);
			return btmBloodDecal;
		}

		public void Play(AudioClip[] clips, Vector3 point, float loudness = 1f)
		{
			if (clips != null && clips.Length != 0)
			{
				AudioClip audioClip = clips[UnityEngine.Random.Range(0, clips.Length)];
				if ((bool)audioClip)
				{
					AudioSystem.PlayClipAt(audioClip, point, volume * Mathf.Clamp01(loudness), soundTemplate);
				}
			}
		}
	}
}
