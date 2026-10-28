using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	[DisallowMultipleComponent]
	[AddComponentMenu(null)]
	public sealed class KillCamView : MonoBehaviour
	{
		private static int s_live;

		private static Camera s_hmd;

		private static int s_hmdCullingMask;

		private static AudioListener s_hmdListener;

		private bool _counted;

		private SlopColorGrade _hiddenGrade;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			s_live = 0;
			s_hmd = null;
			s_hmdCullingMask = 0;
			s_hmdListener = null;
		}

		private void OnEnable()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			Camera camera = ((player != null) ? player.mainCamera : null);
			if (camera == null)
			{
				return;
			}
			_counted = true;
			if (s_live++ == 0)
			{
				s_hmd = camera;
				s_hmdCullingMask = camera.cullingMask;
				camera.cullingMask = 0;
				if (camera.TryGetComponent<AudioListener>(out var component) && component.enabled)
				{
					component.enabled = false;
					s_hmdListener = component;
				}
			}
			if (camera.TryGetComponent<SlopColorGrade>(out _hiddenGrade))
			{
				_hiddenGrade.Hide();
			}
		}

		private void OnDisable()
		{
			if (_hiddenGrade != null)
			{
				_hiddenGrade.Unhide();
			}
			_hiddenGrade = null;
			if (!_counted)
			{
				return;
			}
			_counted = false;
			if (--s_live <= 0)
			{
				if (s_hmd != null)
				{
					s_hmd.cullingMask = s_hmdCullingMask;
				}
				if (s_hmdListener != null)
				{
					s_hmdListener.enabled = true;
				}
				s_hmd = null;
				s_hmdListener = null;
			}
		}
	}
}
