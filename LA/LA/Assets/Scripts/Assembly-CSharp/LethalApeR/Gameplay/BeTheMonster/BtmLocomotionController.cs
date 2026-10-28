using System.Collections;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[DefaultExecutionOrder(100)]
	public class BtmLocomotionController : MonoBehaviour
	{
		private IMonsterLocomotion _active;

		private MonsterDefinition _def;

		private BtmConfig _cfg;

		private Player _player;

		private readonly MonsterEmbodiment _embodiment = new MonsterEmbodiment();

		public float DebugCrouch;

		public static BtmLocomotionController Instance { get; private set; }

		public IMonsterLocomotion ActiveLocomotion => _active;

		public MonsterDefinition ActiveDefinition => _def;

		public MonsterEmbodiment Embodiment => _embodiment;

		public bool IsActive => _active != null;

		private void Awake()
		{
			Instance = this;
			_player = GetComponent<Player>();
			if (_player == null)
			{
				_player = Player.Instance;
			}
		}

		private void OnEnable()
		{
			if (_player == null)
			{
				_player = GetComponent<Player>() ?? Player.Instance;
			}
		}

		private void OnDestroy()
		{
			ClearMonster();
			if (Instance == this)
			{
				Instance = null;
			}
		}

		public void SetMonster(MonsterDefinition def, BtmConfig cfg)
		{
			ClearMonster();
			if (def == null)
			{
				return;
			}
			_def = def;
			_cfg = cfg;
			if (_player == null)
			{
				_player = GetComponent<Player>() ?? Player.Instance;
			}
			if (def.locomotion == MonsterLocomotionType.Legged)
			{
				_active = new LeggedMonsterLocomotion();
			}
			else
			{
				_active = new GorillaMonsterLocomotion();
			}
			_active.Activate(def, cfg, _player);
			_embodiment.Equip(def, _player);
			if (_player != null)
			{
				_player.targetScale = def.scale;
			}
			if (_embodiment.IsEmbodied && isActiveAndEnabled)
			{
				StartCoroutine(CalibrateRoutine());
			}
		}

		private IEnumerator CalibrateRoutine()
		{
			int guard = 0;
			while (_embodiment.NeedsCalibration && guard++ < 60 && !_embodiment.TryCalibrate())
			{
				yield return null;
			}
		}

		public void ClearMonster()
		{
			_embodiment.Unequip();
			if (_active != null)
			{
				_active.Deactivate();
				_active = null;
			}
			_def = null;
			if (_player != null)
			{
				_player.targetScale = 1f;
			}
		}

		private void LateUpdate()
		{
			if (_active != null)
			{
				_active.Tick(Time.deltaTime);
				_embodiment.UpdateBody(Mathf.Max(_active.CrouchAmount, DebugCrouch));
			}
		}
	}
}
