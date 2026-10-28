using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgRoleCardAnchor : MonoBehaviour
	{
		[Tooltip("Seconds between attempts while the local rig has not spawned yet.")]
		[SerializeField]
		private float retryInterval = 0.25f;

		private Transform _anchoredTo;

		private float _nextTry;

		private void OnEnable()
		{
			_anchoredTo = null;
			_nextTry = 0f;
		}

		private void LateUpdate()
		{
			if ((_anchoredTo != null && base.transform.parent == _anchoredTo) || Time.unscaledTime < _nextTry)
			{
				return;
			}
			_nextTry = Time.unscaledTime + Mathf.Max(0.05f, retryInterval);
			Transform transform = ResolveHmd();
			if (!(transform == null))
			{
				base.transform.SetParent(transform, worldPositionStays: false);
				_anchoredTo = transform;
			}
		}

		private static Transform ResolveHmd()
		{
			if (Player.HasInstance && Player.Instance != null && Player.Instance.mainCamera != null)
			{
				return Player.Instance.mainCamera.transform;
			}
			Camera main = Camera.main;
			if (main != null)
			{
				return main.transform;
			}
			return null;
		}
	}
}
