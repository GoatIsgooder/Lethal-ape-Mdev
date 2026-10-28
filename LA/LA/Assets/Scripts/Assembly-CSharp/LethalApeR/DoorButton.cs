namespace LethalApeR
{
	public class DoorButton : BaseButton
	{
		public DoorManager doorManager;

		public bool targetOpen = true;

		public override void OnButtonPressed(bool isLeft)
		{
			doorManager.TryActivate(targetOpen);
		}
	}
}
