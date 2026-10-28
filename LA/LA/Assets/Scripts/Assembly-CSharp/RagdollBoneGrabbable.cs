using Locomotion.Scripts;
using UnityEngine;

[DisallowMultipleComponent]
public class RagdollBoneGrabbable : MonoBehaviour, IGrabbable, INoReparentOnGrab
{
	[Tooltip("Wired by RagdollManager at setup — leave alone.")]
	public RagdollManager manager;

	[Tooltip("Wired by RagdollManager at setup — leave alone.")]
	public RagdollSystem drive;

	public void OnGrab()
	{
		if ((bool)manager)
		{
			manager.NotifyBoneGrabbed(this);
		}
	}

	public void OnDrop()
	{
		if ((bool)manager)
		{
			manager.NotifyBoneDropped(this);
		}
	}
}
