using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Logic/Logic Trigger")]
	public sealed class LogicTrigger : ZoneComponent
	{
		[SerializeField]
		[Tooltip("What fires this trigger.")]
		private LogicTriggerType trigger;

		[SerializeField]
		[Tooltip("Button Pressed: the button to listen to.")]
		private MapButton button;

		[SerializeField]
		[Tooltip("Race Finished: the race to listen to.")]
		private RaceCourse race;

		[SerializeField]
		[Min(0.5f)]
		[Tooltip("Timer: seconds between fires.")]
		private float interval = 5f;

		[SerializeField]
		[Tooltip("Timer: keep firing, or fire once.")]
		private bool repeat = true;

		[SerializeField]
		[Tooltip("Only ever fire once per map session.")]
		private bool onceOnly;

		[SerializeField]
		[Min(0f)]
		[Tooltip("Seconds before it can fire again.")]
		private float cooldown = 0.5f;

		[SerializeField]
		[Tooltip("Local Player: only the player who set it off sees the result. Everyone: the whole room does.")]
		private LogicScope scope = LogicScope.Everyone;

		[SerializeField]
		private LogicAction[] actions = new LogicAction[0];

		public LogicTriggerType Trigger => trigger;

		public MapButton Button => button;

		public RaceCourse Race => race;

		public float Interval => interval;

		public bool Repeat => repeat;

		public bool OnceOnly => onceOnly;

		public float Cooldown => cooldown;

		public LogicScope Scope => scope;

		public LogicAction[] Actions => actions;

		public bool UsesZone => trigger == LogicTriggerType.PlayerEnters || trigger == LogicTriggerType.PlayerExits;
	}
}
