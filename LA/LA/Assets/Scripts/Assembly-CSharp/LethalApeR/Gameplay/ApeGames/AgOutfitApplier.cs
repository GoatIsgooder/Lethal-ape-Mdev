using System.Reflection;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgOutfitApplier : MonoBehaviour
	{
		private const string AnchorName = "ApeGamesOutfits";

		private const string SeekerChild = "SeekerOutfit";

		private const string HiderChild = "HiderOutfit";

		private static bool _warned;

		private Transform _anchor;

		private GameObject _seekerOutfit;

		private GameObject _hiderOutfit;

		private bool _resolved;

		public static AgOutfitApplier GetFor(MonkeDevNetworkingPlayer player)
		{
			if (player == null)
			{
				return null;
			}
			AgOutfitApplier component = player.GetComponent<AgOutfitApplier>();
			if (component != null)
			{
				return component;
			}
			return player.gameObject.AddComponent<AgOutfitApplier>();
		}

		public void Apply(bool isSeeker)
		{
			if (Resolve())
			{
				if (!_anchor.gameObject.activeSelf)
				{
					_anchor.gameObject.SetActive(true);
				}
				if (_seekerOutfit != null)
				{
					_seekerOutfit.SetActive(isSeeker);
				}
				if (_hiderOutfit != null)
				{
					_hiderOutfit.SetActive(!isSeeker);
				}
			}
		}

		public void Clear()
		{
			if (Resolve() && !(_anchor == null))
			{
				if (_seekerOutfit != null)
				{
					_seekerOutfit.SetActive(false);
				}
				if (_hiderOutfit != null)
				{
					_hiderOutfit.SetActive(false);
				}
			}
		}

		private void OnDisable()
		{
			Clear();
			_anchor = null;
			_seekerOutfit = null;
			_hiderOutfit = null;
			_resolved = false;
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_warned = false;
		}

		private bool Resolve()
		{
			if (_resolved)
			{
				return _anchor != null;
			}
			_resolved = true;
			_anchor = transform.Find(AnchorName);
			if (_anchor == null)
			{
				_anchor = DeepFind(transform, AnchorName);
			}
			if (_anchor == null)
			{
				WarnOnce("no 'ApeGamesOutfits' anchor found on the player rig");
				return false;
			}
			Transform seeker = _anchor.Find(SeekerChild);
			Transform hider = _anchor.Find(HiderChild);
			_seekerOutfit = ((seeker != null) ? seeker.gameObject : null);
			_hiderOutfit = ((hider != null) ? hider.gameObject : null);
			if (_seekerOutfit == null || _hiderOutfit == null)
			{
				WarnOnce("'ApeGamesOutfits' anchor is missing a 'SeekerOutfit' and/or 'HiderOutfit' child");
			}
			return true;
		}

		private static Transform DeepFind(Transform root, string childName)
		{
			for (int i = 0; i < root.childCount; i++)
			{
				Transform child = root.GetChild(i);
				if (child.name == childName)
				{
					return child;
				}
				Transform found = DeepFind(child, childName);
				if (found != null)
				{
					return found;
				}
			}
			return null;
		}

		private void WarnOnce(string why)
		{
			if (!_warned)
			{
				_warned = true;
				Debug.LogError("[AgOutfitApplier] " + why + ", ApeGames role outfits are skipped until it's authored on NetworkPlayer.prefab.", this);
			}
		}
	}
}
