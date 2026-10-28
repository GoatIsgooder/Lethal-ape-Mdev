using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Networking;
using LethalApeR.Rivals.Weapons;
using Photon.Pun;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Rivals.Combat
{
	[Obfuscation(Exclude = true)]
	public class PlayerHealth : MonoBehaviourPun, IPunObservable, IDamageable, IPoolLifecycle
	{
		[Header("Health")]
		[Tooltip("Maximum hit points. Reset to this on spawn/revive.")]
		[SerializeField]
		private float maxHealth = 100f;

		[SerializeField]
		private float currentHealth = 100f;

		[Header("State (read-only at runtime)")]
		[SerializeField]
		private Team team;

		[SerializeField]
		private bool isAlive = true;

		[SerializeField]
		private bool isInSafeZone;

		[Header("Death visuals (optional, designer-wired)")]
		[Tooltip("Toggled off on death, on again on revive (e.g. the live player model).")]
		[SerializeField]
		private GameObject aliveVisualRoot;

		[Tooltip("Toggled on on death (e.g. a ragdoll or 'down' marker).")]
		[SerializeField]
		private GameObject deathVisualRoot;

		public UnityEvent onDied;

		public UnityEvent onRevived;

		public UnityEvent<float> onDamaged;

		private float spawnProtectionEndTime;

		private static readonly Dictionary<int, PlayerHealth> _byActor = new Dictionary<int, PlayerHealth>();

		private int _registeredActor = -1;

		[Header("Damage hitboxes (auto-built at runtime)")]
		[Tooltip("Build the head + body hitbox colliders on spawn. Leave ON — without them players cannot be shot.")]
		[SerializeField]
		private bool buildHitboxes = true;

		[Tooltip("Layer the hitboxes live on. It is isolated from all physics collisions at runtime, leaving it raycast-only.")]
		[SerializeField]
		private string hitboxLayerName = "RivalsHitbox";

		[Tooltip("Transform the hitboxes track. Defaults to the child named 'Head' (tracks the real head for local AND remote players).")]
		[SerializeField]
		private Transform hitboxAnchor;

		[SerializeField]
		private float headHitboxRadius = 0.18f;

		[SerializeField]
		private Vector3 headHitboxOffset = new Vector3(0f, 0.02f, 0f);

		[SerializeField]
		private float bodyHitboxRadius = 0.26f;

		[SerializeField]
		private float bodyHitboxHeight = 0.8f;

		[Tooltip("How far below the head the body capsule's centre sits (in head-scaled metres).")]
		[SerializeField]
		private float bodyHitboxDrop = 0.45f;

		[Tooltip("Extra offset for the body capsule, relative to the way the player faces (x=right, y=up, z=forward). Use it to nudge a mis-centred body box. Live-editable in Play mode.")]
		[SerializeField]
		private Vector3 bodyHitboxOffset = Vector3.zero;

		private Transform _hbAnchor;

		private SphereCollider _headHitbox;

		private CapsuleCollider _bodyHitbox;

		private bool _hitboxesBuilt;

		private bool _hitboxesAlive = true;

		private static bool _hitboxLayerIsolated;

		private MonkeDevNetworkingPlayer _netPlayer;

		private float _lastFlashHealth;

		[Header("Debug — hitbox gizmos")]
		[Tooltip("Draw this player's hitbox colliders in the Scene view. Green = body (hittable), red = headshot collider, yellow = trigger (weapon rays ignore these), grey = disabled collider.")]
		[SerializeField]
		private bool drawHitboxGizmos = true;

		[Tooltip("Only draw while this object is selected (keeps the Scene view clean when several players are present).")]
		[SerializeField]
		private bool gizmosOnlyWhenSelected;

		[Tooltip("Also draw colliders on inactive children (e.g. cosmetic variants not currently equipped).")]
		[SerializeField]
		private bool gizmosIncludeInactive;

		private static readonly Color GizmoBody = new Color(0.2f, 1f, 0.35f, 0.9f);

		private static readonly Color GizmoHead = new Color(1f, 0.25f, 0.2f, 0.95f);

		private static readonly Color GizmoTrigger = new Color(1f, 0.85f, 0.15f, 0.5f);

		private static readonly Color GizmoDisabled = new Color(0.5f, 0.5f, 0.5f, 0.4f);

		public Team Team => team;

		public bool IsAlive => isAlive;

		public float MaxHealth => maxHealth;

		public float CurrentHealth => currentHealth;

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

		public bool HasSpawnProtection => Time.time < spawnProtectionEndTime;

		public bool IsInSafeZone => isInSafeZone;

		public int ActorNumber
		{
			get
			{
				if (!(base.photonView != null) || base.photonView.Owner == null)
				{
					return -1;
				}
				return base.photonView.Owner.ActorNumber;
			}
		}

		public static IReadOnlyDictionary<int, PlayerHealth> All => _byActor;

		int IPoolLifecycle.PoolCallbackOrder => 200;

		public static bool TryGet(int actorNumber, out PlayerHealth health)
		{
			return _byActor.TryGetValue(actorNumber, out health);
		}

		private void OnEnable()
		{
			RegisterActor();
			CombatantRegistry.Register(this);
		}

		private void Start()
		{
			RegisterActor();
			EnsureHitboxes();
			_netPlayer = GetComponent<MonkeDevNetworkingPlayer>();
			_lastFlashHealth = currentHealth;
		}

		private void OnDisable()
		{
			UnregisterActor();
			CombatantRegistry.Unregister(this);
		}

		private void OnDestroy()
		{
			UnregisterActor();
			CombatantRegistry.Unregister(this);
		}

		private void Update()
		{
			int actorNumber = ActorNumber;
			if (actorNumber >= 0 && actorNumber != _registeredActor)
			{
				RegisterActor();
			}
		}

		private void RegisterActor()
		{
			int actorNumber = ActorNumber;
			if (actorNumber >= 0)
			{
				if (_registeredActor >= 0 && _registeredActor != actorNumber && _byActor.TryGetValue(_registeredActor, out var value) && value == this)
				{
					_byActor.Remove(_registeredActor);
				}
				_registeredActor = actorNumber;
				_byActor[actorNumber] = this;
			}
		}

		private void UnregisterActor()
		{
			if (_registeredActor >= 0 && _byActor.TryGetValue(_registeredActor, out var value) && value == this)
			{
				_byActor.Remove(_registeredActor);
			}
			_registeredActor = -1;
		}

		public void ApplyDamage(in DamageInfo info)
		{
			if (!isAlive || HasSpawnProtection || isInSafeZone || !DamageAllowedByGameState())
			{
				return;
			}
			if (info.AttackerActorNumber >= 0 && TryGet(info.AttackerActorNumber, out var health) && health != null && health.Team.IsSameTeam(team))
			{
				return;
			}
			if (info.AttackerActorNumber >= 0 && TryGet(info.AttackerActorNumber, out var health2) && health2 != null && !health2.IsAlive)
			{
				return;
			}
			if (!(base.photonView == null) && base.photonView.Owner != null)
			{
				Debug.Log(string.Format("[Rivals] Shot landed: {0} hit player {1} ", info.AttackerActorNumber, ActorNumber) + string.Format("for {0:0.#}{1} with '{2}'", info.ResolvedAmount, info.IsHeadshot ? " (HEADSHOT)" : "", info.Source), this);
				if (info.AttackerActorNumber != ActorNumber)
				{
					RivalsEvents.RaiseLocalHitDealt(in info, this);
				}
				base.photonView.RPC("RPC_ReceiveDamage", base.photonView.Owner, info.ResolvedAmount, info.AttackerActorNumber, (int)info.WeaponType, info.Source ?? string.Empty, info.IsHeadshot);
			}
		}

		private static bool DamageAllowedByGameState()
		{
			GamemodeManager instance = GamemodeManager.Instance;
			if (instance != null)
			{
				return instance.State == GameState.RoundActive;
			}
			return false;
		}

		void IPoolLifecycle.OnPoolReleased()
		{
			ResetForPool();
		}

		void IPoolLifecycle.OnPoolAcquired()
		{
		}

		public void ResetForPool()
		{
			isAlive = true;
			isInSafeZone = false;
			team = Team.None;
			currentHealth = maxHealth;
			spawnProtectionEndTime = 0f;
			if (aliveVisualRoot != null)
			{
				aliveVisualRoot.SetActive(true);
			}
			if (deathVisualRoot != null)
			{
				deathVisualRoot.SetActive(false);
			}
		}

		public void ApplyHeal(float amount, int healerActor)
		{
			if (amount > 0f && isAlive && !(base.photonView == null) && base.photonView.Owner != null)
			{
				base.photonView.RPC("RPC_ReceiveHeal", base.photonView.Owner, amount, healerActor);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReceiveDamage(float amount, int attackerActor, int weaponType, string source, bool headshot)
		{
			if (!isAlive || HasSpawnProtection || isInSafeZone || !DamageAllowedByGameState())
			{
				return;
			}
			if (attackerActor >= 0)
			{
				if (TryGet(attackerActor, out var health) && health != null && health.Team.IsSameTeam(team))
				{
					return;
				}
				if (TryGet(attackerActor, out var health2) && health2 != null && !health2.IsAlive)
				{
					return;
				}
			}
			currentHealth = Mathf.Max(0f, currentHealth - amount);
			Debug.Log(string.Format("[Rivals] Player {0} got shot by {1} ", ActorNumber, attackerActor) + string.Format("for {0:0.#}{1} with '{2}' — HP {3:0.#}/{4:0.#}", amount, headshot ? " (HEADSHOT)" : "", source, currentHealth, maxHealth), this);
			onDamaged?.Invoke(amount);
			RivalsEvents.RaisePlayerDamaged(this, amount, attackerActor);
			RivalsEvents.RaiseLocalDamaged(amount, headshot, attackerActor);
			if (!(currentHealth > 0f))
			{
				base.photonView.RPC("RPC_Died", RpcTarget.All, attackerActor, weaponType, source, headshot);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_ReceiveHeal(float amount, int healerActor)
		{
			if (isAlive)
			{
				currentHealth = Mathf.Min(maxHealth, currentHealth + amount);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Died(int killerActor, int weaponType, string weaponName, bool headshot)
		{
			if (isAlive)
			{
				isAlive = false;
				currentHealth = 0f;
				if (aliveVisualRoot != null)
				{
					aliveVisualRoot.SetActive(false);
				}
				if (deathVisualRoot != null)
				{
					deathVisualRoot.SetActive(true);
				}
				onDied?.Invoke();
				KillInfo info = new KillInfo
				{
					Victim = this,
					VictimActorNumber = ActorNumber,
					KillerActorNumber = killerActor,
					WeaponType = (WeaponType)weaponType,
					WeaponName = weaponName,
					WasHeadshot = headshot
				};
				RivalsEvents.RaisePlayerKilled(in info);
			}
		}

		public void Revive(float? overrideMaxHealth = null)
		{
			if (overrideMaxHealth.HasValue)
			{
				maxHealth = overrideMaxHealth.Value;
			}
			base.photonView.RPC("RPC_Revive", RpcTarget.All, maxHealth);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Revive(float newMaxHealth)
		{
			maxHealth = newMaxHealth;
			currentHealth = newMaxHealth;
			isAlive = true;
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

		public void SetTeam(Team newTeam)
		{
			base.photonView.RPC("RPC_SetTeam", RpcTarget.All, (int)newTeam);
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetTeam(int newTeam)
		{
			team = (Team)newTeam;
		}

		public void SetSpawnProtection(float seconds)
		{
			spawnProtectionEndTime = Time.time + Mathf.Max(0f, seconds);
		}

		public void SetSafeZone(bool inside)
		{
			isInSafeZone = inside;
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
			if (stream.IsWriting)
			{
				stream.SendNext(currentHealth);
				stream.SendNext(maxHealth);
				stream.SendNext((byte)team);
				stream.SendNext(isAlive);
				stream.SendNext(Mathf.Max(0f, spawnProtectionEndTime - Time.time));
			}
			else
			{
				currentHealth = (float)stream.ReceiveNext();
				maxHealth = (float)stream.ReceiveNext();
				team = (Team)(byte)stream.ReceiveNext();
				isAlive = (bool)stream.ReceiveNext();
				spawnProtectionEndTime = (float)stream.ReceiveNext() + Time.time;
			}
		}

		private void OnValidate()
		{
			if (!(maxHealth > 0f))
			{
				maxHealth = 100f;
			}
			currentHealth = Mathf.Clamp(currentHealth, 0f, maxHealth);
		}

		private void EnsureHitboxes()
		{
			if (!buildHitboxes || _hitboxesBuilt)
			{
				return;
			}
			_hbAnchor = ((hitboxAnchor != null) ? hitboxAnchor : base.transform.Find("Head"));
			if (_hbAnchor == null)
			{
				Debug.LogWarning("[PlayerHealth] No hitbox anchor ('Head' child) on '" + base.name + "' — hitboxes not built; this player can't be shot.", this);
				return;
			}
			int num = LayerMask.NameToLayer(hitboxLayerName);
			if (num >= 0)
			{
				IsolateHitboxLayer(num);
			}
			else
			{
				Debug.LogWarning(string.Format("[PlayerHealth] Layer '{0}' not defined — hitboxes fall back to layer {1} (not physics-isolated). Add the layer in Project Settings ▸ Tags and Layers.", hitboxLayerName, base.gameObject.layer), this);
				num = base.gameObject.layer;
			}
			_headHitbox = new GameObject("HeadHitbox").AddComponent<SphereCollider>();
			Transform obj = _headHitbox.transform;
			obj.SetParent(_hbAnchor, false);
			obj.localPosition = headHitboxOffset;
			obj.localRotation = Quaternion.identity;
			obj.localScale = Vector3.one;
			_headHitbox.radius = headHitboxRadius;
			_headHitbox.isTrigger = false;
			_headHitbox.gameObject.layer = num;
			_headHitbox.gameObject.tag = "Head";
			_bodyHitbox = new GameObject("BodyHitbox").AddComponent<CapsuleCollider>();
			Transform obj2 = _bodyHitbox.transform;
			obj2.SetParent(_hbAnchor, false);
			obj2.localScale = Vector3.one;
			_bodyHitbox.direction = 1;
			_bodyHitbox.radius = bodyHitboxRadius;
			_bodyHitbox.height = bodyHitboxHeight;
			_bodyHitbox.center = Vector3.zero;
			_bodyHitbox.isTrigger = false;
			_bodyHitbox.gameObject.layer = num;
			_hitboxesBuilt = true;
			PositionBodyHitbox();
		}

		private static void IsolateHitboxLayer(int layer)
		{
			if (!_hitboxLayerIsolated)
			{
				for (int i = 0; i < 32; i++)
				{
					Physics.IgnoreLayerCollision(layer, i, true);
				}
				_hitboxLayerIsolated = true;
			}
		}

		private void PositionBodyHitbox()
		{
			if (!(_bodyHitbox == null) && !(_hbAnchor == null))
			{
				float y = _hbAnchor.lossyScale.y;
				Vector3 vector = Quaternion.Euler(0f, _hbAnchor.eulerAngles.y, 0f) * (bodyHitboxOffset * y);
				_bodyHitbox.transform.position = _hbAnchor.position + Vector3.down * (bodyHitboxDrop * y) + vector;
				_bodyHitbox.transform.rotation = Quaternion.identity;
			}
		}

		private void ApplyHitboxDimensions()
		{
			if (_headHitbox != null)
			{
				_headHitbox.radius = headHitboxRadius;
				_headHitbox.transform.localPosition = headHitboxOffset;
			}
			if (_bodyHitbox != null)
			{
				_bodyHitbox.radius = bodyHitboxRadius;
				_bodyHitbox.height = bodyHitboxHeight;
			}
		}

		private void LateUpdate()
		{
			if (currentHealth < _lastFlashHealth - 0.01f && _netPlayer != null)
			{
				_netPlayer.FlashDamage();
			}
			_lastFlashHealth = currentHealth;
			if (!_hitboxesBuilt)
			{
				return;
			}
			PositionBodyHitbox();
			ApplyHitboxDimensions();
			bool flag = isAlive && buildHitboxes;
			if (_hitboxesAlive != flag)
			{
				_hitboxesAlive = flag;
				if (_headHitbox != null)
				{
					_headHitbox.enabled = flag;
				}
				if (_bodyHitbox != null)
				{
					_bodyHitbox.enabled = flag;
				}
			}
		}

		private void OnDrawGizmos()
		{
			if (drawHitboxGizmos && !gizmosOnlyWhenSelected)
			{
				DrawHitboxGizmos();
			}
		}

		private void OnDrawGizmosSelected()
		{
			if (drawHitboxGizmos && gizmosOnlyWhenSelected)
			{
				DrawHitboxGizmos();
			}
		}

		private void DrawHitboxGizmos()
		{
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(gizmosIncludeInactive);
			foreach (Collider collider in componentsInChildren)
			{
				if (!(collider == null))
				{
					Color color = (!collider.enabled) ? GizmoDisabled : (collider.isTrigger ? GizmoTrigger : (Weapon.IsHeadCollider(collider) ? GizmoHead : GizmoBody));
					DrawCollider(collider, color);
				}
			}
			Gizmos.matrix = Matrix4x4.identity;
		}

		private static void DrawCollider(Collider col, Color color)
		{
			Gizmos.color = color;
			if (col is BoxCollider boxCollider)
			{
				Gizmos.matrix = Matrix4x4.TRS(boxCollider.transform.position, boxCollider.transform.rotation, boxCollider.transform.lossyScale);
				Gizmos.DrawWireCube(boxCollider.center, boxCollider.size);
				Gizmos.matrix = Matrix4x4.identity;
			}
			else if (col is SphereCollider sphereCollider)
			{
				Vector3 lossyScale = sphereCollider.transform.lossyScale;
				float num = sphereCollider.radius * Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z));
				Gizmos.DrawWireSphere(sphereCollider.transform.TransformPoint(sphereCollider.center), num);
			}
			else if (col is CapsuleCollider cap)
			{
				DrawCapsule(cap);
			}
			else
			{
				Gizmos.DrawWireCube(col.bounds.center, col.bounds.size);
			}
		}

		private static void DrawCapsule(CapsuleCollider cap)
		{
			Transform transform = cap.transform;
			Vector3 lossyScale = transform.lossyScale;
			Vector3 toDirection;
			float num;
			float num2;
			switch (cap.direction)
			{
			case 0:
				toDirection = Vector3.right;
				num = Mathf.Max(Mathf.Abs(lossyScale.y), Mathf.Abs(lossyScale.z));
				num2 = Mathf.Abs(lossyScale.x);
				break;
			case 2:
				toDirection = Vector3.forward;
				num = Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.y));
				num2 = Mathf.Abs(lossyScale.z);
				break;
			default:
				toDirection = Vector3.up;
				num = Mathf.Max(Mathf.Abs(lossyScale.x), Mathf.Abs(lossyScale.z));
				num2 = Mathf.Abs(lossyScale.y);
				break;
			}
			float num3 = cap.radius * num;
			float num4 = Mathf.Max(0f, Mathf.Max(cap.height * num2, num3 * 2f) * 0.5f - num3);
			Vector3 pos = transform.TransformPoint(cap.center);
			Quaternion q = transform.rotation * Quaternion.FromToRotation(Vector3.up, toDirection);
			Matrix4x4 matrix = Gizmos.matrix;
			Gizmos.matrix = Matrix4x4.TRS(pos, q, Vector3.one);
			Vector3 vector = Vector3.up * num4;
			Vector3 vector2 = -vector;
			Gizmos.DrawWireSphere(vector, num3);
			Gizmos.DrawWireSphere(vector2, num3);
			Gizmos.DrawLine(vector + Vector3.right * num3, vector2 + Vector3.right * num3);
			Gizmos.DrawLine(vector - Vector3.right * num3, vector2 - Vector3.right * num3);
			Gizmos.DrawLine(vector + Vector3.forward * num3, vector2 + Vector3.forward * num3);
			Gizmos.DrawLine(vector - Vector3.forward * num3, vector2 - Vector3.forward * num3);
			Gizmos.matrix = matrix;
		}

		void IDamageable.ApplyDamage(in DamageInfo info)
		{
			ApplyDamage(in info);
		}
	}
}
