using System.Reflection;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Opposer
{
	public class OpposerPlayer : MonoBehaviourPun
	{
		[Header("Health")]
		public float maxHealth = 100f;

		public float currentHealth = 100f;

		[Header("Armor")]
		public bool hasArmor;

		public GameObject helmetObject;

		public GameObject vestObject;

		[Header("Zone State")]
		public bool isInSafeZone;

		public bool hasSpawnProtection;

		[Header("Stats")]
		public int deathCount;

		[Header("Ground Slam")]
		[Tooltip("Landing speed (m/s) needed to trigger a ground slam")]
		public float groundSlamThreshold = 15f;

		[Tooltip("Slam radius at threshold speed; scales with impact")]
		public float groundSlamRadius = 5f;

		[Tooltip("Slam damage at the epicentre at threshold speed")]
		public float groundSlamBaseDamage = 30f;

		public ParticleSystem groundSlamEffect;

		public AudioClip groundSlamSound;

		[Header("Audio")]
		public AudioSource damageAudioSource;

		public AudioClip[] damageSounds;

		public AudioClip deathSound;

		private const float ArmoredDamageScale = 0.5f;

		private const string KillsKey = "OpposerKills";

		private MonkeDevNetworkingPlayer _networkPlayer;

		private float _protectionEndsAt;

		private Vector3 _previousVelocity;

		private bool _wasTouching = true;

		private void Awake()
		{
			_networkPlayer = GetComponent<MonkeDevNetworkingPlayer>();
		}

		private void Update()
		{
			if (hasSpawnProtection && Time.time >= _protectionEndsAt)
			{
				hasSpawnProtection = false;
			}
			if (photonView.IsMine)
			{
				TrackLanding();
			}
		}

		private void TrackLanding()
		{
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (instance == null)
			{
				return;
			}
			Vector3 linearVelocity = instance.playerRigidBody.linearVelocity;
			bool flag = instance.wasLeftHandTouching || instance.wasRightHandTouching;
			if (flag && !_wasTouching)
			{
				float num = Mathf.Abs(_previousVelocity.y);
				if (num >= groundSlamThreshold)
				{
					BroadcastGroundSlam(num);
				}
			}
			_previousVelocity = linearVelocity;
			_wasTouching = flag;
		}

		private void BroadcastGroundSlam(float impactSpeed)
		{
			if (!(OpposerGameMode.Instance == null) && PhotonNetwork.InRoom)
			{
				float num = groundSlamRadius * (impactSpeed / groundSlamThreshold);
				photonView.RPC("RPC_GroundSlam", RpcTarget.All, transform.position, impactSpeed, num);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_GroundSlam(Vector3 position, float impactVelocity, float radius)
		{
			if (groundSlamEffect != null)
			{
				groundSlamEffect.transform.position = position;
				groundSlamEffect.Emit((int)(impactVelocity * 5f));
			}
			if (damageAudioSource != null && groundSlamSound != null)
			{
				damageAudioSource.PlayOneShot(groundSlamSound, Mathf.Clamp01(impactVelocity * 0.05f));
			}
			if (photonView.IsMine)
			{
				ApplySlamDamage(position, impactVelocity, radius);
			}
		}

		private void ApplySlamDamage(Vector3 epicentre, float impactSpeed, float radius)
		{
			OpposerGameMode instance = OpposerGameMode.Instance;
			if (instance == null)
			{
				return;
			}
			foreach (OpposerPlayer allPlayer in instance.allPlayers)
			{
				if (!(allPlayer == null) && !(allPlayer == this) && !allPlayer.isInSafeZone && !allPlayer.hasSpawnProtection)
				{
					float num = Vector3.Distance(epicentre, allPlayer.transform.position);
					if (!(num > radius))
					{
						SendSlamHit(allPlayer, num, radius, impactSpeed);
					}
				}
			}
		}

		private void SendSlamHit(OpposerPlayer victim, float distance, float radius, float impactSpeed)
		{
			float num = (1f - distance / radius) * groundSlamBaseDamage * (impactSpeed / groundSlamThreshold);
			victim.photonView.RPC("RPC_TakeDamage", RpcTarget.All, num, photonView.OwnerActorNr, "Ground Slam");
		}

		public void InitializeForOpposer()
		{
			RestoreCombatState();
			if (photonView.IsMine)
			{
				ExitGames.Client.Photon.Hashtable hashtable = new ExitGames.Client.Photon.Hashtable();
				hashtable[KillsKey] = 0;
				photonView.Owner.SetCustomProperties(hashtable);
			}
			deathCount = 0;
			RemoveArmor();
		}

		public void ResetOpposerState()
		{
			RestoreCombatState();
		}

		private void RestoreCombatState()
		{
			currentHealth = maxHealth;
			hasArmor = false;
			isInSafeZone = false;
			hasSpawnProtection = false;
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		public void RPC_TakeDamage(float damage, int attackerActorNumber, string damageSource)
		{
			if (isInSafeZone || hasSpawnProtection)
			{
				return;
			}
			currentHealth -= (hasArmor ? (damage * ArmoredDamageScale) : damage);
			if (damageAudioSource != null && damageSounds != null && damageSounds.Length != 0)
			{
				damageAudioSource.PlayOneShot(damageSounds[Random.Range(0, damageSounds.Length)]);
			}
			if (currentHealth <= 0f)
			{
				currentHealth = 0f;
				Die(attackerActorNumber, damageSource);
			}
		}

		public void TakeDamage(float damage, PhotonView attackerView, string damageSource = "Unknown")
		{
			if (!photonView.IsMine)
			{
				Debug.LogWarning("[OpposerPlayer] TakeDamage called on non-owned player!");
				return;
			}
			int num = ((attackerView != null) ? attackerView.OwnerActorNr : (-1));
			photonView.RPC("RPC_TakeDamage", RpcTarget.All, damage, num, damageSource);
		}

		private void Die(int killerActorNumber, string damageSource)
		{
			deathCount++;
			if (damageAudioSource != null && deathSound != null)
			{
				damageAudioSource.PlayOneShot(deathSound);
			}
			OpposerGameMode instance = OpposerGameMode.Instance;
			if (!(instance == null))
			{
				OpposerPlayer killer = FindByActor(instance, killerActorNumber);
				instance.OnPlayerDeath(this, killer);
			}
		}

		private static OpposerPlayer FindByActor(OpposerGameMode mode, int actorNumber)
		{
			foreach (OpposerPlayer allPlayer in mode.allPlayers)
			{
				if (allPlayer != null && allPlayer.photonView.OwnerActorNr == actorNumber)
				{
					return allPlayer;
				}
			}
			return null;
		}

		public void Respawn(float protectionDuration)
		{
			currentHealth = maxHealth;
			hasSpawnProtection = true;
			_protectionEndsAt = Time.time + protectionDuration;
			hasArmor = false;
		}

		public void EquipArmor()
		{
			hasArmor = true;
		}

		public void RemoveArmor()
		{
			hasArmor = false;
		}

		public void Heal(float amount)
		{
			currentHealth = Mathf.Min(currentHealth + amount, maxHealth);
		}

		public void SetInSafeZone(bool inSafeZone)
		{
			isInSafeZone = inSafeZone;
		}

		public static float GetDamageMultiplier(string bodyPartName)
		{
			switch (bodyPartName)
			{
			case "Head":
				return 5f;
			case "HumanoidRootPart":
			case "Torso":
			case "UpperTorso":
			case "LowerTorso":
				return 1f;
			default:
				return 0.5f;
			}
		}
	}
}
