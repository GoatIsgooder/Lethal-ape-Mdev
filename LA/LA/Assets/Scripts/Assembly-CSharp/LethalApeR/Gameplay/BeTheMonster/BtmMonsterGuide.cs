using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmMonsterGuide : MonoBehaviour
	{
		[Serializable]
		public class Entry
		{
			[Tooltip("MonsterEntry.MonsterName of the skin.")]
			public string skinName;

			public string displayName;

			[Tooltip("Optional: a perk this skin has beyond the ones read from its settings.")]
			public string perkName;

			[TextArea(1, 3)]
			public string perkText;
		}

		[Serializable]
		public class PerkRow
		{
			public GameObject root;

			public TMP_Text name;

			public TMP_Text description;
		}

		public readonly struct Perk
		{
			public readonly string Name;

			public readonly string Text;

			public Perk(string name, string text)
			{
				Name = name;
				Text = text;
			}
		}

		public struct Traits
		{
			public float Scale;

			public float Reach;

			public bool HuntBoost;

			public float BoostRange;

			public bool Mimic;

			public bool ChainsawLeft;

			public bool ChainsawRight;

			public bool Chainsaw => ChainsawLeft || ChainsawRight;
		}

		private const string KeyColour = "#5AE0BD";

		private const char Nbsp = ' ';

		private static readonly Regex Keys = new Regex("\\b(LEFT STICK|RIGHT STICK|BOTH TRIGGERS|LEFT TRIGGER|RIGHT TRIGGER|TRIGGER|GRIP|A|B)\\b");

		private const float PerkThreshold = 1.095f;

		private const float HugeThreshold = 1.2f;

		[Header("Card")]
		[SerializeField]
		private CanvasGroup canvasGroup;

		[SerializeField]
		private RectTransform card;

		[SerializeField]
		private TMP_Text titleText;

		[Tooltip("Shown top to bottom; a perk past the last row isn't shown.")]
		[SerializeField]
		private List<PerkRow> perkRows = new List<PerkRow>();

		[Header("Timing")]
		[Tooltip("After the monster spawn teleport.")]
		[SerializeField]
		private float showDelay = 3.2f;

		[SerializeField]
		private float displayDuration = 8f;

		[SerializeField]
		private float dismissTriggerValue = 0.7f;

		[Header("Follow")]
		[Tooltip("From the eyes, at player scale 1. Scaled with the player so a big monster sees it at the same distance.")]
		[SerializeField]
		private Vector3 followOffset = new Vector3(0f, -0.1f, 0.72f);

		[SerializeField]
		private float positionSmoothTime = 0.1f;

		[SerializeField]
		private float rotationSharpness = 6f;

		[SerializeField]
		private float maxPitch = 35f;

		[Header("Monsters")]
		[SerializeField]
		private List<Entry> monsters = new List<Entry>
		{
			new Entry
			{
				skinName = "SandMan",
				displayName = "Sandman"
			},
			new Entry
			{
				skinName = "Ashy",
				displayName = "Ashy"
			},
			new Entry
			{
				skinName = "FlesherBTMSkin",
				displayName = "Flesher"
			},
			new Entry
			{
				skinName = "MimicBTMSkin",
				displayName = "Mimic"
			},
			new Entry
			{
				skinName = "GrimBTMSkin",
				displayName = "Grim"
			},
			new Entry
			{
				skinName = "ProtoBTMSkin",
				displayName = "Prototype"
			},
			new Entry
			{
				skinName = "GusBTMSkin",
				displayName = "Gus"
			},
			new Entry
			{
				skinName = "SledgeBTMSkin",
				displayName = "Sledge"
			},
			new Entry
			{
				skinName = "BloodMoonGusBTMSkin",
				displayName = "Blood Moon Gus"
			},
			new Entry
			{
				skinName = "SawRunnerBTMSkin",
				displayName = "Saw Runner"
			},
			new Entry
			{
				skinName = "MechanicBTMSkin",
				displayName = "Mechanic"
			},
			new Entry
			{
				skinName = "LumberjackBTMSkin",
				displayName = "Lumberjack",
				perkName = "THROWING AXE",
				perkText = "Swing it to chop people in half. GRIP, swing and let go to throw it; TRIGGER calls it back through anyone in the way."
			}
		};

		private readonly List<Perk> _perks = new List<Perk>(4);

		private Transform _view;

		private Vector3 _smoothedPosition;

		private Vector3 _positionVelocity;

		private Quaternion _smoothedRotation;

		private Coroutine _routine;

		private double _showAt = -1.0;

		private bool _visible;

		private bool _subscribed;

		public IReadOnlyList<Entry> Entries => monsters;

		private void Start()
		{
			SetVisible(false);
			if (BTMGameManager.Instance)
			{
				BTMGameManager.Instance.OnRoundStarted += OnRoundStarted;
				BTMGameManager.Instance.OnRoundEnded += OnRoundEnded;
				_subscribed = true;
			}
		}

		private void OnDestroy()
		{
			if (_subscribed && BTMGameManager.Instance)
			{
				BTMGameManager.Instance.OnRoundStarted -= OnRoundStarted;
				BTMGameManager.Instance.OnRoundEnded -= OnRoundEnded;
			}
		}

		private void OnRoundStarted(int[] monsters, int[] activePlayers, bool roundActive, string mapId)
		{
			Hide();
			_showAt = -1.0;
			if (roundActive && PhotonNetwork.LocalPlayer != null && Array.IndexOf(monsters, PhotonNetwork.LocalPlayer.ActorNumber) >= 0)
			{
				BTMGameManager instance = BTMGameManager.Instance;
				_showAt = RoundProps.PlayStartTime(in instance.roomProperties) + Mathf.Max(instance.roomSettings.monsterSpawnDelay, 0f) + showDelay;
			}
		}

		private void OnRoundEnded(int[] winners, string mapId)
		{
			_showAt = -1.0;
			Hide();
		}

		private void Update()
		{
			if (_showAt > 0.0 && PhotonNetwork.Time >= _showAt)
			{
				_showAt = -1.0;
				Show();
			}
			if (!_visible)
			{
				return;
			}
			VRInputController instance = VRInputController.Instance;
			if (instance && instance.LeftTriggerValue > dismissTriggerValue && instance.RightTriggerValue > dismissTriggerValue)
			{
				Hide();
			}
			GameModePlayer gameModePlayer = LocalState();
			if (!gameModePlayer || !gameModePlayer.isMonster)
			{
				Hide();
			}
		}

		private void LateUpdate()
		{
			if (_visible && _view)
			{
				_smoothedPosition = Vector3.SmoothDamp(_smoothedPosition, _view.position, ref _positionVelocity, positionSmoothTime);
				_smoothedRotation = Quaternion.Slerp(_smoothedRotation, TargetRotation(), Time.deltaTime * rotationSharpness);
				Place();
			}
		}

		private static GameModePlayer LocalState()
		{
			return GameModePlayer.LocalPlayer;
		}

		[ContextMenu("Show Now")]
		public void Show()
		{
			GameModePlayer gameModePlayer = LocalState();
			Camera main = Camera.main;
			if (!gameModePlayer || !gameModePlayer.isMonster || !main || !canvasGroup || !card)
			{
				return;
			}
			GameModePlayer.MonsterEntry currentMonsterEntry = gameModePlayer.CurrentMonsterEntry;
			Entry entry = Find(currentMonsterEntry?.MonsterName);
			Perks(Read(currentMonsterEntry), entry, _perks);
			if (_perks.Count == 0)
			{
				return;
			}
			titleText.text = ((entry != null) ? entry.displayName : "Monster").ToUpperInvariant();
			for (int i = 0; i < perkRows.Count; i++)
			{
				PerkRow perkRow = perkRows[i];
				if (perkRow != null && (bool)perkRow.root)
				{
					perkRow.root.SetActive(i < _perks.Count);
					if (i < _perks.Count)
					{
						perkRow.name.text = _perks[i].Name;
						perkRow.description.text = Keys.Replace(_perks[i].Text, "<color=#5AE0BD>$1</color>");
					}
				}
			}
			_view = main.transform;
			_smoothedPosition = _view.position;
			_positionVelocity = Vector3.zero;
			_smoothedRotation = TargetRotation();
			Place();
			SetVisible(true);
			LayoutRebuilder.ForceRebuildLayoutImmediate(card);
			if (_routine != null)
			{
				StopCoroutine(_routine);
			}
			_routine = StartCoroutine(Lifetime());
		}

		private IEnumerator Lifetime()
		{
			StartCoroutine(BtmTween.FadeCanvas(canvasGroup, 0f, 1f, 0.25f, BtmTween.OutQuad));
			yield return StartCoroutine(BtmTween.ScaleTo(card, 0.85f, 1f, 0.35f, BtmTween.OutBack));
			yield return new WaitForSeconds(displayDuration);
			_routine = null;
			Hide();
		}

		public void Hide()
		{
			if (_visible)
			{
				if (_routine != null)
				{
					StopCoroutine(_routine);
				}
				_routine = StartCoroutine(HideRoutine());
			}
		}

		private IEnumerator HideRoutine()
		{
			StartCoroutine(BtmTween.FadeCanvas(canvasGroup, canvasGroup.alpha, 0f, 0.2f, BtmTween.InQuad));
			yield return StartCoroutine(BtmTween.ScaleTo(card, card.localScale.x, 0.9f, 0.2f, BtmTween.InBack));
			_routine = null;
			SetVisible(false);
		}

		private void SetVisible(bool visible)
		{
			_visible = visible;
			if (canvasGroup)
			{
				if (!visible)
				{
					canvasGroup.alpha = 0f;
				}
				if (card)
				{
					card.localScale = Vector3.one * (visible ? 0.85f : 1f);
				}
				canvasGroup.gameObject.SetActive(visible);
			}
		}

		private void Place()
		{
			float num = (GorillaLocomotion.Player.HasInstance ? Mathf.Max(GorillaLocomotion.Player.Instance.CurrentScale, 0.1f) : 1f);
			base.transform.SetPositionAndRotation(_smoothedPosition + _smoothedRotation * (followOffset * num), _smoothedRotation);
			base.transform.localScale = Vector3.one * num;
		}

		private Quaternion TargetRotation()
		{
			Vector3 eulerAngles = _view.eulerAngles;
			float value = ((eulerAngles.x > 180f) ? (eulerAngles.x - 360f) : eulerAngles.x);
			value = Mathf.Clamp(value, 0f - maxPitch, maxPitch);
			return Quaternion.Euler(value, eulerAngles.y, 0f);
		}

		private Entry Find(string skin)
		{
			if (string.IsNullOrEmpty(skin))
			{
				return null;
			}
			foreach (Entry monster in monsters)
			{
				if (monster != null && string.Equals(monster.skinName, skin, StringComparison.OrdinalIgnoreCase))
				{
					return monster;
				}
			}
			return null;
		}

		public static Traits Read(GameModePlayer.MonsterEntry entry)
		{
			if (entry == null)
			{
				return new Traits
				{
					Scale = 1f,
					Reach = 1f
				};
			}
			float scaleMultiplier = entry.scaleMultiplier;
			float reachMultiplier = entry.reachMultiplier;
			bool mimic = string.Equals(entry.MonsterName, "MimicBTMSkin", StringComparison.OrdinalIgnoreCase);
			if (!entry.MonsterGameObject)
			{
				return new Traits
				{
					Scale = scaleMultiplier,
					Reach = reachMultiplier,
					Mimic = mimic
				};
			}
			bool chainsawLeft = false;
			bool chainsawRight = false;
			BtmChainsawFx[] componentsInChildren = entry.MonsterGameObject.GetComponentsInChildren<BtmChainsawFx>(true);
			foreach (BtmChainsawFx btmChainsawFx in componentsInChildren)
			{
				if (btmChainsawFx.LeftHand)
				{
					chainsawLeft = true;
				}
				else
				{
					chainsawRight = true;
				}
			}
			BtmMonsterSkin componentInChildren = entry.MonsterGameObject.GetComponentInChildren<BtmMonsterSkin>(true);
			bool flag = (bool)componentInChildren && componentInChildren.IsLegged;
			return new Traits
			{
				Scale = scaleMultiplier,
				Reach = reachMultiplier,
				HuntBoost = (flag && componentInChildren.HuntBoost),
				BoostRange = (flag ? componentInChildren.HuntBoostRange : 0f),
				Mimic = mimic,
				ChainsawLeft = chainsawLeft,
				ChainsawRight = chainsawRight
			};
		}

		public static void Perks(Traits t, Entry authored, List<Perk> perks)
		{
			perks.Clear();
			if (t.Mimic)
			{
				perks.Add(new Perk("DISGUISE", string.Format("B turns you into your last kill. B or GRIP drops it. 20{0}s cooldown.", Nbsp)));
			}
			if (t.Chainsaw)
			{
				perks.Add(new Perk("CHAINSAW", ChainsawText(t)));
			}
			if (t.HuntBoost)
			{
				perks.Add(new Perk("HUNTER'S RUSH", string.Format("Faster when a survivor is within {0}{1}m.", Mathf.RoundToInt(t.BoostRange), Nbsp)));
			}
			if (t.Scale >= 1.2f)
			{
				perks.Add(new Perk("HUGE", string.Format("{0}% bigger. Every swing reaches further.", Percent(t.Scale))));
			}
			else if (t.Scale >= 1.095f)
			{
				perks.Add(new Perk("BIG", string.Format("{0}% bigger than the rest.", Percent(t.Scale))));
			}
			if (t.Reach >= 1.095f)
			{
				perks.Add(new Perk("LONG ARMS", string.Format("{0}% more reach.", Percent(t.Reach))));
			}
			if (authored != null && !string.IsNullOrEmpty(authored.perkName))
			{
				perks.Add(new Perk(authored.perkName.ToUpperInvariant(), authored.perkText ?? ""));
			}
		}

		private static string ChainsawText(Traits t)
		{
			return ((!t.ChainsawLeft) ? "Hold RIGHT TRIGGER to rev." : (t.ChainsawRight ? "Each TRIGGER revs its arm." : "Hold LEFT TRIGGER to rev.")) + " Only a running saw kills, and it cuts them in half.";
		}

		private static int Percent(float multiplier)
		{
			return Mathf.RoundToInt((multiplier - 1f) * 100f);
		}
	}
}
