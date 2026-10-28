using System;
using System.Collections.Generic;

namespace LethalApeR.PlayFab
{
	[Serializable]
	public class RemoteCatalog
	{
		public string CatalogVersion;

		public List<RemoteCatalogItem> Catalog;
	}
}
