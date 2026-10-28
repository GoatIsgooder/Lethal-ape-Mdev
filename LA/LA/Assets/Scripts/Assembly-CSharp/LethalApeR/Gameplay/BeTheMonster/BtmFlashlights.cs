using System.Collections.Generic;
using ExitGames.Client.Photon;
using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.InputSystem;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmFlashlights : MonoBehaviourPunCallbacks
	{
		public const string PropKey = "btmFl";

		[Tooltip("This map's volumes: a player carries a torch while their head is inside one of them.")]
		[SerializeField]
		private BtmMapVolumeBinder area;

		[Tooltip("For a map without a volume binder: boxes covering the map. Authoring only, switched off on Awake (a live collider is a wall to gorilla locomotion).")]
		[SerializeField]
		private BoxCollider[] areaBoxes = new BoxCollider[0];

		[SerializeField]
		private float areaMargin = 1.5f;

		[SerializeField]
		private BtmFlashlight torchPrefab;

		[Header("Quest budget")]
		[Tooltip("Realtime spot lights from torches, the holder's own included. Each is a ForwardAdd pass over everything it reaches.")]
		[SerializeField]
		[Range(1f, 4f)]
		private int maxRealtimeLights = 2;

		[Tooltip("A remote torch whose light lands further than this from the eye never gets a real light; the fog has it by then.")]
		[SerializeField]
		private float remoteLightRange = 22f;

		[Tooltip("Beyond this a remote torch's haze and glare switch off and it stops raycasting.")]
		[SerializeField]
		private float hazeRange = 32f;

		[Tooltip("Remote beams drawing their haze at once, nearest the eye first (one the eye stands in always counts). Each is a transparent cone up to full screen plus 13 raycasts a frame; the rest show their glare only.")]
		[SerializeField]
		[Range(0f, 6f)]
		private int maxHazes = 3;

		[Header("Editor")]
		[SerializeField]
		private Key debugKey = Key.L;

		private readonly Dictionary<int, BtmFlashlight> _byActor = new Dictionary<int, BtmFlashlight>();

		private readonly List<int> _actors = new List<int>();

		private readonly Stack<BtmFlashlight> _pool = new Stack<BtmFlashlight>();

		private readonly Hashtable _prop = new Hashtable();

		private Camera _cam;

		private int _stamp;

		private double _round = double.NaN;

		private bool _on;

		private bool _held;

		private void Awake()
		{
			for (int i = 0; i < areaBoxes.Length; i++)
			{
				if (areaBoxes[i] != null)
				{
					areaBoxes[i].enabled = false;
				}
			}
		}

		public override void OnEnable()
		{
			base.OnEnable();
			ClearStaleProp();
		}

		public override void OnDisable()
		{
			base.OnDisable();
			SetOn(false);
			for (int num = _actors.Count - 1; num >= 0; num--)
			{
				Park(num);
			}
		}

		public override void OnJoinedRoom()
		{
			ClearStaleProp();
		}

		private void LateUpdate()
		{
			_stamp++;
			RoundProperties props = default(RoundProperties);
			BTMGameManager instance = BTMGameManager.Instance;
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			bool flag = instance != null && manager != null && PhotonNetwork.InRoom && instance.roomProperties.roundActive;
			MonkeDevNetworkingPlayer monkeDevNetworkingPlayer = null;
			if (flag)
			{
				props = instance.roomProperties;
				if (!props.startTime.Equals(_round))
				{
					_round = props.startTime;
					SetOn(false);
				}
				monkeDevNetworkingPlayer = manager.LocalPlayer;
			}
			bool flag2 = monkeDevNetworkingPlayer != null && monkeDevNetworkingPlayer.photonView != null && Carries(monkeDevNetworkingPlayer, props, mine: true);
			Switch(flag2);
			if (flag)
			{
				List<MonkeDevNetworkingPlayer> players = manager.Players;
				for (int i = 0; i < players.Count; i++)
				{
					MonkeDevNetworkingPlayer monkeDevNetworkingPlayer2 = players[i];
					if (monkeDevNetworkingPlayer2 == null || monkeDevNetworkingPlayer2.photonView == null || monkeDevNetworkingPlayer2.photonView.Owner == null)
					{
						continue;
					}
					bool isMine = monkeDevNetworkingPlayer2.photonView.IsMine;
					if (isMine ? flag2 : Carries(monkeDevNetworkingPlayer2, props, mine: false))
					{
						bool fresh;
						BtmFlashlight btmFlashlight = Claim(monkeDevNetworkingPlayer2.photonView.OwnerActorNr, out fresh);
						btmFlashlight.Follow(monkeDevNetworkingPlayer2.LeftHand, Mathf.Clamp(monkeDevNetworkingPlayer2.Head.localScale.x, 0.25f, 4f));
						btmFlashlight.SetState(isMine ? _on : IsOn(monkeDevNetworkingPlayer2.photonView.Owner), isMine, !fresh);
					}
				}
			}
			for (int num = _actors.Count - 1; num >= 0; num--)
			{
				if (_byActor[_actors[num]].Stamp != _stamp)
				{
					Park(num);
				}
			}
			if (_actors.Count != 0)
			{
				if (_cam == null || !_cam.isActiveAndEnabled)
				{
					_cam = Camera.main;
				}
				Vector3 position = ((_cam != null) ? _cam.transform : base.transform).position;
				Vector3 forward = ((_cam != null) ? _cam.transform : base.transform).forward;
				Budget(position, forward);
				HazeBudget(position, forward);
				float deltaTime = Time.deltaTime;
				for (int j = 0; j < _actors.Count; j++)
				{
					_byActor[_actors[j]].Tick(deltaTime, position, hazeRange);
				}
			}
		}

		private bool Carries(MonkeDevNetworkingPlayer p, RoundProperties props, bool mine)
		{
			if (!p.isActiveAndEnabled || p.Head == null || p.LeftHand == null)
			{
				return false;
			}
			if (!mine && p.NetworkHidden)
			{
				return false;
			}
			int ownerActorNr = p.photonView.OwnerActorNr;
			if (!Has(props.activePlayers, ownerActorNr) && !Has(props.currentMonsters, ownerActorNr))
			{
				return false;
			}
			if (Has(props.escapedPlayers, ownerActorNr))
			{
				return false;
			}
			return InArea(p.Head.position);
		}

		private bool InArea(Vector3 point)
		{
			if (BtmSpawnArea.Contains(point))
			{
				return false;
			}
			if (area != null)
			{
				return area.Contains(point, areaMargin);
			}
			for (int i = 0; i < areaBoxes.Length; i++)
			{
				if (InBox(areaBoxes[i], point))
				{
					return true;
				}
			}
			return areaBoxes.Length == 0;
		}

		private bool InBox(BoxCollider box, Vector3 point)
		{
			if (box == null)
			{
				return false;
			}
			Transform transform = box.transform;
			Vector3 vector = transform.InverseTransformPoint(point);
			Vector3 center = box.center;
			Vector3 lossyScale = transform.lossyScale;
			Vector3 size = box.size;
			if (Mathf.Abs(vector.x - center.x) <= size.x * 0.5f + areaMargin / Mathf.Max(Mathf.Abs(lossyScale.x), 0.0001f) && Mathf.Abs(vector.y - center.y) <= size.y * 0.5f + areaMargin / Mathf.Max(Mathf.Abs(lossyScale.y), 0.0001f))
			{
				return Mathf.Abs(vector.z - center.z) <= size.z * 0.5f + areaMargin / Mathf.Max(Mathf.Abs(lossyScale.z), 0.0001f);
			}
			return false;
		}

		private void Switch(bool carrying)
		{
			bool flag = ButtonHeld();
			bool held = _held;
			_held = flag;
			if (!carrying)
			{
				SetOn(false);
			}
			else if (flag && !held)
			{
				SetOn(!_on);
				if (VRInputController.Instance != null)
				{
					VRInputController.Instance.PulseLeft(0.3f, 0.03f);
				}
			}
		}

		private bool ButtonHeld()
		{
			if (VRInputController.Instance != null && VRInputController.Instance.LeftSecondaryButton)
			{
				return true;
			}
			return false;
		}

		private void SetOn(bool on)
		{
			if (_on != on)
			{
				_on = on;
				Publish(on);
			}
		}

		private void ClearStaleProp()
		{
			if (!_on && IsOn(PhotonNetwork.LocalPlayer))
			{
				Publish(false);
			}
		}

		private void Publish(bool on)
		{
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (localPlayer != null)
			{
				_prop[PropKey] = on;
				localPlayer.SetCustomProperties(_prop);
			}
		}

		private static bool IsOn(Player owner)
		{
			if (owner != null && owner.CustomProperties != null && owner.CustomProperties.TryGetValue(PropKey, out var value) && value is bool flag)
			{
				return flag;
			}
			return false;
		}

		private void Budget(Vector3 eye, Vector3 look)
		{
			int num = maxRealtimeLights;
			for (int i = 0; i < _actors.Count; i++)
			{
				BtmFlashlight btmFlashlight = _byActor[_actors[i]];
				bool flag = btmFlashlight.Holder && btmFlashlight.Lit && num > 0;
				btmFlashlight.LightTarget = (flag ? 1f : 0f);
				if (flag)
				{
					num--;
				}
			}
			if (num < 1)
			{
				return;
			}
			float num2 = remoteLightRange * remoteLightRange;
			while (num > 0)
			{
				BtmFlashlight btmFlashlight2 = null;
				float num3 = float.MaxValue;
				for (int j = 0; j < _actors.Count; j++)
				{
					BtmFlashlight btmFlashlight3 = _byActor[_actors[j]];
					if (btmFlashlight3.Holder || !btmFlashlight3.Lit || btmFlashlight3.LightTarget > 0f)
					{
						continue;
					}
					Vector3 vector = btmFlashlight3.Focus - eye;
					float sqrMagnitude = vector.sqrMagnitude;
					if (!(sqrMagnitude > num2))
					{
						float num4 = Mathf.Sqrt(sqrMagnitude);
						if (Vector3.Dot(look, vector) < 0f)
						{
							num4 += 8f;
						}
						if (btmFlashlight3.HasLight)
						{
							num4 -= 2f;
						}
						if (num4 < num3)
						{
							num3 = num4;
							btmFlashlight2 = btmFlashlight3;
						}
					}
				}
				if (btmFlashlight2 == null)
				{
					break;
				}
				btmFlashlight2.LightTarget = 1f;
				num--;
			}
		}

		private void HazeBudget(Vector3 eye, Vector3 look)
		{
			float num = hazeRange * hazeRange;
			for (int i = 0; i < _actors.Count; i++)
			{
				BtmFlashlight btmFlashlight = _byActor[_actors[i]];
				if (btmFlashlight.Lit && !btmFlashlight.Holder && !btmFlashlight.Blocked && (btmFlashlight.LensPosition - eye).sqrMagnitude < num)
				{
					Vector3 nearest;
					float num2 = btmFlashlight.BeamDistance(eye, out nearest);
					if (num2 > 0f && Vector3.Dot(look, nearest - eye) < 0f)
					{
						num2 += 8f;
					}
					btmFlashlight.HazeRank = (btmFlashlight.Haze ? (num2 - 2f) : num2);
				}
				else
				{
					btmFlashlight.HazeRank = float.MaxValue;
				}
				btmFlashlight.Haze = false;
			}
			for (int j = 0; j < maxHazes; j++)
			{
				BtmFlashlight btmFlashlight2 = null;
				for (int k = 0; k < _actors.Count; k++)
				{
					BtmFlashlight btmFlashlight3 = _byActor[_actors[k]];
					if (!btmFlashlight3.Haze && btmFlashlight3.HazeRank != float.MaxValue && (btmFlashlight2 == null || btmFlashlight3.HazeRank < btmFlashlight2.HazeRank))
					{
						btmFlashlight2 = btmFlashlight3;
					}
				}
				if (btmFlashlight2 == null)
				{
					break;
				}
				btmFlashlight2.Haze = true;
			}
		}

		private BtmFlashlight Claim(int actor, out bool fresh)
		{
			if (_byActor.TryGetValue(actor, out var value))
			{
				value.Stamp = _stamp;
				fresh = false;
				return value;
			}
			value = ((_pool.Count > 0) ? _pool.Pop() : Object.Instantiate(torchPrefab, base.transform));
			value.gameObject.SetActive(true);
			value.Stamp = _stamp;
			_byActor[actor] = value;
			_actors.Add(actor);
			fresh = true;
			return value;
		}

		private void Park(int index)
		{
			int key = _actors[index];
			BtmFlashlight btmFlashlight = _byActor[key];
			_byActor.Remove(key);
			_actors.RemoveAt(index);
			if (!(btmFlashlight == null))
			{
				btmFlashlight.ResetState();
				btmFlashlight.gameObject.SetActive(false);
				_pool.Push(btmFlashlight);
			}
		}

		private static bool Has(int[] actors, int actor)
		{
			if (actors == null)
			{
				return false;
			}
			for (int i = 0; i < actors.Length; i++)
			{
				if (actors[i] == actor)
				{
					return true;
				}
			}
			return false;
		}
	}
}
