using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmGhostPanelButton : BaseButton
	{
		[SerializeField]
		private BtmGhostWristPanel panel;

		[SerializeField]
		private BtmGhostWristPanel.Action action;

		private bool _accepted;

		public BtmGhostWristPanel.Action Action => action;

		public override void OnButtonPressed(bool isLeft)
		{
			_accepted = panel != null && panel.Press(action, isLeft);
		}

		public override void ButtonVisuals(bool isLeft)
		{
			if (_accepted)
			{
				_accepted = false;
				base.ButtonVisuals(isLeft);
			}
		}
	}
}
