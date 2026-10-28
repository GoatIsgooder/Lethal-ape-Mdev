using System;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnPartyKeypad : MonoBehaviour
	{
		[Tooltip("Digits 0-9, index = digit.")]
		public FnButton[] digits = new FnButton[10];

		public FnButton clearButton;

		[Tooltip("Optional backspace: removes the last digit (a single mis-press shouldn't clear the whole code).")]
		public FnButton deleteButton;

		public FnButton newButton;

		public FnButton joinButton;

		public FnButton publicButton;

		public TMP_Text display;

		public TMP_Text statusLabel;

		private readonly Action<bool>[] _digitHandlers = new Action<bool>[10];

		private readonly char[] _entry = new char[5];

		private int _length;

		private string _shownDisplay;

		private string _shownStatus;

		private int _shownLength = -1;

		private int _shownStatusKey = -1;

		private string _shownRoom;

		private static bool Busy
		{
			get
			{
				if (!(FnMatchmaker.Instance == null))
				{
					return FnMatchmaker.Instance.Busy;
				}
				return true;
			}
		}

		private void OnEnable()
		{
			for (int i = 0; i < 10 && i < digits.Length; i++)
			{
				if (!(digits[i] == null))
				{
					int digit = i;
					_digitHandlers[i] = delegate
					{
						Type(digit);
					};
					digits[i].Pressed += _digitHandlers[i];
				}
			}
			if (clearButton != null)
			{
				clearButton.Pressed += OnClear;
			}
			if (deleteButton != null)
			{
				deleteButton.Pressed += OnDelete;
			}
			if (newButton != null)
			{
				newButton.Pressed += OnNew;
			}
			if (joinButton != null)
			{
				joinButton.Pressed += OnJoin;
			}
			if (publicButton != null)
			{
				publicButton.Pressed += OnPublic;
			}
		}

		private void OnDisable()
		{
			for (int i = 0; i < 10 && i < digits.Length; i++)
			{
				if (digits[i] != null && _digitHandlers[i] != null)
				{
					digits[i].Pressed -= _digitHandlers[i];
				}
			}
			if (clearButton != null)
			{
				clearButton.Pressed -= OnClear;
			}
			if (deleteButton != null)
			{
				deleteButton.Pressed -= OnDelete;
			}
			if (newButton != null)
			{
				newButton.Pressed -= OnNew;
			}
			if (joinButton != null)
			{
				joinButton.Pressed -= OnJoin;
			}
			if (publicButton != null)
			{
				publicButton.Pressed -= OnPublic;
			}
		}

		private void Type(int digit)
		{
			if (!Busy && _length < _entry.Length)
			{
				_entry[_length++] = (char)(48 + digit);
				Beep();
			}
		}

		private void OnClear(bool _)
		{
			_length = 0;
			Beep();
		}

		private void OnDelete(bool _)
		{
			if (!Busy && _length != 0)
			{
				_length--;
				Beep();
			}
		}

		private void OnNew(bool _)
		{
			if (!Busy)
			{
				string code = UnityEngine.Random.Range(0, 100000).ToString("D5");
				_length = 0;
				Beep();
				FnMatchmaker.Instance.JoinParty(code);
			}
		}

		private void OnJoin(bool _)
		{
			if (!Busy)
			{
				if (_length < _entry.Length)
				{
					Error(joinButton);
					return;
				}
				string code = new string(_entry, 0, _length);
				_length = 0;
				Beep();
				FnMatchmaker.Instance.JoinParty(code);
			}
		}

		private void OnPublic(bool _)
		{
			if (!Busy)
			{
				if (!FnMatchmaker.InParty)
				{
					Error(publicButton);
					return;
				}
				Beep();
				FnMatchmaker.Instance.JoinPublicHub();
			}
		}

		private void Beep()
		{
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FnAudio.Play(audio.keypadBeep, transform.position, 0.6f, 1f, 6f, 1f);
			}
		}

		private void Error(FnButton b)
		{
			if (b != null)
			{
				b.FlashRefused();
			}
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FnAudio.Play(audio.keypadError, transform.position, 0.7f, 1f, 6f, 1f);
			}
		}

		private void LateUpdate()
		{
			if (display != null && _length != _shownLength)
			{
				_shownLength = _length;
				char[] array = new char[_entry.Length];
				for (int i = 0; i < array.Length; i++)
				{
					array[i] = ((i < _length) ? _entry[i] : '_');
				}
				_shownDisplay = new string(array);
				display.text = _shownDisplay;
			}
			if (statusLabel == null)
			{
				return;
			}
			bool flag = FnMatchmaker.Instance != null && FnMatchmaker.Instance.Busy;
			bool inParty = FnMatchmaker.InParty;
			int num = (flag ? 1 : (inParty ? 2 : 3));
			string text = ((PhotonNetwork.CurrentRoom != null) ? PhotonNetwork.CurrentRoom.Name : null);
			if (num != _shownStatusKey || (!flag && inParty && (object)text != _shownRoom))
			{
				_shownRoom = text;
				_shownStatusKey = num;
				_shownStatus = (flag ? "JOINING..." : (inParty ? string.Format("PARTY {0}", FnMatchmaker.PartyCode) : "PUBLIC HUB"));
				statusLabel.text = _shownStatus;
			}
		}
	}
}
