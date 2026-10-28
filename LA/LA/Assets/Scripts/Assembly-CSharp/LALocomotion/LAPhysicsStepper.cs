using UnityEngine;

namespace LALocomotion
{
	[DefaultExecutionOrder(-1000)]
	[DisallowMultipleComponent]
	public class LAPhysicsStepper : MonoBehaviour
	{
		[Tooltip("Off = Unity's fixed step (what ships in Slop today), for comparison.")]
		public bool stepPerFrame = true;

		[Tooltip("Longest single step. A longer frame (a hitch) is split into equal steps.")]
		public float maxStep = 1f / 60f;

		private bool _switched;

		private SimulationMode _savedMode;

		private void OnEnable()
		{
			Apply();
		}

		private void OnDisable()
		{
			Restore();
		}

		private void OnValidate()
		{
			if (isActiveAndEnabled && Application.isPlaying)
			{
				Apply();
			}
		}

		private void Apply()
		{
			if (!stepPerFrame)
			{
				Restore();
			}
			else if (!_switched)
			{
				_savedMode = Physics.simulationMode;
				Physics.simulationMode = SimulationMode.Script;
				_switched = true;
			}
		}

		private void Restore()
		{
			if (_switched)
			{
				Physics.simulationMode = _savedMode;
				_switched = false;
			}
		}

		private void Update()
		{
			if (!_switched)
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			if (!(deltaTime <= 0f))
			{
				int steps = Mathf.Max(1, Mathf.CeilToInt(deltaTime / Mathf.Max(maxStep, 0.001f) - 0.001f));
				float step = deltaTime / (float)steps;
				for (int i = 0; i < steps; i++)
				{
					Physics.Simulate(step);
				}
			}
		}
	}
}
