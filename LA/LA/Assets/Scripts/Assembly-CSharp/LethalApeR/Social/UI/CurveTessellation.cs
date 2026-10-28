using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	[DisallowMultipleComponent]
	public sealed class CurveTessellation : BaseMeshEffect
	{
		[Tooltip("Widest column, in canvas units (for the side-to-side curve). 0 = don't split across.")]
		[SerializeField]
		[Min(0f)]
		private float maxColumn = 40f;

		[Tooltip("Tallest row, in canvas units (for the list's drum). 0 = don't split down.")]
		[SerializeField]
		[Min(0f)]
		private float maxRow;

		private static readonly List<UIVertex> Source = new List<UIVertex>(256);

		private static readonly List<UIVertex> Result = new List<UIVertex>(2048);

		public override void ModifyMesh(VertexHelper vh)
		{
			if (!IsActive() || vh.currentVertCount == 0)
			{
				return;
			}
			Source.Clear();
			vh.GetUIVertexStream(Source);
			if (Source.Count % 6 == 0)
			{
				Result.Clear();
				for (int i = 0; i < Source.Count; i += 6)
				{
					SplitQuad(i);
				}
				vh.Clear();
				vh.AddUIVertexTriangleStream(Result);
			}
		}

		private void SplitQuad(int start)
		{
			UIVertex uIVertex = Source[start];
			UIVertex uIVertex2 = Source[start];
			for (int i = start; i < start + 6; i++)
			{
				UIVertex uIVertex3 = Source[i];
				if (uIVertex3.position.x <= uIVertex.position.x && uIVertex3.position.y <= uIVertex.position.y)
				{
					uIVertex = uIVertex3;
				}
				if (uIVertex3.position.x >= uIVertex2.position.x && uIVertex3.position.y >= uIVertex2.position.y)
				{
					uIVertex2 = uIVertex3;
				}
			}
			int num = ((maxColumn > 0f) ? Mathf.Clamp(Mathf.CeilToInt((uIVertex2.position.x - uIVertex.position.x) / maxColumn), 1, 64) : 1);
			int num2 = ((maxRow > 0f) ? Mathf.Clamp(Mathf.CeilToInt((uIVertex2.position.y - uIVertex.position.y) / maxRow), 1, 64) : 1);
			if (num == 1 && num2 == 1)
			{
				for (int j = start; j < start + 6; j++)
				{
					Result.Add(Source[j]);
				}
				return;
			}
			for (int k = 0; k < num; k++)
			{
				float tx = (float)k / (float)num;
				float tx2 = (float)(k + 1) / (float)num;
				for (int l = 0; l < num2; l++)
				{
					float ty = (float)l / (float)num2;
					float ty2 = (float)(l + 1) / (float)num2;
					UIVertex item = Corner(uIVertex, uIVertex2, tx, ty);
					UIVertex item2 = Corner(uIVertex, uIVertex2, tx, ty2);
					UIVertex item3 = Corner(uIVertex, uIVertex2, tx2, ty2);
					UIVertex item4 = Corner(uIVertex, uIVertex2, tx2, ty);
					Result.Add(item);
					Result.Add(item2);
					Result.Add(item3);
					Result.Add(item3);
					Result.Add(item4);
					Result.Add(item);
				}
			}
		}

		public void Configure(float column, float row)
		{
			maxColumn = column;
			maxRow = row;
		}

		private static UIVertex Corner(UIVertex bl, UIVertex tr, float tx, float ty)
		{
			UIVertex result = bl;
			result.position = new Vector3(Mathf.Lerp(bl.position.x, tr.position.x, tx), Mathf.Lerp(bl.position.y, tr.position.y, ty), bl.position.z);
			// RE: unsure - colour blend is an unnamed helper taking (Color32, Color32, float); read as Color32.Lerp
			result.color = Color32.Lerp(bl.color, tr.color, (tx + ty) * 0.5f);
			result.uv0 = new Vector4(Mathf.Lerp(bl.uv0.x, tr.uv0.x, tx), Mathf.Lerp(bl.uv0.y, tr.uv0.y, ty), bl.uv0.z, bl.uv0.w);
			return result;
		}
	}
}
