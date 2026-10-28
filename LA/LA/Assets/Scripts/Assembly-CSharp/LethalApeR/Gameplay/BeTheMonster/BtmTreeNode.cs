using System.Reflection;
using System.Text;
using GorillaLocomotion;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmTreeNode : MonoBehaviour
	{
		private enum State
		{
			Locked = 0,
			Short = 1,
			Ready = 2,
			Owned = 3
		}

		private enum Token
		{
			Resting = 0,
			Held = 1,
			Returning = 2,
			Smashing = 3,
			Hidden = 4
		}

		[SerializeField]
		private BtmItemDefinition item;

		[Header("Rig")]
		[SerializeField]
		private Transform cage;

		[SerializeField]
		private Transform itemAnchor;

		[SerializeField]
		private float itemSize = 0.2f;

		[Tooltip("Shown instead of the item when it has no held model (slot unlocks).")]
		[SerializeField]
		private GameObject fallbackDisplay;

		[SerializeField]
		private Transform token;

		[Tooltip("Where the nut rests (top of its travel).")]
		[SerializeField]
		private Transform tokenRest;

		[Tooltip("Where the nut meets the cage (bottom of its travel).")]
		[SerializeField]
		private Transform tokenImpact;

		[SerializeField]
		private LineRenderer beam;

		[SerializeField]
		private Renderer[] cageRenderers;

		[SerializeField]
		private Renderer[] tokenRenderers;

		[Header("Panel")]
		[SerializeField]
		private TMP_Text nameText;

		[SerializeField]
		private TMP_Text costText;

		[SerializeField]
		private TMP_Text descriptionText;

		[SerializeField]
		private TMP_Text tagText;

		[SerializeField]
		private TMP_Text statusText;

		[SerializeField]
		private TMP_Text promptText;

		[Header("Feel")]
		[SerializeField]
		private float grabRadius = 0.12f;

		[SerializeField]
		[Range(0.3f, 1f)]
		private float gripThreshold = 0.7f;

		[SerializeField]
		private float followSharpness = 28f;

		[SerializeField]
		private float returnSpring = 70f;

		[SerializeField]
		private float returnDamping = 11f;

		[SerializeField]
		private float detentSpacing = 0.05f;

		[SerializeField]
		private float smashSeconds = 0.09f;

		[SerializeField]
		private float cageSpin = 18f;

		[SerializeField]
		private float itemSpin = 40f;

		[Header("Feedback")]
		[SerializeField]
		private ParticleSystem smashBurst;

		[SerializeField]
		private AudioClip grabClip;

		[SerializeField]
		private AudioClip detentClip;

		[SerializeField]
		private AudioClip unlockClip;

		[SerializeField]
		private AudioClip rejectClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float volume = 0.8f;

		[Tooltip("Neon colour per side: the cage, nut and beam all take it.")]
		[SerializeField]
		private Color survivorColor = new Color(0.72f, 0.86f, 1f);

		[SerializeField]
		private Color monsterColor = new Color(0.95f, 0.1f, 0.14f);

		[SerializeField]
		private Color coreColor = new Color(1f, 0.62f, 0.18f);

		[SerializeField]
		private Color rejectColor = new Color(1f, 0.1f, 0.12f);

		private const string Gold = "#FFD633";

		private const string Red = "#FF4A4A";

		private const string Dim = "#BFC7D1";

		private static readonly int TintId = Shader.PropertyToID("_Tint");

		private static readonly int FlashId = Shader.PropertyToID("_Flash");

		private static readonly int DimId = Shader.PropertyToID("_Dim");

		private State _state;

		private Token _token;

		private float _s;

		private float _sVel;

		private float _lastDetent;

		private float _smashStart;

		private BtmHand _hand;

		private readonly bool[] _gripWasDown = new bool[2];

		private GameObject _display;

		private MaterialPropertyBlock _mpb;

		private AudioSource _voice;

		private float _flash;

		private float _rejectUntil;

		private float _messageUntil;

		public BtmItemDefinition Item => item;

		private Color SideColor
		{
			get
			{
				if (item == null || item.branch == BtmBranch.Core)
				{
					return coreColor;
				}
				if (item.role != BtmRole.Monster)
				{
					return survivorColor;
				}
				return monsterColor;
			}
		}

		private float TravelLength
		{
			get
			{
				if (!(tokenRest != null) || !(tokenImpact != null))
				{
					return 0f;
				}
				return Vector3.Distance(tokenRest.position, tokenImpact.position);
			}
		}

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 1f;
			_voice.spatialize = false;
			_voice.rolloffMode = AudioRolloffMode.Linear;
			_voice.maxDistance = 12f;
		}

		private void OnEnable()
		{
			BtmProgress.Changed += Refresh;
			Player.Teleported += HandleRigTeleported;
			if (_display == null && itemAnchor != null && item != null && item.heldPrefab != null)
			{
				_display = BtmVisualCopy.Create(item.heldPrefab, itemAnchor.position, itemAnchor.rotation, itemAnchor);
				BtmVisualCopy.FitTo(_display, itemSize);
				BtmVisualCopy.ApplyTint(_display, item.tint);
			}
			if (fallbackDisplay != null)
			{
				fallbackDisplay.SetActive(item != null && item.heldPrefab == null);
			}
			Refresh();
			_s = 0f;
			_token = ((_state == State.Owned) ? Token.Hidden : Token.Resting);
			PlaceToken();
		}

		private void OnDisable()
		{
			BtmProgress.Changed -= Refresh;
			Player.Teleported -= HandleRigTeleported;
			LetGo();
		}

		private void HandleRigTeleported(Player player)
		{
			if (_token == Token.Held)
			{
				LetGo();
				_token = Token.Resting;
				_s = 0f;
				_sVel = 0f;
				PlaceToken();
			}
		}

		private void OnValidate()
		{
			if (!Application.isPlaying)
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				Color sideColor = SideColor;
				ApplyBlock(cageRenderers, new Color(sideColor.r, sideColor.g, sideColor.b, 1f), 0f, 0f);
				ApplyBlock(tokenRenderers, new Color(sideColor.r, sideColor.g, sideColor.b, 1f), 0f, 0f);
				if (beam != null)
				{
					beam.startColor = (beam.endColor = sideColor * 0.4f);
				}
			}
		}

		private void Update()
		{
			if (item == null || (!BtmTechTreeRoom.LocalInTree && _token != Token.Held && _token != Token.Smashing))
			{
				return;
			}
			float deltaTime = Time.deltaTime;
			float time = Time.time;
			if (cage != null)
			{
				cage.Rotate(0f, cageSpin * deltaTime, 0f);
			}
			if (_display != null)
			{
				_display.transform.Rotate(0f, itemSpin * deltaTime, 0f);
			}
			if (_messageUntil > 0f && time >= _messageUntil)
			{
				_messageUntil = 0f;
				Refresh();
			}
			switch (_token)
			{
			case Token.Resting:
			case Token.Returning:
				TryGrab();
				if (_token == Token.Returning)
				{
					Spring(deltaTime);
				}
				break;
			case Token.Held:
				Follow(deltaTime);
				break;
			case Token.Smashing:
				Smash(time);
				break;
			}
			PlaceToken();
			UpdateLook(deltaTime, time);
		}

		private void TryGrab()
		{
			if (token == null || tokenRest == null || tokenImpact == null)
			{
				return;
			}
			for (int i = 0; i < 2; i++)
			{
				BtmHand btmHand = BtmHands.At(i);
				if (!btmHand.Present)
				{
					continue;
				}
				if (btmHand.Grip < gripThreshold)
				{
					_gripWasDown[i] = false;
					continue;
				}
				bool flag = _gripWasDown[i];
				_gripWasDown[i] = true;
				if (!flag && !btmHand.HoldingSomething && !((btmHand.Palm - token.position).sqrMagnitude > grabRadius * grabRadius))
				{
					_hand = btmHand;
					btmHand.Suspend(this);
					_token = Token.Held;
					_lastDetent = _s;
					_sVel = 0f;
					Play(grabClip, 0.7f);
					btmHand.Pulse(0.35f, 0.05f);
					break;
				}
			}
		}

		private void LetGo()
		{
			if (_hand != null)
			{
				_hand.Resume(this);
			}
			_hand = null;
		}

		private void Follow(float dt)
		{
			if (_hand == null || !_hand.Present || _hand.Grip < gripThreshold - 0.12f)
			{
				LetGo();
				_token = Token.Returning;
				return;
			}
			float travelLength = TravelLength;
			if (travelLength < 0.001f)
			{
				return;
			}
			Vector3 rhs = (tokenImpact.position - tokenRest.position) / travelLength;
			float b = Mathf.Clamp01(Vector3.Dot(_hand.Palm - tokenRest.position, rhs) / travelLength);
			float s = _s;
			_s = Mathf.Lerp(_s, b, 1f - Mathf.Exp((0f - followSharpness) * dt));
			_sVel = (_s - s) / Mathf.Max(dt, 0.0001f);
			if (Mathf.Abs(_s - _lastDetent) * travelLength >= detentSpacing)
			{
				_lastDetent = _s;
				Play(detentClip, 0.35f);
				_hand.Pulse(Mathf.Lerp(0.08f, 0.3f, _s), 0.02f);
			}
			if (_s >= 0.985f)
			{
				Commit();
			}
		}

		private void Spring(float dt)
		{
			_sVel += ((0f - returnSpring) * _s - returnDamping * _sVel) * dt;
			_s += _sVel * dt;
			if (_s < 0f)
			{
				_s = 0f;
				_sVel *= -0.25f;
			}
			if (_s < 0.002f && Mathf.Abs(_sVel) < 0.02f)
			{
				_token = Token.Resting;
				_s = 0f;
				_sVel = 0f;
			}
		}

		private void Commit()
		{
			BtmHand hand = _hand;
			BtmUnlockResult btmUnlockResult = BtmProgress.TryUnlock(item);
			if (btmUnlockResult != BtmUnlockResult.Unlocked)
			{
				LetGo();
				_token = Token.Returning;
				_s = 0.97f;
				_sVel = -9f;
				_rejectUntil = Time.time + 0.55f;
				Play(rejectClip, 1f);
				if (hand != null)
				{
					hand.Pulse(0.6f, 0.22f);
				}
				ShowMessage(RejectReason(btmUnlockResult), 2.5f);
			}
			else
			{
				_token = Token.Smashing;
				_smashStart = Time.time;
				LetGo();
			}
		}

		private void Smash(float now)
		{
			float num = (now - _smashStart) / smashSeconds;
			_s = Mathf.Lerp(0.985f, 1.08f, num);
			if (!(num < 1f))
			{
				_token = Token.Hidden;
				_flash = 1f;
				if (smashBurst != null)
				{
					smashBurst.Play();
				}
				Play(unlockClip, 1f);
				BtmHand btmHand = BtmHands.Nearest((cage != null) ? cage.position : base.transform.position, 0.6f);
				if (btmHand != null)
				{
					btmHand.Pulse(1f, 0.28f);
				}
				if (BtmCyberGlobals.Instance != null)
				{
					BtmCyberGlobals.Instance.Burst((cage != null) ? cage.position : base.transform.position);
				}
				Refresh();
			}
		}

		private void PlaceToken()
		{
			if (!(token == null) && !(tokenRest == null) && !(tokenImpact == null))
			{
				bool flag = _token != Token.Hidden;
				if (token.gameObject.activeSelf != flag)
				{
					token.gameObject.SetActive(flag);
				}
				if (flag)
				{
					float num = ((_token == Token.Resting) ? (Mathf.Sin(Time.time * 2.4f) * 0.008f) : 0f);
					token.position = Vector3.LerpUnclamped(tokenRest.position, tokenImpact.position, _s) + Vector3.up * num;
					token.Rotate(0f, ((_token == Token.Held) ? 220f : 60f) * Time.deltaTime, 0f);
				}
			}
		}

		private void UpdateLook(float dt, float now)
		{
			_flash = Mathf.MoveTowards(_flash, 0f, dt * 1.6f);
			float num = ((_state == State.Locked) ? 0.75f : ((_state == State.Short) ? 0.35f : 0f));
			Color sideColor = SideColor;
			Color tint = ((_rejectUntil > now) ? rejectColor : new Color(sideColor.r, sideColor.g, sideColor.b, 1f));
			ApplyBlock(cageRenderers, tint, _flash, num);
			float flash = 0f;
			if (_token == Token.Held)
			{
				flash = _s * 0.5f + 0.25f;
			}
			else if (_state == State.Ready)
			{
				flash = Mathf.Sin(now * 4f) * 0.15f + 0.15f;
			}
			ApplyBlock(tokenRenderers, tint, flash, num * 0.6f);
			if (!(beam != null))
			{
				return;
			}
			bool flag = _state != State.Owned;
			if (beam.enabled != flag)
			{
				beam.enabled = flag;
			}
			if (flag)
			{
				Color color = ((_rejectUntil > now) ? (rejectColor * (Mathf.Abs(Mathf.Sin(now * 40f)) * 0.5f + 0.5f)) : ((_state == State.Ready || _token == Token.Held) ? sideColor : (sideColor * 0.4f)));
				beam.startColor = color;
				beam.endColor = color;
				if (tokenRest != null && tokenImpact != null)
				{
					beam.SetPosition(0, tokenRest.position + (tokenRest.position - tokenImpact.position).normalized * 0.12f);
					beam.SetPosition(1, tokenImpact.position);
				}
			}
		}

		private void ApplyBlock(Renderer[] renderers, Color tint, float flash, float dim)
		{
			if (renderers == null)
			{
				return;
			}
			foreach (Renderer renderer in renderers)
			{
				if (!(renderer == null))
				{
					renderer.GetPropertyBlock(_mpb);
					_mpb.SetColor(TintId, tint);
					_mpb.SetFloat(FlashId, flash);
					_mpb.SetFloat(DimId, dim);
					renderer.SetPropertyBlock(_mpb);
				}
			}
		}

		private void Refresh()
		{
			if (item == null)
			{
				return;
			}
			_state = ComputeState();
			if (_state == State.Owned)
			{
				if (_token != Token.Smashing)
				{
					_token = Token.Hidden;
				}
			}
			else if (_token == Token.Hidden)
			{
				_token = Token.Resting;
				_s = 0f;
				_sVel = 0f;
			}
			SetText(nameText, item.displayName);
			SetText(costText, (_state == State.Owned) ? "<color=#BFC7D1>OWNED</color>" : string.Format("<color={0}>{1}</color> <size=60%>{2}</size>", Gold, item.cost, "Salvage".ToUpperInvariant()));
			SetText(descriptionText, Description());
			SetText(tagText, (item.kind == BtmItemKind.SlotUnlock) ? "=( PERMANENT UPGRADE )=" : "=( EQUIPABLE AT ROUND START )=");
			SetText(promptText, (_state == State.Owned) ? "OWNED" : ((_state == State.Locked) ? "LOCKED" : "PULL THE NUT DOWN"));
			if (!(_messageUntil > 0f))
			{
				SetText(statusText, StatusLine());
			}
		}

		private string Description()
		{
			if (item.kind == BtmItemKind.Gadget || item.kind == BtmItemKind.SlotUnlock)
			{
				return item.description;
			}
			return item.description + "\n<color=#BFC7D1>Lasts " + item.DurationLabel + "</color>";
		}

		private string StatusLine()
		{
			switch (_state)
			{
			case State.Locked:
				return "<color=#FF4A4A>Requires " + MissingNames() + "</color>";
			case State.Short:
				return string.Format("<color={0}>You have {1}  -  need {2} more</color>", Dim, BtmProgress.Salvage, item.cost - BtmProgress.Salvage);
			case State.Owned:
				if (item.kind != BtmItemKind.SlotUnlock)
				{
					return "<color=#BFC7D1>Pick it in the loadout box at round start</color>";
				}
				return "";
			default:
				return "<color=#FFD633>Grab the nut above the cage and pull it down</color>";
			}
		}

		private string RejectReason(BtmUnlockResult result)
		{
			return result switch
			{
				BtmUnlockResult.MissingPrerequisite => "<color=#FF4A4A>Unlock " + MissingNames() + " first</color>",
				BtmUnlockResult.NotEnoughSalvage => string.Format("<color={0}>Need {1} more {2}</color>", Red, item.cost - BtmProgress.Salvage, "Salvage"),
				_ => "<color=#BFC7D1>Already owned</color>",
			};
		}

		private string MissingNames()
		{
			StringBuilder stringBuilder = new StringBuilder();
			BtmItemDefinition[] prerequisites = item.prerequisites;
			if (prerequisites != null)
			{
				foreach (BtmItemDefinition btmItemDefinition in prerequisites)
				{
					if (!(btmItemDefinition == null) && !BtmProgress.Owns(btmItemDefinition))
					{
						if (stringBuilder.Length > 0)
						{
							stringBuilder.Append(" + ");
						}
						stringBuilder.Append(btmItemDefinition.displayName);
					}
				}
			}
			return stringBuilder.ToString();
		}

		private State ComputeState()
		{
			return BtmProgress.CanUnlock(item) switch
			{
				BtmUnlockResult.AlreadyOwned => State.Owned,
				BtmUnlockResult.MissingPrerequisite => State.Locked,
				BtmUnlockResult.NotEnoughSalvage => State.Short,
				_ => State.Ready,
			};
		}

		private void ShowMessage(string message, float seconds)
		{
			SetText(statusText, message);
			_messageUntil = Time.time + seconds;
		}

		private void Play(AudioClip clip, float scale)
		{
			if (clip != null)
			{
				_voice.PlayOneShot(clip, volume * scale);
			}
		}

		private static void SetText(TMP_Text text, string value)
		{
			if (text != null && !(text.text == value))
			{
				text.text = value;
			}
		}

		private void OnDrawGizmosSelected()
		{
			if (!(tokenRest == null) && !(tokenImpact == null))
			{
				Gizmos.color = new Color(1f, 0.3f, 0.85f, 0.9f);
				Gizmos.DrawLine(tokenRest.position, tokenImpact.position);
				Gizmos.DrawWireSphere(tokenRest.position, grabRadius);
			}
		}
	}
}
