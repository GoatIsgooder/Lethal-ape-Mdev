using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public abstract class FnPuppetBase : MonoBehaviour
	{
		public FnDifficulty variant;

		[Header("Eyes")]
		[Tooltip("Unlit pupils or glows, tinted through FnAnimatronic's eye logic (_Color).")]
		public Renderer[] eyeGlows = new Renderer[0];

		public Color eyeColor = new Color(1f, 0.95f, 0.85f);

		[Header("Glow")]
		[Tooltip("Lit renderers with an emissive glow (_GlowColor, e.g. Fnaf/MonsterGlow) that follows the eyes: dark while dormant, up while it hunts.")]
		public Renderer[] glowRenderers = new Renderer[0];

		[ColorUsage(false, true)]
		public Color glowColor = Color.black;

		public Action<Vector3, float> OnPlant;

		public abstract float HeadServoScale { get; }

		public virtual bool Crawls => false;

		public virtual bool RaisesPlants => false;

		public abstract bool Staring { get; }

		public abstract Vector3 LensPosition { get; }

		public abstract void EnsureInit();

		public abstract void Snap();

		public abstract void Drive(in FnPuppetInput input);

		protected static bool FeedSees(Vector3 eye, float leanWithin, float margin, out Vector3 lens, out float closeness)
		{
			lens = default(Vector3);
			closeness = 0f;
			FnCameraSystem instance = FnCameraSystem.Instance;
			if (instance == null || instance.Mode != FnCameraSystem.FeedMode.Live)
			{
				return false;
			}
			if (!FnStations.TryGet(instance.ShownStation, out var station) || station.AudioOnly)
			{
				return false;
			}
			Vector3 vector = eye - station.Pose.position;
			float magnitude = vector.magnitude;
			if (magnitude < 0.05f || magnitude > station.Range)
			{
				return false;
			}
			Vector3 vector2 = station.Pose.InverseTransformDirection(vector / magnitude);
			if (vector2.z <= 0.05f)
			{
				return false;
			}
			float num = station.VerticalFov * 0.5f * Mathf.Deg2Rad;
			if (Mathf.Abs(Mathf.Atan2(vector2.y, vector2.z)) > num + margin)
			{
				return false;
			}
			float num2 = Mathf.Atan(Mathf.Tan(num) * Mathf.Max(station.Aspect, 0.5f));
			if (Mathf.Abs(Mathf.Atan2(vector2.x, vector2.z)) > num2 + margin)
			{
				return false;
			}
			lens = station.Pose.position;
			closeness = Mathf.Clamp01(1f - magnitude / Mathf.Max(leanWithin, 0.5f));
			return true;
		}
	}
}
