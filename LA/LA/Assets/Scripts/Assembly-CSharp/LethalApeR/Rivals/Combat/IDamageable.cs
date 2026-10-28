namespace LethalApeR.Rivals.Combat
{
	public interface IDamageable
	{
		Team Team { get; }

		bool IsAlive { get; }

		void ApplyDamage(in DamageInfo info);

		void ApplyHeal(float amount, int healerActor);
	}
}
