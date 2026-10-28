using System.Reflection;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgSpectateButton : BaseButton
	{
		public enum Mode
		{
			Next = 0,
			Previous = 1,
			AudioToggle = 2
		}

		public AgSpectateViewport viewport;

		public Mode mode;

		public override void OnButtonPressed(bool isLeft)
		{
			if (!(viewport == null))
			{
				switch (mode)
				{
				case Mode.Next:
					viewport.NextTarget();
					break;
				case Mode.Previous:
					viewport.PreviousTarget();
					break;
				case Mode.AudioToggle:
					viewport.ToggleListen();
					break;
				}
			}
		}
	}
}
