using System;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Audio;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.InputSystem;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmMimic : MonoBehaviourPun
	{
		private const double CooldownTolerance = 0.25;

		private const float RumbleInterval = 0.06f;

		private const float GripThreshold = 0.7f;

		private static readonly string[] MonsterShapes = new string[2] { "MonsterTransformation", "MouthOpen" };

		private const string SpasmShape = "MonsterTransformation";

		private static readonly int MorphId = Shader.PropertyToID("_Morph");

		private static readonly int FlashId = Shader.PropertyToID("_Flash");

		private static readonly int SweepTopId = Shader.PropertyToID("_SweepTop");

		private static readonly int SweepHeightId = Shader.PropertyToID("_SweepHeight");

		private static readonly int BulgeScaleId = Shader.PropertyToID("_BulgeScale");

		private static readonly int MainTexId = Shader.PropertyToID("_MainTex");

		private static readonly int ColorMaskId = Shader.PropertyToID("_ColorMask");

		private static readonly int BumpMapId = Shader.PropertyToID("_BumpMap");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		[Tooltip("The MonsterEntry.MonsterName that carries this ability.")]
		[SerializeField]
		private string skinName = "MimicBTMSkin";

		[Header("Rig")]
		[SerializeField]
		private MonkeDevNetworkingPlayer player;

		[SerializeField]
		private GameModePlayer gameModePlayer;

		[Tooltip("The skin's container under Head/MonsterRigs. It is moved so the mimic model lands exactly on the ApeRig.")]
		[SerializeField]
		private Transform mimicRoot;

		[SerializeField]
		private SkinnedMeshRenderer mimicBody;

		[SerializeField]
		private SkinnedMeshRenderer mimicEyes;

		[Tooltip("The skin's KillTrigger hands. Switched off from the start of a morph until a reveal lands.")]
		[SerializeField]
		private BtmMonsterHand[] mimicHands = Array.Empty<BtmMonsterHand>();

		[Tooltip("Head/PlayerModels/ApeRig: the body the disguise ends up wearing.")]
		[SerializeField]
		private Transform apeModel;

		[Tooltip("The survivor catch trigger under the ape rig. Off while disguised: nothing may catch a monster.")]
		[SerializeField]
		private Collider apeKillTrigger;

		[Header("Look")]
		[SerializeField]
		private Material morphBodyMaterial;

		[SerializeField]
		private Material morphTeethMaterial;

		[Tooltip("Goes on every eye of the disguise: the survivors' tell.")]
		[SerializeField]
		private Material disguiseEyeMaterial;

		[Tooltip("Cosmetic ids a disguise never wears because they cover the eyes (masks, visors).")]
		[SerializeField]
		private string[] eyeCoveringCosmetics = Array.Empty<string>();

		[SerializeField]
		private float sweepHeadroom = 0.25f;

		[SerializeField]
		private float sweepHeight = 1.3f;

		[SerializeField]
		private float spasmWeight = 22f;

		[Header("Timing")]
		[SerializeField]
		private float morphDuration = 1.5f;

		[SerializeField]
		private float revealDuration = 0.5f;

		[SerializeField]
		private float cooldown = 20f;

		[Header("Feedback")]
		[SerializeField]
		private PlaySfx morphSfx;

		[SerializeField]
		private PlaySfx revealSfx;

		[Header("Desktop")]
		[SerializeField]
		private Key keyboardKey = Key.M;

		private const string HintText = "<color=#FF2648><b>YOU ARE THE MIMIC</b>\n<size=50%>B: wear your last catch\nB or GRIP: drop the disguise</color>";

		private MimicPhase _phase;

		private double _phaseStart;

		private double _cooldownReadyAt;

		private MonkeDevNetworkingPlayer.AppearanceSnapshot _look;

		private bool _cached;

		private Material[] _restMaterials;

		private Material[] _morphMaterials;

		private int[] _shapeIndices = Array.Empty<int>();

		private float[] _restWeights = Array.Empty<float>();

		private int _spasmIndex = -1;

		private bool _eyesRestActive;

		private Vector3 _restPosition;

		private Vector3 _alignedPosition;

		private Quaternion _restRotation;

		private Quaternion _alignedRotation;

		private Vector3 _restScale;

		private Vector3 _alignedScale;

		private MaterialPropertyBlock _mpb;

		private MaterialPropertyBlock _clearMpb;

		private HashSet<string> _eyeCoverings;

		private bool _secondaryHeld;

		private bool _leftGripHeld;

		private bool _rightGripHeld;

		private bool _keyHeld;

		private bool _restoreHierarchy;

		private float _spasmSeed;

		private float _nextRumble;

		private bool _cooldownPending;

		private double _hintRound = -1.0;

		public MimicPhase Phase => _phase;

		private Vector3 SfxPosition
		{
			get
			{
				if (!(player != null) || !(player.Head != null))
				{
					return base.transform.position;
				}
				return player.Head.position;
			}
		}

		private void Awake()
		{
			_spasmSeed = UnityEngine.Random.value * 100f;
			_mpb = new MaterialPropertyBlock();
			_clearMpb = new MaterialPropertyBlock();
			_eyeCoverings = new HashSet<string>(eyeCoveringCosmetics ?? Array.Empty<string>(), StringComparer.Ordinal);
			CacheRig();
		}

		private void OnDisable()
		{
			if (_phase != MimicPhase.Monster || _cooldownReadyAt > 0.0)
			{
				RestoreMimicLook();
				ReleaseDisguise();
				_restoreHierarchy = true;
			}
		}

		private void Update()
		{
			if (_restoreHierarchy)
			{
				_restoreHierarchy = false;
				RestoreHierarchy();
			}
			if (_phase == MimicPhase.Monster && _cooldownReadyAt <= 0.0 && !IsEligible())
			{
				return;
			}
			if (!IsEligible())
			{
				ResetToMonster();
				return;
			}
			if (base.photonView.IsMine)
			{
				ReadInput();
				TickOwnerFeedback();
			}
			if (_phase == MimicPhase.Revealing)
			{
				TickReveal();
			}
			else if (_phase == MimicPhase.MorphingIn)
			{
				TickMorph();
			}
		}

		private void ReadInput()
		{
			VRInputController instance = VRInputController.Instance;
			bool flag = instance != null && instance.RightSecondaryButton;
			bool flag2 = instance != null && instance.RightPrimaryButton;
			bool flag3 = BtmMimicRules.ShiftPressed(flag, _secondaryHeld, flag2);
			_secondaryHeld = flag;
			bool flag4 = KeyboardHeld();
			bool flag5 = flag4 && !_keyHeld;
			_keyHeld = flag4;
			bool flag6 = instance != null && instance.LeftGripValue > GripThreshold;
			bool flag7 = instance != null && instance.RightGripValue > GripThreshold;
			bool flag8 = (flag6 && !_leftGripHeld) || (flag7 && !_rightGripHeld);
			_leftGripHeld = flag6;
			_rightGripHeld = flag7;
			if (gameModePlayer.isMonster)
			{
				bool flag9 = flag5 || flag3;
				if (flag9 && _phase == MimicPhase.Monster)
				{
					RequestShift();
				}
				else if (_phase == MimicPhase.Disguised && (flag8 || flag9))
				{
					RequestReveal();
				}
			}
		}

		private bool KeyboardHeld()
		{
			Keyboard current = Keyboard.current;
			if (current == null || keyboardKey == Key.None)
			{
				return false;
			}
			return current[keyboardKey].isPressed;
		}

		[ContextMenu("Shift")]
		public void RequestShift()
		{
			if (!base.photonView.IsMine || _phase != MimicPhase.Monster || !IsEligible() || !gameModePlayer.isMonster)
			{
				return;
			}
			if (!BtmMimicRules.CooldownReady(PhotonNetwork.Time, _cooldownReadyAt, CooldownTolerance) || gameModePlayer.IsHighlighted || HandBusy())
			{
				Pulse(0.08f, 0.05f);
				return;
			}
			int ownerActorNr = base.photonView.OwnerActorNr;
			int num = BtmMimicRules.ResolveTarget(ownerActorNr, BtmMimicKills.LastKillActor(ownerActorNr));
			base.photonView.RPC("RPC_MimicShift", RpcTarget.All, num);
		}

		[ContextMenu("Reveal")]
		public void RequestReveal()
		{
			if (base.photonView.IsMine && _phase == MimicPhase.Disguised)
			{
				base.photonView.RPC("RPC_MimicShift", RpcTarget.All, BtmMimicRules.RevealTarget);
			}
		}

		private bool HandBusy()
		{
			BtmMonsterHand[] array = mimicHands;
			foreach (BtmMonsterHand btmMonsterHand in array)
			{
				if (btmMonsterHand != null && btmMonsterHand.isGrabbing)
				{
					return true;
				}
			}
			return false;
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_MimicShift(int target, PhotonMessageInfo info)
		{
			Photon.Realtime.Player sender = info.Sender;
			if (sender == null || sender.ActorNumber != base.photonView.OwnerActorNr || !IsEligible())
			{
				return;
			}
			double num = (double)info.SentServerTimestamp / 1000.0;
			SettleTransitions(num);
			if (target == BtmMimicRules.RevealTarget)
			{
				if (BtmMimicRules.AcceptsReveal(_phase))
				{
					BeginReveal(num);
				}
			}
			else if (BtmMimicRules.AcceptsShift(_phase) && BtmMimicRules.CooldownReady(num, _cooldownReadyAt, CooldownTolerance) && BtmMimicRules.IsValidTarget(target, sender.ActorNumber, BtmMimicKills.LastKillActor(sender.ActorNumber)))
			{
				BeginMorph(target, num);
			}
		}

		private void SettleTransitions(double time)
		{
			if (_phase == MimicPhase.MorphingIn)
			{
				if (_phaseStart + (double)morphDuration > time)
				{
					return;
				}
				FinishMorph();
			}
			if (_phase == MimicPhase.Revealing && _phaseStart + (double)revealDuration <= time)
			{
				FinishReveal();
			}
		}

		private void BeginMorph(int target, double startTime)
		{
			int ownerActorNr = base.photonView.OwnerActorNr;
			BtmMimicKills.Victim victim = ((ownerActorNr != target) ? BtmMimicKills.LastKill(ownerActorNr) : null);
			_look = Disguise((victim != null) ? victim.Look : BtmMimicKills.LookOf(player));
			_phase = MimicPhase.MorphingIn;
			_phaseStart = startTime;
			SetHandsLive(false);
			WearMorphMaterials(_look);
			gameModePlayer.UseSurvivorScale = true;
			ApplyOwnerScale();
			if (morphSfx != null)
			{
				morphSfx.PlayAudioAt(SfxPosition);
			}
			TickMorph();
		}

		private void TickMorph()
		{
			float num = BtmMimicRules.Progress(PhotonNetwork.Time, _phaseStart, morphDuration);
			MimicPose pose = BtmMimicRules.MorphInPose(num);
			ApplyPose(pose, 1f - num);
			Rumble(pose.Flash * 0.6f + 0.15f);
			if (num >= 1f)
			{
				FinishMorph();
			}
		}

		private void FinishMorph()
		{
			RestoreMimicLook();
			_phase = MimicPhase.Disguised;
			player.SetAppearanceOverride(_look, disguiseEyeMaterial);
			if (apeKillTrigger != null)
			{
				apeKillTrigger.enabled = false;
			}
			gameModePlayer.IsDisguised = true;
		}

		private void BeginReveal(double startTime)
		{
			if (_phase == MimicPhase.MorphingIn)
			{
				FinishMorph();
			}
			_phase = MimicPhase.Revealing;
			_cooldownPending = true;
			_phaseStart = startTime;
			_cooldownReadyAt = startTime + (double)revealDuration + (double)cooldown;
			player.ClearAppearanceOverride();
			if (apeKillTrigger != null)
			{
				apeKillTrigger.enabled = true;
			}
			gameModePlayer.IsDisguised = false;
			gameModePlayer.UseSurvivorScale = false;
			ApplyOwnerScale();
			WearMorphMaterials(_look ?? Disguise(BtmMimicKills.LookOf(player)));
			if (revealSfx != null)
			{
				revealSfx.PlayAudioAt(SfxPosition);
			}
			TickReveal();
		}

		private void TickReveal()
		{
			float num = BtmMimicRules.Progress(PhotonNetwork.Time, _phaseStart, revealDuration);
			MimicPose pose = BtmMimicRules.RevealPose(num);
			float num2 = 1f - num;
			ApplyPose(pose, num2);
			Rumble(num2 * 0.8f);
			if (num >= 1f)
			{
				FinishReveal();
			}
		}

		private void FinishReveal()
		{
			RestoreMimicLook();
			SetHandsLive(true);
			_look = null;
			_phase = MimicPhase.Monster;
		}

		private void ApplyPose(MimicPose pose, float spasm)
		{
			for (int i = 0; i < _shapeIndices.Length; i++)
			{
				float num = (1f - pose.Shape) * _restWeights[i];
				if (_shapeIndices[i] == _spasmIndex)
				{
					num += spasmWeight * ((Mathf.PerlinNoise(Time.time * 24f, _spasmSeed) - 0.5f) * 2f) * spasm;
				}
				mimicBody.SetBlendShapeWeight(_shapeIndices[i], Mathf.Clamp(num, 0f, 100f));
			}
			mimicRoot.localPosition = Vector3.LerpUnclamped(_restPosition, _alignedPosition, pose.Shape);
			mimicRoot.localRotation = Quaternion.SlerpUnclamped(_restRotation, _alignedRotation, pose.Shape);
			mimicRoot.localScale = Vector3.LerpUnclamped(_restScale, _alignedScale, pose.Shape);
			bool flag = _eyesRestActive || pose.Eyes;
			if (mimicEyes != null && mimicEyes.gameObject.activeSelf != flag)
			{
				mimicEyes.gameObject.SetActive(flag);
			}
			Transform transform2 = ((player != null && player.Head != null) ? player.Head : base.transform);
			float y = transform2.lossyScale.y;
			mimicBody.GetPropertyBlock(_mpb);
			_mpb.SetFloat(MorphId, pose.Sweep);
			_mpb.SetFloat(FlashId, pose.Flash);
			_mpb.SetFloat(SweepTopId, transform2.position.y + y * sweepHeadroom);
			_mpb.SetFloat(SweepHeightId, y * sweepHeight);
			_mpb.SetFloat(BulgeScaleId, y);
			mimicBody.SetPropertyBlock(_mpb);
		}

		private MonkeDevNetworkingPlayer.AppearanceSnapshot Disguise(MonkeDevNetworkingPlayer.AppearanceSnapshot look)
		{
			if (look == null || _eyeCoverings.Count == 0)
			{
				return look;
			}
			Dictionary<string, string> dictionary = new Dictionary<string, string>(look.Cosmetics.Count);
			foreach (KeyValuePair<string, string> cosmetic in look.Cosmetics)
			{
				dictionary[cosmetic.Key] = ((cosmetic.Key == "PlayerModel" || cosmetic.Key == "Skin" || cosmetic.Key == "Eye") ? cosmetic.Value : WithoutEyeCoverings(cosmetic.Value));
			}
			return new MonkeDevNetworkingPlayer.AppearanceSnapshot(look.Name, look.ColourJson, dictionary);
		}

		private string WithoutEyeCoverings(string csv)
		{
			if (string.IsNullOrEmpty(csv))
			{
				return csv;
			}
			string[] array = csv.Split(',');
			List<string> list = new List<string>(array.Length);
			string[] array2 = array;
			for (int i = 0; i < array2.Length; i++)
			{
				string text = array2[i].Trim();
				if (text.Length > 0 && !_eyeCoverings.Contains(text))
				{
					list.Add(text);
				}
			}
			return string.Join(",", list);
		}

		private void WearMorphMaterials(MonkeDevNetworkingPlayer.AppearanceSnapshot look)
		{
			if (!IsMorphMaterial(mimicBody.sharedMaterials))
			{
				_restMaterials = mimicBody.sharedMaterials;
			}
			mimicBody.sharedMaterials = _morphMaterials;
			Material skin = ((look != null) ? player.SkinMaterialFor(look.Cosmetics) : null);
			mimicBody.GetPropertyBlock(_mpb);
			_mpb.SetTexture(MainTexId, SkinTexture(skin, MainTexId, Texture2D.whiteTexture));
			_mpb.SetTexture(ColorMaskId, SkinTexture(skin, ColorMaskId, Texture2D.whiteTexture));
			_mpb.SetTexture(BumpMapId, SkinTexture(skin, BumpMapId, Texture2D.normalTexture));
			_mpb.SetColor(ColorId, ParseColour(look?.ColourJson));
			mimicBody.SetPropertyBlock(_mpb);
		}

		private bool IsMorphMaterial(Material[] materials)
		{
			if (materials != null && materials.Length != 0)
			{
				return materials[0] == morphBodyMaterial;
			}
			return false;
		}

		private static Texture SkinTexture(Material skin, int id, Texture fallback)
		{
			Texture texture = ((skin != null && skin.HasProperty(id)) ? skin.GetTexture(id) : null);
			if (!(texture != null))
			{
				return fallback;
			}
			return texture;
		}

		private static Color ParseColour(string json)
		{
			if (string.IsNullOrEmpty(json))
			{
				return Color.white;
			}
			try
			{
				return JsonUtility.FromJson<Color>(json);
			}
			catch (Exception)
			{
				return Color.white;
			}
		}

		private bool IsEligible()
		{
			if (!_cached || gameModePlayer == null || BTMGameManager.Instance == null)
			{
				return false;
			}
			BTMGameManager instance = BTMGameManager.Instance;
			if (!instance.roomProperties.roundActive)
			{
				return false;
			}
			int[] currentMonsters = instance.roomProperties.currentMonsters;
			if (currentMonsters == null)
			{
				return false;
			}
			if (Array.IndexOf(currentMonsters, base.photonView.OwnerActorNr) < 0)
			{
				return false;
			}
			GameModePlayer.MonsterEntry currentMonsterEntry = gameModePlayer.CurrentMonsterEntry;
			if (currentMonsterEntry == null)
			{
				return false;
			}
			return string.Equals(currentMonsterEntry.MonsterName, skinName, StringComparison.OrdinalIgnoreCase);
		}

		private void SetHandsLive(bool live)
		{
			BtmMonsterHand[] array = mimicHands;
			foreach (BtmMonsterHand btmMonsterHand in array)
			{
				if (btmMonsterHand != null && btmMonsterHand.gameObject.activeSelf != live)
				{
					btmMonsterHand.gameObject.SetActive(live);
				}
			}
		}

		private void RestoreMimicLook()
		{
			if (_cached)
			{
				if (_restMaterials != null && IsMorphMaterial(mimicBody.sharedMaterials))
				{
					mimicBody.sharedMaterials = _restMaterials;
				}
				_clearMpb.Clear();
				mimicBody.SetPropertyBlock(_clearMpb);
				for (int i = 0; i < _shapeIndices.Length; i++)
				{
					mimicBody.SetBlendShapeWeight(_shapeIndices[i], _restWeights[i]);
				}
				mimicRoot.localPosition = _restPosition;
				mimicRoot.localRotation = _restRotation;
				mimicRoot.localScale = _restScale;
			}
		}

		private void RestoreHierarchy()
		{
			SetHandsLive(true);
			if (mimicEyes != null && mimicEyes.gameObject.activeSelf != _eyesRestActive)
			{
				mimicEyes.gameObject.SetActive(_eyesRestActive);
			}
		}

		private void ReleaseDisguise()
		{
			_look = null;
			_phase = MimicPhase.Monster;
			_cooldownReadyAt = 0.0;
			_cooldownPending = false;
			if (player != null)
			{
				player.ClearAppearanceOverride();
			}
			if (apeKillTrigger != null)
			{
				apeKillTrigger.enabled = true;
			}
			if (gameModePlayer != null)
			{
				gameModePlayer.IsDisguised = false;
				gameModePlayer.UseSurvivorScale = false;
			}
		}

		private void ResetToMonster()
		{
			MimicPhase phase = _phase;
			RestoreMimicLook();
			RestoreHierarchy();
			ReleaseDisguise();
			if (phase != MimicPhase.Monster)
			{
				ApplyOwnerScale();
			}
		}

		private void ApplyOwnerScale()
		{
			if (base.photonView.IsMine && GorillaLocomotion.Player.HasInstance && !(BTMGameManager.Instance == null) && !(gameModePlayer == null))
			{
				GorillaLocomotion.Player.Instance.targetScale = gameModePlayer.RoundScale(BTMGameManager.Instance.roomSettings.monsterSize);
			}
		}

		private void CacheRig()
		{
			if (!player || !gameModePlayer || !mimicRoot || !mimicBody || !apeModel || !morphBodyMaterial || !morphTeethMaterial)
			{
				Debug.LogError("[BtmMimic] Missing references on " + base.name + ", the Mimic ability is disabled.", this);
				return;
			}
			_morphMaterials = new Material[2] { morphBodyMaterial, morphTeethMaterial };
			Mesh sharedMesh = mimicBody.sharedMesh;
			List<int> list = new List<int>(MonsterShapes.Length);
			List<float> list2 = new List<float>(MonsterShapes.Length);
			string[] monsterShapes = MonsterShapes;
			foreach (string text in monsterShapes)
			{
				if (!(sharedMesh != null))
				{
					continue;
				}
				int blendShapeIndex = sharedMesh.GetBlendShapeIndex(text);
				if (blendShapeIndex >= 0)
				{
					list.Add(blendShapeIndex);
					list2.Add(mimicBody.GetBlendShapeWeight(blendShapeIndex));
					if (text == SpasmShape)
					{
						_spasmIndex = blendShapeIndex;
					}
				}
			}
			_shapeIndices = list.ToArray();
			_restWeights = list2.ToArray();
			_eyesRestActive = mimicEyes != null && mimicEyes.gameObject.activeSelf;
			_restPosition = mimicRoot.localPosition;
			_restRotation = mimicRoot.localRotation;
			_restScale = mimicRoot.localScale;
			Transform parent = mimicBody.transform.parent;
			Matrix4x4 matrix4x = Matrix4x4.TRS(parent.localPosition, parent.localRotation, parent.localScale);
			Matrix4x4 matrix4x2 = mimicRoot.parent.worldToLocalMatrix * apeModel.localToWorldMatrix * matrix4x.inverse;
			_alignedPosition = matrix4x2.GetPosition();
			_alignedRotation = matrix4x2.rotation;
			_alignedScale = matrix4x2.lossyScale;
			_cached = true;
		}

		private void TickOwnerFeedback()
		{
			BTMGameManager instance = BTMGameManager.Instance;
			if (instance != null && gameModePlayer.isMonster && _hintRound != instance.roomProperties.startTime)
			{
				_hintRound = instance.roomProperties.startTime;
				if (BtmSelectedRole.Instance != null)
				{
					BtmSelectedRole.Instance.ShowNotice(HintText);
				}
			}
			if (_cooldownPending && _phase == MimicPhase.Monster && PhotonNetwork.Time >= _cooldownReadyAt)
			{
				_cooldownPending = false;
				Pulse(0.25f, 0.08f);
			}
		}

		private void Rumble(float amplitude)
		{
			if (base.photonView.IsMine && !(Time.time < _nextRumble))
			{
				_nextRumble = Time.time + RumbleInterval;
				Pulse(amplitude, RumbleInterval);
			}
		}

		private static void Pulse(float amplitude, float duration)
		{
			VRInputController instance = VRInputController.Instance;
			if (!(instance == null))
			{
				instance.PulseLeft(amplitude, duration);
				instance.PulseRight(amplitude, duration);
			}
		}
	}
}
