using System;

namespace LethalApeR.PlayFab
{
	[Serializable]
	public class RemoteCatalogItem
	{
		public string ItemId;

		public string ItemClass;

		public string DisplayName;

		public RemoteVirtualCurrencyPrices VirtualCurrencyPrices;

		public RemoteBundle Bundle;
	}
}
