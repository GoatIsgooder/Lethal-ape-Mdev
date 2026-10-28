using LethalApeR;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;

namespace LALocomotion
{
	[DefaultExecutionOrder(-160)]
	[DisallowMultipleComponent]
	public class LATurn : MonoBehaviour
	{
		public LAPlayer player;

		public float snapAngle = 45f;

		[Tooltip("Degrees per second at full stick.")]
		public float smoothSpeed = 180f;

		[Tooltip("Stick deflection that fires a snap turn.")]
		public float snapPress = 0.5f;

		[Tooltip("The stick has to come back under this before the next snap (also the smooth-turn deadzone).")]
		public float snapRearm = 0.1f;

		private bool _armed = true;

		private void Update()
		{
			if (player == null)
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (instance == null)
			{
				return;
			}
			float x = Mathf.Clamp(instance.RightJoystick.x, -1f, 1f);
			float magnitude = Mathf.Abs(x);
			switch (TurnController.currentTurnMode)
			{
			case TurnController.TurnMode.Smooth:
				if (magnitude > snapRearm)
				{
					player.Turn(x * smoothSpeed * Time.deltaTime);
				}
				break;
			case TurnController.TurnMode.Snap:
				if (_armed && magnitude > snapPress)
				{
					player.Turn((x < 0f) ? (0f - snapAngle) : snapAngle);
					_armed = false;
				}
				else if (magnitude < snapRearm)
				{
					_armed = true;
				}
				break;
			}
		}
	}
}
