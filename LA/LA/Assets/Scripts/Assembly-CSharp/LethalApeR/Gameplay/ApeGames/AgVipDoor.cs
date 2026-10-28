using System.Reflection;
using LethalApeR.Networking;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgVipDoor : MonoBehaviour
	{
		private const string HintDefault = "VIP ONLY";

		public Collider blockCollider;

		public TMP_Text hintText;

		public float hintSeconds = 3f;

		private GameObject _hintGo;

		private bool _hintVisible;

		private float _hintHideAt;

		private bool _headInside;

		private BoxCollider _probeBox;

		private void Awake()
		{
			if (blockCollider == null || blockCollider.isTrigger)
			{
				Debug.LogError("[AgVipDoor] blockCollider must be assigned and SOLID (isTrigger = false), door will not gate.", this);
			}
			_probeBox = GetComponent<BoxCollider>();
			if (_probeBox != null && _probeBox == blockCollider)
			{
				_probeBox = null;
			}
			if (_probeBox != null && _probeBox.enabled)
			{
				_probeBox.enabled = false;
			}
			if (hintText != null)
			{
				_hintGo = hintText.gameObject;
				if (string.IsNullOrEmpty(hintText.text))
				{
					hintText.text = HintDefault;
				}
				_hintGo.SetActive(false);
			}
		}

		private void OnEnable()
		{
			AgEntitlements.OnEntitlementsChanged += OnEntitlementsChanged;
		}

		private void OnDisable()
		{
			AgEntitlements.OnEntitlementsChanged -= OnEntitlementsChanged;
			_headInside = false;
			if (blockCollider != null)
			{
				blockCollider.enabled = true;
			}
			HideHint();
		}

		private void Update()
		{
			UpdateHeadProbe();
			if (_hintVisible && Time.unscaledTime >= _hintHideAt)
			{
				HideHint();
			}
		}

		private void UpdateHeadProbe()
		{
			if (_probeBox == null)
			{
				return;
			}
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Transform transform = ((manager != null) ? manager.Head : null);
			if (transform == null)
			{
				return;
			}
			Vector3 vector = base.transform.InverseTransformPoint(transform.position);
			Vector3 center = _probeBox.center;
			Vector3 size = _probeBox.size;
			bool flag = Mathf.Abs(vector.x - center.x) <= size.x * 0.5f && Mathf.Abs(vector.y - center.y) <= size.y * 0.5f && Mathf.Abs(vector.z - center.z) <= size.z * 0.5f;
			if (flag == _headInside)
			{
				return;
			}
			_headInside = flag;
			if (flag)
			{
				Apply();
			}
			else if (blockCollider != null)
			{
				blockCollider.enabled = true;
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				_headInside = true;
				Apply();
			}
		}

		private void OnTriggerExit(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				_headInside = false;
				if (blockCollider != null)
				{
					blockCollider.enabled = true;
				}
			}
		}

		private void OnEntitlementsChanged()
		{
			if (_headInside)
			{
				Apply();
			}
		}

		private void Apply()
		{
			if (!(blockCollider == null))
			{
				if (AgEntitlements.OwnsVip)
				{
					blockCollider.enabled = false;
					HideHint();
				}
				else
				{
					blockCollider.enabled = true;
					ShowHint();
				}
			}
		}

		private void ShowHint()
		{
			if (!(_hintGo == null))
			{
				_hintHideAt = Time.unscaledTime + hintSeconds;
				if (!_hintVisible)
				{
					_hintVisible = true;
					_hintGo.SetActive(true);
				}
			}
		}

		private void HideHint()
		{
			if (_hintVisible)
			{
				_hintVisible = false;
				if (_hintGo != null)
				{
					_hintGo.SetActive(false);
				}
			}
		}
	}
}
