using System.Reflection;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class BTMMonsterPOVButton : BaseButton
	{
		public BTMMonsterPOV _btmMonsterPOV;

		public bool _isNextButton = true;

		public override void OnButtonPressed(bool isLeft)
		{
			if (_isNextButton)
			{
				_btmMonsterPOV.NextMonster();
			}
			else
			{
				_btmMonsterPOV.PreviousMonster();
			}
		}
	}
}
