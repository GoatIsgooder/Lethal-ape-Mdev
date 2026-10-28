using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmGenerator : MonoBehaviour
	{
		[Tooltip("Unique per map, 0-31 (bit in 'gp', byte index in 'gpp'). Set by BtmGeneratorSpawner from the spawn point's id.")]
		public int generatorId;

		[Header("Crank")]
		[Tooltip("Visual wheel, spun from synced progress. Auto-found: child named 'Wheel'.")]
		[SerializeField]
		private Transform crankWheel;

		[Tooltip("Visual wheel degrees per progress point. 28 matches the manager's charge rate, so the wheel tracks the hand 1:1 when cranking solo.")]
		[SerializeField]
		private float wheelDegreesPerPoint = 28f;

		[Tooltip("Max visual catch-up speed so remote wheels animate instead of teleporting.")]
		[SerializeField]
		private float wheelVisualMaxSpeed = 540f;

		[Tooltip("Wheel-local axis the wheel visually spins around (and the crank tracks hands around).")]
		[SerializeField]
		private Vector3 wheelLocalSpinAxis = Vector3.forward;

		[Header("Progress UI")]
		[Tooltip("Shows 0%..100%. Auto-found: the TMP under the child named 'Screen Text'.")]
		[SerializeField]
		private TMP_Text progressText;

		[Header("Lamp")]
		[SerializeField]
		private Renderer lampRenderer;

		[SerializeField]
		private Color offColor = Color.red;

		[SerializeField]
		private Color onColor = new Color(0f, 1f, 0.083f, 1f);

		[Header("Audio")]
		[SerializeField]
		private AudioSource audioSource;

		[Tooltip("One-shot at the moment the generator reaches 100%.")]
		[SerializeField]
		private AudioClip powerOnClip;

		[Tooltip("Starts when the power-on clip finishes; loops until the round ends (generator despawn).")]
		[SerializeField]
		private AudioClip loopClip;

		private static readonly List<BtmGenerator> Registry = new List<BtmGenerator>();

		private static readonly int EmissionColorId = Shader.PropertyToID("_EmissionColor");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static AudioClip _fallbackClip;

		private MaterialPropertyBlock _mpb;

		private Coroutine _audioRoutine;

		private readonly List<Renderer> _pingRenderers = new List<Renderer>(16);

		private bool _pingRenderersCached;

		private float _visualAngle;

		private float _localOverlay;

		private float _lastTarget;

		private bool _visualSeeded;

		private Quaternion _wheelRestRotation = Quaternion.identity;

		public static IReadOnlyList<BtmGenerator> ActiveGenerators => Registry;

		public bool IsPowered { get; private set; }

		public int Progress { get; private set; }

		public Vector3 WheelLocalSpinAxis => wheelLocalSpinAxis;

		public Transform CrankWheel => crankWheel;

		private void Awake()
		{
			SelfConfigure();
			if (crankWheel != null)
			{
				_wheelRestRotation = crankWheel.localRotation;
			}
		}

		private void SelfConfigure()
		{
			if (crankWheel == null)
			{
				Transform transform = base.transform.Find("Wheel");
				if (transform != null)
				{
					crankWheel = transform;
				}
			}
			if (progressText == null)
			{
				progressText = GetComponentInChildren<TMP_Text>(true);
			}
			if (audioSource == null)
			{
				audioSource = GetComponentInChildren<AudioSource>(true);
			}
			if (!(crankWheel != null) || !(crankWheel.GetComponent<BtmGeneratorCrank>() == null))
			{
				return;
			}
			GameObject gameObject = crankWheel.gameObject;
			int num = LayerMask.NameToLayer("Grabbable");
			if (num >= 0)
			{
				gameObject.layer = num;
			}
			else
			{
				Debug.LogError(string.Format("[BtmGenerator {0}] 'Grabbable' layer missing — the crank can't be grabbed.", generatorId));
			}
			if (gameObject.GetComponent<Collider>() == null)
			{
				BoxCollider boxCollider = gameObject.AddComponent<BoxCollider>();
				boxCollider.isTrigger = true;
				MeshFilter component = gameObject.GetComponent<MeshFilter>();
				if (component != null && component.sharedMesh != null)
				{
					Bounds bounds = component.sharedMesh.bounds;
					boxCollider.center = bounds.center;
					boxCollider.size = Vector3.Max(bounds.size, Vector3.one * 0.05f) * 1.15f;
				}
				else
				{
					boxCollider.size = new Vector3(0.9f, 0.9f, 0.3f);
				}
			}
			gameObject.AddComponent<BtmGeneratorCrank>();
		}

		private void OnEnable()
		{
			if (!Registry.Contains(this))
			{
				Registry.Add(this);
			}
			ApplyLamp();
			RefreshText();
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.NotifyGeneratorRegistryChanged();
			}
		}

		private void OnDisable()
		{
			Registry.Remove(this);
			StopPowerAudio();
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager.Instance.NotifyGeneratorRegistryChanged();
			}
		}

		public void ApplyPowered(bool powered, bool playFx)
		{
			if (IsPowered != powered)
			{
				IsPowered = powered;
				ApplyLamp();
				if (powered)
				{
					ApplyProgress(100);
					StartPowerAudio(playFx);
				}
				else
				{
					StopPowerAudio();
					ApplyProgress(0);
				}
			}
		}

		public void ApplyProgress(int progress)
		{
			int num = (IsPowered ? 100 : Mathf.Clamp(progress, 0, 100));
			if (num != Progress)
			{
				Progress = num;
				RefreshText();
				if (!_visualSeeded)
				{
					SnapWheelVisual();
				}
			}
		}

		private void SnapWheelVisual()
		{
			_visualSeeded = true;
			_localOverlay = 0f;
			_lastTarget = wheelDegreesPerPoint * (float)Progress;
			_visualAngle = _lastTarget;
			if (crankWheel != null)
			{
				crankWheel.localRotation = _wheelRestRotation * Quaternion.AngleAxis(0f - _visualAngle, wheelLocalSpinAxis);
			}
		}

		private void RefreshText()
		{
			if (progressText != null)
			{
				progressText.text = string.Format("{0}%", Progress);
			}
		}

		public void AddLocalWheelSpin(float clockwiseDegrees)
		{
			_localOverlay = Mathf.Min(_localOverlay + clockwiseDegrees, 720f);
		}

		private void Update()
		{
			if (!(crankWheel == null))
			{
				float num = wheelDegreesPerPoint * (float)Progress;
				float num2 = num - _lastTarget;
				_lastTarget = num;
				if (num2 > 0f)
				{
					_localOverlay = Mathf.Max(0f, _localOverlay - num2);
				}
				_localOverlay = Mathf.MoveTowards(_localOverlay, 0f, 12f * Time.deltaTime);
				float num3 = Mathf.Max(num + _localOverlay, _visualAngle);
				if (!Mathf.Approximately(num3, _visualAngle))
				{
					_visualAngle = Mathf.MoveTowards(_visualAngle, num3, wheelVisualMaxSpeed * Time.deltaTime);
					crankWheel.localRotation = _wheelRestRotation * Quaternion.AngleAxis(0f - _visualAngle, wheelLocalSpinAxis);
				}
			}
		}

		public void GetPingRenderers(List<Renderer> into)
		{
			if (!_pingRenderersCached)
			{
				_pingRenderersCached = true;
				Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>();
				foreach (Renderer renderer in componentsInChildren)
				{
					if (!(renderer == null) && !(renderer is ParticleSystemRenderer) && !(renderer.GetComponent<TMP_Text>() != null))
					{
						_pingRenderers.Add(renderer);
					}
				}
			}
			into.AddRange(_pingRenderers);
		}

		private void ApplyLamp()
		{
			if (!(lampRenderer == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				Color color = (IsPowered ? onColor : offColor);
				lampRenderer.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, color);
				_mpb.SetColor(EmissionColorId, IsPowered ? (color * 1.6f) : Color.black);
				lampRenderer.SetPropertyBlock(_mpb);
			}
		}

		private void StartPowerAudio(bool playChirp)
		{
			if (!(audioSource == null))
			{
				if (_audioRoutine != null)
				{
					StopCoroutine(_audioRoutine);
				}
				_audioRoutine = StartCoroutine(PowerAudioSequence(playChirp));
			}
		}

		private IEnumerator PowerAudioSequence(bool playChirp)
		{
			if (playChirp)
			{
				AudioClip audioClip = ((powerOnClip != null) ? powerOnClip : GetFallbackClip());
				audioSource.PlayOneShot(audioClip, 1f);
				yield return new WaitForSeconds(Mathf.Max(0f, audioClip.length - 0.25f));
			}
			if (loopClip != null)
			{
				audioSource.clip = loopClip;
				audioSource.loop = true;
				audioSource.Play();
			}
			_audioRoutine = null;
		}

		private void StopPowerAudio()
		{
			if (_audioRoutine != null)
			{
				StopCoroutine(_audioRoutine);
				_audioRoutine = null;
			}
			if (audioSource != null && audioSource.isPlaying)
			{
				audioSource.Stop();
			}
		}

		private static AudioClip GetFallbackClip()
		{
			if (_fallbackClip != null)
			{
				return _fallbackClip;
			}
			float[] array = new float[19845];
			float num = 0f;
			for (int i = 0; i < 19845; i++)
			{
				float num2 = (float)i / 44100f;
				float num3 = Mathf.Clamp01(num2 / 0.45f);
				float num4 = Mathf.Exp(num2 * -4f);
				float num5 = Mathf.Clamp01(num2 * 60f);
				num += (170f + num3 * 520f) * 6.2831855f / 44100f;
				array[i] = (Mathf.Sin(num) * 0.6f + Mathf.Sin(num * 2f) * 0.2f) * (num4 * num5);
			}
			_fallbackClip = AudioClip.Create("BtmGeneratorPowerOn", 19845, 1, 44100, false);
			_fallbackClip.SetData(array, 0);
			return _fallbackClip;
		}
	}
}
