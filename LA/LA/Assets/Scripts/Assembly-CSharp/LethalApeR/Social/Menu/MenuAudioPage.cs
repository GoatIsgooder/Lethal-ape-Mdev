using LethalApeR.Social.UI;
using TMPro;
using UnityEngine;

namespace LethalApeR.Social.Menu
{
	public sealed class MenuAudioPage : MonoBehaviour
	{
		[SerializeField]
		private VolumeRow[] volumes;

		[SerializeField]
		private GameObject micButtons;

		[SerializeField]
		private SocialButton micOn;

		[SerializeField]
		private SocialButton micOff;

		[SerializeField]
		private GameObject micNotice;

		[SerializeField]
		private TMP_Text micNoticeLabel;

		[SerializeField]
		private SocialButton snap;

		[SerializeField]
		private SocialButton smooth;

		[SerializeField]
		private SocialButton none;

		private float _nextPoll;

		private int _micState = -1;

		private void Awake()
		{
			micOn.Pressed += () => GameSettings.MicOn = true;
			micOff.Pressed += () => GameSettings.MicOn = false;
			snap.Pressed += () => GameSettings.Turn = TurnController.TurnMode.Snap;
			smooth.Pressed += () => GameSettings.Turn = TurnController.TurnMode.Smooth;
			none.Pressed += () => GameSettings.Turn = TurnController.TurnMode.None;
		}

		private void OnEnable()
		{
			GameSettings.Changed += Refresh;
			_micState = -1;
			Refresh();
		}

		private void OnDisable()
		{
			GameSettings.Changed -= Refresh;
		}

		private void Update()
		{
			if (!(Time.unscaledTime < _nextPoll))
			{
				_nextPoll = Time.unscaledTime + 1f;
				RefreshMic();
				RefreshTurn();
			}
		}

		private void Refresh()
		{
			for (int i = 0; i < volumes.Length; i++)
			{
				volumes[i].Refresh();
			}
			RefreshMic();
			RefreshTurn();
		}

		private void RefreshMic()
		{
			bool voiceInScene = VoiceEnforcer.VoiceInScene;
			bool flag = voiceInScene && GameSettings.MicPermitted;
			bool micOnValue = flag && GameSettings.MicOn;
			int num = (!voiceInScene) ? 0 : ((!flag) ? 1 : (micOnValue ? 2 : 3));
			if (num != _micState)
			{
				_micState = num;
				micButtons.SetActive(flag);
				micNotice.SetActive(!flag);
				if (flag)
				{
					micOn.SetLook(micOnValue ? ButtonLook.SegmentOn : ButtonLook.Segment);
					micOff.SetLook(micOnValue ? ButtonLook.Segment : ButtonLook.SegmentOn);
				}
				else
				{
					micNoticeLabel.text = (voiceInScene ? "PERMISSION OFF  <color=#8E8E96><size=80%>ALLOW IN QUEST SETTINGS</size></color>" : "NO VOICE CHAT IN THIS MODE");
				}
			}
		}

		private void RefreshTurn()
		{
			TurnController.TurnMode turn = GameSettings.Turn;
			snap.SetLook((turn == TurnController.TurnMode.Snap) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			smooth.SetLook((turn == TurnController.TurnMode.Smooth) ? ButtonLook.SegmentOn : ButtonLook.Segment);
			none.SetLook((turn == TurnController.TurnMode.None) ? ButtonLook.SegmentOn : ButtonLook.Segment);
		}
	}
}
