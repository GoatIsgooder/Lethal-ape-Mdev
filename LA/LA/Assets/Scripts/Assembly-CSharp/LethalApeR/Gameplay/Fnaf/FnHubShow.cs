using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnHubShow : MonoBehaviour
	{
		[Tooltip("The exhibits: copies of the Default variants, each standing in a hub specimen tube.")]
		public FnPuppetBase[] performers = new FnPuppetBase[0];

		[Tooltip("A performer turns to watch the local guard when their head is this close (m).")]
		public float watchRange = 9f;

		[Tooltip("Seconds between a performer's glances at the guard, and how long each lasts (random in range).")]
		public Vector2 glanceEvery = new Vector2(5f, 12f);

		public Vector2 glanceFor = new Vector2(1.8f, 3.6f);

		[Tooltip("Head speed while turning to look (degrees per second): slow, it is half asleep.")]
		public float headSpeed = 30f;

		private const float EyeHeight = 1.6f;

		private float[] _nextGlance = new float[0];

		private float[] _glanceUntil = new float[0];

		private float[] _yaw = new float[0];

		private float[] _pitch = new float[0];

		private Renderer[] _renderers = new Renderer[0];

		private bool _awake = true;

		private void Awake()
		{
			int num = performers.Length;
			_nextGlance = new float[num];
			_glanceUntil = new float[num];
			_yaw = new float[num];
			_pitch = new float[num];
			for (int i = 0; i < num; i++)
			{
				_nextGlance[i] = Time.time + Random.Range(2f, glanceEvery.y);
				_pitch[i] = -26f;
			}
			_renderers = GetComponentsInChildren<Renderer>(true);
			for (int j = 0; j < num; j++)
			{
				if (!(performers[j] == null))
				{
					performers[j].EnsureInit();
					performers[j].Snap();
				}
			}
		}

		private void LateUpdate()
		{
			FnGame instance = FnGame.Instance;
			bool flag = instance == null || instance.RoomKind != FnRoomKind.Night;
			if (_awake != flag)
			{
				_awake = flag;
				for (int i = 0; i < _renderers.Length; i++)
				{
					if (_renderers[i] != null)
					{
						_renderers[i].enabled = flag;
					}
				}
			}
			if (!flag)
			{
				return;
			}
			Transform head = FnPlatform.Head;
			float time = Time.time;
			float deltaTime = Time.deltaTime;
			for (int j = 0; j < performers.Length; j++)
			{
				FnPuppetBase fnPuppetBase = performers[j];
				if (fnPuppetBase == null)
				{
					continue;
				}
				Transform transform = fnPuppetBase.transform;
				float yaw = 0f;
				float pitch = -26f;
				bool flag2 = false;
				if (head != null && (head.position - transform.position).sqrMagnitude < watchRange * watchRange)
				{
					if (time >= _nextGlance[j])
					{
						_glanceUntil[j] = time + Random.Range(glanceFor.x, glanceFor.y);
						_nextGlance[j] = _glanceUntil[j] + Random.Range(glanceEvery.x, glanceEvery.y);
					}
					if (time < _glanceUntil[j])
					{
						FnAiRules.LookAngles(transform.position + Vector3.up * 1.6f, head.position, transform.eulerAngles.y, 75f, 40f, out yaw, out pitch);
						flag2 = true;
					}
				}
				_yaw[j] = Mathf.MoveTowards(_yaw[j], yaw, headSpeed * deltaTime);
				_pitch[j] = Mathf.MoveTowards(_pitch[j], pitch, headSpeed * deltaTime);
				FnPuppetInput input = new FnPuppetInput
				{
					StrideLength = 1.5f,
					Home = true,
					HeadYaw = _yaw[j],
					HeadPitch = _pitch[j],
					HasLook = (flag2 || Mathf.Abs(_yaw[j]) > 0.5f || _pitch[j] > -25.5f),
					LookPoint = (flag2 ? head.position : Vector3.zero),
					BangAge = 99f,
					KnockRaps = 1,
					KnockInterval = 0.25f,
					JumpChargeAge = 99f,
					LandAge = 99f,
					Dt = deltaTime
				};
				fnPuppetBase.Drive(in input);
			}
		}
	}
}
