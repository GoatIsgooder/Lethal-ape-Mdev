using UnityEngine;

namespace LethalApeR.SpiderApe
{
	[DisallowMultipleComponent]
	public class SpiderApeComfort : MonoBehaviour
	{
		[Header("References")]
		[Tooltip("Head camera. Auto-resolved from the Player singleton if left empty.")]
		[SerializeField]
		private Camera headCamera;

		[Tooltip("The vignette quad. Should be a child of the camera using the Slop/SpeedVignette material.")]
		[SerializeField]
		private Renderer vignette;

		[Header("Speed Response")]
		[Tooltip("Below this speed (m/s) there's no vignette at all — normal gorilla movement should never trigger it.")]
		[SerializeField]
		private float startSpeed = 9f;

		[Tooltip("Speed (m/s) at which the vignette is fully closed in.")]
		[SerializeField]
		private float fullSpeed = 24f;

		[Tooltip("Only vignette while actually swinging. Off = any fast movement triggers it.")]
		[SerializeField]
		private bool onlyWhileSwinging = true;

		[Header("Aperture")]
		[Tooltip("Opening at rest. Above ~1.45 the ring is entirely off the quad, i.e. invisible.")]
		[SerializeField]
		private float openAperture = 1.5f;

		[Tooltip("Opening at full speed. Lower = more tunnel. 0.45–0.6 is the usual comfortable range.")]
		[SerializeField]
		private float closedAperture = 0.5f;

		[Tooltip("Softness of the edge. Hard edges are their own kind of unpleasant.")]
		[SerializeField]
		private float feather = 0.35f;

		[Tooltip("Overall opacity. 0 turns the whole effect off without removing the component.")]
		[Range(0f, 1f)]
		[SerializeField]
		private float strength = 0.9f;

		[Header("Response Rates")]
		[Tooltip("How fast the vignette closes. Should be quick — it needs to be there before the motion is.")]
		[SerializeField]
		private float closeRate = 6f;

		[Tooltip("How fast it opens back up. Deliberately slower: a vignette that flickers open and shut between arcs is worse than one that lingers.")]
		[SerializeField]
		private float openRate = 2.5f;

		[Header("Placement")]
		[Tooltip("Metres in front of the camera. Far enough that stereo disparity on the soft edge is imperceptible; ZTest Always means geometry can't occlude it.")]
		[SerializeField]
		private float quadDistance = 2f;

		[Tooltip("Oversize factor over the camera's FOV. VR's per-eye field is wider and asymmetric, so the quad is deliberately generous.")]
		[SerializeField]
		private float coverage = 2.2f;

		[Tooltip("Re-fit the quad to the camera every frame. Off is fine once it's placed.")]
		[SerializeField]
		private bool refitEveryFrame;

		private MaterialPropertyBlock _mpb;

		private int _apertureId;

		private int _featherId;

		private int _strengthId;

		private float _aperture;

		private bool _fitted;

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			_apertureId = Shader.PropertyToID("_Aperture");
			_featherId = Shader.PropertyToID("_Feather");
			_strengthId = Shader.PropertyToID("_Strength");
			_aperture = openAperture;
		}

		private void LateUpdate()
		{
			if (vignette == null)
			{
				return;
			}
			if (headCamera == null)
			{
				headCamera = ResolveCamera();
			}
			if (headCamera == null)
			{
				return;
			}
			if (!_fitted || refitEveryFrame)
			{
				FitQuad();
			}
			float b = openAperture;
			SpiderApeSwing instance = SpiderApeSwing.Instance;
			if (instance != null && (!onlyWhileSwinging || instance.IsSwinging))
			{
				float t = Mathf.InverseLerp(startSpeed, Mathf.Max(fullSpeed, startSpeed + 0.01f), instance.Speed);
				t = Mathf.SmoothStep(0f, 1f, t);
				b = Mathf.Lerp(openAperture, closedAperture, t);
			}
			float num = ((b < _aperture) ? closeRate : openRate);
			_aperture = Mathf.Lerp(_aperture, b, 1f - Mathf.Exp((0f - num) * Time.deltaTime));
			vignette.GetPropertyBlock(_mpb);
			_mpb.SetFloat(_apertureId, _aperture);
			_mpb.SetFloat(_featherId, Mathf.Max(feather, 0.01f));
			_mpb.SetFloat(_strengthId, strength);
			vignette.SetPropertyBlock(_mpb);
			bool flag = strength > 0.001f && _aperture < openAperture - 0.005f;
			if (vignette.enabled != flag)
			{
				vignette.enabled = flag;
			}
		}

		private void FitQuad()
		{
			Transform transform = vignette.transform;
			if (transform.parent != headCamera.transform)
			{
				transform.SetParent(headCamera.transform, false);
			}
			transform.localPosition = new Vector3(0f, 0f, quadDistance);
			transform.localRotation = Quaternion.identity;
			float num = 2f * quadDistance * Mathf.Tan(headCamera.fieldOfView * 0.5f * Mathf.Deg2Rad) * coverage;
			transform.localScale = new Vector3(num * Mathf.Max(headCamera.aspect, 1f), num, 1f);
			_fitted = true;
		}

		private Camera ResolveCamera()
		{
			GorillaLocomotion.Player player = (GorillaLocomotion.Player.HasInstance ? GorillaLocomotion.Player.Instance : null);
			if (player != null && player.mainCamera != null)
			{
				return player.mainCamera;
			}
			return Camera.main;
		}
	}
}
