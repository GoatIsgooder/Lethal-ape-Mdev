using System.Reflection;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmRiftPortal : MonoBehaviour
	{
		[Tooltip("Local-space box your head has to enter (tear plane = local XY, facing +Z).")]
		[SerializeField]
		private Vector3 passHalfExtents = new Vector3(0.7f, 0.95f, 0.3f);

		[SerializeField]
		private Vector3 passCenter = Vector3.zero;

		[Tooltip("Surge starts at this distance from the tear and peaks at the second.")]
		[SerializeField]
		private Vector2 surgeRange = new Vector2(3.6f, 0.5f);

		[SerializeField]
		[Min(0.1f)]
		private float surgeSharpness = 4f;

		[Header("Visuals")]
		[SerializeField]
		private Renderer[] surgeRenderers;

		[SerializeField]
		private ParticleSystem suction;

		[SerializeField]
		private ParticleSystem passBurst;

		[SerializeField]
		private float suctionRateIdle = 10f;

		[SerializeField]
		private float suctionRateSurge = 55f;

		[Header("Audio (2D, no spatializer)")]
		[SerializeField]
		private AudioSource hum;

		[SerializeField]
		private Vector2 humVolume = new Vector2(0.08f, 0.5f);

		[SerializeField]
		private Vector2 humPitch = new Vector2(0.85f, 1.25f);

		[SerializeField]
		private AudioClip passClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float passVolume = 0.8f;

		[Header("Haptics")]
		[SerializeField]
		[Range(0f, 1f)]
		private float rumbleMax = 0.18f;

		[SerializeField]
		[Min(0.02f)]
		private float rumbleInterval = 0.09f;

		private static readonly int SurgeId = Shader.PropertyToID("_Surge");

		private MaterialPropertyBlock _mpb;

		private AudioSource _voice;

		private float _surge;

		private float _nextRumble;

		private bool _wasInside;

		private void Awake()
		{
			_mpb = new MaterialPropertyBlock();
			_voice = base.gameObject.AddComponent<AudioSource>();
			_voice.playOnAwake = false;
			_voice.spatialBlend = 0f;
			_voice.spatialize = false;
			if (hum != null)
			{
				hum.loop = true;
				hum.spatialize = false;
				hum.volume = 0f;
			}
		}

		private void OnEnable()
		{
			if (hum != null && hum.clip != null && !hum.isPlaying)
			{
				hum.Play();
			}
		}

		private void Update()
		{
			BtmTechTreeRoom instance = BtmTechTreeRoom.Instance;
			bool flag = false;
			float b = 0f;
			if (Player.HasInstance && Player.Instance.headCollider != null)
			{
				Vector3 vector = base.transform.InverseTransformPoint(Player.Instance.headCollider.transform.position) - passCenter;
				float num = Mathf.Max(0f, new Vector2(vector.x / Mathf.Max(passHalfExtents.x, 0.01f), vector.y / Mathf.Max(passHalfExtents.y, 0.01f)).magnitude - 1f);
				float value = Mathf.Sqrt(vector.z * vector.z + num * num);
				b = Mathf.InverseLerp(surgeRange.x, surgeRange.y, value);
				flag = Mathf.Abs(vector.x) <= passHalfExtents.x && Mathf.Abs(vector.y) <= passHalfExtents.y && Mathf.Abs(vector.z) <= passHalfExtents.z;
			}
			bool flag2 = instance != null && !instance.IsTransitioning;
			if (flag && !_wasInside && flag2)
			{
				Pass(instance);
			}
			_wasInside = flag;
			_surge = Mathf.Lerp(_surge, flag2 ? b : 0f, 1f - Mathf.Exp((0f - surgeSharpness) * Time.deltaTime));
			ApplySurge();
			Rumble();
		}

		private void Pass(BtmTechTreeRoom room)
		{
			if (passBurst != null)
			{
				passBurst.Play();
			}
			if (passClip != null)
			{
				_voice.PlayOneShot(passClip, passVolume);
			}
			if (VRInputController.Instance != null)
			{
				VRInputController.Instance.PulseLeft(0.8f, 0.25f);
				VRInputController.Instance.PulseRight(0.8f, 0.25f);
			}
			room.Exit();
		}

		private void ApplySurge()
		{
			Renderer[] array = surgeRenderers;
			if (array != null)
			{
				foreach (Renderer renderer in array)
				{
					if (!(renderer == null))
					{
						renderer.GetPropertyBlock(_mpb);
						_mpb.SetFloat(SurgeId, _surge);
						renderer.SetPropertyBlock(_mpb);
					}
				}
			}
			if (suction != null)
			{
				ParticleSystem.EmissionModule emission = suction.emission;
				emission.rateOverTime = Mathf.Lerp(suctionRateIdle, suctionRateSurge, _surge);
			}
			if (hum != null)
			{
				float target = 0f;
				if (BtmTechTreeRoom.Instance != null && BtmTechTreeRoom.Instance.LocalPlayerInside)
				{
					target = Mathf.Lerp(humVolume.x, humVolume.y, _surge);
				}
				hum.volume = Mathf.MoveTowards(hum.volume, target, Time.deltaTime * 0.8f);
				hum.pitch = Mathf.Lerp(humPitch.x, humPitch.y, _surge);
			}
		}

		private void Rumble()
		{
			if (!(_surge < 0.35f) && !(Time.time < _nextRumble))
			{
				_nextRumble = Time.time + rumbleInterval;
				if (!(VRInputController.Instance == null))
				{
					float amplitude = rumbleMax * Mathf.InverseLerp(0.35f, 1f, _surge);
					VRInputController.Instance.PulseLeft(amplitude, rumbleInterval);
					VRInputController.Instance.PulseRight(amplitude, rumbleInterval);
				}
			}
		}

		private void OnDrawGizmosSelected()
		{
			Gizmos.matrix = base.transform.localToWorldMatrix;
			Gizmos.color = new Color(0.4f, 0.85f, 1f, 0.6f);
			Gizmos.DrawWireCube(passCenter, passHalfExtents * 2f);
		}
	}
}
