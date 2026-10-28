using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using LethalApeR;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.Audio;

public class GameModePlayer : MonoBehaviourPun, IPoolLifecycle
{
	[Serializable]
	public class MonsterEntry
	{
		public GameObject MonsterGameObject;

		public string MonsterName;

		[Header("Powerup (1 = none)")]
		[Tooltip("Multiplies the round's monsterSize for this skin — a 'big monster' powerup. 1 = the normal monster scale.")]
		[Range(0.5f, 3f)]
		public float scaleMultiplier = 1f;

		[Tooltip("Multiplies this skin's hand kill/grab trigger radius — a 'long arms' reach powerup. 1 = the authored reach.")]
		[Range(0.5f, 3f)]
		public float reachMultiplier = 1f;

		[Tooltip("Multiplies this skin's movement speed (arm-swing launch, or walk for legged skins). A big skin covers more ground per swing, so it can trade some back here. 1 = unchanged.")]
		[Range(0.5f, 1.5f)]
		public float speedMultiplier = 1f;
	}

	public bool isEliminated;

	public bool isMonster;

	public bool isInfected;

	public bool isFrozen;

	public Material taggedMaterial;

	public GameObject monsterRigsParent;

	[Tooltip("Container for LEGGED monster rigs (Gus). Lives on the NetworkPlayer ROOT, not under Head — a full-body rig must not inherit head pitch/roll. Optional: leave null on prefabs with no legged skins.")]
	public GameObject monsterRigsLeggedParent;

	public GameObject apeRig;

	public MonsterEntry[] availableMonsters;

	public AudioSource speaker;

	public AudioMixerGroup monsterAudioGroup;

	public AudioMixerGroup defaultAudioGroup;

	public List<PlayerColorReciever> playerColorReciever = new List<PlayerColorReciever>();

	private bool _isHighlighted;

	private bool _isDisguised;

	private string _selectedMonsterSkin;

	private float _reachPerk = 1f;

	private static readonly int EnableOverlayId = Shader.PropertyToID("_EnableOverlay");

	public static GameModePlayer LocalPlayer
	{
		get
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = (manager ? manager.LocalPlayer : null);
			if (!monkeDevNetworkingPlayer)
			{
				return null;
			}
			return monkeDevNetworkingPlayer.gameModePlayer;
		}
	}

	public MonsterEntry CurrentMonsterEntry { get; private set; }

	public float CurrentScaleMultiplier
	{
		get
		{
			if (!isMonster || CurrentMonsterEntry == null)
			{
				return 1f;
			}
			return Mathf.Max(CurrentMonsterEntry.scaleMultiplier, 0.1f);
		}
	}

	public float CurrentSpeedMultiplier
	{
		get
		{
			if (!isMonster || UseSurvivorScale || CurrentMonsterEntry == null)
			{
				return 1f;
			}
			return Mathf.Clamp(CurrentMonsterEntry.speedMultiplier, 0.5f, 1.5f);
		}
	}

	public bool IsMonster
	{
		get
		{
			return isMonster;
		}
		set
		{
			isMonster = value && BTMGameManager.Instance != null;
			ApplyRigVisibility();
			UpdateMonsterSkin();
			UpdateVoiceEffects();
		}
	}

	public bool IsDisguised
	{
		get
		{
			return _isDisguised;
		}
		set
		{
			if (_isDisguised != value)
			{
				_isDisguised = value;
				ApplyRigVisibility();
			}
		}
	}

	public bool ShowsMonsterRig
	{
		get
		{
			if (isMonster)
			{
				return !_isDisguised;
			}
			return false;
		}
	}

	public bool UseSurvivorScale { get; set; }

	public bool IsEliminated
	{
		get
		{
			return isEliminated;
		}
		set
		{
			isEliminated = value;
			List<PlayerColorReciever> list = playerColorReciever;
			if (list == null || list.Count <= 0)
			{
				list = new List<PlayerColorReciever>(GetComponentsInChildren<PlayerColorReciever>(true));
			}
			foreach (PlayerColorReciever item in list)
			{
				if (item != null)
				{
					item.SetMaterial(null, value);
				}
			}
			UpdateVoiceEffects();
		}
	}

	public bool IsHighlighted
	{
		get
		{
			return _isHighlighted;
		}
		set
		{
			UpdateHighlight(value);
		}
	}

	int IPoolLifecycle.PoolCallbackOrder => 300;

	public float RoundScale(float monsterSize)
	{
		if (!isMonster || UseSurvivorScale)
		{
			return 1f;
		}
		return CurrentScaleMultiplier * monsterSize;
	}

	public void ApplyRigVisibility()
	{
		bool showsMonsterRig = ShowsMonsterRig;
		SetMonsterRigsActive(showsMonsterRig);
		if (apeRig != null)
		{
			apeRig.SetActive(!showsMonsterRig);
		}
	}

	public void SetMonsterRigsActive(bool active)
	{
		if (monsterRigsParent != null)
		{
			monsterRigsParent.SetActive(active);
		}
		if (monsterRigsLeggedParent != null)
		{
			monsterRigsLeggedParent.SetActive(active);
		}
	}

	void IPoolLifecycle.OnPoolReleased()
	{
		_isDisguised = false;
		UseSurvivorScale = false;
		isEliminated = false;
		isMonster = false;
		isInfected = false;
		isFrozen = false;
		SetMonsterRigsActive(active: false);
		if (apeRig != null)
		{
			apeRig.SetActive(true);
		}
		if (availableMonsters == null)
		{
			return;
		}
		MonsterEntry[] array = availableMonsters;
		foreach (MonsterEntry monsterEntry in array)
		{
			if (monsterEntry != null && monsterEntry.MonsterGameObject != null)
			{
				monsterEntry.MonsterGameObject.SetActive(false);
			}
		}
	}

	void IPoolLifecycle.OnPoolAcquired()
	{
	}

	private void UpdateVoiceEffects()
	{
		if (!(speaker == null))
		{
			speaker.outputAudioMixerGroup = (isMonster ? monsterAudioGroup : defaultAudioGroup);
			if (base.photonView.IsMine)
			{
				speaker.volume = 0f;
			}
		}
	}

	private void UpdateMonsterSkin()
	{
		string text = _selectedMonsterSkin;
		if (string.IsNullOrWhiteSpace(text) && base.photonView != null && base.photonView.Owner != null && base.photonView.Owner.CustomProperties != null && base.photonView.Owner.CustomProperties.TryGetValue("Cosmetics", out var value) && value is Dictionary<string, string> dictionary && dictionary.TryGetValue("MonsterSkin", out var value2))
		{
			text = (string.IsNullOrWhiteSpace(value2) ? text : value2);
		}
		string text2 = (string.IsNullOrWhiteSpace(text) ? "SandMan" : text);
		if (availableMonsters == null)
		{
			return;
		}
		MonsterEntry monsterEntry = null;
		for (int i = 0; i < availableMonsters.Length; i++)
		{
			MonsterEntry monsterEntry2 = availableMonsters[i];
			if (monsterEntry2 != null && monsterEntry2.MonsterGameObject != null && string.Equals(monsterEntry2.MonsterName, text2, StringComparison.OrdinalIgnoreCase))
			{
				monsterEntry = monsterEntry2;
				break;
			}
		}
		if (monsterEntry == null)
		{
			if (!string.IsNullOrWhiteSpace(text2))
			{
				Debug.LogWarning("[GameModePlayer] MonsterSkin '" + text2 + "' matches no availableMonsters entry — falling back to the first skin.", this);
			}
			monsterEntry = availableMonsters.FirstOrDefault((MonsterEntry e) => e != null && e.MonsterGameObject != null);
		}
		MonsterEntry[] array = availableMonsters;
		foreach (MonsterEntry monsterEntry3 in array)
		{
			if (monsterEntry3 != null && monsterEntry3.MonsterGameObject != null)
			{
				if (monsterEntry3 == monsterEntry)
				{
					monsterEntry3.MonsterGameObject.SetActive(isMonster);
					ApplyReach(monsterEntry);
				}
				else
				{
					monsterEntry3.MonsterGameObject.SetActive(false);
				}
			}
		}
		CurrentMonsterEntry = monsterEntry;
	}

	public void SetReachPerk(float perk)
	{
		if (!Mathf.Approximately(_reachPerk, perk))
		{
			_reachPerk = perk;
			ApplyReach(CurrentMonsterEntry);
		}
	}

	private void ApplyReach(MonsterEntry entry)
	{
		if (entry == null || entry.MonsterGameObject == null)
		{
			return;
		}
		BtmMonsterHand[] componentsInChildren = entry.MonsterGameObject.GetComponentsInChildren<BtmMonsterHand>(true);
		foreach (BtmMonsterHand btmMonsterHand in componentsInChildren)
		{
			if (btmMonsterHand != null)
			{
				btmMonsterHand.SetReachMultiplier(_reachPerk * entry.reachMultiplier);
			}
		}
	}

	private void UpdateHighlight(bool highlighted)
	{
		_isHighlighted = highlighted;
		GameObject gameObject = null;
		if (availableMonsters != null)
		{
			MonsterEntry[] array = availableMonsters;
			foreach (MonsterEntry monsterEntry in array)
			{
				if (monsterEntry != null && monsterEntry.MonsterGameObject != null && monsterEntry.MonsterGameObject.activeSelf)
				{
					gameObject = monsterEntry.MonsterGameObject;
					break;
				}
			}
		}
		if (gameObject == null)
		{
			return;
		}
		Renderer[] componentsInChildren = gameObject.GetComponentsInChildren<Renderer>(true);
		float value = (highlighted ? 1f : 0f);
		Renderer[] array2 = componentsInChildren;
		foreach (Renderer renderer in array2)
		{
			Material[] materials = renderer.materials;
			foreach (Material material in materials)
			{
				if (material.HasProperty(EnableOverlayId))
				{
					material.SetFloat(EnableOverlayId, value);
					if (highlighted)
					{
						material.EnableKeyword("OVERLAY");
					}
					else
					{
						material.DisableKeyword("OVERLAY");
					}
				}
			}
		}
	}

	public void SetPlayerMaterialDirect(Material mat)
	{
	}

	public void SetSelectedMonsterSkin(string skinId)
	{
		_selectedMonsterSkin = skinId;
		UpdateMonsterSkin();
		if (base.photonView.IsMine && isMonster && BTMGameManager.Instance != null && GorillaLocomotion.Player.HasInstance)
		{
			GorillaLocomotion.Player.Instance.targetScale = RoundScale(BTMGameManager.Instance.roomSettings.monsterSize);
		}
	}

	public void ResetSkinState()
	{
		SetReachPerk(1f);
		_selectedMonsterSkin = null;
		CurrentMonsterEntry = null;
	}

	[Obfuscation(Exclude = true)]
	public void RPC_NotifyKill(int victimActorId, int killerActorId)
	{
	}
}
