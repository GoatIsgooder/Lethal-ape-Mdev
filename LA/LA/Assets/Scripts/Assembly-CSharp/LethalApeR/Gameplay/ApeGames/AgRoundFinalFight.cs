using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundFinalFight : AgRoundBase
	{
		public AudioClip bonkClip;

		public GameObject bonkVfxPrefab;

		public float bonkVfxLifetime = 1.5f;

		public AgStormZone storm;

		public AgVignettePulse vignettePulse;

		public Color hitPulseColor = new Color(0.95f, 0.12f, 0.12f, 1f);

		private readonly Dictionary<int, GameObject> _hammers = new Dictionary<int, GameObject>(12);

		private readonly List<int> _actorScratch = new List<int>(12);

		private readonly List<int> _pendingActors = new List<int>(12);

		private bool _active;

		private bool _preparing;

		private bool _subscribed;

		private float _nextPendingRetry;

		public override int RoundIndex => 4;

		public override void OnRoundPrepare(AgRoundProperties p)
		{
			_preparing = true;
			base.OnRoundPrepare(p);
			_active = true;
			_preparing = false;
			_nextPendingRetry = 0f;
			ReleaseAllHammers();
			_pendingActors.Clear();
			if (p != null && p.alive != null)
			{
				for (int i = 0; i < p.alive.Length; i++)
				{
					if (!TryAttachHammer(p.alive[i]))
					{
						_pendingActors.Add(p.alive[i]);
					}
				}
			}
			if (storm != null)
			{
				storm.Begin();
			}
			Subscribe();
		}

		public override void OnRoundCleanup()
		{
			_active = false;
			_pendingActors.Clear();
			ReleaseAllHammers();
			if (storm != null)
			{
				storm.End();
			}
			Unsubscribe();
			base.OnRoundCleanup();
		}

		public override void LocalTick(double elapsed, AgRoundProperties p)
		{
			if (storm != null)
			{
				storm.Tick(elapsed);
			}
			if (_pendingActors.Count == 0 || Time.unscaledTime < _nextPendingRetry)
			{
				return;
			}
			_nextPendingRetry = Time.unscaledTime + 1f;
			for (int i = _pendingActors.Count - 1; i >= 0; i--)
			{
				int actor = _pendingActors[i];
				if (p == null || !p.AliveContains(actor) || TryAttachHammer(actor))
				{
					_pendingActors.RemoveAt(i);
				}
			}
		}

		public override RandomizeSpawnPoint GetSpawnFor(int actor, AgRoundProperties p)
		{
			if (p != null && p.TowerAContains(actor))
			{
				return playersTp;
			}
			return (secondaryTp != null) ? secondaryTp : playersTp;
		}

		public void OnHammerHitVisuals(int victimActor)
		{
			if (victimActor < 1 || (bonkClip == null && bonkVfxPrefab == null))
			{
				return;
			}
			AgNetSync sync = AgNetSync.Get(victimActor);
			if (sync == null)
			{
				return;
			}
			Vector3 position = ((sync.Head != null) ? sync.Head : sync.transform).position;
			if (bonkClip != null)
			{
				AudioSource.PlayClipAtPoint(bonkClip, position, 1f);
			}
			if (bonkVfxPrefab != null)
			{
				Object.Destroy(Object.Instantiate(bonkVfxPrefab, position, Quaternion.identity), Mathf.Max(0.1f, bonkVfxLifetime));
			}
		}

		public void OnHammerHitVictim(int victimActor, Vector3 impulse)
		{
			if (PhotonNetwork.LocalPlayer == null || PhotonNetwork.LocalPlayer.ActorNumber != victimActor || !_active)
			{
				return;
			}
			float maxSpeed = 18f;
			if (ApeGamesManager.Instance != null && ApeGamesManager.Instance.settings != null)
			{
				maxSpeed = ApeGamesManager.Instance.settings.finalFight.maxKnockbackSpeed;
			}
			if (impulse.sqrMagnitude > maxSpeed * maxSpeed)
			{
				impulse = impulse.normalized * maxSpeed;
			}
			AgLauncher.Launch(impulse);
			float t = 1f;
			if (maxSpeed > 0.01f)
			{
				t = Mathf.Clamp01(impulse.magnitude / maxSpeed);
			}
			AgHaptics.Both(Mathf.Lerp(0.5f, 1f, t), Mathf.Lerp(0.14f, 0.26f, t));
			if (vignettePulse == null)
			{
				vignettePulse = Object.FindFirstObjectByType<AgVignettePulse>();
			}
			if (vignettePulse != null)
			{
				vignettePulse.Pulse(hitPulseColor, Mathf.Lerp(0.5f, 1f, t));
			}
		}

		private bool TryAttachHammer(int actor)
		{
			if (actor < 1)
			{
				return true;
			}
			if (_hammers.TryGetValue(actor, out var existing) && existing != null)
			{
				return true;
			}
			bool isLocal = PhotonNetwork.LocalPlayer != null && PhotonNetwork.LocalPlayer.ActorNumber == actor;
			AgNetSync sync = AgNetSync.Get(actor);
			AgHammer hammer = (sync != null) ? sync.GetComponentInChildren<AgHammer>(true) : null;
			if (hammer == null && isLocal)
			{
				hammer = AgHammer.LocalInstance;
			}
			if (hammer == null)
			{
				return false;
			}
			ArmHammer(hammer, isLocal);
			_hammers[actor] = hammer.gameObject;
			return true;
		}

		private static void ArmHammer(AgHammer hammer, bool isLocal)
		{
			if (!(hammer == null))
			{
				GameObject go = hammer.gameObject;
				go.SetActive(true);
				hammer.Configure(isLocal);
				if (!go.activeSelf)
				{
					go.SetActive(true);
				}
			}
		}

		private static void ReleaseHammer(GameObject go)
		{
			if (go != null)
			{
				go.SetActive(false);
			}
		}

		private void HandlePropsChanged(AgRoundProperties p)
		{
			if (p == null || !_active)
			{
				return;
			}
			_actorScratch.Clear();
			foreach (KeyValuePair<int, GameObject> kv in _hammers)
			{
				if (kv.Value == null || !p.AliveContains(kv.Key))
				{
					_actorScratch.Add(kv.Key);
				}
			}
			for (int i = 0; i < _actorScratch.Count; i++)
			{
				int actor = _actorScratch[i];
				if (_hammers.TryGetValue(actor, out var go))
				{
					ReleaseHammer(go);
				}
				_hammers.Remove(actor);
				if (p.AliveContains(actor) && !_pendingActors.Contains(actor))
				{
					_pendingActors.Add(actor);
				}
			}
			for (int j = _pendingActors.Count - 1; j >= 0; j--)
			{
				if (!p.AliveContains(_pendingActors[j]))
				{
					_pendingActors.RemoveAt(j);
				}
			}
			if (p.alive == null)
			{
				return;
			}
			for (int k = 0; k < p.alive.Length; k++)
			{
				int actor2 = p.alive[k];
				if (!_hammers.ContainsKey(actor2) && !_pendingActors.Contains(actor2))
				{
					_pendingActors.Add(actor2);
				}
			}
		}

		private void ReleaseAllHammers()
		{
			foreach (KeyValuePair<int, GameObject> kv in _hammers)
			{
				ReleaseHammer(kv.Value);
			}
			_hammers.Clear();
		}

		private void Subscribe()
		{
			if (!_subscribed && !(ApeGamesManager.Instance == null))
			{
				ApeGamesManager.Instance.OnPropsChanged += HandlePropsChanged;
				_subscribed = true;
			}
		}

		private void Unsubscribe()
		{
			if (_subscribed)
			{
				if (ApeGamesManager.Instance != null)
				{
					ApeGamesManager.Instance.OnPropsChanged -= HandlePropsChanged;
				}
				_subscribed = false;
			}
		}

		private void OnDisable()
		{
			_active = false;
			ReleaseAllHammers();
			Unsubscribe();
		}

		private void OnEnable()
		{
			if (!_active && !_preparing && !(ApeGamesManager.Instance == null))
			{
				AgRoundProperties p = ApeGamesManager.Instance.Props;
				if (p != null && p.phase == AgPhase.Round && p.round == RoundIndex)
				{
					OnRoundPrepare(p);
				}
			}
		}

		private void OnDestroy()
		{
			Unsubscribe();
			ReleaseAllHammers();
		}
	}
}
