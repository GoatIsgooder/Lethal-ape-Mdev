using ImGuiNET;
using UnityEngine;

namespace UImGui
{
	public class ShowDemoWindow : MonoBehaviour
	{
		[Header("Audio")]
		[SerializeField]
		private AudioClip buttonClickClip;

		[SerializeField]
		private AudioClip hoverClip;

		[SerializeField]
		private AudioSource audioSource;

		private const int FPS_HISTORY_SIZE = 128;

		private float[] _fpsHistory;

		private int _fpsHistoryIdx;

		private static readonly string[] TabNames = { "Movement", "Local", "Players", "Moderation", "Debugging" };

		private int _activeTab;

		private uint _currentHoveredId;

		private uint _previousHoveredId;

		private bool _joyStickFly;

		private bool _speedBoost;

		private float _customSpeed;

		private float _customJump;

		private float _customSize;

		private void OnEnable()
		{
			if (audioSource == null)
			{
				audioSource = GetComponent<AudioSource>();
			}

			if (audioSource == null)
			{
				audioSource = gameObject.AddComponent<AudioSource>();
			}

			_fpsHistory = new float[FPS_HISTORY_SIZE];

			UImGuiUtility.Layout += OnLayout;
		}

		private void OnDisable()
		{
			UImGuiUtility.Layout -= OnLayout;
		}

		private void OnLayout(UImGui uImGui)
		{
			_currentHoveredId = 0;

			PushStyle();

			ImGuiIOPtr io = ImGui.GetIO();
			ImGui.SetNextWindowPos(io.DisplaySize * 0.5f, ImGuiCond.Once, new Vector2(0.5f, 0.5f));
			ImGui.SetNextWindowSize(new Vector2(720f, 520f), ImGuiCond.Once);
			ImGui.SetNextWindowSizeConstraints(new Vector2(520f, 380f), new Vector2(1920f, 1080f));

			ImGui.Begin("LAR Menu", ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoScrollWithMouse);

			DrawFpsHeader();
			ImGui.Spacing();
			ImGui.Separator();
			ImGui.Spacing();

			DrawTabBar();
			ImGui.Spacing();

			ImGui.BeginChild("##page", ImGui.GetContentRegionAvail(), ImGuiChildFlags.None, ImGuiWindowFlags.NoScrollbar);
			DrawTabPage(_activeTab);
			ImGui.EndChild();

			ImGui.End();

			HandleHoverAudio();

			PopStyle();
		}

		private void DrawFpsHeader()
		{
			float dt = Time.unscaledDeltaTime;
			float fps = 1f / Mathf.Max(dt, 0.0001f);

			_fpsHistory[_fpsHistoryIdx] = fps;
			_fpsHistoryIdx = (_fpsHistoryIdx + 1) % FPS_HISTORY_SIZE;

			ImGui.Text(string.Format("LAR - Editor  |  {0:0} fps", fps));

			if (ImGui.IsItemHovered())
			{
				ImGui.BeginTooltip();
				ImGui.Text(string.Format("{0:0.0} fps  /  {1:0.00} ms", fps, dt * 1000f));
				ImGui.Spacing();
				ImGui.PlotLines("##fpsplot", ref _fpsHistory[0], FPS_HISTORY_SIZE, _fpsHistoryIdx, null, 0f, 200f, new Vector2(260f, 60f));
				ImGui.EndTooltip();
			}
		}

		private void DrawTabBar()
		{
			float spacing = ImGui.GetStyle().ItemSpacing.x;
			float framePadding = ImGui.GetStyle().FramePadding.x;
			float avail = ImGui.GetContentRegionAvail().x;
			float lineWidth = 0f;

			for (int i = 0; i < TabNames.Length; i++)
			{
				float width = ImGui.CalcTextSize(TabNames[i]).x + framePadding * 2f;

				if (i > 0)
				{
					float next = lineWidth + spacing;
					if (next + width <= avail)
					{
						ImGui.SameLine();
						lineWidth = next;
					}
					else
					{
						lineWidth = 0f;
					}
				}

				bool selected = i == _activeTab;
				ImGui.PushStyleColor(ImGuiCol.Button, selected ? new Vector4(0.32f, 0.32f, 0.36f, 1f) : new Vector4(0.18f, 0.18f, 0.2f, 1f));
				ImGui.PushStyleColor(ImGuiCol.ButtonHovered, selected ? new Vector4(0.32f, 0.32f, 0.36f, 1f) : new Vector4(0.26f, 0.26f, 0.3f, 1f));
				ImGui.PushStyleColor(ImGuiCol.ButtonActive, new Vector4(0.32f, 0.32f, 0.36f, 1f));

				if (Btn(TabNames[i], new Vector2(0f, 24f)))
				{
					_activeTab = i;
				}

				ImGui.PopStyleColor(3);

				lineWidth += width;
			}
		}

		private void DrawTabPage(int tab)
		{
			switch (tab)
			{
				case 0:
					DrawPage_Movement();
					break;
				case 1:
					DrawPage_Local();
					break;
				case 2:
					DrawPage_Players();
					break;
				case 3:
					DrawPage_Moderation();
					break;
				case 4:
					DrawPage_Debug();
					break;
			}
		}

		private bool BeginScaledFrame(string id, float heightRatio = 0f)
		{
			Vector2 avail = ImGui.GetContentRegionAvail();
			float height = heightRatio > 0f ? avail.y * heightRatio : 0f;

			ImGui.PushStyleColor(ImGuiCol.ChildBg, new Vector4(0f, 0f, 0f, 0f));
			bool result = ImGui.BeginChild(id, new Vector2(avail.x, height), ImGuiChildFlags.Border);
			ImGui.PopStyleColor(1);

			return result;
		}

		private void DrawPage_Movement()
		{
			ImGui.TextUnformatted("Movement");
			ImGui.Spacing();

			BeginScaledFrame("##mv_frame", 0.9f);

			Checkbox("Joystick Fly", ref _joyStickFly);
			Checkbox("Speed Boost", ref _speedBoost);

			ImGui.Spacing();

			SliderFloat("Speed##mv", ref _customSpeed, 1f, 20f, "%.1f");
			SliderFloat("Jump##mv", ref _customJump, 1f, 10f, "%.1f");

			ImGui.Spacing();

			SliderFloat("Player Size", ref _customSize, 0.1f, 10f, "%.1f");

			ImGui.EndChild();
		}

		private void DrawPage_Local()
		{
			ImGui.TextUnformatted("Local Player");
			ImGui.Spacing();

			BeginScaledFrame("##loc_frame", 0.85f);

			ImGui.EndChild();
		}

		private void DrawPage_Players()
		{
			ImGui.TextUnformatted("Players");
			ImGui.Spacing();

			BeginScaledFrame("##pl_frame", 0.85f);

			ImGui.TextWrapped("Connected player list will appear here.");
			ImGui.Spacing();

			for (int i = 0; i < 5; i++)
			{
				Btn(string.Format("Player_{0}", i), new Vector2(ImGui.GetContentRegionAvail().x, 24f));
			}

			ImGui.EndChild();
		}

		private void DrawPage_Moderation()
		{
			ImGui.TextUnformatted("Moderation");
			ImGui.Spacing();

			BeginScaledFrame("##modframe", 0.85f);

			ImGui.TextWrapped("Moderation tools for room management.");
			ImGui.Spacing();

			float width = ImGui.GetContentRegionAvail().x;

			Btn("Report Target", new Vector2(width, 28f));
			Btn("Kick Target", new Vector2(width, 28f));
			Btn("Mute Target", new Vector2(width, 28f));
			Btn("TP to Target", new Vector2(width, 28f));

			ImGui.EndChild();
		}

		private void DrawPage_Debug()
		{
			ImGui.TextUnformatted("Debug");
			ImGui.Spacing();

			BeginScaledFrame("##dbg_frame", 0.85f);

			float dt = Time.unscaledDeltaTime;
			ImGui.Text(string.Format("FPS: {0:0.0}  |  Frame: {1:0.00} ms", 1f / Mathf.Max(dt, 0.0001f), dt * 1000f));
			ImGui.Text(string.Format("Time.time: {0:0.00}", Time.time));

			ImGui.Spacing();

			ImGui.PlotLines("##dbgfps", ref _fpsHistory[0], FPS_HISTORY_SIZE, _fpsHistoryIdx, "FPS", 0f, 200f, new Vector2(ImGui.GetContentRegionAvail().x, 80f));

			ImGui.Spacing();

			Btn("Log Test", new Vector2(ImGui.GetContentRegionAvail().x, 28f));

			ImGui.EndChild();
		}

		private bool Btn(string label, Vector2 size = default(Vector2))
		{
			bool clicked = ImGui.Button(label, size);
			RegisterHover();

			if (clicked)
			{
				PlayClip(buttonClickClip);
			}

			return clicked;
		}

		private bool Checkbox(string label, ref bool v)
		{
			bool changed = ImGui.Checkbox(label, ref v);
			RegisterHover();
			return changed;
		}

		private bool SliderFloat(string label, ref float v, float min, float max, string fmt = "%.2f")
		{
			bool changed = ImGui.SliderFloat(label, ref v, min, max, fmt);
			RegisterHover();
			return changed;
		}

		private void RegisterHover()
		{
			if (ImGui.IsItemHovered())
			{
				uint id = ImGui.GetItemID();
				if (id != 0)
				{
					_currentHoveredId = id;
				}
			}
		}

		private void HandleHoverAudio()
		{
			if (_currentHoveredId != 0 && _currentHoveredId != _previousHoveredId)
			{
				PlayClip(hoverClip != null ? hoverClip : buttonClickClip);
			}

			_previousHoveredId = _currentHoveredId;
		}

		private void PlayClip(AudioClip clip)
		{
			if (audioSource != null && clip != null)
			{
				audioSource.PlayOneShot(clip);
			}
		}

		private static void PushStyle()
		{
			ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 6f);
			ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 4f);
			ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, new Vector2(12f, 12f));
			ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, new Vector2(8f, 6f));

			ImGui.PushStyleColor(ImGuiCol.Text, new Vector4(0.9f, 0.9f, 0.9f, 1f));
			ImGui.PushStyleColor(ImGuiCol.WindowBg, new Vector4(0.12f, 0.12f, 0.12f, 0.95f));
			ImGui.PushStyleColor(ImGuiCol.ChildBg, new Vector4(0f, 0f, 0f, 0f));
			ImGui.PushStyleColor(ImGuiCol.Border, new Vector4(0.3f, 0.3f, 0.3f, 0.5f));
			ImGui.PushStyleColor(ImGuiCol.FrameBg, new Vector4(0.2f, 0.2f, 0.2f, 1f));
			ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, new Vector4(0.28f, 0.28f, 0.28f, 1f));
			ImGui.PushStyleColor(ImGuiCol.FrameBgActive, new Vector4(0.35f, 0.35f, 0.35f, 1f));
			ImGui.PushStyleColor(ImGuiCol.TitleBg, new Vector4(0.1f, 0.1f, 0.1f, 1f));
			ImGui.PushStyleColor(ImGuiCol.TitleBgActive, new Vector4(0.15f, 0.15f, 0.15f, 1f));
			ImGui.PushStyleColor(ImGuiCol.Button, new Vector4(0.24f, 0.24f, 0.24f, 1f));
			ImGui.PushStyleColor(ImGuiCol.ButtonHovered, new Vector4(0.34f, 0.34f, 0.34f, 1f));
			ImGui.PushStyleColor(ImGuiCol.ButtonActive, new Vector4(0.42f, 0.42f, 0.42f, 1f));
			ImGui.PushStyleColor(ImGuiCol.CheckMark, new Vector4(0.8f, 0.8f, 0.8f, 1f));
			ImGui.PushStyleColor(ImGuiCol.SliderGrab, new Vector4(0.5f, 0.5f, 0.5f, 1f));
			ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, new Vector4(0.7f, 0.7f, 0.7f, 1f));
			ImGui.PushStyleColor(ImGuiCol.PlotLines, new Vector4(0.6f, 0.6f, 0.6f, 1f));
			ImGui.PushStyleColor(ImGuiCol.PlotHistogram, new Vector4(0.55f, 0.55f, 0.55f, 1f));
			ImGui.PushStyleColor(ImGuiCol.Tab, new Vector4(0.18f, 0.18f, 0.2f, 1f));
			ImGui.PushStyleColor(ImGuiCol.TabHovered, new Vector4(0.3f, 0.3f, 0.34f, 1f));
		}

		private static void PopStyle()
		{
			ImGui.PopStyleColor(19);
			ImGui.PopStyleVar(4);
		}
	}
}

