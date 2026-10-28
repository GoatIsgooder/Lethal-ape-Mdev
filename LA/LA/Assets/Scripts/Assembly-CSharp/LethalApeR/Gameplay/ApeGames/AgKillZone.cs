using System.Reflection;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgKillZone : MonoBehaviour
	{
		public AgCause cause = AgCause.Fell;

		[Header("Non-instant death")]
		[SerializeField]
		private float downForce = 50f;

		[SerializeField]
		private float killDelay = 1.25f;

		[Header("Feedback (all optional)")]
		[SerializeField]
		private AudioSource entrySfx;

		[SerializeField]
		private AgVignettePulse vignettePulse;

		[SerializeField]
		private Color pulseColor = new Color(0.95f, 0.1f, 0.1f, 1f);

		private const float RefireSeconds = 1f;

		private BoxCollider _box;

		private float _nextFireAt;

		private bool _dying;

		private float _dyingSince;

		private void Awake()
		{
			_box = GetComponent<BoxCollider>();
			if (_box != null && _box.enabled)
			{
				_box.enabled = false;
			}
		}

		private void OnEnable()
		{
			_dying = false;
			_dyingSince = 0f;
			_nextFireAt = 0f;
		}

		private void Update()
		{
			if (_box == null)
			{
				return;
			}
			Transform head = (MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null;
			if (head == null)
			{
				return;
			}
			Vector3 local = transform.InverseTransformPoint(head.position);
			Vector3 center = _box.center;
			Vector3 half = _box.size * 0.5f;
			bool inside = Mathf.Abs(local.x - center.x) <= half.x && Mathf.Abs(local.y - center.y) <= half.y && Mathf.Abs(local.z - center.z) <= half.z;
			ApeGamesManager mgr = ApeGamesManager.Instance;
			if (mgr == null)
			{
				return;
			}
			if (_dying)
			{
				if (!inside || !(Time.time - _dyingSince < killDelay))
				{
					_dying = false;
					_nextFireAt = Time.time + 1f;
					mgr.HandleKillZone(cause);
				}
			}
			else
			{
				if (!inside || Time.time < _nextFireAt)
				{
					return;
				}
				if (mgr.IsLocalContestant())
				{
					mgr.ApplyLocalDownForce(downForce, killDelay);
					_dying = true;
					_dyingSince = Time.time;
					AgHaptics.Both(1f, 0.3f);
					if (entrySfx != null)
					{
						entrySfx.Play();
					}
					if (vignettePulse != null)
					{
						vignettePulse.Pulse(pulseColor, 1f);
					}
				}
				else
				{
					_nextFireAt = Time.time + 1f;
					mgr.HandleKillZone(cause);
				}
			}
		}
	}
}
