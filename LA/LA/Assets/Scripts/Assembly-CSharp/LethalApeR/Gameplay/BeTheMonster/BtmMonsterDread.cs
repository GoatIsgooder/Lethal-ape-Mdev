using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[RequireComponent(typeof(SlopDreadEmitter))]
	[DisallowMultipleComponent]
	public sealed class BtmMonsterDread : MonoBehaviour
	{
		[SerializeField]
		private GameModePlayer player;

		private SlopDreadEmitter _emitter;

		private void Awake()
		{
			_emitter = GetComponent<SlopDreadEmitter>();
			if (!player)
			{
				player = GetComponentInParent<GameModePlayer>();
			}
			_emitter.enabled = false;
		}

		private void OnDisable()
		{
			if ((bool)_emitter)
			{
				_emitter.enabled = false;
			}
		}

		private void Update()
		{
			bool flag = (bool)player && ((player.photonView != null && player.photonView.IsMine) ? player.isMonster : player.ShowsMonsterRig);
			if (_emitter.enabled != flag)
			{
				_emitter.enabled = flag;
			}
		}
	}
}
