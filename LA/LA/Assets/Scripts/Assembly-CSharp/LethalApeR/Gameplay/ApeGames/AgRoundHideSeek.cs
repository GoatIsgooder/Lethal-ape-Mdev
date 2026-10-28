using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoundHideSeek : AgRoundBase
	{
		[SerializeField]
		private float seekerSpawnDelay = 5f;

		private readonly List<GameObject> _handTriggers = new List<GameObject>(2);

		private float _holdSeconds = 5f;

		private bool _holdActive;

		private float _holdFailsafeUntil;

		private bool _movementSuppressed;

		private bool _subscribed;

		private bool _wantHandTriggers;

		private float _nextHandTriggerRetry;

		private bool _releaseCuePlayed;

		public override int RoundIndex => 3;

		public override void OnRoundPrepare(AgRoundProperties p)
		{
			base.OnRoundPrepare(p);
			ApeGamesManager instance = ApeGamesManager.Instance;
			_holdSeconds = ((instance != null && instance.settings != null) ? instance.settings.hideSeek.seekerSpawnDelay : seekerSpawnDelay);
			ValidateGenerators();
			Subscribe();
			AgSeekerHandTrigger.ResetCooldowns();
			ApplyOutfits(p);
			_wantHandTriggers = false;
			_nextHandTriggerRetry = 0f;
			_releaseCuePlayed = false;
			if (PhotonNetwork.LocalPlayer != null && p != null && PhotonNetwork.LocalPlayer.ActorNumber >= 1 && p.SeekersContains(PhotonNetwork.LocalPlayer.ActorNumber) && ApeGamesManager.IsLocalAlive())
			{
				_wantHandTriggers = true;
				AttachHandTriggers();
				_holdActive = _holdSeconds > 0f;
				_holdFailsafeUntil = Time.time + _holdSeconds + 2f;
			}
		}

		public override void OnRoundCleanup()
		{
			_wantHandTriggers = false;
			ReleaseSeekerHold();
			DetachHandTriggers();
			ClearOutfits();
			Unsubscribe();
			base.OnRoundCleanup();
		}

		public override void LocalTick(double elapsed, AgRoundProperties p)
		{
			if (_wantHandTriggers && _handTriggers.Count == 0 && Time.unscaledTime >= _nextHandTriggerRetry)
			{
				_nextHandTriggerRetry = Time.unscaledTime + 1f;
				if (ApeGamesManager.IsLocalAlive())
				{
					AttachHandTriggers();
				}
				else
				{
					_wantHandTriggers = false;
				}
			}
			if (!_holdActive)
			{
				return;
			}
			if (p == null || elapsed >= (double)_holdSeconds || p.phase != AgPhase.Round || !ApeGamesManager.IsLocalAlive())
			{
				ReleaseSeekerHold();
				return;
			}
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			if (!(player == null))
			{
				if (!_movementSuppressed)
				{
					player.disableMovement = true;
					_movementSuppressed = true;
				}
				if (player.playerRigidBody != null)
				{
					player.playerRigidBody.linearVelocity = Vector3.zero;
					player.playerRigidBody.angularVelocity = Vector3.zero;
				}
			}
		}

		public override RandomizeSpawnPoint GetSpawnFor(int actor, AgRoundProperties p)
		{
			if (p != null && p.SeekersContains(actor) && secondaryTp != null)
			{
				return secondaryTp;
			}
			return playersTp;
		}

		private void OnDisable()
		{
			_wantHandTriggers = false;
			ReleaseSeekerHold();
			DetachHandTriggers();
			Unsubscribe();
		}

		private void Update()
		{
			if (_holdActive && Time.time >= _holdFailsafeUntil)
			{
				ReleaseSeekerHold();
			}
		}

		private void Subscribe()
		{
			if (!_subscribed)
			{
				ApeGamesManager instance = ApeGamesManager.Instance;
				if (!(instance == null))
				{
					_subscribed = true;
					instance.OnPropsChanged += OnPropsChangedHandler;
					instance.OnLocalEliminated += OnLocalEliminatedHandler;
					instance.OnRoundEndedEvent += OnRoundEndedHandler;
				}
			}
		}

		private void Unsubscribe()
		{
			if (_subscribed)
			{
				_subscribed = false;
				ApeGamesManager instance = ApeGamesManager.Instance;
				if (!(instance == null))
				{
					instance.OnPropsChanged -= OnPropsChangedHandler;
					instance.OnLocalEliminated -= OnLocalEliminatedHandler;
					instance.OnRoundEndedEvent -= OnRoundEndedHandler;
				}
			}
		}

		private void OnPropsChangedHandler(AgRoundProperties p)
		{
			if (p != null && p.phase == AgPhase.Round && p.round == RoundIndex)
			{
				ApplyOutfits(p);
			}
		}

		private void OnLocalEliminatedHandler()
		{
			_wantHandTriggers = false;
			ReleaseSeekerHold();
			DetachHandTriggers();
		}

		private void OnRoundEndedHandler(int round, AgRoundProperties p)
		{
			if (RoundIndex == round)
			{
				_wantHandTriggers = false;
				ReleaseSeekerHold();
				DetachHandTriggers();
				ClearOutfits();
			}
		}

		private void ReleaseSeekerHold()
		{
			_holdActive = false;
			if (_movementSuppressed)
			{
				_movementSuppressed = false;
				if (!_releaseCuePlayed)
				{
					_releaseCuePlayed = true;
					AgHaptics.Both(0.7f, 0.16f);
				}
				if (GorillaLocomotion.Player.HasInstance)
				{
					GorillaLocomotion.Player.Instance.disableMovement = false;
				}
			}
		}

		private void AttachHandTriggers()
		{
			DetachHandTriggers();
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.LocalPlayer : null);
			if (!(monkeDevNetworkingPlayer == null))
			{
				if (monkeDevNetworkingPlayer.LeftHand != null)
				{
					_handTriggers.Add(AgSeekerHandTrigger.Attach(monkeDevNetworkingPlayer.LeftHand, true));
				}
				if (monkeDevNetworkingPlayer.RightHand != null)
				{
					_handTriggers.Add(AgSeekerHandTrigger.Attach(monkeDevNetworkingPlayer.RightHand, false));
				}
			}
		}

		private void DetachHandTriggers()
		{
			for (int i = 0; i < _handTriggers.Count; i++)
			{
				if (_handTriggers[i] != null)
				{
					Object.Destroy(_handTriggers[i]);
				}
			}
			_handTriggers.Clear();
		}

		private void ApplyOutfits(AgRoundProperties p)
		{
			if (p == null)
			{
				return;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
				if (monkeDevNetworkingPlayer == null)
				{
					continue;
				}
				PhotonView photonView = monkeDevNetworkingPlayer.photonView;
				if (photonView == null)
				{
					continue;
				}
				int ownerActorNr = photonView.OwnerActorNr;
				if (ownerActorNr < 1)
				{
					continue;
				}
				AgOutfitApplier agOutfitApplier = AgOutfitApplier.GetFor(monkeDevNetworkingPlayer);
				if (!(agOutfitApplier == null))
				{
					if (p.SeekersContains(ownerActorNr))
					{
						agOutfitApplier.Apply(true);
					}
					else if (p.AliveContains(ownerActorNr) && !p.EscapedContains(ownerActorNr))
					{
						agOutfitApplier.Apply(false);
					}
					else
					{
						agOutfitApplier.Clear();
					}
				}
			}
		}

		private void ClearOutfits()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			List<MonkeDevNetworkingPlayer> players = manager.Players;
			for (int i = 0; i < players.Count; i++)
			{
				MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = players[i];
				if (!(monkeDevNetworkingPlayer == null))
				{
					AgOutfitApplier component = monkeDevNetworkingPlayer.GetComponent<AgOutfitApplier>();
					if (component != null)
					{
						component.Clear();
					}
				}
			}
		}

		private void ValidateGenerators()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			int num = ((instance != null && instance.settings != null) ? instance.settings.hideSeek.generatorsRequired : 0);
			IReadOnlyList<AgGenerator> activeGenerators = AgGenerator.ActiveGenerators;
			if (num > 0 && activeGenerators.Count != num)
			{
				Debug.LogError(string.Format("[AgRoundHideSeek] {0} generator(s) active but settings.hideSeek.generatorsRequired = {1}, place exactly that many under the round root.", activeGenerators.Count, num), this);
			}
			int num2 = 0;
			for (int i = 0; i < activeGenerators.Count; i++)
			{
				AgGenerator agGenerator = activeGenerators[i];
				if (agGenerator == null)
				{
					continue;
				}
				if (agGenerator.generatorId < 0 || agGenerator.generatorId >= 32)
				{
					Debug.LogError(string.Format("[AgRoundHideSeek] Generator '{0}' has out-of-range generatorId {1} (must be 0-31).", agGenerator.name, agGenerator.generatorId), agGenerator);
					continue;
				}
				int num3 = 1 << agGenerator.generatorId;
				if ((num3 & num2) != 0)
				{
					Debug.LogError(string.Format("[AgRoundHideSeek] Duplicate generatorId {0}, those generators will share one progress slot.", agGenerator.generatorId), agGenerator);
				}
				num2 |= num3;
			}
		}
	}
}
