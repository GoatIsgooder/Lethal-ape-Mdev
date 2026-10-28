using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[ExecuteAlways]
	[DisallowMultipleComponent]
	public class FnPropAnchor : MonoBehaviour
	{
		[Serializable]
		public class Rider
		{
			public Transform target;

			[HideInInspector]
			public Vector3 localPosition;

			[HideInInspector]
			public Quaternion localRotation = Quaternion.identity;

			[HideInInspector]
			public bool seated;
		}

		[Tooltip("Night fixtures that sit on this prop (buttons, labels, a console root). They follow it while editing.")]
		public Rider[] riders = new Rider[0];
	}
}
