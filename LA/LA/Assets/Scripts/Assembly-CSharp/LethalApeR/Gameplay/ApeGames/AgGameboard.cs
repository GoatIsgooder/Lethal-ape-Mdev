using System;
using System.Reflection;
using System.Text;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgGameboard : MonoBehaviourPunCallbacks
	{
		public TMP_Text boardText;

		private const float RebuildInterval = 0.5f;

		private const string JoinText = "<b><size=120%>APE <color=#E53935>GAMES</color></size></b>\n\n<color=#FFD54F><b>JOIN AN APE GAMES ROOM</b></color>\n\n<alpha=#AA>Cannot start right now";

		private readonly StringBuilder _sb = new StringBuilder(256);

		private float _nextRebuild;

		private bool _dirty;

		private bool _hooked;

		private void Start()
		{
			Hook();
			if ((bool)boardText)
			{
				boardText.text = JoinText;
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			Hook();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			Unhook();
		}

		private void Hook()
		{
			if (!_hooked && !(ApeGamesManager.Instance == null))
			{
				_hooked = true;
				ApeGamesManager.Instance.OnPropsChanged += OnManagerPropsChanged;
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				if (ApeGamesManager.Instance != null)
				{
					ApeGamesManager.Instance.OnPropsChanged -= OnManagerPropsChanged;
				}
			}
		}

		private void OnManagerPropsChanged(AgRoundProperties p)
		{
			_dirty = true;
		}

		public override void OnJoinedRoom()
		{
			_dirty = true;
		}

		public override void OnLeftRoom()
		{
			_dirty = false;
			if ((bool)boardText)
			{
				boardText.text = JoinText;
			}
		}

		public override void OnPlayerEnteredRoom(Player newPlayer)
		{
			_dirty = true;
		}

		public override void OnPlayerLeftRoom(Player otherPlayer)
		{
			_dirty = true;
		}

		private void Update()
		{
			if (!_hooked)
			{
				Hook();
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null || !PhotonNetwork.InRoom)
			{
				return;
			}
			AgRoundProperties props = instance.Props;
			if (props != null && props.queue == ApeGamesManager.GameQueue && (_dirty || !(Time.unscaledTime < _nextRebuild)))
			{
				_dirty = false;
				_nextRebuild = Time.unscaledTime + RebuildInterval;
				Rebuild(instance, props);
			}
		}

		private void Rebuild(ApeGamesManager mgr, AgRoundProperties p)
		{
			if (!boardText)
			{
				return;
			}
			_sb.Length = 0;
			_sb.Append("<b><size=120%>APE <color=#E53935>GAMES</color></size></b>\n\n");
			switch (p.phase)
			{
			case AgPhase.Idle:
			case AgPhase.LobbyWait:
				_sb.Append("<color=#FFD54F><b>WAITING FOR APES</b></color>\n");
				_sb.Append(PhotonNetwork.CurrentRoom.PlayerCount).Append('/').Append((mgr.settings != null) ? mgr.settings.minPlayers : 2);
				break;
			case AgPhase.Round:
				_sb.Append("<color=#FFD54F><b>ROUND ").Append(mgr.RoundDisplayNumber(p.round)).Append('/')
					.Append(mgr.EnabledRoundCount)
					.Append("</b></color>\n")
					.Append(AgRoleCard.GetRoundName(p.round));
				break;
			case AgPhase.Intermission:
				_sb.Append("<color=#FFD54F><b>INTERMISSION</b></color>\n<alpha=#AA>next: ");
				_sb.Append(AgRoleCard.GetRoundName(mgr.ResolveStartingRound(p.round)));
				break;
			case AgPhase.MatchEnd:
				_sb.Append("<color=#FFD54F><b>THE APE GAMES HAVE A WINNER</b></color>");
				break;
			}
			_sb.Append("\n\n");
			if (p.phase != AgPhase.Idle)
			{
				_sb.Append("<b>Time</b>\n");
				if (p.phase == AgPhase.Round && !(p.endTime > 0.0))
				{
					_sb.Append("<color=#FFB300>LAST APE STANDING</color>");
				}
				else
				{
					int num = (int)Math.Max(0.0, p.endTime - PhotonNetwork.Time);
					_sb.Append("<color=#FFB300>");
					if (num < 600)
					{
						_sb.Append('0');
					}
					_sb.Append(num / 60).Append(':');
					int num2 = num % 60;
					if (num2 < 10)
					{
						_sb.Append('0');
					}
					_sb.Append(num2).Append("</color>");
				}
				_sb.Append("\n\n");
			}
			int num3 = ((p.alive != null) ? p.alive.Length : 0);
			int num4 = num3 + ((p.eliminated != null) ? p.eliminated.Length : 0);
			if (num4 > 0)
			{
				_sb.Append("<b>Apes</b>\n").Append(num3).Append('/')
					.Append(num4)
					.Append("\n\n");
			}
			if (p.phase == AgPhase.Round && p.round == 3)
			{
				if (mgr.TryGetGeneratorProgress(out var powered, out var total))
				{
					_sb.Append("<b>Generators</b>\n<color=#7CFC8E>").Append(powered).Append("</color>/")
						.Append(total)
						.Append("\n\n");
				}
				_sb.Append("<b>Catches</b>\n").Append(p.catchCount);
			}
			boardText.SetText(_sb);
		}
	}
}
