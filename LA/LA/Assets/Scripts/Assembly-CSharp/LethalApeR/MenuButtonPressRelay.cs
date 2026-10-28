using UnityEngine;

namespace LethalApeR
{
	[DisallowMultipleComponent]
	public sealed class MenuButtonPressRelay : MonoBehaviour
	{
		private MenuButtonPress _owner;

		private int _index = -1;

		private string _tag;

		public void Bind(MenuButtonPress owner, int index, string tag)
		{
			_owner = owner;
			_index = index;
			_tag = tag;
		}

		private void OnTriggerEnter(Collider other)
		{
			if (_owner != null && other.CompareTag(_tag))
			{
				_owner.FingerEnter(_index, other);
			}
		}

		private void OnTriggerExit(Collider other)
		{
			if (_owner != null && other.CompareTag(_tag))
			{
				_owner.FingerExit(_index, other);
			}
		}

		private void OnDisable()
		{
			if (_owner != null)
			{
				_owner.TargetDisabled(_index);
			}
		}
	}
}
