using System;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	[RequireComponent(typeof(CanvasRenderer))]
	public sealed class MenuFrame : MaskableGraphic
	{
		[Flags]
		public enum Corners
		{
			None = 0,
			TopLeft = 1,
			TopRight = 2,
			BottomRight = 4,
			BottomLeft = 8
		}

		private const AdditionalCanvasShaderChannels Channels = AdditionalCanvasShaderChannels.TexCoord1 | AdditionalCanvasShaderChannels.TexCoord2 | AdditionalCanvasShaderChannels.TexCoord3;

		[SerializeField]
		private Color fill = new Color(0.04f, 0.04f, 0.04f, 1f);

		[SerializeField]
		private Color border = new Color(0.8f, 0.8f, 0.8f, 1f);

		[Tooltip("Canvas units.")]
		[SerializeField]
		[Min(0f)]
		private float borderWidth = 4f;

		[Tooltip("Canvas units.")]
		[SerializeField]
		[Min(0f)]
		private float chamfer;

		[SerializeField]
		private Corners chamferCorners = Corners.BottomRight;

		[Tooltip("Horizontal shear: the top edge shifts right by skew x half-height.")]
		[SerializeField]
		[Range(-1f, 1f)]
		private float skew;

		[Tooltip("Canvas units. Rounds every corner (half the size makes a circle); overrides the chamfer.")]
		[SerializeField]
		[Min(0f)]
		private float cornerRadius;

		public Color Fill
		{
			get
			{
				return fill;
			}
			set
			{
				if (!(fill == value))
				{
					fill = value;
					SetVerticesDirty();
				}
			}
		}

		public Color Border
		{
			get
			{
				return border;
			}
			set
			{
				if (!(border == value))
				{
					border = value;
					SetVerticesDirty();
				}
			}
		}

		public float BorderWidth
		{
			get
			{
				return borderWidth;
			}
			set
			{
				if (!Mathf.Approximately(borderWidth, value))
				{
					borderWidth = Mathf.Max(0f, value);
					SetVerticesDirty();
				}
			}
		}

		protected override void OnEnable()
		{
			base.OnEnable();
			EnsureChannels();
		}

		protected override void OnCanvasHierarchyChanged()
		{
			base.OnCanvasHierarchyChanged();
			EnsureChannels();
		}

		private void EnsureChannels()
		{
			Canvas canvas = base.canvas;
			if (!(canvas == null))
			{
				Canvas rootCanvas = canvas.rootCanvas;
				if ((rootCanvas.additionalShaderChannels & Channels) != Channels)
				{
					rootCanvas.additionalShaderChannels |= Channels;
				}
			}
		}

		protected override void OnPopulateMesh(VertexHelper vh)
		{
			vh.Clear();
			Rect pixelAdjustedRect = GetPixelAdjustedRect();
			float hw = pixelAdjustedRect.width * 0.5f;
			float hh = pixelAdjustedRect.height * 0.5f;
			if (!(hw <= 0f) && !(hh <= 0f))
			{
				Vector2 center = pixelAdjustedRect.center;
				Vector4 borderLinear = Linear(border);
				Vector4 fillLinear = Linear(fill);
				float limit = Mathf.Min(hw, hh);
				Vector4 shape = new Vector4(Mathf.Min(borderWidth, limit), chamfer, (float)chamferCorners, Mathf.Min(cornerRadius, limit));
				Color32 tint = color;
				AddCorner(vh, center, 0f - hw, 0f - hh, hw, hh, tint, borderLinear, fillLinear, shape);
				AddCorner(vh, center, 0f - hw, hh, hw, hh, tint, borderLinear, fillLinear, shape);
				AddCorner(vh, center, hw, hh, hw, hh, tint, borderLinear, fillLinear, shape);
				AddCorner(vh, center, hw, 0f - hh, hw, hh, tint, borderLinear, fillLinear, shape);
				vh.AddTriangle(0, 1, 2);
				vh.AddTriangle(2, 3, 0);
			}
		}

		private void AddCorner(VertexHelper vh, Vector2 centre, float x, float y, float hw, float hh, Color32 tint, Vector4 borderLinear, Vector4 fillLinear, Vector4 shape)
		{
			UIVertex simpleVert = UIVertex.simpleVert;
			simpleVert.position = new Vector3(centre.x + x + skew * y, centre.y + y, 0f);
			simpleVert.color = tint;
			simpleVert.uv0 = new Vector4(x, y, hw, hh);
			simpleVert.uv1 = borderLinear;
			simpleVert.uv2 = fillLinear;
			simpleVert.uv3 = shape;
			vh.AddVert(simpleVert);
		}

		private static Vector4 Linear(Color c)
		{
			if (QualitySettings.activeColorSpace == ColorSpace.Linear)
			{
				c = c.linear;
			}
			return c;
		}
	}
}
