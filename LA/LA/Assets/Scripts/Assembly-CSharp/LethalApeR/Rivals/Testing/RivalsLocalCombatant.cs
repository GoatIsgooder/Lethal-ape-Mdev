using LethalApeR.Rivals.Combat;
using UnityEngine;

namespace LethalApeR.Rivals.Testing
{
	public class RivalsLocalCombatant : MonoBehaviour, IDamageable
	{
		public Team team = Team.TeamA;

		public float maxHealth = 100f;

		private float _hp;

		private bool _alive = true;

		public Team Team => team;

		public bool IsAlive => _alive;

		private void OnEnable()
		{
			_hp = maxHealth;
			_alive = true;
			CombatantRegistry.Register(this);
		}

		private void OnDisable()
		{
			_alive = false;
			CombatantRegistry.Unregister(this);
		}

		public void SetTeam(Team t)
		{
			team = t;
		}

		public void ReviveFull()
		{
			_hp = maxHealth;
			_alive = true;
		}

		public void ApplyDamage(in DamageInfo info)
		{
			if (base.isActiveAndEnabled && _alive)
			{
				_hp = Mathf.Max(0f, _hp - info.ResolvedAmount);
				RivalsEvents.RaiseLocalDamaged(info.ResolvedAmount, info.IsHeadshot, info.AttackerActorNumber);
				if (_hp <= 0f)
				{
					_alive = false;
				}
			}
		}

		public void ApplyHeal(float amount, int healerActor)
		{
			if (base.isActiveAndEnabled && _alive)
			{
				_hp = Mathf.Min(maxHealth, _hp + amount);
			}
		}

		void IDamageable.ApplyDamage(in DamageInfo info)
		{
			ApplyDamage(in info);
		}
	}
}
