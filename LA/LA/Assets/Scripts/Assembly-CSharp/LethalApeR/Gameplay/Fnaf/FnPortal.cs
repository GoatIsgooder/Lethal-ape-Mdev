using LethalApeR.SceneFlow;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnPortal : FnButton
	{
		[Tooltip("Exact Build Settings scene name.")]
		public string sceneName = "FNAF";

		private bool _going;

		private void OnEnable()
		{
			Pressed += Go;
		}

		private void OnDisable()
		{
			Pressed -= Go;
		}

		private void Go(bool _)
		{
			if (_going)
			{
				return;
			}
			if (FnMatchmaker.Instance != null && FnMatchmaker.Instance.Busy)
			{
				FlashRefused();
				return;
			}
			if (SceneTransition.Go(sceneName, new SceneTransition.Options
			{
				fadeOut = 0.35f,
				fadeIn = 0.5f,
				leaveRoom = true
			}))
			{
				_going = true;
				SetLit(true);
			}
			else
			{
				FlashRefused();
			}
		}
	}
}
