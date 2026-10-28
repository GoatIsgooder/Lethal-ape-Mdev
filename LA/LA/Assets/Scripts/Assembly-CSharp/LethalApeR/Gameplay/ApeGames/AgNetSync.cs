using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using Photon.Voice.PUN;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	public class AgNetSync : MonoBehaviour, IPunObservable, IOnEventCallback
	{
		[StructLayout((LayoutKind)2)]
		private struct FloatBits
		{
			[FieldOffset(0)]
			public float F;

			[FieldOffset(0)]
			public uint U;
		}

		[Serializable]
		private struct HandOffset
		{
			public Vector3 position;

			public Vector3 rotation;
		}

		[Serializable]
		private struct CrossplayHandOffsets
		{
			public HandOffset leftHand;

			public HandOffset rightHand;
		}

		private const byte PoseEventCode = 173;

		[Header("Avatar bones (wire on the prefab, same layout in both builds)")]
		[SerializeField]
		private Transform head;

		[SerializeField]
		private Transform leftHand;

		[SerializeField]
		private Transform rightHand;

		[Header("Name")]
		[SerializeField]
		private TMP_Text nameText;

		[Header("Build logo (crossplay), two quads above the name; the owner's build enables one")]
		[SerializeField]
		private GameObject laLogo;

		[SerializeField]
		private GameObject larLogo;

		[Header("Colour")]
		[SerializeField]
		private Renderer[] colorTargets;

		[Header("Crossplay hand offsets")]
		[SerializeField]
		private CrossplayHandOffsets laSourceOffsets;

		[SerializeField]
		private CrossplayHandOffsets larSourceOffsets;

		[SerializeField]
		private float lerpSpeed = 18f;

		[SerializeField]
		private bool debugLog;

		private static readonly Dictionary<int, AgNetSync> ByActor = new Dictionary<int, AgNetSync>();

		private int _registeredActor = -1;

		private const string ColourProp = "Colour";

		private const string BuildProp = "Build";

		private const string PoseFmtProp = "PoseFmt";

		private const byte PoseFormatVersion = 3;

		private const int PoseV3Length = 37;

		private const int PoseV2Length = 31;

		private const float PosRange = 128f;

		private const float HandRange = 4f;

		private const float Sqrt2Inv = 0.70710677f;

		private const string BuildTag = "LA";

		private const float ColorCheckInterval = 0.5f;

		private const float FormatCheckInterval = 0.5f;

		private const float SendInterval = 1f / 15f;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly RaiseEventOptions ToOthers = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.Others
		};

		private PhotonView _view;

		private PhotonVoiceView _voiceView;

		private AudioSource _voiceSource;

		private MaterialPropertyBlock _mpb;

		private float _nextColorCheck;

		private float _nextSend;

		private float _nextDebug;

		private float _nextFormatCheck;

		private bool _colorApplied;

		private bool _localPropsSent;

		private bool _sendV3;

		private Vector3 _headPos;

		private Vector3 _lHandPos;

		private Vector3 _rHandPos;

		private Quaternion _headRot = Quaternion.identity;

		private Quaternion _lHandRot = Quaternion.identity;

		private Quaternion _rHandRot = Quaternion.identity;

		private bool _received;

		private string _offsetsForBuild = string.Empty;

		private bool _offsetsFromLa;

		private bool _correctHands;

		private readonly object[] _poseData = new object[6];

		private readonly byte[] _poseBuffer = new byte[PoseV3Length];

		public Color CurrentColor { get; private set; } = Color.white;

		public string CurrentBuild { get; private set; } = string.Empty;

		public Transform Head => head;

		public Transform LeftHand => leftHand;

		public Transform RightHand => rightHand;

		public static int RegisteredCount => ByActor.Count;

		public Player Owner => (_view != null) ? _view.Owner : null;

		public int ActorNumber => (_view != null && _view.Owner != null) ? _view.OwnerActorNr : -1;

		public bool IsMine => _view != null && _view.IsMine;

		public AudioSource VoiceSource
		{
			get
			{
				if (_voiceSource != null)
				{
					return _voiceSource;
				}
				if (_voiceView == null)
				{
					_voiceView = GetComponent<PhotonVoiceView>();
				}
				var speaker = (_voiceView != null) ? _voiceView.SpeakerInUse : null;
				if (speaker != null)
				{
					_voiceSource = speaker.GetComponent<AudioSource>();
				}
				return _voiceSource;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			ByActor.Clear();
		}

		public static AgNetSync Get(int actorNumber)
		{
			if (ByActor.TryGetValue(actorNumber, out AgNetSync sync) && sync != null)
			{
				return sync;
			}
			return null;
		}

		public static void CollectAll(List<AgNetSync> into)
		{
			if (into == null)
			{
				return;
			}
			into.Clear();
			foreach (KeyValuePair<int, AgNetSync> item in ByActor)
			{
				if (item.Value != null)
				{
					into.Add(item.Value);
				}
			}
		}

		private void Awake()
		{
			_view = GetComponent<PhotonView>();
			_mpb = new MaterialPropertyBlock();
		}

		private void OnEnable()
		{
			PhotonNetwork.AddCallbackTarget(this);
		}

		private void OnDisable()
		{
			PhotonNetwork.RemoveCallbackTarget(this);
			Unregister();
		}

		private void OnDestroy()
		{
			Unregister();
		}

		private void RegisterActor()
		{
			if (_view == null || _view.Owner == null)
			{
				return;
			}
			int ownerActorNr = _view.OwnerActorNr;
			if (ownerActorNr != _registeredActor)
			{
				if (_registeredActor != -1)
				{
					ByActor.Remove(_registeredActor);
				}
				_registeredActor = ownerActorNr;
				ByActor[ownerActorNr] = this;
			}
		}

		private void Unregister()
		{
			if (_registeredActor != -1)
			{
				if (ByActor.TryGetValue(_registeredActor, out AgNetSync sync) && sync == this)
				{
					ByActor.Remove(_registeredActor);
				}
				_registeredActor = -1;
			}
		}

		private void Update()
		{
			if (_view == null)
			{
				return;
			}
			RegisterActor();
			if (Time.time >= _nextColorCheck)
			{
				_nextColorCheck = Time.time + ColorCheckInterval;
				RefreshFromProps();
			}
			if (_view.IsMine)
			{
				StampLocalProps();
				if (Time.time >= _nextFormatCheck)
				{
					_nextFormatCheck = Time.time + FormatCheckInterval;
					_sendV3 = RoomSupportsLatest();
				}
				GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
				if (instance != null)
				{
					if (head != null && instance.headCollider != null)
					{
						head.position = instance.headCollider.transform.position;
						head.rotation = instance.headCollider.transform.rotation;
					}
					if (leftHand != null && instance.leftHandFollower != null)
					{
						leftHand.position = instance.leftHandFollower.position;
						leftHand.rotation = instance.leftHandFollower.rotation;
					}
					if (rightHand != null && instance.rightHandFollower != null)
					{
						rightHand.position = instance.rightHandFollower.position;
						rightHand.rotation = instance.rightHandFollower.rotation;
					}
				}
				if (Time.time >= _nextSend && PhotonNetwork.InRoom)
				{
					_nextSend = Time.time + SendInterval;
					SendPose();
				}
			}
			else if (_received)
			{
				float t = 1f - Mathf.Exp((0f - lerpSpeed) * Time.deltaTime);
				if (head != null)
				{
					head.position = Vector3.Lerp(head.position, _headPos, t);
					head.rotation = Quaternion.Slerp(head.rotation, _headRot, t);
				}
				if (leftHand != null)
				{
					leftHand.position = Vector3.Lerp(leftHand.position, _lHandPos, t);
					leftHand.rotation = Quaternion.Slerp(leftHand.rotation, _lHandRot, t);
				}
				if (rightHand != null)
				{
					rightHand.position = Vector3.Lerp(rightHand.position, _rHandPos, t);
					rightHand.rotation = Quaternion.Slerp(rightHand.rotation, _rHandRot, t);
				}
			}
		}

		private void SendPose()
		{
			int o = 0;
			Transform h = (head != null) ? head : transform;
			Transform l = (leftHand != null) ? leftHand : transform;
			Transform r = (rightHand != null) ? rightHand : transform;
			if (_sendV3)
			{
				Vector3 position = h.position;
				_poseBuffer[o++] = PoseFormatVersion;
				WriteVectorFull(_poseBuffer, ref o, position);
				WriteRotation(_poseBuffer, ref o, h.rotation);
				WriteVector(_poseBuffer, ref o, l.position - position, HandRange);
				WriteRotation(_poseBuffer, ref o, l.rotation);
				WriteVector(_poseBuffer, ref o, r.position - position, HandRange);
				WriteRotation(_poseBuffer, ref o, r.rotation);
				PhotonNetwork.RaiseEvent(PoseEventCode, _poseBuffer, ToOthers, SendOptions.SendUnreliable);
			}
			else
			{
				_poseData[0] = h.position;
				_poseData[1] = h.rotation;
				_poseData[2] = l.position;
				_poseData[3] = l.rotation;
				_poseData[4] = r.position;
				_poseData[5] = r.rotation;
				PhotonNetwork.RaiseEvent(PoseEventCode, _poseData, ToOthers, SendOptions.SendUnreliable);
			}
			if (debugLog && Time.time >= _nextDebug)
			{
				_nextDebug = Time.time + 1f;
				Debug.Log(string.Format("[AgNetSync] WRITE (owner, v{0}) head={1}", _sendV3 ? 3 : 2, h.position));
			}
		}

		public void OnEvent(EventData photonEvent)
		{
			if (photonEvent.Code != PoseEventCode || _view == null || _view.IsMine || _view.OwnerActorNr != photonEvent.Sender)
			{
				return;
			}
			object customData = photonEvent.CustomData;
			if (customData is byte[] array)
			{
				if (array.Length >= PoseV3Length && array[0] == PoseFormatVersion)
				{
					ReadPoseV3(array);
				}
				else
				{
					if (array.Length < PoseV2Length || array[0] != 2)
					{
						return;
					}
					ReadPoseV2(array);
				}
			}
			else
			{
				if (!(customData is object[] array2) || array2.Length < 6)
				{
					return;
				}
				_headPos = (Vector3)array2[0];
				_headRot = (Quaternion)array2[1];
				_lHandPos = (Vector3)array2[2];
				_lHandRot = (Quaternion)array2[3];
				_rHandPos = (Vector3)array2[4];
				_rHandRot = (Quaternion)array2[5];
			}
			ApplyHandOffsets();
			_received = true;
			if (debugLog && Time.time >= _nextDebug)
			{
				_nextDebug = Time.time + 1f;
				Debug.Log(string.Format("[AgNetSync] READ (remote actor={0}) build='{1}' correcting={2} head={3}", photonEvent.Sender, CurrentBuild, _correctHands, _headPos));
			}
		}

		private void ApplyHandOffsets()
		{
			if (_correctHands)
			{
				CrossplayHandOffsets crossplayHandOffsets = (_offsetsFromLa ? laSourceOffsets : larSourceOffsets);
				_lHandRot *= Quaternion.Euler(crossplayHandOffsets.leftHand.rotation);
				_lHandPos += _lHandRot * crossplayHandOffsets.leftHand.position;
				_rHandRot *= Quaternion.Euler(crossplayHandOffsets.rightHand.rotation);
				_rHandPos += _rHandRot * crossplayHandOffsets.rightHand.position;
			}
		}

		private void ResolveHandOffsets()
		{
			if (!(CurrentBuild == _offsetsForBuild))
			{
				_offsetsForBuild = CurrentBuild;
				_offsetsFromLa = CurrentBuild == "LA";
				_correctHands = CurrentBuild != BuildTag && (_offsetsFromLa || CurrentBuild == "LAR");
			}
		}

		private void ReadPoseV3(byte[] b)
		{
			int o = 1;
			_headPos = ReadVectorFull(b, ref o);
			_headRot = ReadRotation(b, ref o);
			_lHandPos = _headPos + ReadVector(b, ref o, HandRange);
			_lHandRot = ReadRotation(b, ref o);
			_rHandPos = _headPos + ReadVector(b, ref o, HandRange);
			_rHandRot = ReadRotation(b, ref o);
		}

		private void ReadPoseV2(byte[] b)
		{
			int o = 1;
			_headPos = ReadVector(b, ref o, PosRange);
			_headRot = ReadRotation(b, ref o);
			_lHandPos = _headPos + ReadVector(b, ref o, HandRange);
			_lHandRot = ReadRotation(b, ref o);
			_rHandPos = _headPos + ReadVector(b, ref o, HandRange);
			_rHandRot = ReadRotation(b, ref o);
		}

		private static bool RoomSupportsLatest()
		{
			Room currentRoom = PhotonNetwork.CurrentRoom;
			if (currentRoom == null || currentRoom.Players == null)
			{
				return false;
			}
			int num = (PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1);
			foreach (KeyValuePair<int, Player> player in currentRoom.Players)
			{
				Player value = player.Value;
				if (value != null && value.ActorNumber != num)
				{
					if (!value.CustomProperties.TryGetValue(PoseFmtProp, out object fmt) || !(fmt is int version) || version < PoseFormatVersion)
					{
						return false;
					}
				}
			}
			return true;
		}

		private static void WriteVectorFull(byte[] b, ref int o, Vector3 v)
		{
			WriteFloat(b, ref o, v.x);
			WriteFloat(b, ref o, v.y);
			WriteFloat(b, ref o, v.z);
		}

		private static Vector3 ReadVectorFull(byte[] b, ref int o)
		{
			float x = ReadFloat(b, ref o);
			float y = ReadFloat(b, ref o);
			float z = ReadFloat(b, ref o);
			return new Vector3(x, y, z);
		}

		private static void WriteFloat(byte[] b, ref int o, float v)
		{
			FloatBits floatBits = default(FloatBits);
			floatBits.F = v;
			uint u = floatBits.U;
			b[o++] = (byte)u;
			b[o++] = (byte)(u >> 8);
			b[o++] = (byte)(u >> 16);
			b[o++] = (byte)(u >> 24);
		}

		private static float ReadFloat(byte[] b, ref int o)
		{
			FloatBits floatBits = default(FloatBits);
			floatBits.U = (uint)(b[o] | (b[o + 1] << 8) | (b[o + 2] << 16) | (b[o + 3] << 24));
			o += 4;
			return floatBits.F;
		}

		private static void WriteVector(byte[] b, ref int o, Vector3 v, float range)
		{
			WriteShort(b, ref o, Quantise(v.x, range));
			WriteShort(b, ref o, Quantise(v.y, range));
			WriteShort(b, ref o, Quantise(v.z, range));
		}

		private static Vector3 ReadVector(byte[] b, ref int o, float range)
		{
			float x = Dequantise(ReadShort(b, ref o), range);
			float y = Dequantise(ReadShort(b, ref o), range);
			float z = Dequantise(ReadShort(b, ref o), range);
			return new Vector3(x, y, z);
		}

		private static short Quantise(float value, float range)
		{
			return (short)Mathf.Clamp(Mathf.RoundToInt(value / range * 32767f), -32768, 32767);
		}

		private static float Dequantise(short raw, float range)
		{
			return (float)raw / 32767f * range;
		}

		private static void WriteShort(byte[] b, ref int o, short v)
		{
			b[o++] = (byte)v;
			b[o++] = (byte)(v >> 8);
		}

		private static short ReadShort(byte[] b, ref int o)
		{
			short result = (short)(b[o] | (b[o + 1] << 8));
			o += 2;
			return result;
		}

		private static void WriteRotation(byte[] b, ref int o, Quaternion q)
		{
			int num = 0;
			float num2 = Mathf.Abs(q.x);
			for (int i = 1; i < 4; i++)
			{
				float num3 = Mathf.Abs(Component(q, i));
				if (num3 > num2)
				{
					num2 = num3;
					num = i;
				}
			}
			float num4 = Component(q, num);
			uint num5 = (uint)(num << 30);
			int num6 = 20;
			for (int j = 0; j < 4; j++)
			{
				if (j != num)
				{
					float num7 = Component(q, j);
					if (num4 < 0f)
					{
						num7 = 0f - num7;
					}
					num5 |= (uint)(PackComponent(num7) << num6);
					num6 -= 10;
				}
			}
			b[o++] = (byte)num5;
			b[o++] = (byte)(num5 >> 8);
			b[o++] = (byte)(num5 >> 16);
			b[o++] = (byte)(num5 >> 24);
		}

		private static Quaternion ReadRotation(byte[] b, ref int o)
		{
			uint num = (uint)(b[o] | (b[o + 1] << 8) | (b[o + 2] << 16) | (b[o + 3] << 24));
			o += 4;
			int num2 = (int)(num >> 30);
			float num3 = UnpackComponent((int)((num >> 20) & 0x3FF));
			float num4 = UnpackComponent((int)((num >> 10) & 0x3FF));
			float num5 = UnpackComponent((int)(num & 0x3FF));
			float num6 = Mathf.Sqrt(Mathf.Max(0f, 1f - (num3 * num3 + num4 * num4 + num5 * num5)));
			return num2 switch
			{
				0 => new Quaternion(num6, num3, num4, num5),
				1 => new Quaternion(num3, num6, num4, num5),
				2 => new Quaternion(num3, num4, num6, num5),
				_ => new Quaternion(num3, num4, num5, num6),
			};
		}

		private static float Component(Quaternion q, int i)
		{
			return i switch
			{
				0 => q.x,
				1 => q.y,
				2 => q.z,
				_ => q.w,
			};
		}

		private static int PackComponent(float c)
		{
			return Mathf.Clamp(Mathf.RoundToInt((c / Sqrt2Inv * 0.5f + 0.5f) * 1023f), 0, 1023);
		}

		private static float UnpackComponent(int raw)
		{
			return ((float)raw / 1023f * 2f - 1f) * Sqrt2Inv;
		}

		public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
		{
		}

		private void RefreshFromProps()
		{
			Player owner = _view.Owner;
			if (owner == null)
			{
				return;
			}
			if (owner.CustomProperties.TryGetValue(BuildProp, out object build) && build is string text && text.Length > 0)
			{
				CurrentBuild = text;
			}
			ApplyBuildLogo();
			ResolveHandOffsets();
			if (nameText != null)
			{
				Player owner2 = _view.Owner;
				nameText.text = (!string.IsNullOrEmpty(owner2.NickName)) ? owner2.NickName : (owner2.UserId ?? string.Empty);
			}
			if (_view.Owner.CustomProperties.TryGetValue(ColourProp, out object colour) && colour is string json)
			{
				Color color;
				try
				{
					color = JsonUtility.FromJson<Color>(json);
				}
				catch (Exception)
				{
					return;
				}
				if (!_colorApplied || color != CurrentColor)
				{
					_colorApplied = true;
					CurrentColor = color;
					ApplyColor(color);
				}
			}
		}

		private void StampLocalProps()
		{
			if (_localPropsSent || !PhotonNetwork.InRoom || PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			Hashtable customProperties = PhotonNetwork.LocalPlayer.CustomProperties;
			if (customProperties != null)
			{
				bool flag = !customProperties.TryGetValue(BuildProp, out object build) || build as string != BuildTag;
				if (customProperties.TryGetValue(PoseFmtProp, out object fmt) && fmt is int version && !(flag || version < PoseFormatVersion))
				{
					_localPropsSent = true;
					return;
				}
			}
			Player localPlayer = PhotonNetwork.LocalPlayer;
			Hashtable hashtable = new Hashtable();
			hashtable[BuildProp] = BuildTag;
			hashtable[PoseFmtProp] = (int)PoseFormatVersion;
			localPlayer.SetCustomProperties(hashtable);
			_localPropsSent = true;
		}

		private void ApplyBuildLogo()
		{
			bool flag = CurrentBuild == "LA";
			bool flag2 = CurrentBuild == "LAR";
			if (laLogo != null && laLogo.activeSelf != flag)
			{
				laLogo.SetActive(flag);
			}
			if (larLogo != null && larLogo.activeSelf != flag2)
			{
				larLogo.SetActive(flag2);
			}
		}

		private void ApplyColor(Color col)
		{
			if (colorTargets == null)
			{
				return;
			}
			for (int i = 0; i < colorTargets.Length; i++)
			{
				Renderer renderer = colorTargets[i];
				if (!(renderer == null))
				{
					renderer.GetPropertyBlock(_mpb);
					_mpb.SetColor(ColorId, col);
					renderer.SetPropertyBlock(_mpb);
				}
			}
		}
	}
}
