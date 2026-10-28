using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnPadConsole : MonoBehaviour
	{
		[Tooltip("The monitor picture the labels below are filmed into. Redrawn only when one of them changes.")]
		public FnOnDemandScreen screen;

		public TMP_Text title;

		public TMP_Text[] rowNames = new TMP_Text[3];

		public TMP_Text[] rowBadges = new TMP_Text[3];

		public Renderer[] rowLamps = new Renderer[3];

		public FnButton readyButton;

		[Tooltip("PUNCH IN / CLOCKED IN for a guard on this pad (tinted lampWaiting / lampReady), otherwise the step-up hint in its authored colour.")]
		public TMP_Text readyLabel;

		public FnButton nightDown;

		public FnButton nightUp;

		public TMP_Text nightLabel;

		[Tooltip("Toggles the pad between DEFAULT and NIGHTMARE. Its lamp is lit on Nightmare (set litColor to red).")]
		public FnButton difficultyButton;

		[Tooltip("DEFAULT or NIGHTMARE, plus a smaller second line when Nightmare is locked for someone on the pad: size it for two lines.")]
		public TMP_Text difficultyLabel;

		public TMP_Text status;

		public Color lampOff = new Color(0.12f, 0.12f, 0.12f, 1f);

		public Color lampReady = new Color(0.25f, 1f, 0.4f, 1f);

		public Color lampWaiting = new Color(0.9f, 0.6f, 0.15f, 1f);

		[Tooltip("Difficulty label tint while the pad is on Nightmare. Otherwise it keeps its authored colour.")]
		public Color nightmareColor = new Color(1f, 0.18f, 0.14f, 1f);

		[Tooltip("The local guard's own row name. Other rows keep their authored colour.")]
		public Color selfNameColor = new Color(0.92f, 1f, 0.93f, 1f);

		[Tooltip("Status line tint while it shows why the master refused a request.")]
		public Color refusalColor = new Color(1f, 0.3f, 0.24f, 1f);

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private const string SubLine = "\n<size=60%><alpha=#B3>";

		private static readonly string LockedText = "DEFAULT" + SubLine + "NIGHTMARE LOCKED";

		private FnHub _hub;

		private FnPad _pad;

		private MaterialPropertyBlock _mpb;

		private readonly string[] _shownNames = new string[3];

		private readonly string[] _shownBadges = new string[3];

		// RE: unsure - array initializer data blob not dumped; -1 sentinels assumed
		private readonly int[] _shownLamps = new int[3] { -1, -1, -1 };

		private string _shownStatus;

		private string _shownNight;

		private string _shownReady;

		private string _shownDifficulty;

		private Color _labelColor = Color.white;

		private Color _nameColor = Color.white;

		private Color _statusColor = Color.white;

		private Color _hintColor = Color.white;

		private int _selfRow = -2;

		private int _requirementNight = -1;

		private string _requirementText;

		private string _refusal;

		private float _refusalUntil;

		private static readonly string[] NightTexts = BuildNightTexts();

		private int _cachedStatusKey = int.MinValue;

		private string _cachedStatus;

		public void Bind(FnHub hub, FnPad pad)
		{
			_hub = hub;
			_pad = pad;
			if (title != null)
			{
				title.text = FnStrings.PadTitle(pad.size);
			}
			if (difficultyLabel != null)
			{
				difficultyLabel.richText = true;
				_labelColor = difficultyLabel.color;
			}
			if (rowNames.Length != 0 && rowNames[0] != null)
			{
				_nameColor = rowNames[0].color;
			}
			if (status != null)
			{
				_statusColor = status.color;
			}
			if (readyLabel != null)
			{
				_hintColor = readyLabel.color;
			}
			_selfRow = -2;
			Redraw();
		}

		private void Redraw()
		{
			if (screen != null)
			{
				screen.MarkDirty();
			}
		}

		private void OnEnable()
		{
			if (readyButton != null)
			{
				readyButton.Pressed += OnReady;
			}
			if (nightDown != null)
			{
				nightDown.Pressed += OnNightDown;
			}
			if (nightUp != null)
			{
				nightUp.Pressed += OnNightUp;
			}
			if (difficultyButton != null)
			{
				difficultyButton.Pressed += OnDifficulty;
			}
		}

		private void OnDisable()
		{
			if (readyButton != null)
			{
				readyButton.Pressed -= OnReady;
			}
			if (nightDown != null)
			{
				nightDown.Pressed -= OnNightDown;
			}
			if (nightUp != null)
			{
				nightUp.Pressed -= OnNightUp;
			}
			if (difficultyButton != null)
			{
				difficultyButton.Pressed -= OnDifficulty;
			}
		}

		public void ShowRefusal(FnRpc request, FnReject reason)
		{
			if (request == FnRpc.PadDifficulty && difficultyButton != null)
			{
				difficultyButton.FlashRefused();
			}
			ShowReason(reason);
		}

		private void ShowReason(FnReject reason)
		{
			_refusal = FnStrings.Reject(reason);
			_refusalUntil = Time.time + 1.5f;
		}

		private bool LocalSlot(out FnPadState state, out int slot)
		{
			state = ((_hub != null && _pad != null) ? _hub.Pad(_pad.Index) : default(FnPadState));
			slot = state.SlotOf(FnGame.LocalActor);
			if (_hub != null && slot >= 0)
			{
				return !state.Locked;
			}
			return false;
		}

		private void OnReady(bool _)
		{
			if (LocalSlot(out var state, out var slot))
			{
				_hub.RequestReady(_pad.Index, !state.Ready(slot));
			}
		}

		private void OnNightDown(bool _)
		{
			StepNight(-1);
		}

		private void OnNightUp(bool _)
		{
			StepNight(1);
		}

		private void StepNight(int step)
		{
			if (!LocalSlot(out var state, out var _))
			{
				return;
			}
			int num = state.Night + step;
			if (num >= 1 && num <= _hub.MaxNightFor(state))
			{
				_hub.RequestNight(_pad.Index, num);
			}
			else if (step > 0)
			{
				if (nightUp != null)
				{
					nightUp.FlashRefused();
				}
			}
			else if (step != 0 && nightDown != null)
			{
				nightDown.FlashRefused();
			}
		}

		private void OnDifficulty(bool _)
		{
			ToggleDifficulty();
		}

		private void ToggleDifficulty()
		{
			if (!LocalSlot(out var state, out var _))
			{
				return;
			}
			bool flag = state.Difficulty != FnDifficulty.Nightmare;
			if (!flag || _hub.NightmareOpen(state))
			{
				_hub.RequestDifficulty(_pad.Index, flag ? FnDifficulty.Nightmare : FnDifficulty.Default);
				return;
			}
			if (difficultyButton != null)
			{
				difficultyButton.FlashRefused();
			}
			ShowReason(FnReject.DifficultyLocked);
		}

		private void LateUpdate()
		{
			if (_hub == null || _pad == null)
			{
				return;
			}
			FnPadState state = _hub.Pad(_pad.Index);
			int size = _pad.size;
			for (int i = 0; i < 3; i++)
			{
				bool flag = true;
				string value;
				string text = "";
				if (i < size)
				{
					int num = state.Occupant(i);
					if (num != 0)
					{
						Player player = FnGame.PlayerOf(num);
						if (player != null)
						{
							value = (string.IsNullOrEmpty(player.NickName) ? "GUARD" : player.NickName);
							text = FnProps.PlayerString(player, FnProps.Build);
							flag = false;
						}
						else
						{
							flag = false;
							value = "- open -";
						}
					}
					else
					{
						value = "- open -";
					}
				}
				else
				{
					value = "";
				}
				string value2 = ((text == "LA") ? "LA" : ((text == "LAR") ? "LAR" : ""));
				SetText((i < rowNames.Length) ? rowNames[i] : null, ref _shownNames[i], value);
				SetText((i < rowBadges.Length) ? rowBadges[i] : null, ref _shownBadges[i], value2);
				bool flag2 = !flag && state.Ready(i);
				bool flag3 = !flag && !flag2;
				int num2 = (flag2 ? 2 : (flag3 ? 1 : 0));
				if (i < rowLamps.Length && _shownLamps[i] != num2)
				{
					_shownLamps[i] = num2;
					Tint(rowLamps[i], flag2 ? lampReady : (flag3 ? lampWaiting : lampOff));
				}
			}
			int num3 = state.SlotOf(FnGame.LocalActor);
			bool flag4 = num3 >= 0 && state.Ready(num3);
			ShowSelf((num3 < size) ? num3 : (-1));
			Color c;
			if (flag4)
			{
				SetText(readyLabel, ref _shownReady, "CLOCKED IN");
				c = lampReady;
			}
			else if (num3 < 0)
			{
				SetText(readyLabel, ref _shownReady, "STEP UP TO CLOCK IN");
				c = _hintColor;
			}
			else
			{
				SetText(readyLabel, ref _shownReady, "PUNCH IN");
				c = lampWaiting;
			}
			SetColor(readyLabel, c);
			if (readyButton != null)
			{
				readyButton.SetLit(flag4);
			}
			SetText(nightLabel, ref _shownNight, NightText((state.Count == 0) ? 1 : state.Night));
			ShowDifficulty(state, num3 >= 0);
			bool flag5 = Time.time < _refusalUntil && !string.IsNullOrEmpty(_refusal);
			SetText(status, ref _shownStatus, StatusText(state, size));
			SetColor(status, flag5 ? refusalColor : _statusColor);
		}

		private void ShowSelf(int row)
		{
			if (_selfRow != row)
			{
				_selfRow = row;
				for (int i = 0; i < rowNames.Length; i++)
				{
					SetColor(rowNames[i], (i == row) ? selfNameColor : _nameColor);
				}
			}
		}

		private static string[] BuildNightTexts()
		{
			string[] array = new string[16];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = string.Format("< NIGHT {0} >", i);
			}
			return array;
		}

		private static string NightText(int night)
		{
			return NightTexts[Mathf.Clamp(night, 0, NightTexts.Length - 1)];
		}

		private void ShowDifficulty(FnPadState state, bool localOnPad)
		{
			bool flag = state.Count != 0 && state.Difficulty == FnDifficulty.Nightmare;
			if (difficultyButton != null)
			{
				difficultyButton.SetLit(flag);
			}
			if (difficultyLabel == null)
			{
				return;
			}
			if (flag)
			{
				SetText(difficultyLabel, ref _shownDifficulty, "NIGHTMARE");
				SetColor(difficultyLabel, nightmareColor);
				return;
			}
			string value = ((state.Count == 0) ? "DEFAULT" : ((localOnPad && !FnProgress.NightmareUnlocked(PhotonNetwork.LocalPlayer)) ? RequirementText() : (_hub.NightmareOpen(state) ? "DEFAULT" : LockedText)));
			SetText(difficultyLabel, ref _shownDifficulty, value);
			SetColor(difficultyLabel, _labelColor);
		}

		private string RequirementText()
		{
			int maxNight = FnGame.Settings.hub.maxNight;
			if (maxNight != _requirementNight)
			{
				_requirementNight = maxNight;
				_requirementText = "DEFAULT" + SubLine + string.Format("NIGHTMARE: SURVIVE NIGHT {0}", maxNight);
			}
			return _requirementText;
		}

		private string StatusText(FnPadState state, int size)
		{
			if (Time.time < _refusalUntil && !string.IsNullOrEmpty(_refusal))
			{
				return _refusal;
			}
			if (state.Locked)
			{
				return "HEADING IN...";
			}
			int num = ((state.Deadline != 0) ? (1000 + Mathf.Max(0, Mathf.CeilToInt((float)FnClock.MsUntil(state.Deadline) / 1000f))) : ((state.Count >= size) ? (2000 + state.ReadyCount * 10 + size) : (3000 + state.Count * 10 + size)));
			if (num != _cachedStatusKey)
			{
				_cachedStatusKey = num;
				if (num < 2000)
				{
					_cachedStatus = string.Format("STARTING {0}", num - 1000);
				}
				else if (num < 3000)
				{
					_cachedStatus = string.Format("READY {0}/{1}", state.ReadyCount, size);
				}
				else
				{
					_cachedStatus = string.Format("WAITING {0}/{1}", state.Count, size);
				}
			}
			return _cachedStatus;
		}

		private void SetText(TMP_Text t, ref string shown, string value)
		{
			if (!(t == null) && !string.Equals(shown, value))
			{
				shown = value;
				t.text = value;
				Redraw();
			}
		}

		private void SetColor(TMP_Text t, Color c)
		{
			if (!(t == null) && !(t.color == c))
			{
				t.color = c;
				Redraw();
			}
		}

		private void Tint(Renderer r, Color c)
		{
			if (!(r == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				r.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, c);
				_mpb.SetColor(BaseColorId, c);
				_mpb.SetColor(EmissionId, c);
				r.SetPropertyBlock(_mpb);
				Redraw();
			}
		}
	}
}
