using System;
using System.Collections.Generic;
using UnityEngine;

namespace LALocomotion
{
	[Serializable]
	public class LAHand
	{
		[Tooltip("The hand's own colliders (the palm sphere). Held items add theirs at runtime.")]
		public List<Collider> colliders = new List<Collider>();

		[Tooltip("Smoothed wrist the colliders and held items hang from.")]
		public LAWrist wrist;

		[Tooltip("Plays this hand's touch sounds.")]
		public AudioSource audioSource;

		[Tooltip("Played when the touched surface has no entry in the surface sound list.")]
		public AudioClip fallbackTouchClip;

		[NonSerialized]
		public bool touching;

		[NonSerialized]
		internal float lastFeedbackTime = -1f;

		[NonSerialized]
		internal int feedbackFrame = -1;

		internal readonly List<LAContact> contacts = new List<LAContact>();

		internal readonly List<object> suspenders = new List<object>(2);

		public IReadOnlyList<LAContact> Contacts => contacts;

		public bool Suspended => suspenders.Count > 0;

		public int TouchingCount
		{
			get
			{
				int count = 0;
				for (int i = 0; i < contacts.Count; i++)
				{
					if (contacts[i].touching)
					{
						count++;
					}
				}
				return count;
			}
		}

		internal int IndexOf(Collider c)
		{
			for (int i = 0; i < contacts.Count; i++)
			{
				if (contacts[i].collider == c)
				{
					return i;
				}
			}
			return -1;
		}
	}
}
