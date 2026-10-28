using LethalApeR.Social.UI;
using UnityEngine;

namespace LethalApeR.Social.Menu
{
	public sealed class VolumeRow : MonoBehaviour
	{
		[SerializeField]
		private GameSettings.Volume volume;

		[SerializeField]
		private SocialButton minus;

		[SerializeField]
		private SocialButton plus;

		[SerializeField]
		private SocialButton[] segments = new SocialButton[10];

		private int _shown = -1;

		private void Awake()
		{
			minus.Pressed += () => GameSettings.SetStep(volume, GameSettings.GetStep(volume) - 1);
			plus.Pressed += () => GameSettings.SetStep(volume, GameSettings.GetStep(volume) + 1);
			for (int i = 0; i < segments.Length; i++)
			{
				int step = i + 1;
				segments[i].Pressed += () => GameSettings.SetStep(volume, (GameSettings.GetStep(volume) == step) ? (step - 1) : step);
			}
		}

		public void Refresh()
		{
			int step = GameSettings.GetStep(volume);
			if (step != _shown)
			{
				_shown = step;
				for (int i = 0; i < segments.Length; i++)
				{
					segments[i].SetLook((i < step) ? ButtonLook.SegmentOn : ButtonLook.Segment);
				}
				minus.SetLook((step <= 0) ? ButtonLook.Disabled : ButtonLook.Normal);
				plus.SetLook((step >= GameSettings.Steps) ? ButtonLook.Disabled : ButtonLook.Normal);
			}
		}
	}
}
