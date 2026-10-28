using System.Collections.Generic;
using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRagdollSpawner : MonoBehaviourPunCallbacks
	{
		public AudioClip deathClip;

		public GameObject bloodFloorQuad;

		private const int MaxRagdolls = 10;

		private const int MaxBloodSplats = 10;

		private const int MaxStingsPerFrame = 2;

		private const string DeadGuyName = "DeadApe";

		private readonly List<GameObject> _ragdolls = new List<GameObject>();

		private readonly List<int> _ragdollActors = new List<int>();

		private readonly List<int> _ragdollFrames = new List<int>();

		private readonly List<GameObject> _bloodSplats = new List<GameObject>();

		private readonly List<int> _bloodActors = new List<int>();

		private readonly List<int> _bloodFrames = new List<int>();

		private readonly Dictionary<MonkeDevNetworkingPlayer, Transform> _deadGuyCache = new Dictionary<MonkeDevNetworkingPlayer, Transform>();

		private bool _warnedMissing;

		private bool _hooked;

		private AgPhase _prevPhase;

		private int _ragdollLayer = -2;

		private int _stingFrame = -1;

		private int _stingsThisFrame;

		public static AgRagdollSpawner Instance { get; private set; }

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				Object.Destroy(this);
			}
			else
			{
				Instance = this;
			}
		}

		private void Start()
		{
			Hook();
		}

		public override void OnEnable()
		{
			base.OnEnable();
			Hook();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			Unhook();
			DespawnAll(true);
		}

		private void OnDestroy()
		{
			DespawnAll(true);
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void Hook()
		{
			if (!_hooked && !(ApeGamesManager.Instance == null))
			{
				_hooked = true;
				ApeGamesManager.Instance.OnPropsChanged += OnPropsChanged;
				ApeGamesManager.Instance.OnRoundEndedEvent += OnRoundEnded;
				ApeGamesManager.Instance.OnMatchEnded += OnMatchEnded;
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				if (!(ApeGamesManager.Instance == null))
				{
					ApeGamesManager.Instance.OnPropsChanged -= OnPropsChanged;
					ApeGamesManager.Instance.OnRoundEndedEvent -= OnRoundEnded;
					ApeGamesManager.Instance.OnMatchEnded -= OnMatchEnded;
				}
			}
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			AgPhase agPhase = ((p != null) ? p.phase : AgPhase.Idle);
			if (agPhase != _prevPhase)
			{
				_prevPhase = agPhase;
				DespawnAll();
			}
		}

		private void OnRoundEnded(int round, AgRoundProperties p)
		{
			DespawnAll();
		}

		private void OnMatchEnded(int[] winners)
		{
			DespawnAll();
		}

		public override void OnLeftRoom()
		{
			DespawnAll(true);
			_deadGuyCache.Clear();
		}

		public void SpawnFor(int actor)
		{
			if (actor < 1)
			{
				return;
			}
			PruneDead();
			for (int i = 0; i < _ragdollActors.Count; i++)
			{
				if (_ragdollActors[i] == actor)
				{
					return;
				}
			}
			for (int j = 0; j < _bloodActors.Count; j++)
			{
				if (_bloodActors[j] == actor)
				{
					return;
				}
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			if (manager == null)
			{
				return;
			}
			MonkeDevNetworkingPlayer playerByActorId = manager.GetPlayerByActorId(actor);
			if (playerByActorId == null)
			{
				return;
			}
			Transform transform = ((playerByActorId.Head != null) ? playerByActorId.Head : playerByActorId.transform);
			Vector3 position = transform.position;
			if (deathClip != null)
			{
				if (_stingFrame != Time.frameCount)
				{
					_stingFrame = Time.frameCount;
					_stingsThisFrame = 0;
				}
				if (_stingsThisFrame < MaxStingsPerFrame)
				{
					_stingsThisFrame++;
					AudioSource.PlayClipAtPoint(deathClip, position, 1f);
				}
			}
			if (TryProjectToGround(position, out var point, out var normal))
			{
				SpawnBlood(actor, point, normal);
			}
			Transform transform2 = FindDeadGuy(playerByActorId);
			if (transform2 == null)
			{
				return;
			}
			while (_ragdolls.Count >= MaxRagdolls)
			{
				if (_ragdolls[0] != null)
				{
					Object.Destroy(_ragdolls[0]);
				}
				_ragdolls.RemoveAt(0);
				_ragdollActors.RemoveAt(0);
				_ragdollFrames.RemoveAt(0);
			}
			Vector3 position2 = point + Vector3.up * 0.1f;
			Quaternion rotation = Quaternion.Euler(0f, transform.eulerAngles.y, 0f);
			GameObject gameObject = Object.Instantiate(transform2.gameObject, position2, rotation);
			gameObject.name = "AgRagdoll_" + actor;
			gameObject.transform.localScale = transform2.lossyScale;
			gameObject.SetActive(true);
			Animator component = gameObject.GetComponent<Animator>();
			if (component != null)
			{
				Object.Destroy(component);
			}
			SkinnedMeshRenderer[] componentsInChildren = gameObject.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			for (int k = 0; k < componentsInChildren.Length; k++)
			{
				componentsInChildren[k].updateWhenOffscreen = true;
			}
			ApplyRagdollLayer(gameObject);
			Vector3 linearVelocity = Vector3.zero;
			if (playerByActorId.photonView != null && playerByActorId.photonView.IsMine && Player.HasInstance)
			{
				linearVelocity = Player.Instance.currentVelocity;
			}
			Rigidbody[] componentsInChildren2 = gameObject.GetComponentsInChildren<Rigidbody>();
			foreach (Rigidbody obj in componentsInChildren2)
			{
				obj.linearVelocity = linearVelocity;
				obj.WakeUp();
			}
			_ragdolls.Add(gameObject);
			_ragdollActors.Add(actor);
			_ragdollFrames.Add(Time.frameCount);
			if (playerByActorId.photonView != null && playerByActorId.photonView.IsMine)
			{
				AgHaptics.Both(0.85f, 0.25f);
			}
		}

		private void SpawnBlood(int actor, Vector3 point, Vector3 normal)
		{
			if (!(bloodFloorQuad == null))
			{
				while (_bloodSplats.Count >= MaxBloodSplats)
				{
					if (_bloodSplats[0] != null)
					{
						Object.Destroy(_bloodSplats[0]);
					}
					_bloodSplats.RemoveAt(0);
					_bloodActors.RemoveAt(0);
					_bloodFrames.RemoveAt(0);
				}
				Quaternion quaternion = Quaternion.FromToRotation(Vector3.up, normal) * Quaternion.Euler(0f, Random.Range(0f, 360f), 0f);
				GameObject gameObject = Object.Instantiate(bloodFloorQuad, point + normal * 0.02f, quaternion * bloodFloorQuad.transform.rotation);
				gameObject.name = "AgBlood_" + actor;
				_bloodSplats.Add(gameObject);
				_bloodActors.Add(actor);
				_bloodFrames.Add(Time.frameCount);
			}
		}

		public void DespawnAll(bool force = false)
		{
			Sweep(_ragdolls, _ragdollActors, _ragdollFrames, force);
			Sweep(_bloodSplats, _bloodActors, _bloodFrames, force);
		}

		private static void Sweep(List<GameObject> objs, List<int> actors, List<int> frames, bool force)
		{
			int num = 0;
			for (int i = 0; i < objs.Count; i++)
			{
				if (!force && objs[i] != null && frames[i] == Time.frameCount)
				{
					objs[num] = objs[i];
					actors[num] = actors[i];
					frames[num] = frames[i];
					num++;
				}
				else if (objs[i] != null)
				{
					Object.Destroy(objs[i]);
				}
			}
			objs.RemoveRange(num, objs.Count - num);
			actors.RemoveRange(num, actors.Count - num);
			frames.RemoveRange(num, frames.Count - num);
		}

		private void PruneDead()
		{
			Prune(_ragdolls, _ragdollActors, _ragdollFrames);
			Prune(_bloodSplats, _bloodActors, _bloodFrames);
		}

		private static void Prune(List<GameObject> objs, List<int> actors, List<int> frames)
		{
			for (int num = objs.Count - 1; num >= 0; num--)
			{
				if (!(objs[num] != null))
				{
					objs.RemoveAt(num);
					actors.RemoveAt(num);
					frames.RemoveAt(num);
				}
			}
		}

		private Transform FindDeadGuy(MonkeDevNetworkingPlayer victim)
		{
			if (_deadGuyCache.TryGetValue(victim, out var value) && value != null)
			{
				return value;
			}
			Transform[] componentsInChildren = victim.GetComponentsInChildren<Transform>(true);
			Transform transform = null;
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				if (componentsInChildren[i] != null && componentsInChildren[i].name == DeadGuyName)
				{
					transform = componentsInChildren[i];
					break;
				}
			}
			if (transform == null)
			{
				if (!_warnedMissing)
				{
					_warnedMissing = true;
					Debug.LogError("[AgRagdollSpawner] No 'DeadApe' subtree under the player rig, eliminations get no ragdoll (player prefab changed?).");
				}
				return null;
			}
			_deadGuyCache[victim] = transform;
			return transform;
		}

		private static bool TryProjectToGround(Vector3 headPos, out Vector3 point, out Vector3 normal)
		{
			if (Physics.Raycast(headPos, Vector3.down, out var hitInfo, 12f, -1, QueryTriggerInteraction.Ignore))
			{
				point = hitInfo.point;
				normal = hitInfo.normal;
				return true;
			}
			point = headPos + Vector3.down * 1.4f;
			normal = Vector3.up;
			return false;
		}

		private void ApplyRagdollLayer(GameObject clone)
		{
			if (_ragdollLayer == -2)
			{
				_ragdollLayer = LayerMask.NameToLayer("Ragdoll");
				if (_ragdollLayer < 0)
				{
					return;
				}
				Physics.IgnoreLayerCollision(_ragdollLayer, _ragdollLayer, true);
				string[] array = new string[5] { "Player", "ChaseMe", "Hand", "Finger", "RivalsHitbox" };
				foreach (string layerName in array)
				{
					int num = LayerMask.NameToLayer(layerName);
					if (num >= 0)
					{
						Physics.IgnoreLayerCollision(_ragdollLayer, num, true);
					}
				}
			}
			if (_ragdollLayer >= 0)
			{
				Transform[] componentsInChildren = clone.GetComponentsInChildren<Transform>(true);
				for (int j = 0; j < componentsInChildren.Length; j++)
				{
					componentsInChildren[j].gameObject.layer = _ragdollLayer;
				}
			}
		}
	}
}
