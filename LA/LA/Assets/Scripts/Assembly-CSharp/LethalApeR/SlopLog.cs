using System.Diagnostics;
using UnityEngine;
using Debug = UnityEngine.Debug;

namespace LethalApeR
{
	public static class SlopLog
	{
		[Conditional("SLOP_VERBOSE_LOGS")]
		public static void Verbose(object message)
		{
			Debug.Log(message);
		}

		[Conditional("SLOP_VERBOSE_LOGS")]
		public static void Verbose(object message, Object context)
		{
			Debug.Log(message, context);
		}
	}
}
