using System.Reflection;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class ElevatorButton : BaseButton
	{
		[Tooltip("Empty = the Elevator this button sits inside.")]
		public Elevator elevator;

		[Tooltip("Step buttons: on = next floor up, off = next floor down.")]
		public bool goUp;

		[Tooltip("-1 = step up/down. 0 or more = send the car to (or call it to) that floor index.")]
		public int targetFloor = -1;

		[Tooltip("Seconds between accepted presses, so a hand resting in the trigger can't spam requests.")]
		public float rpcCooldown = 0.5f;

		private float _nextPressTime;

		public override void OnButtonPressed(bool isLeft)
		{
			float time = Time.time;
			if (time < _nextPressTime)
			{
				return;
			}
			_nextPressTime = time + rpcCooldown;
			if (elevator == null)
			{
				elevator = GetComponentInParent<Elevator>();
			}
			if (elevator == null)
			{
				return;
			}
			if (targetFloor >= 0)
			{
				elevator.RequestFloor(targetFloor);
			}
			else
			{
				elevator.ToggleElevator(goUp);
			}
		}
	}
}
