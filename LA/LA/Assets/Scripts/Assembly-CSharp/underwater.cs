using GorillaLocomotion;
using UnityEngine;

public class underwater : MonoBehaviour
{
	public Swimmy swimmy;

	public AudioLowPassFilter muffle;

	private bool _inside;

	private void OnTriggerEnter(Collider other)
	{
		if (IsLocalHead(other))
		{
			SetInside(true);
		}
	}

	private void OnTriggerExit(Collider other)
	{
		if (IsLocalHead(other))
		{
			SetInside(false);
		}
	}

	private void OnDisable()
	{
		SetInside(false);
	}

	private void SetInside(bool inside)
	{
		if (_inside != inside)
		{
			_inside = inside;
			if (swimmy != null)
			{
				swimmy.enabled = inside;
			}
			if (muffle != null)
			{
				muffle.enabled = inside;
			}
		}
	}

	private static bool IsLocalHead(Collider other)
	{
		if (Player.HasInstance && Player.Instance.headCollider != null)
		{
			return other == Player.Instance.headCollider;
		}
		return false;
	}
}
