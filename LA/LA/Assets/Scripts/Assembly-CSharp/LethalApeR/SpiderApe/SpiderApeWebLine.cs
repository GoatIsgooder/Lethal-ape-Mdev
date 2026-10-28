using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.SpiderApe
{
	[RequireComponent(typeof(LineRenderer))]
	[DisallowMultipleComponent]
	public class SpiderApeWebLine : MonoBehaviour
	{
		private enum LineState
		{
			Hidden = 0,
			Travel = 1,
			Attached = 2,
			Falling = 3
		}

		[Header("Rope")]
		[Tooltip("Points in the strand. 10–20 is the sweet spot; more just costs vertices.")]
		[Range(4f, 40f)]
		[SerializeField]
		private int pointCount = 14;

		[Tooltip("Extra material length as a fraction of the solver's rope length. This is why the web still bows a little at full tension instead of looking like rebar.")]
		[Range(0f, 0.25f)]
		[SerializeField]
		private float slack = 0.02f;

		[Tooltip("Constraint passes per frame. Higher = crisper snap-straight under tension.")]
		[Range(1f, 12f)]
		[SerializeField]
		private int iterations = 6;

		[Tooltip("Gravity on the strand itself. Heavier than real gravity looks better — thin line, big distances, the eye wants more droop than physics gives.")]
		[SerializeField]
		private float ropeGravity = 16f;

		[Tooltip("Velocity retained per frame. Lower = the strand settles fast and stops jiggling.")]
		[Range(0.5f, 1f)]
		[SerializeField]
		private float damping = 0.93f;

		[Header("Flight")]
		[Tooltip("How far the strand whips sideways while it's flying to the target.")]
		[SerializeField]
		private float whipAmplitude = 0.35f;

		[Tooltip("Waves along the strand during flight.")]
		[SerializeField]
		private float whipWaves = 1.5f;

		[Tooltip("Seconds for the strand to fade up to full width as it leaves the nozzle.")]
		[SerializeField]
		private float widthFadeIn = 0.06f;

		[Header("Legibility")]
		[Tooltip("Minimum apparent thickness, as width per metre of distance to the camera. A 3cm strand 40m away is sub-pixel and shimmers badly; widening it with distance keeps a long web readable instead of a crawling dotted line. 0 disables and gives you honest world-space width.")]
		[SerializeField]
		private float minAngularWidth = 0.0012f;

		[Header("Release")]
		[Tooltip("Seconds the cut strand hangs and fades before it disappears.")]
		[SerializeField]
		private float fadeTime = 0.7f;

		[Header("Shader")]
		[Tooltip("Float property on the web material used to fade the strand out. Matches Slop/WebStrand.")]
		[SerializeField]
		private string alphaProperty = "_Alpha";

		private LineRenderer _lr;

		private MaterialPropertyBlock _mpb;

		private int _alphaId;

		private Vector3[] _p;

		private Vector3[] _prev;

		private LineState _state;

		private Vector3 _lastFrom;

		private Vector3 _lastTo;

		private bool _endsValid;

		private float _lastDt = 1f / 72f;

		private float _fadeTimer;

		private float _widthTimer;

		private float _baseWidth = 1f;

		private bool _farEndPinned;

		private float _materialLength = 1f;

		private Camera _cam;

		private void Awake()
		{
			_lr = GetComponent<LineRenderer>();
			_mpb = new MaterialPropertyBlock();
			_alphaId = Shader.PropertyToID(string.IsNullOrEmpty(alphaProperty) ? "_Alpha" : alphaProperty);
			pointCount = Mathf.Max(pointCount, 4);
			_p = new Vector3[pointCount];
			_prev = new Vector3[pointCount];
			_lr.useWorldSpace = true;
			_lr.positionCount = pointCount;
			_baseWidth = _lr.widthMultiplier;
			_lr.enabled = false;
		}

		private void OnEnable()
		{
			Transform rig = (Player.HasInstance && Player.Instance != null) ? Player.Instance.transform : null;
			if (transform.parent != rig)
			{
				transform.SetParent(rig, true);
			}
			float parentScale = ((transform.parent != null) ? transform.parent.lossyScale : Vector3.one).x;
			transform.localScale = Vector3.one * ((Mathf.Abs(parentScale) > 0.0001f) ? (1f / parentScale) : 1f);
		}

		public void Clear()
		{
			_state = LineState.Hidden;
			_endsValid = false;
			if (_lr != null)
			{
				_lr.enabled = false;
			}
		}

		public void SetTravel(Vector3 from, Vector3 target, float t01)
		{
			if (_lr == null)
			{
				return;
			}
			if (_state != LineState.Travel)
			{
				_state = LineState.Travel;
				_widthTimer = 0f;
				SetAlpha(1f);
			}
			_widthTimer += Time.deltaTime;
			_lr.enabled = true;
			float fade = ((widthFadeIn > 0f) ? Mathf.Clamp01(_widthTimer / widthFadeIn) : 1f);
			ApplyWidth(fade, Vector3.Lerp(from, target, 0.5f));
			Vector3 tip = Vector3.Lerp(from, target, t01);
			BuildFlightShape(from, tip, t01);
			_materialLength = Mathf.Max(Vector3.Distance(from, tip) * 1.02f, 0.5f);
			for (int i = 0; i < _p.Length; i++)
			{
				_prev[i] = _p[i];
			}
			_lastFrom = from;
			_lastTo = tip;
			_endsValid = true;
			_farEndPinned = true;
			_lr.SetPositions(_p);
		}

		public void SetAttached(Vector3 from, Vector3 anchor, float ropeLength)
		{
			if (_lr == null)
			{
				return;
			}
			if (_state != LineState.Attached)
			{
				_state = LineState.Attached;
				_lr.enabled = true;
				SetAlpha(1f);
				if (!_endsValid)
				{
					SeedStraight(from, anchor);
				}
			}
			ApplyWidth(1f, Vector3.Lerp(from, anchor, 0.5f));
			_farEndPinned = true;
			_materialLength = Mathf.Max(ropeLength * (1f + slack), Vector3.Distance(from, anchor) * 1.005f);
			Simulate(from, anchor, _materialLength, true);
			_lr.SetPositions(_p);
		}

		public void ReleaseFrom(Vector3 handPos, bool keepFarEnd = true)
		{
			if (!(_lr == null) && _state != LineState.Hidden && _state != LineState.Falling)
			{
				if (!_endsValid)
				{
					Clear();
					return;
				}
				_state = LineState.Falling;
				_fadeTimer = 0f;
				_farEndPinned = keepFarEnd;
				_lastFrom = handPos;
			}
		}

		private void LateUpdate()
		{
			if (_state == LineState.Falling)
			{
				_fadeTimer += Time.deltaTime;
				if (fadeTime <= 0f || _fadeTimer >= fadeTime)
				{
					SetAlpha(1f);
					Clear();
					return;
				}
				Simulate(_p[0], _lastTo, _materialLength, false);
				ApplyWidth(1f, Vector3.Lerp(_p[0], _p[_p.Length - 1], 0.5f));
				_lr.SetPositions(_p);
				SetAlpha(1f - _fadeTimer / fadeTime);
			}
		}

		private void Simulate(Vector3 from, Vector3 to, float materialLength, bool pinNear)
		{
			int num = _p.Length;
			float num2 = Mathf.Min(Time.deltaTime, 1f / 30f);
			if (num2 <= 0.0001f)
			{
				return;
			}
			float num3 = Mathf.Clamp(num2 / Mathf.Max(_lastDt, 0.0001f), 0.5f, 2f);
			_lastDt = num2;
			Vector3 vector = (pinNear ? (from - _lastFrom) : Vector3.zero);
			Vector3 vector2 = (_farEndPinned ? (to - _lastTo) : Vector3.zero);
			if (vector != Vector3.zero || vector2 != Vector3.zero)
			{
				float num4 = 1f / (float)(num - 1);
				for (int i = 0; i < num; i++)
				{
					Vector3 vector3 = Vector3.Lerp(vector, vector2, (float)i * num4);
					_p[i] += vector3;
					_prev[i] += vector3;
				}
			}
			Vector3 vector4 = Vector3.down * (ropeGravity * num2 * num2);
			int num5 = (pinNear ? 1 : 0);
			int num6 = (_farEndPinned ? (num - 2) : (num - 1));
			for (int j = num5; j <= num6; j++)
			{
				Vector3 vector5 = _p[j];
				_p[j] = vector5 + (vector5 - _prev[j]) * (damping * num3) + vector4;
				_prev[j] = vector5;
			}
			if (pinNear)
			{
				_p[0] = from;
			}
			if (_farEndPinned)
			{
				_p[num - 1] = to;
			}
			float num7 = Mathf.Max(materialLength, 0.01f) / (float)(num - 1);
			for (int k = 0; k < iterations; k++)
			{
				for (int l = 0; l < num - 1; l++)
				{
					Vector3 vector6 = _p[l + 1] - _p[l];
					float magnitude = vector6.magnitude;
					if (magnitude <= num7 || magnitude < 1E-06f)
					{
						continue;
					}
					Vector3 vector7 = vector6 * ((magnitude - num7) / magnitude);
					bool flag = l == 0 && pinNear;
					bool flag2 = l + 1 == num - 1 && _farEndPinned;
					if (!(flag && flag2))
					{
						if (flag)
						{
							_p[l + 1] -= vector7;
						}
						else if (flag2)
						{
							_p[l] += vector7;
						}
						else
						{
							_p[l] += vector7 * 0.5f;
							_p[l + 1] -= vector7 * 0.5f;
						}
					}
				}
				if (pinNear)
				{
					_p[0] = from;
				}
				if (_farEndPinned)
				{
					_p[num - 1] = to;
				}
			}
			if (!pinNear)
			{
				from = _p[0];
			}
			_lastFrom = from;
			if (_farEndPinned)
			{
				_lastTo = to;
			}
		}

		private void BuildFlightShape(Vector3 from, Vector3 tip, float t01)
		{
			int num = _p.Length;
			Vector3 vector = tip - from;
			float magnitude = vector.magnitude;
			if (magnitude < 0.0001f)
			{
				for (int i = 0; i < num; i++)
				{
					_p[i] = from;
				}
				return;
			}
			Vector3 vector2 = vector / magnitude;
			Vector3 vector3 = Vector3.Cross(vector2, Vector3.up);
			if (vector3.sqrMagnitude < 0.001f)
			{
				vector3 = Vector3.Cross(vector2, Vector3.right);
			}
			vector3 = vector3.normalized;
			float num2 = whipAmplitude * (1f - Mathf.Clamp01(t01));
			float num3 = 1f / (float)(num - 1);
			for (int j = 0; j < num; j++)
			{
				float num4 = (float)j * num3;
				float num5 = Mathf.Sin(num4 * Mathf.PI);
				float num6 = Mathf.Sin(whipWaves * num4 * Mathf.PI * 2f);
				_p[j] = from + vector2 * (magnitude * num4) + vector3 * (num5 * num6 * num2);
			}
		}

		private void SeedStraight(Vector3 from, Vector3 to)
		{
			int num = _p.Length;
			float num2 = 1f / (float)(num - 1);
			for (int i = 0; i < num; i++)
			{
				_p[i] = Vector3.Lerp(from, to, (float)i * num2);
				_prev[i] = _p[i];
			}
			_lastFrom = from;
			_lastTo = to;
			_endsValid = true;
		}

		private void ApplyWidth(float fade, Vector3 midPoint)
		{
			float num = _baseWidth;
			if (minAngularWidth > 0f)
			{
				Camera camera = ResolveCamera();
				if (camera != null)
				{
					num = Mathf.Max(num, Vector3.Distance(camera.transform.position, midPoint) * minAngularWidth);
				}
			}
			_lr.widthMultiplier = num * Mathf.Clamp01(fade);
		}

		private Camera ResolveCamera()
		{
			if (_cam == null)
			{
				Player player = (Player.HasInstance ? Player.Instance : null);
				_cam = ((player != null && player.mainCamera != null) ? player.mainCamera : Camera.main);
			}
			return _cam;
		}

		private void SetAlpha(float a)
		{
			if (!(_lr == null) && _mpb != null)
			{
				_lr.GetPropertyBlock(_mpb);
				_mpb.SetFloat(_alphaId, Mathf.Clamp01(a));
				_lr.SetPropertyBlock(_mpb);
			}
		}
	}
}
