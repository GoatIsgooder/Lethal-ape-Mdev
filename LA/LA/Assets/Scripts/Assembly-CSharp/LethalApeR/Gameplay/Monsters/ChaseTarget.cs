using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class ChaseTarget : MonoBehaviour
	{
		[Tooltip("Optional: chase this transform (e.g. the head) instead of this object's root.")]
		[SerializeField]
		private Transform _targetOverride;

		private Transform _registered;

		public Transform TargetTransform => (_targetOverride != null) ? _targetOverride : base.transform;

		private void OnEnable()
		{
			_registered = TargetTransform;
			ChaseTargetRegistry.Register(_registered);
		}

		private void OnDisable()
		{
			Release();
		}

		private void OnDestroy()
		{
			Release();
		}

		private void Release()
		{
			if (!(_registered == null))
			{
				ChaseTargetRegistry.Unregister(_registered);
				_registered = null;
			}
		}
	}
}
