namespace LethalApeR
{
	public class TurningButton : BaseButton
	{
		public TurnController.TurnMode newMode;

		public override void OnButtonPressed(bool isLeft)
		{
			TurnController.SetTurnMode(newMode);
		}
	}
}
