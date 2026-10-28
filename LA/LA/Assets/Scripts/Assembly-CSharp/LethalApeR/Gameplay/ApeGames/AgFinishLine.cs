using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	public class AgFinishLine : MonoBehaviour
	{
		[SerializeField]
		private int roundIndex = -1;

		[Header("Crossing feedback (optional)")]
		[SerializeField]
		private AudioSource crossSfx;

		[SerializeField]
		private ParticleSystem crossBurst;

		private BoxCollider _box;

		private bool _crossFxPlayed;

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
			_crossFxPlayed = false;
		}

		private void Update()
		{
			if (_box == null)
			{
				return;
			}
			Transform head = ((MonkeDevNetworkingManager.Manager != null) ? MonkeDevNetworkingManager.Manager.Head : null);
			if (!(head == null))
			{
				Vector3 vector = base.transform.InverseTransformPoint(head.position);
				Vector3 center = _box.center;
				Vector3 size = _box.size;
				if (!(Mathf.Abs(vector.x - center.x) > size.x * 0.5f) && !(Mathf.Abs(vector.y - center.y) > size.y * 0.5f) && !(Mathf.Abs(vector.z - center.z) > size.z * 0.5f))
				{
					TryCross();
				}
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				TryCross();
			}
		}

		private void OnTriggerStay(Collider other)
		{
			if (other.CompareTag("MainCamera"))
			{
				TryCross();
			}
		}

		private void TryCross()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (instance == null)
			{
				return;
			}
			AgRoundProperties props = instance.Props;
			if (props == null || !(props.queue == ApeGamesManager.GameQueue) || props.phase != AgPhase.Round || props.round > 2 || (roundIndex >= 0 && props.round != roundIndex) || !ApeGamesManager.IsLocalAlive())
			{
				return;
			}
			Player localPlayer = PhotonNetwork.LocalPlayer;
			if (localPlayer == null || localPlayer.ActorNumber < 1 || props.EscapedContains(localPlayer.ActorNumber))
			{
				return;
			}
			if (!_crossFxPlayed)
			{
				_crossFxPlayed = true;
				AgHaptics.Both(0.8f, 0.22f);
				if (crossSfx != null)
				{
					crossSfx.Play();
				}
				if (crossBurst != null)
				{
					crossBurst.Play();
				}
			}
			instance.RequestFinishCross();
		}
	}
}
