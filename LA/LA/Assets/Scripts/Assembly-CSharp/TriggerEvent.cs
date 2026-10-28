using LethalApeR;
using UnityEngine;
using UnityEngine.Events;

public class TriggerEvent : MonoBehaviour
{
	[Tooltip("Only colliders with this tag will activate the events.")]
	public string targetTag = "HandTag";

	[Space]
	public UnityEvent onTriggerEnter;

	public UnityEvent onTriggerExit;

	private MenuPressGate _gate;

	private bool _gateResolved;

	private void OnTriggerEnter(Collider other)
	{
		if (!other.CompareTag(targetTag))
		{
			return;
		}
		if (!_gateResolved)
		{
			_gate = MenuPressGate.Find(this);
			_gateResolved = true;
		}
		if (!(_gate != null) || _gate.TryPress(base.gameObject))
		{
			onTriggerEnter?.Invoke();
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (other.CompareTag(targetTag))
		{
			onTriggerExit?.Invoke();
		}
	}
}
