using System.Reflection;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class ModsScrollPageButton : BaseButton
	{
		[Header("Scroll")]
		[SerializeField]
		private ModsScrollPage target;

		[Tooltip("ON  = Forwards button  (>) -> next page.\nOFF = Backwards button (<) -> previous page.")]
		[SerializeField]
		private bool forwards = true;

		private MenuPressGate _gate;

		private bool _gateResolved;

		private bool MayPress()
		{
			if (!_gateResolved)
			{
				_gate = MenuPressGate.Find(this);
				_gateResolved = true;
			}
			if (_gate == null)
			{
				return true;
			}
			return _gate.TryPress(gameObject);
		}

		public override void ButtonVisuals(bool isLeft)
		{
			if (MayPress())
			{
				base.ButtonVisuals(isLeft);
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (!MayPress())
			{
				return;
			}
			if (target == null)
			{
				Debug.LogWarning("[ModsScrollPageButton] No target ModsScrollPage assigned.", this);
			}
			else if (forwards)
			{
				target.NextPage();
			}
			else
			{
				target.PreviousPage();
			}
		}
	}
}
