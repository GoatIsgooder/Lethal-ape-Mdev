using UnityEngine;

namespace LethalApeR
{
	public class SetActives : MonoBehaviour
	{
		[Tooltip("Activated when the trigger fires.")]
		public GameObject[] Enable;

		[Tooltip("Deactivated when the trigger fires.")]
		public GameObject[] Disable;

		[Tooltip("React to the head (MainCamera tag) instead of the hands (HandTag).")]
		public bool useMainCameraTag;

		private void OnTriggerEnter(Collider other)
		{
			if (!(other is null) && other.CompareTag(useMainCameraTag ? "MainCamera" : "HandTag"))
			{
				Apply(Enable, true);
				Apply(Disable, false);
			}
		}

		private static void Apply(GameObject[] targets, bool active)
		{
			if (targets == null)
			{
				return;
			}
			for (int i = 0; i < targets.Length; i++)
			{
				if (targets[i] != null)
				{
					targets[i].SetActive(active);
				}
			}
		}
	}
}
