using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public class BtmOwnerHiddenRenderer : MonoBehaviour
	{
		[Tooltip("Renderers to hide for the owning player. Empty = every Renderer under this object.")]
		[SerializeField]
		private Renderer[] renderers;

		private PhotonView _view;

		private void OnEnable()
		{
			Apply();
		}

		private void Start()
		{
			Apply();
		}

		public void Apply()
		{
			if (_view == null)
			{
				_view = GetComponentInParent<PhotonView>(true);
			}
			bool flag = _view == null || !_view.IsMine;
			Renderer[] array = ((renderers != null && renderers.Length != 0) ? renderers : GetComponentsInChildren<Renderer>(true));
			for (int i = 0; i < array.Length; i++)
			{
				if (array[i] != null)
				{
					array[i].enabled = flag;
				}
			}
		}
	}
}
