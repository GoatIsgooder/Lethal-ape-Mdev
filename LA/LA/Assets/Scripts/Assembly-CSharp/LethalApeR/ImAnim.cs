using System;
using System.Collections.Generic;
using ImGuiNET;
using UnityEngine;

namespace LethalApeR
{
	public static class ImAnim
	{
		public enum Ease
		{
			Linear = 0,
			InQuad = 1,
			OutQuad = 2,
			InOutQuad = 3,
			InCubic = 4,
			OutCubic = 5,
			InOutCubic = 6,
			InQuart = 7,
			OutQuart = 8,
			InOutQuart = 9,
			InBack = 10,
			OutBack = 11,
			OutBounce = 12,
			OutElastic = 13,
			Spring = 14
		}

		private struct FloatTween
		{
			public float From;

			public float To;

			public float Duration;

			public double StartTime;

			public Ease Ease;

			public int LastFrame;
		}

		private struct Ripple
		{
			public Vector2 Origin;

			public double StartTime;

			public float Duration;

			public bool Active;

			public int LastFrame;
		}

		private static readonly Dictionary<ulong, FloatTween> _tweens = new Dictionary<ulong, FloatTween>();

		private static readonly Dictionary<uint, Ripple> _ripples = new Dictionary<uint, Ripple>();

		private static readonly List<ulong> _staleTweens = new List<ulong>();

		private static readonly List<uint> _staleRipples = new List<uint>();

		public static float ApplyEase(Ease ease, float t)
		{
			t = Mathf.Clamp01(t);
			switch (ease)
			{
			case Ease.InQuad:
				return t * t;
			case Ease.OutQuad:
				return 1f - (1f - t) * (1f - t);
			case Ease.InOutQuad:
				if (!(t < 0.5f))
				{
					return 1f - (-2f * t + 2f) * (-2f * t + 2f) / 2f;
				}
				return 2f * t * t;
			case Ease.InCubic:
				return t * t * t;
			case Ease.OutCubic:
				return 1f - Mathf.Pow(1f - t, 3f);
			case Ease.InOutCubic:
				if (!(t < 0.5f))
				{
					return 1f - Mathf.Pow(-2f * t + 2f, 3f) / 2f;
				}
				return 4f * t * t * t;
			case Ease.InQuart:
				return t * t * t * t;
			case Ease.OutQuart:
				return 1f - Mathf.Pow(1f - t, 4f);
			case Ease.InOutQuart:
				if (!(t < 0.5f))
				{
					return 1f - Mathf.Pow(-2f * t + 2f, 4f) / 2f;
				}
				return 8f * t * t * t * t;
			case Ease.InBack:
			{
				float num7 = 1.70158f;
				float num8 = num7 + 1f;
				return num8 * t * t * t - num7 * t * t;
			}
			case Ease.OutBack:
			{
				float num5 = 1.70158f;
				float num6 = num5 + 1f;
				return 1f + num6 * Mathf.Pow(t - 1f, 3f) + num5 * Mathf.Pow(t - 1f, 2f);
			}
			case Ease.OutBounce:
			{
				float num3 = 7.5625f;
				float num4 = 2.75f;
				if (t < 1f / num4)
				{
					return num3 * t * t;
				}
				if (t < 2f / num4)
				{
					return num3 * (t -= 1.5f / num4) * t + 0.75f;
				}
				if (t < 2.5f / num4)
				{
					return num3 * (t -= 2.25f / num4) * t + 0.9375f;
				}
				return num3 * (t -= 2.625f / num4) * t + 0.984375f;
			}
			case Ease.OutElastic:
			{
				float num2 = (float)Math.PI * 2f / 3f;
				if (Mathf.Approximately(t, 0f))
				{
					return 0f;
				}
				if (Mathf.Approximately(t, 1f))
				{
					return 1f;
				}
				return Mathf.Pow(2f, -10f * t) * Mathf.Sin((t * 10f - 0.75f) * num2) + 1f;
			}
			case Ease.Spring:
				return 1f - Mathf.Exp(-6f * t) * Mathf.Cos(t * 20f);
			default:
				return t;
			}
		}

		public static float TweenFloat(uint id, int channel, float target, float duration = 0.2f, Ease ease = Ease.OutCubic)
		{
			ulong key = ((ulong)id << 16) | (uint)(channel & 0xFFFF);
			double time = ImGui.GetTime();
			int frameCount = ImGui.GetFrameCount();
			if (_tweens.TryGetValue(key, out var value))
			{
				if (Mathf.Abs(value.To - target) > 1E-05f)
				{
					float from = EvalTween(value, time);
					value = new FloatTween
					{
						From = from,
						To = target,
						Duration = duration,
						StartTime = time,
						Ease = ease
					};
				}
				value.LastFrame = frameCount;
				_tweens[key] = value;
				return EvalTween(value, time);
			}
			_tweens[key] = new FloatTween
			{
				From = target,
				To = target,
				Duration = duration,
				StartTime = time,
				Ease = ease,
				LastFrame = frameCount
			};
			return target;
		}

		public static Vector4 TweenVec4(uint id, int channel, Vector4 target, float duration = 0.2f, Ease ease = Ease.OutCubic)
		{
			return new Vector4(TweenFloat(id, channel * 4, target.x, duration, ease), TweenFloat(id, channel * 4 + 1, target.y, duration, ease), TweenFloat(id, channel * 4 + 2, target.z, duration, ease), TweenFloat(id, channel * 4 + 3, target.w, duration, ease));
		}

		private static float EvalTween(FloatTween s, double now)
		{
			if (s.Duration <= 0f)
			{
				return s.To;
			}
			float t = Mathf.Clamp01((float)((now - s.StartTime) / (double)s.Duration));
			return s.From + (s.To - s.From) * ApplyEase(s.Ease, t);
		}

		public static void TriggerRipple(uint id, Vector2 mousePos, float duration = 0.45f)
		{
			_ripples[id] = new Ripple
			{
				Origin = mousePos,
				StartTime = ImGui.GetTime(),
				Duration = duration,
				Active = true,
				LastFrame = ImGui.GetFrameCount()
			};
		}

		public static void DrawRipple(ImDrawListPtr dl, uint id, Vector2 btnPos, Vector2 btnSize, Vector4 tintColor)
		{
			if (!_ripples.TryGetValue(id, out var value) || !value.Active)
			{
				return;
			}
			float num = (float)((ImGui.GetTime() - value.StartTime) / (double)value.Duration);
			value.LastFrame = ImGui.GetFrameCount();
			if (num >= 1f)
			{
				value.Active = false;
				_ripples[id] = value;
				return;
			}
			_ripples[id] = value;
			float num2 = 1f - Mathf.Pow(1f - Mathf.Clamp01(num), 3f);
			float radius = btnSize.magnitude * num2;
			float w = tintColor.w * (1f - num2) * 0.5f;
			dl.PushClipRect(btnPos, btnPos + btnSize, true);
			dl.AddCircleFilled(value.Origin, radius, ImGui.GetColorU32(new Vector4(tintColor.x, tintColor.y, tintColor.z, w)));
			dl.PopClipRect();
		}

		public static void NewFrame()
		{
			int frameCount = ImGui.GetFrameCount();
			_staleTweens.Clear();
			foreach (KeyValuePair<ulong, FloatTween> tween in _tweens)
			{
				if (frameCount - tween.Value.LastFrame >= 5)
				{
					_staleTweens.Add(tween.Key);
				}
			}
			for (int i = 0; i < _staleTweens.Count; i++)
			{
				_tweens.Remove(_staleTweens[i]);
			}
			_staleRipples.Clear();
			foreach (KeyValuePair<uint, Ripple> ripple in _ripples)
			{
				if (!ripple.Value.Active && frameCount - ripple.Value.LastFrame >= 5)
				{
					_staleRipples.Add(ripple.Key);
				}
			}
			for (int j = 0; j < _staleRipples.Count; j++)
			{
				_ripples.Remove(_staleRipples[j]);
			}
		}

		public static void Reset()
		{
			_tweens.Clear();
			_ripples.Clear();
		}
	}
}
