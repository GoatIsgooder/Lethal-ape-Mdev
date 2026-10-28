using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Logic/Race Course")]
	[DisallowMultipleComponent]
	public sealed class RaceCourse : MapComponent
	{
		[SerializeField]
		private string raceName = "Race";

		[SerializeField]
		private RaceGate startGate;

		[SerializeField]
		[Tooltip("Optional gates that must be passed in this order.")]
		private RaceGate[] checkpoints = new RaceGate[0];

		[SerializeField]
		private RaceGate finishGate;

		[SerializeField]
		[Tooltip("Optional sign that shows the room's best times.")]
		private TextSign resultsSign;

		[SerializeField]
		[Range(1f, 10f)]
		private int resultsShown = 5;

		[SerializeField]
		[Tooltip("Show a running timer on the player's wrist during a run.")]
		private bool wristTimer = true;

		public string RaceName => raceName;

		public RaceGate StartGate => startGate;

		public RaceGate[] Checkpoints => checkpoints;

		public RaceGate FinishGate => finishGate;

		public TextSign ResultsSign => resultsSign;

		public int ResultsShown => resultsShown;

		public bool WristTimer => wristTimer;
	}
}
