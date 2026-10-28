using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnStations
	{
		public struct Station
		{
			public Transform Pose;

			public float VerticalFov;

			public float Aspect;

			public float Range;

			public bool AudioOnly;

			public bool Cove;

			public string Label;
		}

		public const int MaxStations = 24;

		private static readonly Station[] Stations = new Station[24];

		private static int _count;

		public static int LocalSelected = -1;

		public static int Count => _count;

		public static int CoveIndex
		{
			get
			{
				for (int i = 0; i < _count; i++)
				{
					if (Stations[i].Pose != null && Stations[i].Cove)
					{
						return i;
					}
				}
				return -1;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			for (int i = 0; i < Stations.Length; i++)
			{
				Stations[i] = default(Station);
			}
			_count = 0;
			LocalSelected = -1;
		}

		public static void Register(int index, in Station station)
		{
			if (index >= 0 && index < 24)
			{
				Stations[index] = station;
				if (index >= _count)
				{
					_count = index + 1;
				}
			}
		}

		public static void Unregister(int index)
		{
			if (index >= 0 && index < 24)
			{
				Stations[index] = default(Station);
				while (_count > 0 && Stations[_count - 1].Pose == null)
				{
					_count--;
				}
			}
		}

		public static bool TryGet(int index, out Station station)
		{
			station = ((index >= 0 && index < 24) ? Stations[index] : default(Station));
			return station.Pose != null;
		}

		public static float MotionInView(int index)
		{
			if (!TryGet(index, out var station) || station.AudioOnly)
			{
				return 0f;
			}
			Vector3 position = station.Pose.position;
			float num = station.VerticalFov * 0.5f * Mathf.Deg2Rad;
			float num2 = Mathf.Atan(Mathf.Tan(num) * Mathf.Max(station.Aspect, 0.1f));
			float num3 = 0f;
			for (int i = 0; i < FnAnimView.Count; i++)
			{
				FnAnimPose fnAnimPose = FnAnimView.Get(i);
				if (!fnAnimPose.Active)
				{
					continue;
				}
				float speed = fnAnimPose.Speed;
				if (speed <= 0.01f)
				{
					continue;
				}
				Vector3 vector = fnAnimPose.Position + Vector3.up * 1.2f - position;
				float magnitude = vector.magnitude;
				if (magnitude < 0.01f || magnitude > station.Range)
				{
					continue;
				}
				Vector3 vector2 = station.Pose.InverseTransformDirection(vector / magnitude);
				if (vector2.z <= 0f || Mathf.Abs(Mathf.Atan2(vector2.x, vector2.z)) > num2)
				{
					continue;
				}
				float num4 = Mathf.Abs(Mathf.Atan2(vector2.y, vector2.z));
				if (speed > num3 && num4 <= num)
				{
					num3 = speed;
				}
			}
			return num3;
		}
	}
}
