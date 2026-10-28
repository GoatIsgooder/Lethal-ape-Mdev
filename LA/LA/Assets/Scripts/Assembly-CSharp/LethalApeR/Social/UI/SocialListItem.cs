using UnityEngine;

namespace LethalApeR.Social.UI
{
	public abstract class SocialListItem : MonoBehaviour
	{
		public RectTransform Rect => (RectTransform)base.transform;

		public virtual void SetPressable(bool pressable)
		{
		}
	}
}
