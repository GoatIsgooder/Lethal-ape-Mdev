using UnityEngine;
using UnityEngine.AI;

namespace LethalApe.SDK
{
	[AddComponentMenu(null)]
	[DisallowMultipleComponent]
	public sealed class MapNavMesh : MapComponent
	{
		[SerializeField]
		private NavMeshData navMeshData;

		[SerializeField]
		private float bakedArea;

		[SerializeField]
		private string bakedUtc = "";

		public NavMeshData Data => navMeshData;

		public float BakedArea => bakedArea;

		public string BakedUtc => bakedUtc;
	}
}
