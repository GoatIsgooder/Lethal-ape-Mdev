using UnityEngine;

namespace LethalApeR.Gameplay
{
	public interface IBlastReceiver
	{
		Vector3 BlastPivot { get; }

		float BlastBodyRadius { get; }

		void OnBlast(in BlastInfo blast, in BlastHit hit);
	}
}
