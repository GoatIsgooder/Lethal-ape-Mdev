namespace LethalApeR
{
	public class LeadberboardButton : BaseButton
	{
		public Leaderboard leaderboard;

		public bool isNextPage;

		public override void OnButtonPressed(bool isLeft)
		{
			if (isNextPage)
			{
				leaderboard.NextPage();
			}
			else
			{
				leaderboard.PrevPage();
			}
		}
	}
}
