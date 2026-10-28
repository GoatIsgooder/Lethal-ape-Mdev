using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class ReadyPad : MonoBehaviour
	{
		[Header("Identity (a group = pads sharing groupId)")]
		public string groupId = "1v1";

		public Team team = Team.TeamA;

		[Tooltip("Unique slot within this team in the group. 0 when the team has one pad.")]
		public int slot;

		[Tooltip("How many players this pad holds (1 for 1v1, 2 for a single 2v2 pad). Auto-set from the group size by RivalsReadyPads.")]
		[Min(1f)]
		public int capacity = 1;

		[Header("Detection")]
		[Tooltip("Horizontal radius around the pad that counts as standing on it.")]
		public float radius = 0.9f;

		[Tooltip("Max vertical distance from the pad to still count (so you can't claim it from a platform above).")]
		public float maxHeight = 2.5f;

		[Header("Visual (optional)")]
		[Tooltip("Renderer tinted by occupancy. Uses MaterialPropertyBlock '_Color'.")]
		public Renderer padRenderer;

		public Color emptyColor = new Color(0.3f, 0.3f, 0.3f, 1f);

		private readonly List<int> _occupants = new List<int>();

		private const float ClaimRetryInterval = 0.75f;

		private RivalsReadyPads _manager;

		private bool _localOnPad;

		private float _nextNotify;

		private MaterialPropertyBlock _mpb;

		public string Key => string.Format("{0}:{1}:{2}", groupId, (int)team, slot);

		public int Capacity => Mathf.Max(1, capacity);

		public IReadOnlyList<int> Occupants => _occupants;

		public bool IsOccupied => _occupants.Count > 0;

		public bool IsFull => _occupants.Count >= Capacity;

		public bool HasOccupant(int actor)
		{
			return _occupants.Contains(actor);
		}

		private void Start()
		{
			_manager = ((RivalsReadyPads.Instance != null) ? RivalsReadyPads.Instance : Object.FindObjectOfType<RivalsReadyPads>());
			if (_manager != null)
			{
				_manager.RegisterPad(this);
			}
			ApplyColor();
		}

		private void OnDestroy()
		{
			if (_manager != null)
			{
				_manager.UnregisterPad(this);
			}
		}

		private void Update()
		{
			if (_manager == null)
			{
				return;
			}
			bool flag = IsLocalPlayerOnPad();
			if (flag != _localOnPad)
			{
				_localOnPad = flag;
				_nextNotify = 0f;
			}
			if (flag != HasOccupant(_manager.LocalActorId) && !(Time.time < _nextNotify))
			{
				_nextNotify = Time.time + 0.75f;
				if (!flag || !IsFull)
				{
					_manager.NotifyLocalOccupancy(this, flag);
				}
			}
		}

		private bool IsLocalPlayerOnPad()
		{
			Player instance = Player.Instance;
			if (instance == null)
			{
				return false;
			}
			Vector3 position = ((instance.bodyCollider != null) ? ((Component)instance.bodyCollider) : ((Component)instance)).transform.position;
			Vector3 position2 = base.transform.position;
			if (Mathf.Abs(position.y - position2.y) > maxHeight)
			{
				return false;
			}
			float num = position.x - position2.x;
			float num2 = position.z - position2.z;
			return num * num + num2 * num2 <= radius * radius;
		}

		public bool AddOccupant(int actor)
		{
			if (IsFull || _occupants.Contains(actor))
			{
				return false;
			}
			_occupants.Add(actor);
			ApplyColor();
			return true;
		}

		public bool RemoveOccupant(int actor)
		{
			bool num = _occupants.Remove(actor);
			if (num)
			{
				ApplyColor();
			}
			return num;
		}

		public void ClearOccupants()
		{
			if (_occupants.Count != 0)
			{
				_occupants.Clear();
				ApplyColor();
			}
		}

		private void ApplyColor()
		{
			if (!(padRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				padRenderer.GetPropertyBlock(_mpb);
				float t = (float)_occupants.Count / (float)Capacity;
				_mpb.SetColor("_Color", Color.Lerp(emptyColor, team.ToColor(), t));
				padRenderer.SetPropertyBlock(_mpb);
			}
		}

		private void OnDrawGizmos()
		{
			Gizmos.color = team.ToColor();
			Vector3 from = base.transform.position + new Vector3(radius, 0.02f, 0f);
			for (int i = 1; i <= 24; i++)
			{
				float f = (float)i / 24f * Mathf.PI * 2f;
				Vector3 vector = base.transform.position + new Vector3(Mathf.Cos(f) * radius, 0.02f, Mathf.Sin(f) * radius);
				Gizmos.DrawLine(from, vector);
				from = vector;
			}
		}
	}
}
