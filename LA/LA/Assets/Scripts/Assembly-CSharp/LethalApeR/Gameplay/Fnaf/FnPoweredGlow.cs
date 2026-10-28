using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnPoweredGlow : MonoBehaviour
	{
		public Renderer target;

		[Tooltip("The material slot on the renderer that lights up.")]
		public int materialIndex;

		public Material powered;

		public Material unpowered;

		private Material[] _slots;

		private int _state = -1;

		private void OnEnable()
		{
			if (target == null)
			{
				target = GetComponent<Renderer>();
			}
			_state = -1;
		}

		private void LateUpdate()
		{
			if (target == null)
			{
				return;
			}
			FnNight instance = FnNight.Instance;
			bool flag = instance != null && instance.InNightRoom && instance.Blackout;
			int num = ((!flag) ? 1 : 0);
			if (num == _state)
			{
				return;
			}
			_state = num;
			if (_slots == null)
			{
				_slots = target.sharedMaterials;
			}
			if (materialIndex >= 0 && materialIndex < _slots.Length)
			{
				Material material = (flag ? unpowered : powered);
				if (!(material == null) && !(_slots[materialIndex] == material))
				{
					_slots[materialIndex] = material;
					target.sharedMaterials = _slots;
				}
			}
		}
	}
}
