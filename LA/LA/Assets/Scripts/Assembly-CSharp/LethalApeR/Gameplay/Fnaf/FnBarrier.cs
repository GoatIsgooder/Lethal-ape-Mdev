using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnBarrier : MonoBehaviour
	{
		[Tooltip("Colliders the local ghost passes. Empty = every collider on this object and its children.")]
		public Collider[] colliders = new Collider[0];

		private Collider[] _colliders;

		private bool[] _wasOn;

		private bool _open;

		private void Awake()
		{
			_colliders = ((colliders != null && colliders.Length != 0) ? colliders : GetComponentsInChildren<Collider>(includeInactive: true));
			_wasOn = new bool[_colliders.Length];
		}

		private void LateUpdate()
		{
			if (FnGhost.LocalIsGhost)
			{
				Open();
			}
			else if (_open)
			{
				Close();
			}
		}

		private void OnDisable()
		{
			if (_open)
			{
				Close();
			}
		}

		private void Open()
		{
			if (!_open)
			{
				_open = true;
				for (int i = 0; i < _colliders.Length; i++)
				{
					_wasOn[i] = _colliders[i] != null && _colliders[i].enabled;
				}
			}
			for (int j = 0; j < _colliders.Length; j++)
			{
				Collider collider = _colliders[j];
				if (collider != null && collider.enabled)
				{
					collider.enabled = false;
				}
			}
		}

		private void Close()
		{
			_open = false;
			for (int i = 0; i < _colliders.Length; i++)
			{
				Collider collider = _colliders[i];
				if (collider != null && _wasOn[i] && !collider.enabled)
				{
					collider.enabled = true;
				}
			}
		}
	}
}
