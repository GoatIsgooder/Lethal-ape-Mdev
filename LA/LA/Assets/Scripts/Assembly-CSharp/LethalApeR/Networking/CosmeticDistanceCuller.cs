using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Networking
{
	[DisallowMultipleComponent]
	[AddComponentMenu("Slop/Cosmetic Distance Culler")]
	public class CosmeticDistanceCuller : MonoBehaviour
	{
		private sealed class CullDriver : MonoBehaviour
		{
			private readonly LodRanker _ranker = new LodRanker();

			private readonly List<CosmeticDistanceCuller> _ranked = new List<CosmeticDistanceCuller>(64);

			private readonly List<float> _sqr = new List<float>(64);

			private float _next;

			private void LateUpdate()
			{
				if (Time.unscaledTime < _next)
				{
					return;
				}
				int count = All.Count;
				if (count == 0)
				{
					return;
				}
				float a = 0.1f;
				for (int i = 0; i < count; i++)
				{
					if (All[i] != null)
					{
						a = All[i].evaluateInterval;
						break;
					}
				}
				_next = Time.unscaledTime + Mathf.Max(a, 0.01f);
				Transform transform = PlayerLodRank.LocalHead();
				if (transform == null)
				{
					return;
				}
				Vector3 position = transform.position;
				_ranked.Clear();
				_sqr.Clear();
				_ranker.Begin(count);
				for (int j = 0; j < count; j++)
				{
					CosmeticDistanceCuller cosmeticDistanceCuller = All[j];
					if (cosmeticDistanceCuller == null)
					{
						continue;
					}
					if (cosmeticDistanceCuller.IsProtectedLocal)
					{
						cosmeticDistanceCuller.RestoreIfHidden();
						continue;
					}
					Vector3 headPosition = cosmeticDistanceCuller.HeadPosition;
					_ranked.Add(cosmeticDistanceCuller);
					float sqrMagnitude = (headPosition - position).sqrMagnitude;
					_sqr.Add(sqrMagnitude);
					_ranker.Add(sqrMagnitude);
				}
				if (_ranked.Count != 0)
				{
					_ranker.Sort();
					for (int k = 0; k < _ranked.Count; k++)
					{
						_ranked[k].Evaluate(_sqr[k], _ranker.RankOf(k));
					}
				}
			}
		}

		private const float DefHide = 25f;

		private const float DefShow = 21f;

		private const int DefBudget = 14;

		private const float DefInterval = 0.1f;

		[Header("Distances (metres from your head to theirs)")]
		[Tooltip("Cosmetics switch OFF beyond this.")]
		[SerializeField]
		private float hideDistance = 25f;

		[Tooltip("Cosmetics switch back ON inside this. Must be LESS than Hide Distance -- the gap is hysteresis, without which a player hovering on the boundary strobes, which is genuinely unpleasant to look at in a headset.")]
		[SerializeField]
		private float showDistance = 21f;

		[Tooltip("Only the nearest this many players show cosmetics at all, however close the rest are. This is the knob that caps a crowd; keep it generous, because a hat popping off somebody a few metres away is very noticeable. Set it to PlayerLodRank.UnlimitedBudget (999) to go back to distance-only.")]
		[SerializeField]
		private int budget = 14;

		[Header("Scheduling")]
		[Tooltip("Seconds between re-rankings, shared across the whole lobby. One tick is a squared distance per player plus a single index sort.")]
		[SerializeField]
		private float evaluateInterval = 0.1f;

		[Tooltip("Never cull your own cosmetics. You are always at distance ~0 from yourself so this rarely matters, but it is free insurance for first-person views.")]
		[SerializeField]
		private bool neverCullLocalPlayer = true;

		private MonkeDevNetworkingPlayer _player;

		private Renderer[] _cosmetics = Array.Empty<Renderer>();

		private bool _cacheValid;

		private bool _hidden;

		private static readonly List<CosmeticDistanceCuller> All = new List<CosmeticDistanceCuller>();

		private static CullDriver _driver;

		private static readonly List<Renderer> _scratch = new List<Renderer>(32);

		private bool IsProtectedLocal
		{
			get
			{
				if (neverCullLocalPlayer && _player != null && _player.photonView != null)
				{
					return _player.photonView.IsMine;
				}
				return false;
			}
		}

		private Vector3 HeadPosition
		{
			get
			{
				if (!(_player != null) || !(_player.Head != null))
				{
					return base.transform.position;
				}
				return _player.Head.position;
			}
		}

		private void Awake()
		{
			_player = GetComponent<MonkeDevNetworkingPlayer>();
		}

		private void OnEnable()
		{
			Sanitise();
			if (!All.Contains(this))
			{
				All.Add(this);
			}
			_cacheValid = false;
			EnsureDriver();
		}

		private void OnDisable()
		{
			All.Remove(this);
			ApplyState(hidden: false);
		}

		private static void EnsureDriver()
		{
			if (!(_driver != null))
			{
				GameObject gameObject = new GameObject("[Cosmetics] Cull Driver");
				gameObject.hideFlags = HideFlags.HideAndDontSave;
				_driver = gameObject.AddComponent<CullDriver>();
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
			}
		}

		public void InvalidateCache()
		{
			_cacheValid = false;
		}

		private void RebuildCache()
		{
			_cacheValid = true;
			if (_player == null || _player.CosmeticSlots == null)
			{
				_cosmetics = Array.Empty<Renderer>();
				return;
			}
			List<Renderer> list = new List<Renderer>(32);
			for (int i = 0; i < _player.CosmeticSlots.Count; i++)
			{
				MonkeDevNetworkingPlayer.CosmeticSlot cosmeticSlot = _player.CosmeticSlots[i];
				if (cosmeticSlot != null && !(cosmeticSlot.Object == null))
				{
					cosmeticSlot.Object.GetComponentsInChildren(includeInactive: true, _scratch);
					list.AddRange(_scratch);
				}
			}
			_cosmetics = list.ToArray();
			ApplyState(_hidden);
		}

		private void RestoreIfHidden()
		{
			if (!_cacheValid)
			{
				RebuildCache();
			}
			if (_hidden)
			{
				ApplyState(hidden: false);
			}
		}

		private void Evaluate(float sqr, int rank)
		{
			if (!_cacheValid)
			{
				RebuildCache();
			}
			if (_cosmetics.Length != 0)
			{
				bool flag = PlayerLodRank.Resolve(_hidden, sqr, hideDistance, showDistance, rank, PlayerLodRank.Scale(budget));
				if (_hidden != flag)
				{
					ApplyState(flag);
				}
			}
		}

		private void Show()
		{
			ApplyState(hidden: false);
		}

		private void ApplyState(bool hidden)
		{
			_hidden = hidden;
			for (int i = 0; i < _cosmetics.Length; i++)
			{
				Renderer renderer = _cosmetics[i];
				if (renderer != null && renderer.enabled == hidden)
				{
					renderer.enabled = !hidden;
				}
			}
		}

		private void OnValidate()
		{
			Sanitise();
		}

		public void ApplyDefaultsIfUnset()
		{
			Sanitise();
		}

		private void Sanitise()
		{
			if (!(hideDistance > 0f))
			{
				hideDistance = 25f;
			}
			if (!(showDistance > 0f))
			{
				showDistance = 21f;
			}
			if (showDistance >= hideDistance)
			{
				showDistance = Mathf.Max(hideDistance - 4f, 0.1f);
			}
			if (budget <= 0)
			{
				budget = 14;
			}
			if (!(evaluateInterval > 0f))
			{
				evaluateInterval = 0.1f;
			}
		}
	}
}
