using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnBearWatch : MonoBehaviourPunCallbacks
	{
		[Tooltip("Tests per second.")]
		public float tickHz = 8f;

		[Tooltip("Bear farther than this from the eye doesn't count as watched in person (m).")]
		public float inPersonRange = 25f;

		[Tooltip("Shrinks the eye's frustum so the blurry lens edge doesn't count (0.3..1).")]
		[Range(0.3f, 1f)]
		public float frustumMargin = 0.85f;

		[Tooltip("Consecutive unseen tests before 'not watching' goes out, so a glance at the frame edge doesn't flicker.")]
		[Range(1f, 4f)]
		public int releaseTicks = 2;

		private const float ChestHeight = 1.1f;

		private float _nextTick;

		private int _unseenTicks;

		private bool _resend;

		public static bool LocalWatching { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			LocalWatching = false;
		}

		public override void OnEnable()
		{
			base.OnEnable();
			_unseenTicks = 0;
			_resend = false;
			LocalWatching = false;
		}

		public override void OnDisable()
		{
			base.OnDisable();
			if (LocalWatching)
			{
				Send(false);
			}
		}

		public override void OnMasterClientSwitched(Player newMasterClient)
		{
			_resend = true;
		}

		public override void OnJoinedRoom()
		{
			LocalWatching = false;
		}

		public override void OnLeftRoom()
		{
			LocalWatching = false;
		}

		private void Update()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active || instance.Phase != FnPhase.Night || !instance.LocalIsAlive)
			{
				if (LocalWatching)
				{
					Send(false);
				}
				_resend = false;
				return;
			}
			if (_resend)
			{
				_resend = false;
				if (LocalWatching)
				{
					Send(true);
				}
			}
			if (Time.unscaledTime < _nextTick)
			{
				return;
			}
			_nextTick = Time.unscaledTime + 1f / Mathf.Max(1f, tickHz);
			bool flag = BearSeen(instance);
			if (flag)
			{
				_unseenTicks = 0;
				if (!LocalWatching)
				{
					Send(flag);
				}
				return;
			}
			_unseenTicks++;
			if (LocalWatching && _unseenTicks >= releaseTicks)
			{
				Send(flag);
			}
		}

		private static void Send(bool watching)
		{
			LocalWatching = watching;
			FnNet.ToMasterClient(FnRpc.BearWatch, watching);
		}

		private bool BearSeen(FnNight night)
		{
			FnAnimPose fnAnimPose = FnAnimView.Get(FnAnim.Bear);
			if (!fnAnimPose.Active || fnAnimPose.State == FnAiState.Dormant || fnAnimPose.State == FnAiState.PoweredDown)
			{
				return false;
			}
			Vector3 headPosition = fnAnimPose.HeadPosition;
			FnWaypointGraph instance = FnWaypointGraph.Instance;
			Vector3 chest = fnAnimPose.Position + Vector3.up * 1.1f;
			Camera eye = FnPlatform.Eye;
			if (eye != null && InFrame(eye.transform, Mathf.Clamp(eye.fieldOfView, 40f, 130f), eye.aspect, eye.nearClipPlane, inPersonRange, frustumMargin, headPosition, chest, instance))
			{
				return true;
			}
			if (night.Power <= 0f)
			{
				return false;
			}
			if (!FnStations.TryGet(FnStations.LocalSelected, out var station) || station.AudioOnly)
			{
				return false;
			}
			return InFrame(station.Pose, station.VerticalFov, station.Aspect, 0.05f, station.Range, 1f, headPosition, chest, instance);
		}

		private static bool InFrame(Transform view, float verticalFov, float aspect, float near, float far, float margin, Vector3 head, Vector3 chest, FnWaypointGraph graph)
		{
			if (Visible(view, verticalFov, aspect, near, far, margin, head, graph))
			{
				return true;
			}
			return Visible(view, verticalFov, aspect, near, far, margin, chest, graph);
		}

		private static bool Visible(Transform view, float verticalFov, float aspect, float near, float far, float margin, Vector3 point, FnWaypointGraph graph)
		{
			Vector3 position = view.position;
			if (!FnAiRules.InViewFrustum(Quaternion.Inverse(view.rotation) * (point - position), verticalFov, aspect, near, far, margin))
			{
				return false;
			}
			if (graph == null)
			{
				return true;
			}
			return graph.Sight(position, point);
		}
	}
}
