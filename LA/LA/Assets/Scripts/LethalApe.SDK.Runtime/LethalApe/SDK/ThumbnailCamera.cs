using UnityEngine;

namespace LethalApe.SDK
{
	[AddComponentMenu("LethalApe SDK/Thumbnail Camera")]
	[DisallowMultipleComponent]
	public sealed class ThumbnailCamera : MapComponent
	{
		[SerializeField]
		[Range(20f, 100f)]
		private float fieldOfView = 60f;

		public float FieldOfView => fieldOfView;
	}
}
