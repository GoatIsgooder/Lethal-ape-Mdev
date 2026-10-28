using System;
using UnityEngine;

namespace LethalApeR
{
	[RequireComponent(typeof(BoxCollider))]
	public class ColorTouchSurface : MonoBehaviour
	{
		public enum Shape
		{
			Circle = 0,
			Stadium = 1
		}

		[SerializeField]
		private Shape shape;

		[Tooltip("A fingertip closer than this above the face starts a touch.")]
		[SerializeField]
		private float pressHeight = 0.012f;

		[Tooltip("A touch ends once the fingertip rises above this.")]
		[SerializeField]
		private float releaseHeight = 0.028f;

		[Tooltip("How far below the face a fingertip may sink. The hand's locomotion sphere meets the desk before the finger gets this deep.")]
		[SerializeField]
		private float maxDepth = 0.08f;

		[Tooltip("How far past the edge a touch may drift before it ends.")]
		[SerializeField]
		private float releaseMargin = 0.02f;

		private readonly Collider[] _candidates = new Collider[4];

		private int _candidateCount;

		private Collider _finger;

		private Vector2 _halfSize = new Vector2(0.1f, 0.1f);

		private float _faceHeight;

		public bool IsTouching { get; private set; }

		public bool TouchIsLeft { get; private set; }

		public Vector2 TouchPoint { get; private set; }

		private void Awake()
		{
			FitToMesh();
		}

		private void Reset()
		{
			FitToMesh();
		}

		private void OnDisable()
		{
			Array.Clear(_candidates, 0, _candidates.Length);
			_candidateCount = 0;
			_finger = null;
			IsTouching = false;
		}

		private void OnTriggerEnter(Collider other)
		{
			if (!other.CompareTag("HandTag"))
			{
				return;
			}
			for (int i = 0; i < _candidateCount; i++)
			{
				if (_candidates[i] == other)
				{
					return;
				}
			}
			if (_candidateCount < _candidates.Length)
			{
				_candidates[_candidateCount++] = other;
			}
		}

		private void OnTriggerExit(Collider other)
		{
			for (int i = 0; i < _candidateCount; i++)
			{
				if (_candidates[i] == other)
				{
					_candidateCount--;
					_candidates[i] = _candidates[_candidateCount];
					_candidates[_candidateCount] = null;
					break;
				}
			}
		}

		public bool Tick(out bool began, out bool ended)
		{
			bool isTouching = IsTouching;
			IsTouching = TrackFinger(isTouching);
			began = IsTouching && !isTouching;
			ended = isTouching && !IsTouching;
			return IsTouching;
		}

		public void FitToMesh()
		{
			MeshFilter component = GetComponent<MeshFilter>();
			if (component != null && component.sharedMesh != null)
			{
				Bounds bounds = component.sharedMesh.bounds;
				_halfSize = new Vector2(bounds.extents.x, bounds.extents.z);
				_faceHeight = bounds.center.y + bounds.extents.y;
			}
			float num = ((shape == Shape.Circle) ? _halfSize.x : _halfSize.y);
			BoxCollider component2 = GetComponent<BoxCollider>();
			float num2 = _faceHeight + releaseHeight + 0.01f;
			float num3 = _faceHeight - maxDepth - 0.01f;
			float num4 = releaseMargin + 0.01f;
			component2.isTrigger = true;
			component2.center = new Vector3(0f, (num3 + num2) * 0.5f, 0f);
			component2.size = new Vector3((num4 + _halfSize.x) * 2f, num2 - num3, (num4 + num) * 2f);
		}

		private bool TrackFinger(bool wasTouching)
		{
			PruneCandidates();
			if (_finger != null)
			{
				if (Usable(_finger) && Sample(FingerPoint(_finger), holding: true, out var point))
				{
					TouchPoint = point;
					return true;
				}
				_finger = null;
				return false;
			}
			if (!wasTouching)
			{
				for (int i = 0; i < _candidateCount; i++)
				{
					Collider collider = _candidates[i];
					if (Sample(FingerPoint(collider), holding: false, out var point2))
					{
						_finger = collider;
						TouchIsLeft = IsLeftFinger(collider);
						TouchPoint = point2;
						return true;
					}
				}
			}
			return false;
		}

		private bool Sample(Vector3 world, bool holding, out Vector2 point)
		{
			Vector3 vector = transform.InverseTransformPoint(world);
			point = new Vector2(vector.x, vector.z);
			float num = vector.y - _faceHeight;
			if (num > (holding ? releaseHeight : pressHeight) || num < 0f - maxDepth)
			{
				return false;
			}
			return EdgeDistance(point) <= (holding ? releaseMargin : 0f);
		}

		private float EdgeDistance(Vector2 p)
		{
			if (shape == Shape.Circle)
			{
				return p.magnitude - _halfSize.x;
			}
			float y = Mathf.Max(Mathf.Abs(p.y) - (_halfSize.y - _halfSize.x), 0f);
			return new Vector2(p.x, y).magnitude - _halfSize.x;
		}

		private void PruneCandidates()
		{
			for (int num = _candidateCount - 1; num >= 0; num--)
			{
				if (!Usable(_candidates[num]))
				{
					_candidateCount--;
					_candidates[num] = _candidates[_candidateCount];
					_candidates[_candidateCount] = null;
				}
			}
		}

		private static bool Usable(Collider c)
		{
			if (c != null && c.enabled)
			{
				return c.gameObject.activeInHierarchy;
			}
			return false;
		}

		private static Vector3 FingerPoint(Collider c)
		{
			SphereCollider sphereCollider = c as SphereCollider;
			if (sphereCollider != null)
			{
				return sphereCollider.transform.TransformPoint(sphereCollider.center);
			}
			return c.bounds.center;
		}

		private static bool IsLeftFinger(Collider c)
		{
			string name = c.gameObject.name;
			if (!name.Contains("LeftFinger") && !name.Contains("L_end"))
			{
				return c.CompareTag("LFinger");
			}
			return true;
		}
	}
}
