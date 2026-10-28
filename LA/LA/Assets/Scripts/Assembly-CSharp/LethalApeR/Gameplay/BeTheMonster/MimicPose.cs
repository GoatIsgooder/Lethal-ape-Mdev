namespace LethalApeR.Gameplay.BeTheMonster
{
	public readonly struct MimicPose
	{
		public readonly float Sweep;

		public readonly float Shape;

		public readonly float Flash;

		public readonly bool Eyes;

		public MimicPose(float sweep, float shape, float flash, bool eyes)
		{
			Sweep = sweep;
			Shape = shape;
			Flash = flash;
			Eyes = eyes;
		}
	}
}
