using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnBreakerDiagram : MonoBehaviour
	{
		public TMP_Text label;

		private string _shown;

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (!(label == null) && !(instance == null) && instance.Active)
			{
				string text = ((instance.FuseUsesLeft <= 0) ? ("BREAKER ORDER\n-\n" + string.Format("RESETS LEFT {0}", 0)) : ("BREAKER ORDER\n" + FnFuseBox.OrderText(instance.FuseOrder) + "\n" + new string('*', instance.FuseProgress) + new string('.', 3 - instance.FuseProgress) + "\n" + string.Format("RESETS LEFT {0}", instance.FuseUsesLeft)));
				if (!(text == _shown))
				{
					_shown = text;
					label.text = text;
				}
			}
		}
	}
}
