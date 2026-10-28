using LALocomotion;
using Locomotion.Scripts;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public static class BtmHands
	{
		public const int Count = 2;

		private static readonly BtmHand[] Hands = new BtmHand[2]
		{
			new BtmHand(left: true),
			new BtmHand(left: false)
		};

		private static float _nextScan;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			BtmHand[] hands = Hands;
			foreach (BtmHand hand in hands)
			{
				hand.la = null;
				hand.old = null;
			}
			_nextScan = 0f;
		}

		public static BtmHand At(int index)
		{
			Refresh();
			return Hands[index];
		}

		public static BtmHand Of(bool left)
		{
			return At((!left) ? 1 : 0);
		}

		public static BtmHand Holding(Rigidbody body)
		{
			for (int i = 0; i < 2; i++)
			{
				if (At(i).HoldsItem(body))
				{
					return Hands[i];
				}
			}
			return null;
		}

		public static BtmHand Nearest(Vector3 position, float maxDistance)
		{
			BtmHand result = null;
			float best = maxDistance * maxDistance;
			for (int i = 0; i < 2; i++)
			{
				BtmHand hand = At(i);
				if (hand.Present)
				{
					float sqr = (hand.Palm - position).sqrMagnitude;
					if (sqr < best)
					{
						best = sqr;
						result = hand;
					}
				}
			}
			return result;
		}

		private static void Refresh()
		{
			bool anyPresent = false;
			bool stale = false;
			BtmHand[] hands = Hands;
			foreach (BtmHand hand in hands)
			{
				if ((object)hand.la != null)
				{
					if (hand.la == null || !hand.la.isActiveAndEnabled)
					{
						stale = true;
					}
				}
				else if ((object)hand.old != null)
				{
					stale |= hand.old == null;
				}
				anyPresent |= hand.Present;
			}
			if (!stale && Time.unscaledTime < _nextScan)
			{
				return;
			}
			_nextScan = Time.unscaledTime + (anyPresent ? 2f : 1f);
			hands = Hands;
			foreach (BtmHand hand2 in hands)
			{
				hand2.la = null;
				hand2.old = null;
			}
			LAGrabber[] grabbers = Object.FindObjectsByType<LAGrabber>(FindObjectsSortMode.None);
			foreach (LAGrabber grabber in grabbers)
			{
				if (grabber.isActiveAndEnabled)
				{
					Hands[(!grabber.isLeft) ? 1 : 0].la = grabber;
				}
			}
			GrabInteractor[] interactors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
			foreach (GrabInteractor interactor in interactors)
			{
				BtmHand hand3 = Hands[(interactor.node != XRNode.LeftHand) ? 1 : 0];
				if (hand3.la == null && (hand3.old == null || interactor.isActiveAndEnabled))
				{
					hand3.old = interactor;
				}
			}
		}
	}
}
