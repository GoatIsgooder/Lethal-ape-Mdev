using System.Collections.Generic;
using ImGuiNET;
using UnityEngine;

namespace LethalApeR
{
	public static class ImGuiNotify
	{
		public enum ToastType
		{
			Info = 0,
			Success = 1,
			Warning = 2,
			Error = 3
		}

		private sealed class Toast
		{
			public ToastType Type;

			public string Title;

			public string Content;

			public string Composed;

			public float Duration;

			public Color? TitleColorOverride;

			public int Repeats = 1;

			public double CreationTime = -1.0;

			public readonly uint Id = _idGen++;

			private static uint _idGen = 48879u;
		}

		private const float PaddingY = 10f;

		private const float NotifWidth = 330f;

		private const float AnimInDuration = 0.38f;

		private const float FadeOutDuration = 0.28f;

		private const float DefaultDuration = 4f;

		private const int MaxVisible = 4;

		private const int MaxQueued = 16;

		private const float RightInsetFrac = 0.3f;

		private const float TopStartFrac = 0.2f;

		private static readonly List<Toast> _queue = new List<Toast>();

		private static readonly List<Toast> _discard = new List<Toast>();

		public static void Insert(ToastType type, string title, string content = null, float duration = 4f, Color? titleColorOverride = null)
		{
			if (_queue.Count > 0)
			{
				Toast toast = _queue[_queue.Count - 1];
				if (toast.Type == type && toast.Title == title && toast.Content == content)
				{
					toast.Repeats++;
					toast.CreationTime = -1.0;
					toast.Composed = Compose(type, title, toast.Repeats);
					return;
				}
			}
			if (_queue.Count >= MaxQueued)
			{
				_queue.RemoveAt(0);
			}
			_queue.Add(new Toast
			{
				Type = type,
				Title = title,
				Content = content,
				Composed = Compose(type, title, 1),
				Duration = duration,
				TitleColorOverride = titleColorOverride
			});
		}

		public static void Clear()
		{
			_queue.Clear();
		}

		public static void Render()
		{
			if (_queue.Count == 0)
			{
				return;
			}
			Vector2 displaySize = ImGui.GetIO().DisplaySize;
			double time = ImGui.GetTime();
			_discard.Clear();
			float num = displaySize.x * RightInsetFrac;
			float num2 = displaySize.y * TopStartFrac;
			float num3 = displaySize.x - NotifWidth - num;
			float num4 = num + NotifWidth;
			int num5 = 0;
			for (int i = 0; i < _queue.Count; i++)
			{
				Toast toast = _queue[i];
				if (num5 >= MaxVisible)
				{
					break;
				}
				if (toast.CreationTime < 0.0)
				{
					toast.CreationTime = time;
				}
				double num6 = time - toast.CreationTime;
				double num7 = (double)toast.Duration + AnimInDuration;
				if (num6 >= num7 + FadeOutDuration)
				{
					_discard.Add(toast);
					continue;
				}
				float num8;
				float num9;
				if (num6 < AnimInDuration)
				{
					float t = (float)(num6 / AnimInDuration);
					num8 = ImAnim.ApplyEase(ImAnim.Ease.OutBack, t);
					num9 = Mathf.Clamp01(ImAnim.ApplyEase(ImAnim.Ease.OutCubic, t));
				}
				else if (num6 < num7)
				{
					num8 = 1f;
					num9 = 1f;
				}
				else
				{
					float t2 = (float)((num6 - num7) / FadeOutDuration);
					num8 = 1f - ImAnim.ApplyEase(ImAnim.Ease.InCubic, t2);
					num9 = Mathf.Clamp01(1f - ImAnim.ApplyEase(ImAnim.Ease.InCubic, t2));
				}
				ImGui.SetNextWindowPos(new Vector2(num3 + num4 * (1f - num8), num2), ImGuiCond.Always);
				ImGui.SetNextWindowSize(new Vector2(NotifWidth, 0f));
				float num10 = num9 * 0.92f;
				ImGui.SetNextWindowBgAlpha(num10);
				GetTypeStyle(toast.Type, out var accentColor, out var titleColor, out var _);
				ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 7f);
				ImGui.PushStyleVar(ImGuiStyleVar.WindowPadding, new Vector2(14f, 10f));
				ImGui.PushStyleVar(ImGuiStyleVar.ItemSpacing, new Vector2(8f, 5f));
				ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 1f);
				ImGui.PushStyleColor(ImGuiCol.WindowBg, new Vector4(0.11f, 0.11f, 0.13f, num10));
				ImGui.PushStyleColor(ImGuiCol.Border, new Vector4(accentColor.x, accentColor.y, accentColor.z, num9 * 0.45f));
				ImGui.Begin(string.Format("##notif_{0}", toast.Id), ImGuiWindowFlags.NoDecoration | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoSavedSettings | ImGuiWindowFlags.NoFocusOnAppearing | ImGuiWindowFlags.NoInputs);
				ImDrawListPtr windowDrawList = ImGui.GetWindowDrawList();
				Vector2 windowPos = ImGui.GetWindowPos();
				Vector2 windowSize = ImGui.GetWindowSize();
				windowDrawList.AddRectFilled(windowPos, new Vector2(windowPos.x + 4f, windowPos.y + windowSize.y), ImGui.GetColorU32(new Vector4(accentColor.x, accentColor.y, accentColor.z, num9)), 4f);
				Color? titleColorOverride = toast.TitleColorOverride;
				Vector4 vector = (titleColorOverride.HasValue ? ((Vector4)titleColorOverride.GetValueOrDefault()) : titleColor);
				ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 10f);
				ImGui.TextColored(new Vector4(vector.x, vector.y, vector.z, num9), toast.Composed);
				if (!string.IsNullOrEmpty(toast.Content))
				{
					ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 10f);
					ImGui.PushStyleColor(ImGuiCol.Text, new Vector4(0.83f, 0.83f, 0.83f, num9));
					ImGui.TextWrapped(toast.Content);
					ImGui.PopStyleColor();
				}
				if (num6 >= AnimInDuration && num6 < num7)
				{
					float duration = toast.Duration;
					ImGui.Spacing();
					ImGui.SetCursorPosX(ImGui.GetCursorPosX() + 10f);
					float x = ImGui.GetContentRegionAvail().x - 10f;
					ImGui.PushStyleColor(ImGuiCol.PlotHistogram, new Vector4(accentColor.x, accentColor.y, accentColor.z, num9 * 0.85f));
					ImGui.PushStyleColor(ImGuiCol.FrameBg, new Vector4(0.07f, 0.07f, 0.09f, num9 * 0.4f));
					ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 2f);
					ImGui.ProgressBar(1f - (float)((num6 - AnimInDuration) / (double)duration), new Vector2(x, 3f), "");
					ImGui.PopStyleVar();
					ImGui.PopStyleColor(2);
				}
				num5++;
				ImGui.Spacing();
				float num11 = Mathf.Max(ImGui.GetWindowSize().y, 52f);
				ImGui.End();
				ImGui.PopStyleColor(2);
				ImGui.PopStyleVar(4);
				num2 += num11 + PaddingY;
			}
			for (int j = 0; j < _discard.Count; j++)
			{
				_queue.Remove(_discard[j]);
			}
		}

		private static string Compose(ToastType type, string title, int repeats)
		{
			GetTypeStyle(type, out var _, out var _, out var icon);
			if (repeats > 1)
			{
				return string.Format("{0}  {1}   x{2}", icon, title, repeats);
			}
			return icon + "  " + title;
		}

		private static void GetTypeStyle(ToastType type, out Vector4 accentColor, out Vector4 titleColor, out string icon)
		{
			switch (type)
			{
			case ToastType.Success:
				accentColor = new Vector4(0.18f, 0.78f, 0.32f, 1f);
				titleColor = new Vector4(0.38f, 1f, 0.48f, 1f);
				icon = "[+]";
				break;
			case ToastType.Warning:
				accentColor = new Vector4(0.9f, 0.7f, 0.08f, 1f);
				titleColor = new Vector4(1f, 0.88f, 0.22f, 1f);
				icon = "[!]";
				break;
			case ToastType.Error:
				accentColor = new Vector4(0.85f, 0.14f, 0.14f, 1f);
				titleColor = new Vector4(1f, 0.34f, 0.34f, 1f);
				icon = "[X]";
				break;
			default:
				accentColor = new Vector4(0.24f, 0.54f, 0.92f, 1f);
				titleColor = new Vector4(0.48f, 0.76f, 1f, 1f);
				icon = "[i]";
				break;
			}
		}
	}
}
