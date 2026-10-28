using UnityEngine;

[DisallowMultipleComponent]
[AddComponentMenu("Slop/Slop Post Process Switch")]
public class SlopPostProcessSwitch : MonoBehaviour
{
	[Tooltip("Ticked = this button turns post-processing ON. Unticked = it turns it OFF.")]
	[SerializeField]
	private bool turnOn = true;

	[Tooltip("Leave empty to find SlopColorGrade on Camera.main. Resolved lazily, so it works even though the player rig spawns after this object.")]
	[SerializeField]
	private SlopColorGrade grade;

	[Tooltip("Log every trigger touch and state change. Turn off once this is confirmed working.")]
	[SerializeField]
	private bool debugLogging = true;

	private void OnTriggerEnter(Collider other)
	{
		if (!(other == null))
		{
			if (debugLogging)
			{
				Debug.Log("[PostSwitch] '" + base.name + "' trigger by '" + other.name + "' tag='" + other.tag + "' " + string.Format("handTag={0}", other.CompareTag("HandTag")), this);
			}
			if (other.CompareTag("HandTag"))
			{
				Apply();
			}
		}
	}

	public void Apply()
	{
		if (Resolve())
		{
			grade.PlayerWantsGrade = turnOn;
			if (debugLogging)
			{
				Debug.Log("[PostSwitch] '" + base.name + "' -> SlopColorGrade on '" + grade.gameObject.name + "' " + string.Format("playerWants={0} enabled={1} (turnOn={2})", grade.PlayerWantsGrade, grade.enabled, turnOn), grade);
			}
		}
	}

	public void SetPostProcessing(bool on)
	{
		if (Resolve())
		{
			grade.PlayerWantsGrade = on;
		}
	}

	public void TogglePostProcessing()
	{
		if (Resolve())
		{
			grade.PlayerWantsGrade = !grade.PlayerWantsGrade;
		}
	}

	private bool Resolve()
	{
		if (grade != null)
		{
			return true;
		}
		Camera main = Camera.main;
		if (main != null)
		{
			grade = main.GetComponent<SlopColorGrade>();
		}
		if (grade == null)
		{
			Debug.LogWarning("[PostSwitch] No SlopColorGrade found on Camera.main (button '" + base.name + "'). Camera.main=" + ((Camera.main == null) ? "NULL" : Camera.main.name) + ". Assign it explicitly if the player camera is not tagged MainCamera.", this);
			return false;
		}
		return true;
	}
}
