namespace LethalApeR.Rivals.Progression
{
	public class JoinRankedHubButton : BaseButton
	{
		public override void OnButtonPressed(bool isLeft)
		{
			RivalsRankedQueue.JoinRankedHub();
		}
	}
}
