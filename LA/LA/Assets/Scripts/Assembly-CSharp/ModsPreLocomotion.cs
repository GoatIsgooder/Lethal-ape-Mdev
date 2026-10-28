using UnityEngine;

[DefaultExecutionOrder(-180)]
public sealed class ModsPreLocomotion : MonoBehaviour
{
	private Mods _mods;

	public void Bind(Mods mods)
	{
		_mods = mods;
	}

	private void Update()
	{
		if (_mods != null)
		{
			_mods.PreLocomotionStep();
		}
	}
}
