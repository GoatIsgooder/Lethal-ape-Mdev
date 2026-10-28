using System;
using UnityEngine;

namespace LethalApeR
{
	public static class FingertipHand
	{
		private static Collider _lastLeft;

		private static Collider _lastRight;

		public static bool IsLeft(Collider finger)
		{
			if ((object)finger == _lastLeft)
			{
				return true;
			}
			if ((object)finger == _lastRight)
			{
				return false;
			}
			string text = finger.name;
			if (text.IndexOf("LeftFinger", StringComparison.Ordinal) >= 0 || text.IndexOf("L_end", StringComparison.Ordinal) >= 0 || finger.CompareTag("LFinger"))
			{
				_lastLeft = finger;
				return true;
			}
			_lastRight = finger;
			return false;
		}
	}
}
