using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Rivals.Combat;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Rivals.Testing
{
	public class RivalsDummy : MonoBehaviour, IDamageable
	{
		[Header("Target")]
		[Tooltip("Team this dummy belongs to. Default TeamB so a TeamA tester can shoot it.")]
		public Team team = Team.TeamB;

		public float maxHealth = 100f;

		[SerializeField]
		private float currentHealth = 100f;

		[Tooltip("If OFF, a same-team attacker can't damage it (mirrors real friendly-fire rules). In solo tests your rig usually has no team, so it can damage the dummy regardless.")]
		public bool friendlyFire;

		[Header("Respawn")]
		public bool autoRevive = true;

		[Min(0f)]
		public float reviveDelay = 3f;

		[Header("Feedback (all optional)")]
		[Tooltip("Shown while alive (the live model). Hidden on death.")]
		public GameObject aliveVisualRoot;

		[Tooltip("Shown on death (ragdoll / 'down' marker). Hidden while alive.")]
		public GameObject deathVisualRoot;

		[Tooltip("Renderer briefly tinted on each hit. Optional.")]
		public Renderer flashRenderer;

		public Color flashColor = Color.white;

		[Min(0f)]
		public float flashTime = 0.06f;

		[Tooltip("Log each hit to the Console (handy when you have no HUD yet).")]
		public bool logHits;

		[Header("Events")]
		public UnityEvent<float> onDamaged;

		public UnityEvent onDied;

		public UnityEvent onRevived;

		private bool _alive = true;

		private Coroutine _reviveRoutine;

		private Coroutine _flashRoutine;

		private Color _flashBaseColor;

		private bool _flashBaseCached;

		public Team Team => team;

		public bool IsAlive => _alive;

		public float CurrentHealth => currentHealth;

		public float MaxHealth => maxHealth;

		public float HealthNormalized
		{
			get
			{
				if (!(maxHealth > 0f))
				{
					return 0f;
				}
				return Mathf.Clamp01(currentHealth / maxHealth);
			}
		}

		private void Awake()
		{
			currentHealth = maxHealth;
			_alive = true;
			if (aliveVisualRoot != null)
			{
				aliveVisualRoot.SetActive(true);
			}
			if (deathVisualRoot != null)
			{
				deathVisualRoot.SetActive(false);
			}
		}

		private void OnEnable()
		{
			CombatantRegistry.Register(this);
		}

		private void OnDisable()
		{
			CombatantRegistry.Unregister(this);
		}

		public void ApplyDamage(in DamageInfo info)
		{
			if (!_alive || (!friendlyFire && info.AttackerActorNumber >= 0 && PlayerHealth.TryGet(info.AttackerActorNumber, out var health) && health != null && health.Team.IsSameTeam(team)))
			{
				return;
			}
			float resolvedAmount = info.ResolvedAmount;
			currentHealth = Mathf.Max(0f, currentHealth - resolvedAmount);
			RivalsEvents.RaiseLocalHitDealt(in info, this);
			if (logHits)
			{
				Debug.Log(string.Format("[RivalsDummy] {0} took {1:0.#}{2} ", base.name, resolvedAmount, info.IsHeadshot ? " (HEADSHOT)" : "") + string.Format("from '{0}' → {1:0}/{2:0} HP", info.Source, currentHealth, maxHealth), this);
			}
			onDamaged?.Invoke(resolvedAmount);
			Flash();
			if (currentHealth <= 0f)
			{
				Die();
			}
		}

		public void ApplyHeal(float amount, int healerActor)
		{
			if (!(amount <= 0f) && _alive)
			{
				currentHealth = Mathf.Min(maxHealth, currentHealth + amount);
			}
		}

		private void Die()
		{
			_alive = false;
			if (aliveVisualRoot != null)
			{
				aliveVisualRoot.SetActive(false);
			}
			if (deathVisualRoot != null)
			{
				deathVisualRoot.SetActive(true);
			}
			if (logHits)
			{
				Debug.Log("[RivalsDummy] " + base.name + " died.", this);
			}
			onDied?.Invoke();
			if (autoRevive)
			{
				if (_reviveRoutine != null)
				{
					StopCoroutine(_reviveRoutine);
				}
				_reviveRoutine = StartCoroutine(ReviveAfterDelay());
			}
		}

		private IEnumerator ReviveAfterDelay()
		{
			yield return new WaitForSeconds(reviveDelay);
			Revive();
			_reviveRoutine = null;
		}

		[ContextMenu("Revive")]
		public void Revive()
		{
			currentHealth = maxHealth;
			_alive = true;
			if (aliveVisualRoot != null)
			{
				aliveVisualRoot.SetActive(true);
			}
			if (deathVisualRoot != null)
			{
				deathVisualRoot.SetActive(false);
			}
			onRevived?.Invoke();
		}

		private void Flash()
		{
			if (!(flashRenderer == null) && !(flashTime <= 0f))
			{
				if (!_flashBaseCached)
				{
					_flashBaseColor = flashRenderer.material.color;
					_flashBaseCached = true;
				}
				if (_flashRoutine != null)
				{
					StopCoroutine(_flashRoutine);
				}
				_flashRoutine = StartCoroutine(FlashRoutine());
			}
		}

		private IEnumerator FlashRoutine()
		{
			flashRenderer.material.color = flashColor;
			yield return new WaitForSeconds(flashTime);
			flashRenderer.material.color = _flashBaseColor;
			_flashRoutine = null;
		}

		private void OnValidate()
		{
			if (maxHealth <= 0f)
			{
				maxHealth = 100f;
			}
			currentHealth = Mathf.Clamp(currentHealth, 0f, maxHealth);
		}

		private void OnDrawGizmos()
		{
			Gizmos.color = team.ToColor();
			Gizmos.DrawWireSphere(base.transform.position + Vector3.up, 0.25f);
		}

		void IDamageable.ApplyDamage(in DamageInfo info)
		{
			ApplyDamage(in info);
		}
	}
}
