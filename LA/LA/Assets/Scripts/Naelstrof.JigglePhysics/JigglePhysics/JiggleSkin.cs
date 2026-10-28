using System;
using System.Collections.Generic;
using UnityEngine;

namespace JigglePhysics
{
	public class JiggleSkin : MonoBehaviour
	{
		[Serializable]
		public class JiggleZone
		{
			[Tooltip("The transform from which the zone effects, this is used as the 'center'.")]
			public Transform target;

			[Tooltip("How large of a radius the zone should effect, in target-space meters. (Scaling the target will effect the radius.)")]
			public float radius;

			[Tooltip("The settings that the skin should update with, create them using the Create->JigglePhysics->Settings menu option.")]
			public JiggleSettingsBase jiggleSettings;

			[HideInInspector]
			public JigglePoint simulatedPoint;
		}

		[Tooltip("Enables interpolation for the simulation, this should be enabled unless you *really* need the simulation to only update on FixedUpdate.")]
		public bool interpolate;

		public List<JiggleZone> jiggleZones;

		[SerializeField]
		[Tooltip("The list of skins to send the deformation data too, they should have JiggleSkin-compatible materials!")]
		public List<SkinnedMeshRenderer> targetSkins;

		[Tooltip("An air force that is applied to the entire rig, this is useful to plug in some wind volumes from external sources.")]
		public Vector3 wind;

		[SerializeField]
		[Tooltip("Draws some simple lines to show what the simulation is doing. Generally this should be disabled.")]
		private bool debugDraw;

		private double accumulation;

		private List<Material> targetMaterials;

		private List<Vector4> packedVectors;

		private int jiggleInfoNameID;

		private const float smoothing = 1f;

		private void Start()
		{
		}

		private void LateUpdate()
		{
		}

		private void UpdateMesh()
		{
		}

		private void FixedUpdate()
		{
		}

		private void OnValidate()
		{
		}

		private void OnDrawGizmosSelected()
		{
		}

		public Vector3 ApplyJiggle(Vector3 toPoint, float blend)
		{
			return default(Vector3);
		}
	}
}
