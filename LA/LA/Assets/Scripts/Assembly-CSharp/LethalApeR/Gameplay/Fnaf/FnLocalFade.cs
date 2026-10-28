using System.Collections;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnLocalFade
	{
		private static object _owner;

		public static bool Dark => _owner != null;

		private static bool MoveInFlight
		{
			get
			{
				if (FnMatchmaker.Instance != null)
				{
					return FnMatchmaker.Instance.Busy;
				}
				return false;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_owner = null;
		}

		public static bool IsDarkBy(object owner)
		{
			if (owner != null)
			{
				return _owner == owner;
			}
			return false;
		}

		public static IEnumerator Out(object owner, float seconds)
		{
			if (owner != null && !MoveInFlight && (_owner == null || _owner == owner))
			{
				_owner = owner;
				yield return FnPlatform.FadeOut(seconds);
			}
		}

		public static IEnumerator In(object owner, float seconds)
		{
			if (!IsDarkBy(owner))
			{
				yield break;
			}
			if (MoveInFlight)
			{
				_owner = null;
				yield break;
			}
			yield return FnPlatform.FadeIn(seconds);
			if (_owner == owner)
			{
				_owner = null;
			}
		}

		public static void ClearNow(object owner)
		{
			if (IsDarkBy(owner))
			{
				_owner = null;
				if (!MoveInFlight)
				{
					RunNow(FnPlatform.FadeIn(0f), 0);
				}
			}
		}

		private static void RunNow(IEnumerator routine, int depth)
		{
			if (routine == null || depth > 4)
			{
				return;
			}
			for (int i = 0; i < 16; i++)
			{
				if (!routine.MoveNext())
				{
					break;
				}
				if (routine.Current is IEnumerator routine2)
				{
					RunNow(routine2, depth + 1);
				}
			}
		}
	}
}
