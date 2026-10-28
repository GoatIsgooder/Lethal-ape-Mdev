using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	public static class MenuImage
	{
		public static void Fill(RawImage image, Texture texture, float zoom, Vector2 focus = default(Vector2))
		{
			if (image == null || texture == null)
			{
				return;
			}
			Rect rect = image.rectTransform.rect;
			if (!(rect.width <= 0f) && !(rect.height <= 0f) && texture.height > 0)
			{
				float rectAspect = rect.width / rect.height;
				float textureAspect = (float)texture.width / (float)texture.height;
				float sx;
				float sy;
				if (textureAspect > rectAspect)
				{
					sx = rectAspect / textureAspect;
					sy = 1f;
				}
				else
				{
					sx = 1f;
					sy = textureAspect / rectAspect;
				}
				float scale = 1f / (Mathf.Max(0f, zoom) + 1f);
				float width = scale * sx;
				float height = scale * sy;
				float halfWidth = width * 0.5f;
				float halfHeight = height * 0.5f;
				float cx = Mathf.Clamp(focus.x + 0.5f, halfWidth, 1f - halfWidth);
				float cy = Mathf.Clamp(focus.y + 0.5f, halfHeight, 1f - halfHeight);
				image.uvRect = new Rect(cx - halfWidth, cy - halfHeight, width, height);
			}
		}
	}
}
