using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnPowerHide : MonoBehaviour
	{
		public Renderer[] renderers = new Renderer[0];

		private int _state = -1;

		private void OnEnable()
		{
			_state = -1;
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			bool flag = instance == null || !instance.InNightRoom || !instance.Blackout;
			int num = (flag ? 1 : 0);
			if (num == _state)
			{
				return;
			}
			_state = num;
			for (int i = 0; i < renderers.Length; i++)
			{
				if (renderers[i] != null)
				{
					renderers[i].enabled = flag;
				}
			}
		}
	}
}
