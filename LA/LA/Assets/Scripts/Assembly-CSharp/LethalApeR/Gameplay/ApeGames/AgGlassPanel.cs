using System.Reflection;
using GorillaLocomotion;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgGlassPanel : MonoBehaviour
	{
		public int row;

		public int side;

		private const float PushRepace = 0.05f;

		private const float SkinUpWorld = 0.35f;

		private const float SkinSideWorld = 0.08f;

		private Renderer[] _renderers;

		private Collider[] _colliders;

		private Collider[] _solidColliders;

		private bool _initialized;

		private float _lastPushTime = -999f;

		private Bounds _paneBounds;

		private bool _hasPaneBounds;

		public bool IsBad { get; private set; }

		public bool IsBroken { get; private set; }

		public bool IsResolved { get; set; }

		private void Awake()
		{
			EnsureInit();
		}

		public void SetBad(bool isBad)
		{
			EnsureInit();
			IsBad = isBad;
		}

		public void ResetPanel()
		{
			EnsureInit();
			IsBad = false;
			IsBroken = false;
			IsResolved = false;
			_lastPushTime = -999f;
			for (int i = 0; i < _renderers.Length; i++)
			{
				if (_renderers[i] != null)
				{
					_renderers[i].enabled = true;
				}
			}
			for (int j = 0; j < _colliders.Length; j++)
			{
				if (_colliders[j] != null)
				{
					_colliders[j].enabled = true;
				}
			}
		}

		public bool TryBreak()
		{
			EnsureInit();
			if (IsBroken)
			{
				return false;
			}
			IsBroken = true;
			for (int i = 0; i < _renderers.Length; i++)
			{
				if (_renderers[i] != null)
				{
					_renderers[i].enabled = false;
				}
			}
			for (int j = 0; j < _solidColliders.Length; j++)
			{
				if (_solidColliders[j] != null)
				{
					_solidColliders[j].enabled = false;
				}
			}
			return true;
		}

		private void OnTriggerEnter(Collider other)
		{
			HandleTouch(other);
		}

		private void OnTriggerStay(Collider other)
		{
			HandleTouch(other);
		}

		private void HandleTouch(Collider other)
		{
			if (IsBroken)
			{
				PushOutOfHole(other);
			}
		}

		private void PushOutOfHole(Collider other)
		{
			if (!(Time.unscaledTime - _lastPushTime < 0.05f) && IsLocalToucher(other))
			{
				ApeGamesManager instance = ApeGamesManager.Instance;
				if (!(instance == null) && ApeGamesManager.IsLocalAlive() && instance.settings != null && !(instance.settings.glass.brokenPushDownSpeed <= 0f))
				{
					_lastPushTime = Time.unscaledTime;
					AgHaptics.Both(0.55f, 0.08f);
				}
			}
		}

		public bool TryGetBounds(out Bounds bounds)
		{
			EnsureInit();
			if (!_hasPaneBounds && _solidColliders != null)
			{
				bool flag = false;
				Bounds paneBounds = default(Bounds);
				for (int i = 0; i < _solidColliders.Length; i++)
				{
					Collider collider = _solidColliders[i];
					if (!(collider == null) && collider.enabled && collider.gameObject.activeInHierarchy)
					{
						if (!flag)
						{
							paneBounds = collider.bounds;
							flag = true;
						}
						else
						{
							paneBounds.Encapsulate(collider.bounds);
						}
					}
				}
				if (flag && paneBounds.size.x > 0.0001f && paneBounds.size.y > 0.0001f)
				{
					_paneBounds = paneBounds;
					_hasPaneBounds = true;
				}
			}
			bounds = _paneBounds;
			return _hasPaneBounds;
		}

		public Vector3 SnapPoint(float yOffset)
		{
			if (TryGetBounds(out var bounds))
			{
				return new Vector3(bounds.center.x, bounds.max.y + yOffset, bounds.center.z);
			}
			return base.transform.position;
		}

		private static bool IsLocalToucher(Collider other)
		{
			if (other.CompareTag("MainCamera") || other.CompareTag("HandTag") || other.CompareTag("LFinger"))
			{
				return true;
			}
			MonkeDevNetworkingPlayer componentInParent = other.GetComponentInParent<MonkeDevNetworkingPlayer>();
			if (componentInParent != null)
			{
				if (MonkeDevNetworkingManager.Manager != null)
				{
					return componentInParent == MonkeDevNetworkingManager.Manager.LocalPlayer;
				}
				return false;
			}
			if (Player.HasInstance)
			{
				return other.transform.IsChildOf(Player.Instance.transform);
			}
			return false;
		}

		private void EnsureInit()
		{
			if (_initialized)
			{
				return;
			}
			_initialized = true;
			Rigidbody rigidbody = GetComponent<Rigidbody>();
			if (rigidbody == null)
			{
				rigidbody = base.gameObject.AddComponent<Rigidbody>();
			}
			rigidbody.isKinematic = true;
			rigidbody.useGravity = false;
			EnsureTriggerSkin();
			_renderers = GetComponentsInChildren<Renderer>(true);
			_colliders = GetComponentsInChildren<Collider>(true);
			int num = 0;
			for (int i = 0; i < _colliders.Length; i++)
			{
				if (_colliders[i] != null && !_colliders[i].isTrigger)
				{
					num++;
				}
			}
			_solidColliders = new Collider[num];
			int num2 = 0;
			for (int j = 0; j < _colliders.Length; j++)
			{
				if (_colliders[j] != null && !_colliders[j].isTrigger)
				{
					_solidColliders[num2++] = _colliders[j];
				}
			}
		}

		private void EnsureTriggerSkin()
		{
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(true);
			BoxCollider boxCollider = null;
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				if (componentsInChildren[i].isTrigger)
				{
					return;
				}
				if (boxCollider == null)
				{
					boxCollider = componentsInChildren[i] as BoxCollider;
				}
			}
			if (!(boxCollider == null))
			{
				GameObject gameObject = new GameObject("TriggerSkin");
				gameObject.transform.SetParent(boxCollider.transform, false);
				gameObject.layer = boxCollider.gameObject.layer;
				BoxCollider boxCollider2 = gameObject.AddComponent<BoxCollider>();
				boxCollider2.isTrigger = true;
				Vector3 lossyScale = boxCollider.transform.lossyScale;
				float num = 1f / Mathf.Max(Mathf.Abs(lossyScale.x), 0.0001f);
				float num2 = 1f / Mathf.Max(Mathf.Abs(lossyScale.y), 0.0001f);
				float num3 = 1f / Mathf.Max(Mathf.Abs(lossyScale.z), 0.0001f);
				boxCollider2.center = boxCollider.center + new Vector3(0f, SkinUpWorld * 0.5f * num2, 0f);
				boxCollider2.size = boxCollider.size + new Vector3(SkinSideWorld * 2f * num, SkinUpWorld * num2, SkinSideWorld * 2f * num3);
			}
		}
	}
}
