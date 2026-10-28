using LethalApeR.Social.UI;
using UnityEngine;

namespace LethalApeR.Social.Menu
{
	public sealed class MenuPlayersPage : MonoBehaviour
	{
		[SerializeField]
		private SocialListView list;

		private LobbyAdapter _adapter;

		public SocialListView List => list;

		private void Awake()
		{
			_adapter = new LobbyAdapter(list);
			list.Warm(0, 9);
		}

		private void OnEnable()
		{
			_adapter.Attach();
		}

		private void OnDisable()
		{
			_adapter.Detach();
		}

		private void Update()
		{
			_adapter.Tick();
		}
	}
}
