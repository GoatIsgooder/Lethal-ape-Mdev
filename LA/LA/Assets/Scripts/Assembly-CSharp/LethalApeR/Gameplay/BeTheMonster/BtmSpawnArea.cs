using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[RequireComponent(typeof(BoxCollider))]
	public class BtmSpawnArea : MonoBehaviour
	{
		private static BtmSpawnArea _instance;

		private Vector3 _center;

		private Vector3 _half;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_instance = null;
		}

		private void Awake()
		{
			BoxCollider component = GetComponent<BoxCollider>();
			_center = component.center;
			_half = component.size * 0.5f;
			component.enabled = false;
		}

		private void OnEnable()
		{
			_instance = this;
		}

		private void OnDisable()
		{
			if (_instance == this)
			{
				_instance = null;
			}
		}

		public static bool Contains(Vector3 world)
		{
			if (_instance != null)
			{
				return _instance.ContainsPoint(world);
			}
			return false;
		}

		private bool ContainsPoint(Vector3 world)
		{
			Vector3 vector = base.transform.InverseTransformPoint(world) - _center;
			if (Mathf.Abs(vector.x) <= _half.x && Mathf.Abs(vector.y) <= _half.y)
			{
				return Mathf.Abs(vector.z) <= _half.z;
			}
			return false;
		}
	}
}
