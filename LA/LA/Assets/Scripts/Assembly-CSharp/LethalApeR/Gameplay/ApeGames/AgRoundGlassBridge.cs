using System;
using System.Collections;
using System.Reflection;
using LethalApeR.Audio;
using LethalApeR.Rivals.Pooling;
using Photon.Pun;
using SlopGame;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundGlassBridge : AgRoundBase
	{
		public const int MaxRows = 12;

		private const float StandTolerance = 1.5f;

		public AgGlassPanel[] panels;

		[Header("Break FX (user-assigned, null-safe)")]
		public GameObject breakVfxPrefab;

		public float breakVfxLifetime = 3f;

		public PlaySfx breakSfx;

		public PlaySfx crackSfx;

		private readonly AgGlassPanel[] _byRowSide = new AgGlassPanel[MaxRows * 2];

		private bool _lookupBuilt;

		private bool _panelsSearched;

		private bool _warnedWiring;

		private bool _subscribed;

		private double _configuredStamp = -1.0;

		private Coroutine _standRoutine;

		private bool _playerPinned;

		private float _standFailsafeUntil;

		public override int RoundIndex => 2;

		private void OnEnable()
		{
			Subscribe();
			TryReconcileFromCachedProps();
		}

		private void Start()
		{
			Subscribe();
			TryReconcileFromCachedProps();
		}

		private void OnDisable()
		{
			AbortStandTest();
			Unsubscribe();
		}

		private void OnDestroy()
		{
			AbortStandTest();
			Unsubscribe();
		}

		private void TryReconcileFromCachedProps()
		{
			if (ApeGamesManager.Instance != null)
			{
				HandlePropsChanged(ApeGamesManager.Instance.Props);
			}
		}

		public override void OnRoundPrepare(AgRoundProperties p)
		{
			base.OnRoundPrepare(p);
			Subscribe();
			Configure(p);
		}

		public override void OnRoundCleanup()
		{
			AbortStandTest();
			ResetAllPanels();
			_lookupBuilt = false;
			_configuredStamp = -1.0;
			Array.Clear(_byRowSide, 0, _byRowSide.Length);
			base.OnRoundCleanup();
		}

		private void AbortStandTest()
		{
			if (_standRoutine != null)
			{
				StopCoroutine(_standRoutine);
				_standRoutine = null;
			}
			StopCrack();
			ReleasePlayer();
		}

		public override void LocalTick(double elapsed, AgRoundProperties p)
		{
			if (p == null || _standRoutine != null || p.phase != AgPhase.Round || p.round != RoundIndex || !ApeGamesManager.IsLocalAlive() || PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (actorNumber < 1 || p.EscapedContains(actorNumber) || !TryGetProbePosition(out var probe))
			{
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			float maxHeight = 10f;
			if (instance != null && instance.settings != null)
			{
				maxHeight = instance.settings.glass.overheadHeight;
			}
			ResolvePanels();
			for (int i = 0; i < MaxRows; i++)
			{
				AgGlassPanel left = _byRowSide[i * 2];
				AgGlassPanel right = _byRowSide[i * 2 + 1];
				if (!IsRowSettled(left) && !IsRowSettled(right) && TryGetRowBand(left, right, out var band) && IsOverBand(probe, band, maxHeight))
				{
					AgGlassPanel agGlassPanel = NearerPane(probe, left, right);
					if (!(agGlassPanel == null))
					{
						BeginStandTest(agGlassPanel);
						break;
					}
				}
			}
		}

		private static bool IsRowSettled(AgGlassPanel panel)
		{
			if (panel != null)
			{
				if (!panel.IsResolved)
				{
					return panel.IsBroken;
				}
				return true;
			}
			return false;
		}

		private static bool TryGetRowBand(AgGlassPanel left, AgGlassPanel right, out Bounds band)
		{
			band = default(Bounds);
			bool flag = false;
			if (left != null && left.TryGetBounds(out var bounds))
			{
				band = bounds;
				flag = true;
			}
			if (right != null && right.TryGetBounds(out var bounds2))
			{
				if (flag)
				{
					band.Encapsulate(bounds2);
				}
				else
				{
					band = bounds2;
				}
				flag = true;
			}
			return flag;
		}

		private static bool IsOverBand(Vector3 probe, Bounds band, float maxHeight)
		{
			if (probe.x < band.min.x || probe.x > band.max.x || probe.z < band.min.z || probe.z > band.max.z)
			{
				return false;
			}
			float num = probe.y - band.max.y;
			if (num >= -StandTolerance)
			{
				return num <= maxHeight;
			}
			return false;
		}

		private static AgGlassPanel NearerPane(Vector3 probe, AgGlassPanel left, AgGlassPanel right)
		{
			Bounds bounds = default(Bounds);
			Bounds bounds2 = default(Bounds);
			bool flag = left != null && left.TryGetBounds(out bounds);
			bool flag2 = right != null && right.TryGetBounds(out bounds2);
			if (!flag && !flag2)
			{
				return null;
			}
			if (!flag)
			{
				return right;
			}
			if (!flag2)
			{
				return left;
			}
			if (!(SqrHorizontal(probe, bounds.center) <= SqrHorizontal(probe, bounds2.center)))
			{
				return right;
			}
			return left;
		}

		private static float SqrHorizontal(Vector3 a, Vector3 b)
		{
			float num = a.x - b.x;
			float num2 = a.z - b.z;
			return num * num + num2 * num2;
		}

		private static bool TryGetProbePosition(out Vector3 probe)
		{
			if (!GorillaLocomotion.Player.HasInstance)
			{
				probe = default(Vector3);
				return false;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			probe = ((instance.bodyCollider != null) ? instance.bodyCollider.transform : instance.transform).position;
			return true;
		}

		public void BeginStandTest(AgGlassPanel panel)
		{
			if (!(panel == null) && !panel.IsBroken && !panel.IsResolved && _standRoutine == null && base.isActiveAndEnabled)
			{
				_standRoutine = StartCoroutine(StandTest(panel));
			}
		}

		private IEnumerator StandTest(AgGlassPanel panel)
		{
			ApeGamesManager mgr = ApeGamesManager.Instance;
			float hold = ((mgr != null && mgr.settings != null) ? mgr.settings.glass.standSeconds : 1f);
			if (hold > 0f)
			{
				SnapToPane(panel);
				PinPlayer();
				AgHaptics.Both(0.35f, 0.08f);
				PlayCrack(panel.transform.position);
				_standFailsafeUntil = Time.time + hold + 2f;
				float until = Time.time + hold;
				float nextTick = Time.time;
				while (Time.time < until && ApeGamesManager.IsLocalAlive() && IsRoundLive())
				{
					if (Time.time >= nextTick)
					{
						float t = ((hold > 0f) ? Mathf.Clamp01((until - Time.time) / hold) : 0f);
						AgHaptics.Both(Mathf.Lerp(0.5f, 0.15f, t), 0.04f);
						nextTick = Time.time + Mathf.Lerp(0.08f, 0.3f, t);
					}
					yield return null;
				}
				StopCrack();
				ReleasePlayer();
				if (ApeGamesManager.IsLocalAlive())
				{
					AgHaptics.Both(panel.IsBad ? 1f : 0.25f, panel.IsBad ? 0.28f : 0.06f);
				}
			}
			panel.IsResolved = true;
			if (panel.IsBad && mgr != null && ApeGamesManager.IsLocalAlive() && IsRoundLive())
			{
				mgr.RequestBreakPanel(panel.row, panel.side);
			}
			_standRoutine = null;
		}

		private bool IsRoundLive()
		{
			if (ApeGamesManager.Instance == null)
			{
				return false;
			}
			AgRoundProperties props = ApeGamesManager.Instance.Props;
			if (props != null && props.queue == ApeGamesManager.GameQueue && props.phase == AgPhase.Round)
			{
				return props.round == RoundIndex;
			}
			return false;
		}

		private void PlayCrack(Vector3 at)
		{
			if (!(crackSfx == null))
			{
				StopCrack();
				crackSfx.PlayAudioAt(at);
			}
		}

		private void StopCrack()
		{
			if (crackSfx == null)
			{
				return;
			}
			AudioSource currentAudioSource = crackSfx.CurrentAudioSource;
			if (currentAudioSource != null)
			{
				bool loop = currentAudioSource.loop;
				currentAudioSource.Stop();
				if (loop && currentAudioSource.gameObject.activeInHierarchy)
				{
					AudioSystem.ReturnToPool(currentAudioSource);
				}
			}
			crackSfx.ClearCurrentAudioSource();
		}

		private void SnapToPane(AgGlassPanel panel)
		{
			float yOffset = 0.05f;
			if (ApeGamesManager.Instance != null && ApeGamesManager.Instance.settings != null)
			{
				yOffset = ApeGamesManager.Instance.settings.glass.standYOffset;
			}
			Vector3 position = panel.SnapPoint(yOffset);
			if (GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.TeleportPlayerRaw(position, Quaternion.identity);
			}
		}

		private void PinPlayer()
		{
			if (!_playerPinned && GorillaLocomotion.Player.HasInstance)
			{
				GorillaLocomotion.Player.Instance.disableMovement = true;
				_playerPinned = true;
			}
		}

		private void ReleasePlayer()
		{
			if (_playerPinned)
			{
				_playerPinned = false;
				if (GorillaLocomotion.Player.HasInstance)
				{
					GorillaLocomotion.Player.Instance.disableMovement = false;
				}
			}
		}

		private void Update()
		{
			if (_playerPinned && Time.time >= _standFailsafeUntil)
			{
				StopCrack();
				ReleasePlayer();
			}
		}

		public void ApplyBreak(int row, int side)
		{
			if (row < 0 || row >= MaxRows || side < 0 || side > 1)
			{
				return;
			}
			ResolvePanels();
			AgGlassPanel agGlassPanel = _byRowSide[row * 2 + side];
			if (agGlassPanel == null || !agGlassPanel.TryBreak())
			{
				return;
			}
			Transform transform = agGlassPanel.transform;
			if (breakVfxPrefab != null)
			{
				GameObject gameObject = SimplePool.SpawnTimed(breakVfxPrefab, transform.position, transform.rotation, breakVfxLifetime);
				if (gameObject != null)
				{
					ParticleSystem componentInChildren = gameObject.GetComponentInChildren<ParticleSystem>();
					if (componentInChildren != null)
					{
						componentInChildren.Clear(true);
						componentInChildren.Play(true);
					}
				}
			}
			if (breakSfx != null)
			{
				breakSfx.PlayAudioAt(transform.position);
			}
		}

		private void HandlePropsChanged(AgRoundProperties p)
		{
			if (p != null && p.phase == AgPhase.Round && p.round == RoundIndex && !_configuredStamp.Equals(p.startTime))
			{
				Configure(p);
			}
		}

		private void Configure(AgRoundProperties p)
		{
			if (p == null)
			{
				return;
			}
			ResolvePanels();
			_configuredStamp = p.startTime;
			for (int i = 0; i < panels.Length; i++)
			{
				AgGlassPanel agGlassPanel = panels[i];
				if (!(agGlassPanel == null))
				{
					agGlassPanel.ResetPanel();
					if (agGlassPanel.row >= 0 && agGlassPanel.row < MaxRows)
					{
						agGlassPanel.SetBad(((p.glassMask >> agGlassPanel.row) & 1) == agGlassPanel.side);
					}
				}
			}
		}

		private void ResolvePanels()
		{
			if (!_panelsSearched && (panels == null || panels.Length == 0))
			{
				_panelsSearched = true;
				panels = ((roundRoot != null) ? roundRoot.GetComponentsInChildren<AgGlassPanel>(true) : GetComponentsInChildren<AgGlassPanel>(true));
			}
			if (_lookupBuilt)
			{
				return;
			}
			_lookupBuilt = true;
			bool flag = false;
			for (int i = 0; i < panels.Length; i++)
			{
				AgGlassPanel agGlassPanel = panels[i];
				if (agGlassPanel == null)
				{
					continue;
				}
				if (agGlassPanel.row < 0 || agGlassPanel.row >= MaxRows || agGlassPanel.side < 0 || agGlassPanel.side > 1)
				{
					flag = true;
					continue;
				}
				int num = agGlassPanel.row * 2 + agGlassPanel.side;
				if (_byRowSide[num] != null && _byRowSide[num] != agGlassPanel)
				{
					flag = true;
				}
				else
				{
					_byRowSide[num] = agGlassPanel;
				}
			}
			if (!_warnedWiring && (flag || panels.Length != MaxRows * 2))
			{
				_warnedWiring = true;
				Debug.LogError(string.Format("[ApeGames] Glass bridge wiring: {0} panels found (expected {1})", panels.Length, MaxRows * 2) + (flag ? ", some with invalid or duplicate row/side ids" : "") + ".");
			}
		}

		private void ResetAllPanels()
		{
			if (panels == null)
			{
				return;
			}
			for (int i = 0; i < panels.Length; i++)
			{
				if (panels[i] != null)
				{
					panels[i].ResetPanel();
				}
			}
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
	}
}
