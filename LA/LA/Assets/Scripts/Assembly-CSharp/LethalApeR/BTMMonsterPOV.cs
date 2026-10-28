using System.Collections.Generic;
using System.Linq;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using Photon.Pun;
using UnityEngine;
using UnityEngine.Serialization;

namespace LethalApeR
{
	public class BTMMonsterPOV : MonoBehaviourPunCallbacks
	{
		[FormerlySerializedAs("_monsterPOVCamera")]
		public Camera monsterPovCamera;

		public List<MonkeDevNetworkingPlayer> monsters;

		public MonkeDevNetworkingPlayer trackedMonster;

		private bool _roundActive;

		private RoundProperties _props;

		private bool _hooked;

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
		}

		private void Hook()
		{
			if (!_hooked && !(BTMGameManager.Instance == null))
			{
				_hooked = true;
				BTMGameManager instance = BTMGameManager.Instance;
				instance.OnRoundStarted = (System.Action<int[], int[], bool, string>)System.Delegate.Combine(instance.OnRoundStarted, new System.Action<int[], int[], bool, string>(OnRoundStarted));
				BTMGameManager instance2 = BTMGameManager.Instance;
				instance2.OnRoundEnded = (System.Action<int[], string>)System.Delegate.Combine(instance2.OnRoundEnded, new System.Action<int[], string>(OnRoundEnded));
				BTMGameManager instance3 = BTMGameManager.Instance;
				instance3.OnRoundPropertiesChanged = (System.Action<RoundProperties>)System.Delegate.Combine(instance3.OnRoundPropertiesChanged, new System.Action<RoundProperties>(OnRoundPropertiesChanged));
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				if (!(BTMGameManager.Instance == null))
				{
					BTMGameManager instance = BTMGameManager.Instance;
					instance.OnRoundStarted = (System.Action<int[], int[], bool, string>)System.Delegate.Remove(instance.OnRoundStarted, new System.Action<int[], int[], bool, string>(OnRoundStarted));
					BTMGameManager instance2 = BTMGameManager.Instance;
					instance2.OnRoundEnded = (System.Action<int[], string>)System.Delegate.Remove(instance2.OnRoundEnded, new System.Action<int[], string>(OnRoundEnded));
					BTMGameManager instance3 = BTMGameManager.Instance;
					instance3.OnRoundPropertiesChanged = (System.Action<RoundProperties>)System.Delegate.Remove(instance3.OnRoundPropertiesChanged, new System.Action<RoundProperties>(OnRoundPropertiesChanged));
				}
			}
		}

		private void OnRoundPropertiesChanged(RoundProperties props)
		{
			if (!props.roundActive || props.currentMonsters == null)
			{
				return;
			}
			_props = props;
			_roundActive = true;
			monsters.Clear();
			MonkeDevNetworkingManager.Manager.Players.ForEach(delegate(MonkeDevNetworkingPlayer player)
			{
				if (props.currentMonsters.Contains(player.photonView.OwnerActorNr))
				{
					monsters.Add(player);
				}
			});
			if ((trackedMonster == null || !monsters.Contains(trackedMonster)) && monsters.Count > 0)
			{
				trackedMonster = monsters[0];
			}
		}

		public override void OnJoinedRoom()
		{
			OnRoundStarted(null, null, false, null);
		}

		private void OnRoundStarted(int[] _, int[] _1, bool _2, string _3)
		{
			RoundProps.TryRead(out _props);
			_roundActive = _props.roundActive;
			monsters.Clear();
			if (_props.currentMonsters.Length != 0)
			{
				MonkeDevNetworkingManager.Manager.Players.ForEach(delegate(MonkeDevNetworkingPlayer player)
				{
					if (_props.currentMonsters.Contains(player.photonView.OwnerActorNr))
					{
						monsters.Add(player);
					}
				});
			}
			if (monsters.Count > 0)
			{
				trackedMonster = monsters[0];
			}
			UpdateCamera();
		}

		private void OnRoundEnded(int[] winners, string map)
		{
			_roundActive = false;
			monsters.Clear();
			trackedMonster = null;
			UpdateCamera();
		}

		private void Update()
		{
			if (_roundActive && !(monsterPovCamera == null) && trackedMonster != null)
			{
				monsterPovCamera.transform.position = trackedMonster.Head.position;
				monsterPovCamera.transform.rotation = trackedMonster.Head.rotation;
				UpdateCamera();
			}
		}

		private void UpdateCamera()
		{
			if ((bool)monsterPovCamera)
			{
				monsterPovCamera.Render();
			}
		}

		private void TrackMonster(MonkeDevNetworkingPlayer monster)
		{
			trackedMonster = monster;
		}

		private void ClearTrackedMonster()
		{
			trackedMonster = null;
		}

		public void NextMonster()
		{
			if (monsters.Count != 0)
			{
				if ((bool)trackedMonster)
				{
					trackedMonster = monsters[(monsters.IndexOf(trackedMonster) + 1) % monsters.Count];
				}
				else
				{
					trackedMonster = monsters[0];
				}
			}
		}

		public void PreviousMonster()
		{
			if (monsters.Count != 0)
			{
				if ((bool)trackedMonster)
				{
					trackedMonster = monsters[(monsters.IndexOf(trackedMonster) + monsters.Count - 1) % monsters.Count];
				}
				else
				{
					trackedMonster = monsters[monsters.Count - 1];
				}
			}
		}
	}
}
