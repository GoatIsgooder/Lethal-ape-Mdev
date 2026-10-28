using LALocomotion;
using Locomotion.Scripts;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmHand
	{
		public readonly bool isLeft;

		internal LAGrabber la;

		internal GrabInteractor old;

		public LAGrabber La => la;

		public bool Present
		{
			get
			{
				if (la != null)
				{
					return true;
				}
				if (old != null)
				{
					return old.palm != null;
				}
				return false;
			}
		}

		public Vector3 Palm
		{
			get
			{
				if (la != null)
				{
					return la.GrabPosition;
				}
				if (old != null && old.palm != null)
				{
					return old.palm.position;
				}
				return Vector3.zero;
			}
		}

		public float Grip
		{
			get
			{
				if (la != null)
				{
					return la.Grip;
				}
				VRInputController instance = VRInputController.Instance;
				if (instance == null)
				{
					return 0f;
				}
				return isLeft ? instance.LeftGripValue : instance.RightGripValue;
			}
		}

		public bool HoldingSomething
		{
			get
			{
				if (la != null)
				{
					return la.Busy;
				}
				if (old != null)
				{
					return old.IsGrabbing;
				}
				return false;
			}
		}

		internal BtmHand(bool left)
		{
			isLeft = left;
		}

		public bool HoldsHandle(Transform handle)
		{
			if (handle == null)
			{
				return false;
			}
			if (la != null)
			{
				if (la.HeldHandle != null)
				{
					return la.HeldHandle.transform == handle;
				}
				return false;
			}
			if (old != null && old.IsGrabbing)
			{
				return old.HeldTransform == handle;
			}
			return false;
		}

		public bool HoldsItem(Rigidbody body)
		{
			if (body == null)
			{
				return false;
			}
			if (la != null)
			{
				if (!Is(la.Held, body))
				{
					return Is(la.Supporting, body);
				}
				return true;
			}
			if (old != null)
			{
				return old.HeldRigidbody == body;
			}
			return false;
		}

		private static bool Is(LAGrabbable item, Rigidbody body)
		{
			if (item != null)
			{
				if (!(item.transform == body.transform))
				{
					return body.transform.IsChildOf(item.transform);
				}
				return true;
			}
			return false;
		}

		public void Pulse(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null) && !(duration <= 0f) && !(amplitude <= 0f))
			{
				if (isLeft)
				{
					instance.PulseLeft(amplitude, duration);
				}
				else
				{
					instance.PulseRight(amplitude, duration);
				}
			}
		}

		public void Suspend(object owner)
		{
			LAPlayer lAPlayer = ((la != null) ? la.player : null);
			if (lAPlayer != null)
			{
				lAPlayer.SuspendHand(isLeft, owner);
			}
		}

		public void Resume(object owner)
		{
			LAPlayer lAPlayer = ((la != null) ? la.player : null);
			if (lAPlayer != null)
			{
				lAPlayer.ResumeHand(isLeft, owner);
			}
		}
	}
}
