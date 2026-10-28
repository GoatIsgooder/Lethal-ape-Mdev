using System.Collections;
using System.Reflection;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	[Obfuscation(Exclude = true)]
	public class BackroomsSlidingDoor : MonoBehaviourPun
	{
		[Header("Panels (the two leaves)")]
		public Transform leftPanel;

		public Transform rightPanel;

		[Header("Closed / open LOCAL positions (captured by the editor tool)")]
		public Vector3 leftClosedLocal;

		public Vector3 leftOpenLocal;

		public Vector3 rightClosedLocal;

		public Vector3 rightOpenLocal;

		[Header("Feel")]
		[Tooltip("Seconds for the doors to slide fully open/closed.")]
		public float slideDuration = 2f;

		[Tooltip("Optional slide SFX (Spatialize = OFF in editor per the project audio gotcha).")]
		public AudioSource slideSfx;

		private bool _open;

		private Coroutine _slide;

		private bool CanRpc
		{
			get
			{
				if (PhotonNetwork.InRoom && base.photonView != null)
				{
					return base.photonView.ViewID != 0;
				}
				return false;
			}
		}

		public bool IsOpen => _open;

		public Vector3 DoorwayCenter
		{
			get
			{
				if (leftPanel != null && rightPanel != null)
				{
					return (leftPanel.position + rightPanel.position) * 0.5f;
				}
				if (leftPanel != null)
				{
					return leftPanel.position;
				}
				if (rightPanel != null)
				{
					return rightPanel.position;
				}
				return base.transform.position;
			}
		}

		private void Awake()
		{
			ApplyImmediate(false);
		}

		public void MasterSetOpen(bool open)
		{
			if (CanRpc)
			{
				base.photonView.RPC("RPC_SetOpen", RpcTarget.AllBuffered, open);
			}
			else
			{
				RPC_SetOpen(open);
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_SetOpen(bool open)
		{
			_open = open;
			if (slideSfx != null && open)
			{
				slideSfx.Play();
			}
			if (_slide != null)
			{
				StopCoroutine(_slide);
			}
			if (base.isActiveAndEnabled && Application.isPlaying)
			{
				_slide = StartCoroutine(SlideRoutine(open));
			}
			else
			{
				ApplyImmediate(open);
			}
		}

		private IEnumerator SlideRoutine(bool open)
		{
			Vector3 lFrom = ((leftPanel != null) ? leftPanel.localPosition : Vector3.zero);
			Vector3 rFrom = ((rightPanel != null) ? rightPanel.localPosition : Vector3.zero);
			Vector3 lTo = (open ? leftOpenLocal : leftClosedLocal);
			Vector3 rTo = (open ? rightOpenLocal : rightClosedLocal);
			float dur = Mathf.Max(slideDuration, 0.05f);
			float t = 0f;
			while (t < dur)
			{
				t += Time.deltaTime;
				float k = Mathf.SmoothStep(0f, 1f, t / dur);
				if (leftPanel != null)
				{
					leftPanel.localPosition = Vector3.Lerp(lFrom, lTo, k);
				}
				if (rightPanel != null)
				{
					rightPanel.localPosition = Vector3.Lerp(rFrom, rTo, k);
				}
				yield return null;
			}
			ApplyImmediate(open);
			_slide = null;
		}

		private void ApplyImmediate(bool open)
		{
			if (leftPanel != null)
			{
				leftPanel.localPosition = (open ? leftOpenLocal : leftClosedLocal);
			}
			if (rightPanel != null)
			{
				rightPanel.localPosition = (open ? rightOpenLocal : rightClosedLocal);
			}
		}
	}
}
