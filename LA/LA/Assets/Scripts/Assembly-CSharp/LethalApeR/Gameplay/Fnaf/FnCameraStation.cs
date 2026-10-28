using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	[DisallowMultipleComponent]
	public class FnCameraStation : MonoBehaviour
	{
		[Tooltip("Camera id on the wire (fnCam, Lure, LurePlayed). A contract table: indices run 0..N-1 with no gaps and match LAR's scene.")]
		public int index;

		[Tooltip("Shown on the monitor, e.g. 1A STAGE. Plain ASCII only: the SDF atlases lack dots, angle quotes, bullets and en dashes.")]
		public string label = "1A STAGE";

		[Tooltip("Sound only, no picture (the kitchen): the monitor shows AUDIO ONLY, it never scrambles and it can't be lured.")]
		public bool audioOnly;

		[Tooltip("Endo's cove camera. Exactly one station sets this.")]
		public bool cove;

		[Tooltip("Vertical field of view of the feed (degrees).")]
		[Range(20f, 110f)]
		public float verticalFov = 60f;

		[Tooltip("How far this camera sees: the motion-test range and the feed's far clip, so anything moving on screen scrambles it (m).")]
		public float range = 18f;

		[Tooltip("Where the feed is taken from: +Z looks out of the lens, +Y is up. Put it just in front of the housing (near clip 5 cm). Defaults to this transform.")]
		public Transform lens;

		[Header("Tally LED")]
		[Tooltip("Optional. Tinted through a MaterialPropertyBlock (_Color and _EmissionColor); blinks while a living guard watches this camera.")]
		public Renderer led;

		public Color ledOn = new Color(1f, 0.1f, 0.06f, 1f);

		public Color ledOff = new Color(0.12f, 0.02f, 0.02f, 1f);

		[Tooltip("Blink rate (Hz). Nothing in FNAF flashes faster than 3 Hz.")]
		[Range(0.25f, 2f)]
		public float ledBlinkHz = 1f;

		private static readonly FnCameraStation[] Registry = new FnCameraStation[24];

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private MaterialPropertyBlock _mpb;

		private int _registered = -1;

		private int _ledState = -1;

		private string _shortId;

		public Transform Lens
		{
			get
			{
				if (lens != null)
				{
					return lens;
				}
				return transform;
			}
		}

		public string ShortId
		{
			get
			{
				if (_shortId == null)
				{
					string text = label ?? "";
					int num = text.IndexOf(' ');
					_shortId = ((num > 0) ? text.Substring(0, num) : text);
				}
				return _shortId;
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			System.Array.Clear(Registry, 0, Registry.Length);
		}

		public static FnCameraStation At(int cameraIndex)
		{
			if (cameraIndex < 0 || cameraIndex >= Registry.Length)
			{
				return null;
			}
			return Registry[cameraIndex];
		}

		private void OnEnable()
		{
			_ledState = -1;
			ApplyLed(false);
			if (index < 0 || index >= 24)
			{
				Debug.LogError(string.Format("[FnCameraStation] {0}: index {1} is outside 0..{2}; this camera is off the wire.", name, index, 23), this);
				return;
			}
			FnCameraStation fnCameraStation = Registry[index];
			if (fnCameraStation != null && fnCameraStation != this)
			{
				Debug.LogError(string.Format("[FnCameraStation] {0} and {1} both claim camera {2}; {3} is ignored.", name, fnCameraStation.name, index, name), this);
				return;
			}
			Registry[index] = this;
			_registered = index;
			FnStations.Register(index, Describe());
		}

		private void OnDisable()
		{
			if (_registered >= 0 && Registry[_registered] == this)
			{
				Registry[_registered] = null;
				FnStations.Unregister(_registered);
			}
			_registered = -1;
			ApplyLed(false);
		}

		private FnStations.Station Describe()
		{
			FnStations.Station result = default(FnStations.Station);
			result.Pose = Lens;
			result.VerticalFov = verticalFov;
			Vector2Int feedSize = FnCameraSystem.FeedSize;
			result.Aspect = (float)feedSize.x / (float)feedSize.y;
			result.Range = range;
			result.AudioOnly = audioOnly;
			result.Cove = cove;
			result.Label = label;
			return result;
		}

		public void ApplyLed(bool watched)
		{
			if (led == null)
			{
				return;
			}
			bool flag = watched && Mathf.Repeat(Time.time * ledBlinkHz, 1f) < 0.5f;
			int num = (flag ? 1 : 0);
			if (num != _ledState)
			{
				_ledState = num;
				Color value = (flag ? ledOn : ledOff);
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				led.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, value);
				_mpb.SetColor(BaseColorId, value);
				_mpb.SetColor(EmissionId, value);
				led.SetPropertyBlock(_mpb);
			}
		}

		private void OnValidate()
		{
			_shortId = null;
			index = Mathf.Clamp(index, 0, 23);
			ledBlinkHz = Mathf.Max(0.5f, ledBlinkHz);
			if (label != null)
			{
				string text = label;
				foreach (char c in text)
				{
					if (c < ' ' || c > '~')
					{
						Debug.LogWarning("[FnCameraStation] " + name + ": label '" + label + "' has a non-ASCII character; the monitor font can't draw it.", this);
						break;
					}
				}
			}
			if (Application.isPlaying && _registered >= 0 && _registered == index && Registry[index] == this)
			{
				FnStations.Register(index, Describe());
			}
		}

		private void OnDrawGizmosSelected()
		{
			Transform lensTransform = Lens;
			Gizmos.color = (audioOnly ? new Color(0.3f, 0.6f, 1f, 0.8f) : (cove ? new Color(0.8f, 0.3f, 1f, 0.8f) : new Color(1f, 0.85f, 0.2f, 0.8f)));
			Gizmos.matrix = Matrix4x4.TRS(lensTransform.position, lensTransform.rotation, Vector3.one);
			Vector2Int feedSize = FnCameraSystem.FeedSize;
			Gizmos.DrawFrustum(Vector3.zero, verticalFov, range, 0.05f, (float)feedSize.x / (float)feedSize.y);
			Gizmos.matrix = Matrix4x4.identity;
		}
	}
}
