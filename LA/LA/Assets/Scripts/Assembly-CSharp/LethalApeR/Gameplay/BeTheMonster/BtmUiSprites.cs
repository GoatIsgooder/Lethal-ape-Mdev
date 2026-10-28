using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmUiSprites
	{
		private static Sprite _dot;

		private static Sprite _ring;

		private static Sprite _soft;

		private static Texture2D _dash;

		private static Texture2D _grid;

		public static Sprite Dot
		{
			get
			{
				if (!(_dot != null))
				{
					return _dot = Circle(64, 0f, 1f, "BtmDot");
				}
				return _dot;
			}
		}

		public static Sprite Ring
		{
			get
			{
				if (!(_ring != null))
				{
					return _ring = Circle(64, 0.72f, 1f, "BtmRing");
				}
				return _ring;
			}
		}

		public static Sprite Soft
		{
			get
			{
				if (!(_soft != null))
				{
					return _soft = Glow(64, "BtmSoft");
				}
				return _soft;
			}
		}

		public static Texture2D Dash
		{
			get
			{
				if (!(_dash != null))
				{
					return _dash = BuildDash();
				}
				return _dash;
			}
		}

		public static Texture2D Grid
		{
			get
			{
				if (!(_grid != null))
				{
					return _grid = BuildGrid();
				}
				return _grid;
			}
		}

		private static Sprite Circle(int size, float inner, float outer, string name)
		{
			Texture2D tex = NewTex(size, size, name);
			Color32[] array = new Color32[size * size];
			float num = (float)(size - 1) * 0.5f;
			float num2 = 1.5f / num;
			for (int i = 0; i < size; i++)
			{
				for (int j = 0; j < size; j++)
				{
					float num3 = (float)i - num;
					float num4 = (float)j - num;
					float num5 = Mathf.Sqrt(num3 * num3 + num4 * num4) / num;
					float num6 = Mathf.Clamp01((outer - num5) / num2);
					float num7 = ((inner > 0f) ? Mathf.Clamp01((num5 - inner) / num2) : 1f);
					array[i * size + j] = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, (byte)(num6 * num7 * 255f));
				}
			}
			return Finish(tex, array);
		}

		private static Sprite Glow(int size, string name)
		{
			Texture2D tex = NewTex(size, size, name);
			Color32[] array = new Color32[size * size];
			float num = (float)(size - 1) * 0.5f;
			for (int i = 0; i < size; i++)
			{
				for (int j = 0; j < size; j++)
				{
					float num2 = (float)i - num;
					float num3 = (float)j - num;
					float num4 = 1f - Mathf.Clamp01(Mathf.Sqrt(num2 * num2 + num3 * num3) / num);
					array[i * size + j] = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, (byte)(num4 * num4 * 255f));
				}
			}
			return Finish(tex, array);
		}

		private static Texture2D BuildDash()
		{
			Texture2D texture2D = NewTex(32, 4, "BtmDash");
			texture2D.wrapModeU = TextureWrapMode.Repeat;
			texture2D.wrapModeV = TextureWrapMode.Clamp;
			Color32[] array = new Color32[128];
			for (int i = 0; i < 32; i++)
			{
				float num = (float)i / 31f;
				float num2 = Mathf.Clamp01(Mathf.Min(num, 0.5f - num) * 16f);
				Color32 color = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, (byte)(num2 * 255f));
				for (int j = 0; j < 4; j++)
				{
					array[j * 32 + i] = color;
				}
			}
			texture2D.SetPixels32(array);
			texture2D.Apply(true, true);
			return texture2D;
		}

		private static Texture2D BuildGrid()
		{
			Texture2D texture2D = NewTex(64, 64, "BtmGrid");
			texture2D.wrapMode = TextureWrapMode.Repeat;
			Color32[] array = new Color32[4096];
			for (int i = 0; i < 64; i++)
			{
				int num = Mathf.Min(i, 63 - i);
				for (int j = 0; j < 64; j++)
				{
					int num2 = Mathf.Min(j, 63 - j);
					float a = ((num2 == 0 || num == 0) ? 0.18f : 0f);
					float num3 = Mathf.Clamp01(1f - Mathf.Sqrt(num * num + num2 * num2) / 3.2f);
					float num4 = Mathf.Max(a, num3 * 0.75f);
					array[i * 64 + j] = new Color32(byte.MaxValue, byte.MaxValue, byte.MaxValue, (byte)(num4 * 255f));
				}
			}
			texture2D.SetPixels32(array);
			texture2D.Apply(true, true);
			return texture2D;
		}

		private static Texture2D NewTex(int w, int h, string name)
		{
			return new Texture2D(w, h, TextureFormat.RGBA32, mipChain: true)
			{
				name = name,
				filterMode = FilterMode.Trilinear,
				anisoLevel = 4
			};
		}

		private static Sprite Finish(Texture2D tex, Color32[] px)
		{
			tex.wrapMode = TextureWrapMode.Clamp;
			tex.SetPixels32(px);
			tex.Apply(true, true);
			return Sprite.Create(tex, new Rect(0f, 0f, tex.width, tex.height), new Vector2(0.5f, 0.5f), tex.width, 0u, SpriteMeshType.FullRect);
		}
	}
}
