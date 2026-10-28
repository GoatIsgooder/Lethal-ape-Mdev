using System;
using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public sealed class PooledNetworkObject : MonoBehaviour
	{
		[Tooltip("Most idle copies of this prefab the pool keeps. Returns beyond this are destroyed. An idle NetworkPlayer is a whole rig resident in memory, so keep this near the room cap.")]
		[SerializeField]
		[Min(0f)]
		private int maxIdle = 32;

		private IPoolLifecycle[] _callbacks = Array.Empty<IPoolLifecycle>();

		private PhotonView[] _views = Array.Empty<PhotonView>();

		private Rigidbody[] _bodies = Array.Empty<Rigidbody>();

		private static readonly Comparison<IPoolLifecycle> ByOrder = (IPoolLifecycle a, IPoolLifecycle b) => a.PoolCallbackOrder.CompareTo(b.PoolCallbackOrder);

		internal int MaxIdle => maxIdle;

		internal NetworkPrefabPool Owner { get; private set; }

		internal string PoolKey { get; private set; }

		internal bool IsIdle { get; set; }

		internal void Bind(NetworkPrefabPool owner, string poolKey)
		{
			Owner = owner;
			PoolKey = poolKey;
			_callbacks = GetComponentsInChildren<IPoolLifecycle>(true);
			Array.Sort(_callbacks, ByOrder);
			_views = GetComponentsInChildren<PhotonView>(true);
			_bodies = GetComponentsInChildren<Rigidbody>(true);
		}

		internal void NotifyReleased()
		{
			for (int i = 0; i < _callbacks.Length; i++)
			{
				try
				{
					_callbacks[i].OnPoolReleased();
				}
				catch (Exception exception)
				{
					Debug.LogException(exception, this);
				}
			}
			for (int j = 0; j < _views.Length; j++)
			{
				PhotonView photonView = _views[j];
				if (photonView != null && photonView.ViewID != 0)
				{
					photonView.ViewID = 0;
				}
			}
			for (int k = 0; k < _bodies.Length; k++)
			{
				Rigidbody rigidbody = _bodies[k];
				if (!(rigidbody == null) && !rigidbody.isKinematic)
				{
					rigidbody.linearVelocity = Vector3.zero;
					rigidbody.angularVelocity = Vector3.zero;
				}
			}
		}

		internal void NotifyAcquired()
		{
			for (int i = 0; i < _callbacks.Length; i++)
			{
				try
				{
					_callbacks[i].OnPoolAcquired();
				}
				catch (Exception exception)
				{
					Debug.LogException(exception, this);
				}
			}
		}
	}
}
