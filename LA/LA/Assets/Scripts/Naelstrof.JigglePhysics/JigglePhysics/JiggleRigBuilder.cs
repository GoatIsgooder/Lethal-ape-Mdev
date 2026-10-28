using System;
using System.Collections.Generic;
using UnityEngine;

namespace JigglePhysics
{
	public class JiggleRigBuilder : MonoBehaviour
	{
		[Serializable]
		public class JiggleRig
		{
			[Tooltip("The root bone from which an individual JiggleRig will be constructed. The JiggleRig encompasses all children of the specified root.")]
			public Transform rootTransform;

			[Tooltip("The settings that the rig should update with, create them using the Create->JigglePhysics->Settings menu option.")]
			public JiggleSettingsBase jiggleSettings;

			[Tooltip("The list of transforms to ignore during the jiggle. Each bone listed will also ignore all the children of the specified bone.")]
			public List<Transform> ignoredTransforms;

			[HideInInspector]
			public List<JiggleBone> simulatedPoints;
		}

		[Tooltip("Enables interpolation for the simulation, this should be enabled unless you *really* need the simulation to only update on FixedUpdate.")]
		public bool interpolate;

		public List<JiggleRig> jiggleRigs;

		[Tooltip("An air force that is applied to the entire rig, this is useful to plug in some wind volumes from external sources.")]
		public Vector3 wind;

		[Tooltip("Draws some simple lines to show what the simulation is doing. Generally this should be disabled.")]
		[SerializeField]
		private bool debugDraw;

		private const float smoothing = 1f;

		private double accumulation;

		private void Awake()
		{
		}

		private void LateUpdate()
		{
		}

		private void FixedUpdate()
		{
		}

		private void CreateSimulatedPoints(JiggleRig rig, Transform currentTransform, JiggleBone parentJiggleBone)
		{
		}
	}
}
