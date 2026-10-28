using System;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DefaultExecutionOrder(110)]
	public class FnMonitor : MonoBehaviour
	{
		[Serializable]
		public struct Channel
		{
			[Tooltip("Camera index this button selects (the contract camera table).")]
			public int station;

			public FnButton button;

			[Tooltip("Optional. Filled with the station's short id (its label up to the first space) and tinted while selected.")]
			public TMP_Text label;
		}

		[Tooltip("Defaults to FnCameraSystem.Instance.")]
		public FnCameraSystem system;

		[Header("Screen")]
		[Tooltip("The glass. Its material uses Fnaf/Static; the feed, static and scramble go in through a MaterialPropertyBlock.")]
		public Renderer screen;

		[Tooltip("Material slot of the glass on that renderer.")]
		public int screenMaterialIndex;

		[Tooltip("Width over height of the glass. 0 stretches the feed over all of it; above 0 the feed keeps its own aspect, letterboxed (or pillarboxed) on the glass.")]
		public float glassAspect;

		[Tooltip("Optional on-screen display laid over the feed (the glass material's _OsdTex). The labels below then live on it, and it is redrawn only when one changes. It shows while the tube is on: never in standby or with the power out.")]
		public FnOnDemandScreen osd;

		[Tooltip("Station name, e.g. 1A STAGE (a corner of the glass).")]
		public TMP_Text stationLabel;

		[Tooltip("NO SIGNAL, AUDIO ONLY or CAMERA OFFLINE (the centre). Optional: without it the station label shows these.")]
		public TMP_Text statusLabel;

		[Header("Camera map")]
		public Channel[] channels = new Channel[0];

		public Color channelIdle = new Color(0.45f, 0.55f, 0.47f, 1f);

		public Color channelSelected = new Color(0.8f, 1f, 0.82f, 1f);

		[Header("Lure")]
		public FnButton lureButton;

		public TMP_Text lureLabel;

		[Tooltip("How long a refusal reason stays on the lure label (s).")]
		public float lureMessageSeconds = 1.5f;

		private static readonly int MainTexId = Shader.PropertyToID("_MainTex");

		private static readonly int StaticId = Shader.PropertyToID("_Static");

		private static readonly int ScrambleId = Shader.PropertyToID("_Scramble");

		private static readonly int PictureRectId = Shader.PropertyToID("_PictureRect");

		private static readonly int OsdId = Shader.PropertyToID("_Osd");

		private readonly string[] _cooldownText = new string[100];

		private Action<bool>[] _handlers = Array.Empty<Action<bool>>();

		private bool[] _channelNamed = Array.Empty<bool>();

		private MaterialPropertyBlock _mpb;

		private Texture _shownTex;

		private float _shownStatic = -1f;

		private float _shownScramble = -1f;

		private string _stationShown;

		private string _statusShown;

		private string _lureShown;

		private float _shownOsd = -1f;

		private float _rectAspect = -1f;

		private Vector4 _pictureRect = new Vector4(0f, 0f, 1f, 1f);

		private int _tinted = int.MinValue;

		private int _interactable = -1;

		private string _lureMessage;

		private float _lureMessageUntil;

		private float _lureLockUntil;

		private FnNight _night;

		private FnCameraSystem Cctv => (system != null) ? system : FnCameraSystem.Instance;

		private void OnEnable()
		{
			_handlers = new Action<bool>[channels.Length];
			_channelNamed = new bool[channels.Length];
			for (int i = 0; i < channels.Length; i++)
			{
				if (!(channels[i].button == null))
				{
					int station = channels[i].station;
					_handlers[i] = delegate
					{
						PressChannel(station);
					};
					channels[i].button.Pressed += _handlers[i];
				}
			}
			if (lureButton != null)
			{
				lureButton.Pressed += PressLure;
			}
			_shownTex = null;
			_shownStatic = -1f;
			_shownScramble = -1f;
			_shownOsd = -1f;
			_rectAspect = -1f;
			_stationShown = null;
			_statusShown = null;
			_lureShown = null;
			_tinted = int.MinValue;
			_interactable = -1;
			_lureMessageUntil = 0f;
		}

		private void OnDisable()
		{
			for (int i = 0; i < channels.Length && i < _handlers.Length; i++)
			{
				if (channels[i].button != null && _handlers[i] != null)
				{
					channels[i].button.Pressed -= _handlers[i];
				}
			}
			if (lureButton != null)
			{
				lureButton.Pressed -= PressLure;
			}
			Listen(null);
		}

		private void OnValidate()
		{
			lureMessageSeconds = Mathf.Max(0f, lureMessageSeconds);
			glassAspect = Mathf.Max(0f, glassAspect);
			_rectAspect = -1f;
			screenMaterialIndex = Mathf.Clamp(screenMaterialIndex, 0, Mathf.Max(0, (screen != null) ? (screen.sharedMaterials.Length - 1) : 0));
		}

		private void Listen(FnNight night)
		{
			if ((object)_night != night)
			{
				if ((object)_night != null)
				{
					_night.Rejected -= OnRejected;
					_night.LurePlayed -= OnLurePlayed;
				}
				_night = night;
				if ((object)night != null)
				{
					night.Rejected += OnRejected;
					night.LurePlayed += OnLurePlayed;
				}
			}
		}

		private void LateUpdate()
		{
			FnCameraSystem cctv = Cctv;
			FnNight instance = FnNight.Instance;
			Listen(instance);
			bool alive = instance != null && instance.LocalIsAlive;
			SetInteractable(alive);
			FnCameraSystem.FeedMode mode = ((cctv != null) ? cctv.Mode : FnCameraSystem.FeedMode.Standby);
			if (cctv != null)
			{
				cctv.ReportScreen(screen);
			}
			ApplyScreen(cctv, mode);
			ApplyLabels(cctv, mode);
			ApplyChannels(cctv);
			ApplyLure(cctv, instance, alive, mode);
		}

		private void ApplyScreen(FnCameraSystem cctv, FnCameraSystem.FeedMode mode)
		{
			if (!(screen == null))
			{
				Texture texture = ((mode == FnCameraSystem.FeedMode.Live && cctv.Feed != null) ? ((Texture)cctv.Feed) : ((Texture)Texture2D.blackTexture));
				float num = ((cctv != null) ? cctv.StaticAmount : 0f);
				float num2 = ((cctv != null) ? cctv.ScrambleAmount : 0f);
				float num3 = ((osd != null && mode != FnCameraSystem.FeedMode.Standby && mode != FnCameraSystem.FeedMode.PowerOut) ? 1f : 0f);
				bool flag = UpdatePictureRect();
				if (!(texture == _shownTex) || num != _shownStatic || num2 != _shownScramble || num3 != _shownOsd || flag)
				{
					_shownTex = texture;
					_shownStatic = num;
					_shownScramble = num2;
					_shownOsd = num3;
					if (_mpb == null)
					{
						_mpb = new MaterialPropertyBlock();
					}
					screen.GetPropertyBlock(_mpb, screenMaterialIndex);
					_mpb.SetVector(PictureRectId, _pictureRect);
					_mpb.SetFloat(OsdId, num3);
					_mpb.SetTexture(MainTexId, texture);
					_mpb.SetFloat(StaticId, num);
					_mpb.SetFloat(ScrambleId, num2);
					screen.SetPropertyBlock(_mpb, screenMaterialIndex);
				}
			}
		}

		private bool UpdatePictureRect()
		{
			float num = ((glassAspect > 0f) ? FnCameraSystem.FeedAspect : 0f);
			float rectAspect = _rectAspect;
			if (num != rectAspect)
			{
				_rectAspect = num;
				_pictureRect = PictureRect(glassAspect, num);
			}
			return num != rectAspect;
		}

		public static Vector4 PictureRect(float glassAspect, float feedAspect)
		{
			if (glassAspect <= 0f || feedAspect <= 0f)
			{
				return new Vector4(0f, 0f, 1f, 1f);
			}
			if (feedAspect < glassAspect)
			{
				float num = feedAspect / glassAspect;
				return new Vector4((1f - num) * 0.5f, 0f, num, 1f);
			}
			float num2 = glassAspect / feedAspect;
			return new Vector4(0f, (1f - num2) * 0.5f, 1f, num2);
		}

		private void ApplyLabels(FnCameraSystem cctv, FnCameraSystem.FeedMode mode)
		{
			string text = "";
			string text2;
			switch (mode)
			{
			case FnCameraSystem.FeedMode.Off:
				text2 = "CAMERA OFFLINE";
				break;
			case FnCameraSystem.FeedMode.Live:
				text = StationName(cctv.ShownStation);
				text2 = "";
				break;
			case FnCameraSystem.FeedMode.AudioOnly:
				text = StationName(cctv.ShownStation);
				text2 = "AUDIO ONLY";
				break;
			case FnCameraSystem.FeedMode.NoSignal:
				text = StationName(cctv.ShownStation);
				text2 = "NO SIGNAL";
				break;
			default:
				text2 = "";
				break;
			}
			if (statusLabel == null && text2.Length > 0)
			{
				text = text2;
			}
			bool flag = SetText(stationLabel, ref _stationShown, text);
			bool flag2 = SetText(statusLabel, ref _statusShown, text2);
			if ((flag || flag2) && osd != null)
			{
				osd.MarkDirty();
			}
		}

		private static string StationName(int index)
		{
			if (!FnStations.TryGet(index, out var station) || station.Label == null)
			{
				return "";
			}
			return station.Label;
		}

		private static bool SetText(TMP_Text label, ref string shown, string text)
		{
			if (label == null || string.Equals(shown, text))
			{
				return false;
			}
			shown = text;
			label.text = text;
			return true;
		}

		private void ApplyChannels(FnCameraSystem cctv)
		{
			int num = ((cctv != null) ? cctv.Selected : (-1));
			for (int i = 0; i < channels.Length; i++)
			{
				Channel channel = channels[i];
				if (channel.button != null)
				{
					channel.button.SetLit(num >= 0 && num == channel.station);
				}
				if (!(channel.label == null) && i < _channelNamed.Length && !_channelNamed[i])
				{
					FnCameraStation fnCameraStation = FnCameraStation.At(channel.station);
					if (!(fnCameraStation == null))
					{
						channel.label.text = fnCameraStation.ShortId;
						_channelNamed[i] = true;
					}
				}
			}
			if (num == _tinted)
			{
				return;
			}
			_tinted = num;
			for (int j = 0; j < channels.Length; j++)
			{
				if (channels[j].label != null)
				{
					channels[j].label.color = ((num >= 0 && channels[j].station == num) ? channelSelected : channelIdle);
				}
			}
		}

		private void SetInteractable(bool alive)
		{
			if (_interactable == (alive ? 1 : 0))
			{
				return;
			}
			_interactable = (alive ? 1 : 0);
			for (int i = 0; i < channels.Length; i++)
			{
				if (channels[i].button != null)
				{
					channels[i].button.interactable = alive;
				}
			}
			if (lureButton != null)
			{
				lureButton.interactable = alive;
			}
		}

		private void PressChannel(int station)
		{
			FnNight instance = FnNight.Instance;
			FnCameraSystem cctv = Cctv;
			if (!(cctv == null) && !(instance == null) && instance.LocalIsAlive)
			{
				cctv.Select((cctv.Selected == station) ? (-1) : station);
			}
		}

		private void ApplyLure(FnCameraSystem cctv, FnNight night, bool alive, FnCameraSystem.FeedMode mode)
		{
			float num = ((night != null && night.Active) ? night.LureCooldownLeft : 0f);
			string text = ((Time.time < _lureMessageUntil) ? _lureMessage : ((!(num > 0f)) ? "LURE" : CooldownText(Mathf.CeilToInt(num))));
			SetText(lureLabel, ref _lureShown, text);
			if (!(lureButton == null))
			{
				bool lit = mode == FnCameraSystem.FeedMode.Live && alive && cctv.Watching && night.Phase == FnPhase.Night && !(num > 0f) && night.Power >= FnGame.Settings.cameras.lureCost;
				lureButton.SetLit(lit);
			}
		}

		private string CooldownText(int seconds)
		{
			int num = Mathf.Clamp(seconds, 0, _cooldownText.Length - 1);
			string text = _cooldownText[num];
			if (text == null)
			{
				text = (_cooldownText[num] = string.Format("LURE {0}s", num));
			}
			return text;
		}

		private void PressLure(bool isLeft)
		{
			FnNight instance = FnNight.Instance;
			FnCameraSystem cctv = Cctv;
			if (cctv == null || instance == null || !instance.LocalIsAlive)
			{
				return;
			}
			if (instance.Phase != FnPhase.Night)
			{
				Refuse(FnReject.WrongPhase);
			}
			else if (instance.Blackout)
			{
				Refuse(FnReject.Blackout);
			}
			else if (!cctv.AtDesk || cctv.Mode != FnCameraSystem.FeedMode.Live)
			{
				Refuse(FnReject.Invalid);
			}
			else if (instance.LureCooldownLeft > 0f)
			{
				lureButton.FlashRefused();
			}
			else if (!(Time.time < _lureLockUntil))
			{
				_lureLockUntil = Time.time + 1f;
				instance.RequestLure(cctv.Selected);
			}
		}

		private void Refuse(FnReject reason)
		{
			if (lureButton != null)
			{
				lureButton.FlashRefused();
			}
			_lureMessage = FnStrings.Reject(reason);
			_lureMessageUntil = Time.time + lureMessageSeconds;
		}

		private void OnRejected(FnRpc request, FnReject reason, int subject)
		{
			if (request == FnRpc.Lure)
			{
				_lureLockUntil = 0f;
				Refuse(reason);
			}
		}

		private void OnLurePlayed(int cam)
		{
			_lureLockUntil = 0f;
			FnAudioBank audio = FnGame.Audio;
			if (!(audio == null) && !(audio.lureLaugh == null) && FnStations.TryGet(cam, out var station))
			{
				Vector3 position = station.Pose.position;
				FnAudio.Play(audio.lureLaugh, position, 1f, 1f, Mathf.Max(4f, FnGame.Settings.noise.lureRadius), 1f);
				FnCameraSystem.RelayToMonitor(audio.lureLaugh, position, 1f);
			}
		}
	}
}
