using System;
using System.Collections.Generic;
using System.Text;
using TMPro;

namespace LethalApeR.Social
{
	public static class SocialText
	{
		public const int MaxNameLength = 16;

		private static TMP_FontAsset _font;

		private static readonly StringBuilder Builder = new StringBuilder(32);

		private static readonly Dictionary<string, string> NameCache = new Dictionary<string, string>(64, StringComparer.Ordinal);

		public static TMP_FontAsset Font
		{
			get
			{
				return _font;
			}
			set
			{
				_font = value;
			}
		}

		public static string CleanName(string raw)
		{
			if (string.IsNullOrWhiteSpace(raw))
			{
				return "PLAYER";
			}
			if (NameCache.TryGetValue(raw, out var value))
			{
				return value;
			}
			if (NameCache.Count > 512)
			{
				NameCache.Clear();
			}
			string text = Clean(raw);
			NameCache[raw] = text;
			return text;
		}

		private static string Clean(string raw)
		{
			Builder.Length = 0;
			string text = raw.Trim().ToUpperInvariant();
			for (int i = 0; i < text.Length && Builder.Length < 16; i++)
			{
				char c = text[i];
				if (c == '<' || c == '>')
				{
					c = '?';
				}
				else
				{
					if (char.IsControl(c))
					{
						continue;
					}
					if (c != ' ' && _font != null && !_font.HasCharacter(c))
					{
						c = '?';
					}
				}
				Builder.Append(c);
			}
			if (Builder.Length == 0)
			{
				return "PLAYER";
			}
			return Builder.ToString();
		}
	}
}
