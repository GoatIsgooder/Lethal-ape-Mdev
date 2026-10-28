using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmCutRemains : MonoBehaviour
	{
		private readonly List<BtmBodyPart> _parts = new List<BtmBodyPart>();

		public int Splashes;

		public IReadOnlyList<BtmBodyPart> Parts => _parts;

		public BtmBodyPart Add(Rigidbody piece)
		{
			BtmBodyPart part = piece.gameObject.AddComponent<BtmBodyPart>();
			if (piece.TryGetComponent<MeshFilter>(out var filter))
			{
				part.Own(filter.sharedMesh);
			}
			if (piece.TryGetComponent<MeshCollider>(out var collider))
			{
				part.Own(collider.sharedMesh);
			}
			_parts.Add(part);
			return part;
		}

		public void Init(float lifetime)
		{
			foreach (BtmBodyPart part in _parts)
			{
				if ((bool)part)
				{
					part.Arm(lifetime);
				}
			}
		}

		public void Retire()
		{
			foreach (BtmBodyPart part in _parts)
			{
				if ((bool)part)
				{
					part.Retire();
				}
			}
		}

		private void Update()
		{
			for (int i = _parts.Count - 1; i >= 0; i--)
			{
				if (!_parts[i])
				{
					_parts.RemoveAt(i);
				}
			}
			if (_parts.Count == 0)
			{
				Object.Destroy(base.gameObject);
			}
		}
	}
}
