using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Rivals.Maps
{
	public class SpawnPoint : MonoBehaviour
	{
		[Tooltip("Which team spawns here. None = usable by any team (FFA-style fallback).")]
		public Team team;

		[Tooltip("Gizmo sphere radius (purely visual).")]
		[SerializeField]
		private float gizmoRadius = 0.4f;

		private static readonly List<SpawnPoint> _all = new List<SpawnPoint>();

		public static IReadOnlyList<SpawnPoint> All => _all;

		private void OnEnable()
		{
			if (!_all.Contains(this))
			{
				_all.Add(this);
			}
		}

		private void OnDisable()
		{
			_all.Remove(this);
		}

		public static List<SpawnPoint> ForTeam(Team team)
		{
			List<SpawnPoint> list = new List<SpawnPoint>();
			foreach (SpawnPoint sp in _all)
			{
				if (sp != null && (sp.team == team || sp.team == Team.None))
				{
					list.Add(sp);
				}
			}
			return list;
		}

		private void OnDrawGizmos()
		{
			Color color = team.ToColor();
			Gizmos.color = color;
			Gizmos.DrawWireSphere(transform.position, gizmoRadius);
			Vector3 tip = transform.position + transform.forward * (gizmoRadius * 2.5f);
			Gizmos.DrawLine(transform.position, tip);
			Vector3 left = Quaternion.LookRotation(transform.forward) * Quaternion.Euler(0f, 150f, 0f) * Vector3.forward;
			Vector3 right = Quaternion.LookRotation(transform.forward) * Quaternion.Euler(0f, -150f, 0f) * Vector3.forward;
			Gizmos.DrawLine(tip, tip + left * (gizmoRadius * 0.8f));
			Gizmos.DrawLine(tip, tip + right * (gizmoRadius * 0.8f));
			Gizmos.color = new Color(color.r, color.g, color.b, 0.2f);
			Gizmos.DrawSphere(transform.position, gizmoRadius);
		}
	}
}
