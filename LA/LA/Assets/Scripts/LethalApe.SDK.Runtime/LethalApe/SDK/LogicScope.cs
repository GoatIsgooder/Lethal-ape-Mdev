using UnityEngine;

namespace LethalApe.SDK
{
	public enum LogicScope
	{
		[Tooltip("Only the player who triggered it sees the result.")]
		LocalPlayer = 0,
		[Tooltip("Everyone in the room sees the result, including players who join later.")]
		Everyone = 1
	}
}
