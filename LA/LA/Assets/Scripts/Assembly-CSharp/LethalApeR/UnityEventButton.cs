using System.Reflection;
using UnityEngine.Events;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class UnityEventButton : BaseButton
	{
		public UnityEvent onClicked;

		public override void OnButtonPressed(bool isLeft)
		{
			onClicked?.Invoke();
		}
	}
}
