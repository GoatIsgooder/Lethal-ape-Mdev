using System.Collections.Generic;
using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Rivals.Weapons;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class WeaponTrialZone : MonoBehaviour
	{
		[Header("Area (oriented box — no collider, won't touch the guns)")]
		[Tooltip("Full size of the trial box in metres, oriented by this object's rotation. Shown as a wire box when selected.")]
		public Vector3 boxSize = new Vector3(8f, 4f, 10f);

		[Tooltip("Box center offset from this object (local/rotated metres).")]
		public Vector3 centerOffset = Vector3.zero;

		[Header("Loadout")]
		[Tooltip("The loadout picker to open. Auto-found in the scene if left empty.")]
		public LoadoutBox loadoutBox;

		[Tooltip("Open the picker automatically the moment the player enters (otherwise wait for the B/Y button).")]
		public bool openOnEnter = true;

		[Header("Gun delivery")]
		[Tooltip("If the range has no weapon-orb rig, spawn the picked guns in front of you to grab. They're cleared when you leave / re-pick.")]
		public bool spawnWeaponsIfNoOrbs = true;

		[Tooltip("Where spawned guns appear relative to the head (local: x=right, y=up, z=forward).")]
		public Vector3 spawnOffset = new Vector3(0f, -0.2f, 0.6f);

		[Tooltip("Sideways spacing between spawned guns (m).")]
		public float spawnSpread = 0.35f;

		private bool _inside;

		private bool _secondaryPrev;

		private bool _hideAfterChosen;

		private readonly List<GameObject> _spawned = new List<GameObject>();

		private readonly Dictionary<LoadoutSlot, WeaponData> _snapshot = new Dictionary<LoadoutSlot, WeaponData>();

		private void Update()
		{
			bool inside = IsPlayerInside();
			if (inside != _inside)
			{
				_inside = inside;
				if (inside)
				{
					Enter();
				}
				else
				{
					Exit();
				}
			}
			if (!_inside)
			{
				return;
			}
			if (_hideAfterChosen)
			{
				_hideAfterChosen = false;
				LoadoutBox box = ResolveBox();
				if (box != null)
				{
					box.Hide();
				}
			}
			VRInputController input = VRInputController.Instance;
			bool secondary = input != null && (input.LeftSecondaryButton || input.RightSecondaryButton);
			if (secondary && !_secondaryPrev)
			{
				OpenBox();
			}
			_secondaryPrev = secondary;
		}

		private void OnDisable()
		{
			if (_inside)
			{
				_inside = false;
				Exit();
			}
		}

		private void Enter()
		{
			GunUnlocker gun = GunUnlocker.Instance;
			if (gun != null)
			{
				SnapshotLoadout(gun);
				gun.SetTrialUnlockAll(on: true);
			}
			LoadoutBox box = ResolveBox();
			if (box != null)
			{
				box.onAllChosen.RemoveListener(OnLoadoutChosen);
				box.onAllChosen.AddListener(OnLoadoutChosen);
			}
			_secondaryPrev = true;
			_hideAfterChosen = false;
			if (openOnEnter)
			{
				OpenBox();
			}
		}

		private void Exit()
		{
			LoadoutBox box = ResolveBox();
			if (box != null)
			{
				box.onAllChosen.RemoveListener(OnLoadoutChosen);
				box.Hide();
			}
			ClearDelivered();
			_hideAfterChosen = false;
			GunUnlocker gun = GunUnlocker.Instance;
			if (gun != null)
			{
				gun.SetTrialUnlockAll(on: false);
				gun.RestoreLoadout(_snapshot);
			}
		}

		private void ClearDelivered()
		{
			ClearSpawned();
			if (RivalsWeaponOrbs.Instance != null)
			{
				RivalsWeaponOrbs.Instance.ClearAll();
			}
		}

		private void OpenBox()
		{
			LoadoutBox box = ResolveBox();
			Player player = Player.Instance;
			if (box == null || player == null)
			{
				return;
			}
			ClearDelivered();
			if (GunUnlocker.Instance != null)
			{
				GunUnlocker.Instance.ClearLoadout();
			}
			Transform head = ((player.headCollider != null) ? player.headCollider.transform : player.transform);
			box.Show(head.position, Quaternion.Euler(0f, head.eulerAngles.y, 0f));
		}

		private void OnLoadoutChosen()
		{
			if (spawnWeaponsIfNoOrbs && RivalsWeaponOrbs.Instance == null)
			{
				SpawnPickedWeapons();
			}
			_hideAfterChosen = true;
		}

		private void SpawnPickedWeapons()
		{
			ClearSpawned();
			GunUnlocker gun = GunUnlocker.Instance;
			Player player = Player.Instance;
			if (gun == null || player == null)
			{
				return;
			}
			Transform head = ((player.headCollider != null) ? player.headCollider.transform : player.transform);
			Vector3 basePos = head.position + head.rotation * spawnOffset;
			int index = 0;
			foreach (LoadoutSlot slot in System.Enum.GetValues(typeof(LoadoutSlot)))
			{
				WeaponData weapon = gun.GetEquipped(slot);
				GameObject prefab = ((weapon != null) ? ((weapon.grabbablePrefab != null) ? weapon.grabbablePrefab : weapon.modelPrefab) : null);
				if (!(prefab == null))
				{
					Vector3 pos = basePos + head.right * (spawnSpread * (float)(index - 1));
					_spawned.Add(Object.Instantiate(prefab, pos, head.rotation));
					index++;
				}
			}
		}

		private void ClearSpawned()
		{
			foreach (GameObject go in _spawned)
			{
				if (go != null)
				{
					RivalsWeaponOrbs.ForceDropIfHeld(go);
					Object.Destroy(go);
				}
			}
			_spawned.Clear();
		}

		private LoadoutBox ResolveBox()
		{
			if (loadoutBox == null)
			{
				loadoutBox = Object.FindObjectOfType<LoadoutBox>();
			}
			return loadoutBox;
		}

		private void SnapshotLoadout(GunUnlocker gun)
		{
			_snapshot.Clear();
			foreach (KeyValuePair<LoadoutSlot, WeaponData> entry in gun.GetLoadout())
			{
				_snapshot[entry.Key] = entry.Value;
			}
		}

		private bool IsPlayerInside()
		{
			Player player = Player.Instance;
			if (player == null)
			{
				return false;
			}
			Vector3 point = ((player.bodyCollider != null) ? player.bodyCollider.transform : player.transform).position;
			Vector3 center = base.transform.position + base.transform.rotation * centerOffset;
			Vector3 delta = point - center;
			if (Mathf.Abs(Vector3.Dot(delta, base.transform.right)) > boxSize.x * 0.5f)
			{
				return false;
			}
			if (Mathf.Abs(Vector3.Dot(delta, base.transform.up)) > boxSize.y * 0.5f)
			{
				return false;
			}
			return Mathf.Abs(Vector3.Dot(delta, base.transform.forward)) <= boxSize.z * 0.5f;
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.color = new Color(0.2f, 0.7f, 1f, 0.6f);
			Gizmos.matrix = Matrix4x4.TRS(base.transform.position + base.transform.rotation * centerOffset, base.transform.rotation, Vector3.one);
			Gizmos.DrawWireCube(Vector3.zero, boxSize);
		}
	}
}
