using GorillaLocomotion;
using UnityEngine;

[RequireComponent(typeof(Collider))]
public class HeadEnterToggle : MonoBehaviour
{
	[Tooltip("Set the Collider on this GameObject to 'Is Trigger'.")]
	[SerializeField]
	private GameObject objectToToggle;

	private void OnTriggerEnter(Collider other)
	{
		if (!(Player.Instance == null) && !(objectToToggle == null) && !(other != Player.Instance.headCollider))
		{
			objectToToggle.SetActive(true);
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (!(Player.Instance == null) && !(objectToToggle == null) && !(other != Player.Instance.headCollider))
		{
			objectToToggle.SetActive(false);
		}
	}
}
