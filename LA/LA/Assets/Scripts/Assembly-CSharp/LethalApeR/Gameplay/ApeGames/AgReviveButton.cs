using System.Collections;
using System.Reflection;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgReviveButton : BaseButton
	{
		private const string LabelNote = "1 REVIVE PER MATCH";

		private const string LabelReady = "READY";

		private const string LabelUsed = "USED";

		private const string LabelArmed = "NEXT ROUND";

		private const string LabelTooLate = "TOO LATE";

		private const float PressPaceSeconds = 1f;

		public TMP_Text stateLabel;

		private bool _hooked;

		private bool _entitlementsHooked;

		private float _nextPressTime;

		private string _appliedLabel;

		private void Start()
		{
			if (!_entitlementsHooked)
			{
				_entitlementsHooked = true;
				AgEntitlements.OnEntitlementsChanged += OnEntitlementsChanged;
			}
			TryHook();
			if (!_hooked)
			{
				InvokeRepeating("TryHook", 1f, 1f);
			}
			Refresh();
		}

		private void OnDestroy()
		{
			CancelInvoke("TryHook");
			if (_entitlementsHooked)
			{
				_entitlementsHooked = false;
				AgEntitlements.OnEntitlementsChanged -= OnEntitlementsChanged;
			}
			if (_hooked && ApeGamesManager.Instance != null)
			{
				ApeGamesManager instance = ApeGamesManager.Instance;
				instance.OnPropsChanged -= OnPropsChanged;
				instance.OnLocalEliminated -= OnStateDirty;
				instance.OnRoundStartedEvent -= OnRoundEdge;
				instance.OnRoundEndedEvent -= OnRoundEdge;
				instance.OnMatchEnded -= OnMatchEndedEvent;
			}
		}

		private void TryHook()
		{
			if (!_hooked && !(ApeGamesManager.Instance == null))
			{
				ApeGamesManager instance = ApeGamesManager.Instance;
				instance.OnPropsChanged += OnPropsChanged;
				instance.OnLocalEliminated += OnStateDirty;
				instance.OnRoundStartedEvent += OnRoundEdge;
				instance.OnRoundEndedEvent += OnRoundEdge;
				instance.OnMatchEnded += OnMatchEndedEvent;
				_hooked = true;
				CancelInvoke("TryHook");
				Refresh();
			}
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			Refresh();
		}

		private void OnRoundEdge(int round, AgRoundProperties p)
		{
			Refresh();
		}

		private void OnMatchEndedEvent(int[] winners)
		{
			Refresh();
		}

		private void OnStateDirty()
		{
			Refresh();
		}

		private void OnEntitlementsChanged()
		{
			TryHook();
			Refresh();
			if (!_hooked && base.isActiveAndEnabled)
			{
				CancelInvoke("TryHook");
				InvokeRepeating("TryHook", 1f, 1f);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (Time.unscaledTime < _nextPressTime)
			{
				return;
			}
			if (!Eligible(out var _))
			{
				Refresh();
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (!(instance == null))
			{
				_nextPressTime = Time.unscaledTime + PressPaceSeconds;
				instance.RequestRevive();
				if (base.isActiveAndEnabled)
				{
					StartCoroutine(AcceptedCue());
				}
			}
		}

		private IEnumerator AcceptedCue()
		{
			yield return null;
			AgHaptics.Both(0.9f, 0.2f);
		}

		private void Refresh()
		{
			Eligible(out var label);
			if (stateLabel != null && (object)_appliedLabel != label)
			{
				_appliedLabel = label;
				stateLabel.text = label;
			}
			bool ownsRevive = AgEntitlements.OwnsRevive;
			if (base.gameObject.activeSelf != ownsRevive)
			{
				base.gameObject.SetActive(ownsRevive);
			}
		}

		private bool Eligible(out string label)
		{
			label = LabelNote;
			if (!AgEntitlements.OwnsRevive)
			{
				return false;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null)
			{
				return false;
			}
			AgRoundProperties props = instance.Props;
			if (props == null || props.queue != "ApeGames")
			{
				return false;
			}
			if (!PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
			{
				return false;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (actorNumber < 1)
			{
				return false;
			}
			if (props.phase != AgPhase.Round && props.phase != AgPhase.Intermission && props.phase != AgPhase.MatchEnd)
			{
				return false;
			}
			if (Contains(props.reviveQueue, actorNumber))
			{
				label = LabelArmed;
				return false;
			}
			if (Contains(props.revivesUsed, actorNumber))
			{
				label = LabelUsed;
				return false;
			}
			if (props.phase != AgPhase.Round && props.phase != AgPhase.Intermission)
			{
				return false;
			}
			if (!Contains(props.eliminated, actorNumber))
			{
				return false;
			}
			bool num = instance.ReviveRejoinRound() >= 0;
			label = (num ? LabelReady : LabelTooLate);
			return num;
		}

		private static bool Contains(int[] arr, int value)
		{
			if (arr == null)
			{
				return false;
			}
			for (int i = 0; i < arr.Length; i++)
			{
				if (arr[i] == value)
				{
					return true;
				}
			}
			return false;
		}
	}
}
