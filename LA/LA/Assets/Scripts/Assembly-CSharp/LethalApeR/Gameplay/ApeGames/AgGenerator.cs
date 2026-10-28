using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgGenerator : MonoBehaviour
	{
		private const int HideSeekRoundIndex = 3;

		public int generatorId;

		[Header("Crank")]
		[SerializeField]
		private Transform crankWheel;

		[SerializeField]
		private float wheelDegreesPerPoint = 28f;

		[SerializeField]
		private float wheelVisualMaxSpeed = 540f;

		[SerializeField]
		private Vector3 wheelLocalSpinAxis = Vector3.forward;

		[Header("Progress UI")]
		[SerializeField]
		private TMP_Text progressText;

		[Header("Lamp")]
		[SerializeField]
		private Renderer lampRenderer;

		[SerializeField]
		private Color offColor = new Color(1f, 0f, 0f, 1f);

		[SerializeField]
		private Color onColor = new Color(0f, 1f, 0.083f, 1f);

		[Header("Audio")]
		[SerializeField]
		private AudioSource audioSource;

		[SerializeField]
		private AudioClip powerOnClip;

		[SerializeField]
		private AudioClip loopClip;

		[Header("Power-on burst (optional)")]
		[SerializeField]
		private ParticleSystem powerOnBurst;

		private static readonly List<AgGenerator> Registry = new List<AgGenerator>();

		private static readonly int EmissionColorId = Shader.PropertyToID("_EmissionColor");

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static AudioClip _fallbackClip;

		private static readonly string[] PercentText = BuildPercentText();

		private MaterialPropertyBlock _mpb;

		private Coroutine _audioRoutine;

		private float _visualAngle;

		private float _localOverlay;

		private float _lastTarget;

		private bool _visualSeeded;

		private Quaternion _wheelRestRotation = Quaternion.identity;

		public static IReadOnlyList<AgGenerator> ActiveGenerators => Registry;

		public bool IsPowered { get; private set; }

		public int Progress { get; private set; }

		public Vector3 WheelLocalSpinAxis => wheelLocalSpinAxis;

		public Transform CrankWheel => crankWheel;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Registry.Clear();
			_fallbackClip = null;
		}

		private static string[] BuildPercentText()
		{
			string[] array = new string[101];
			for (int i = 0; i < array.Length; i++)
			{
				array[i] = i.ToString() + "%";
			}
			return array;
		}

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
			if (audioSource != null)
			{
				audioSource.spatialize = false;
				audioSource.playOnAwake = false;
			}
			if (!(crankWheel != null) || !(crankWheel.GetComponent<AgGeneratorCrank>() == null))
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
				Debug.LogError(string.Format("[AgGenerator {0}] 'Grabbable' layer missing, the crank can't be grabbed.", generatorId));
			}
			if (gameObject.GetComponent<Collider>() == null)
			{
				BoxCollider boxCollider = gameObject.AddComponent<BoxCollider>();
				boxCollider.isTrigger = true;
				MeshFilter component = gameObject.GetComponent<MeshFilter>();
				Vector3 size = new Vector3(0.9f, 0.9f, 0.3f);
				if (component != null && component.sharedMesh != null)
				{
					Bounds bounds = component.sharedMesh.bounds;
					boxCollider.center = bounds.center;
					size = Vector3.Max(bounds.size, Vector3.one * 0.05f) * 1.15f;
				}
				boxCollider.size = size;
			}
			gameObject.AddComponent<AgGeneratorCrank>();
		}

		private void OnEnable()
		{
			Registry.Remove(this);
			Registry.Add(this);
			ApplyLamp();
			RefreshText();
			AdoptCachedProps();
		}

		private void AdoptCachedProps()
		{
			ApeGamesManager instance = ApeGamesManager.Instance;
			bool flag = false;
			int progress = 0;
			AgRoundProperties agRoundProperties = ((instance != null) ? instance.Props : null);
			if (agRoundProperties != null && agRoundProperties.phase == AgPhase.Round && agRoundProperties.round == HideSeekRoundIndex && generatorId >= 0 && generatorId < 32)
			{
				if (((agRoundProperties.poweredGenerators >> generatorId) & 1) != 0)
				{
					flag = true;
					progress = 100;
				}
				else if (agRoundProperties.generatorProgress != null && generatorId < agRoundProperties.generatorProgress.Length)
				{
					progress = agRoundProperties.generatorProgress[generatorId];
				}
			}
			bool isPowered = IsPowered;
			ApplyPowered(flag, false);
			if (flag && isPowered)
			{
				StartPowerAudio(false);
			}
			ApplyProgress(progress);
		}

		private void OnDisable()
		{
			Registry.Remove(this);
			StopPowerAudio();
		}

		public void ApplyPowered(bool powered, bool playFx)
		{
			if (IsPowered == powered)
			{
				return;
			}
			IsPowered = powered;
			ApplyLamp();
			if (powered)
			{
				ApplyProgress(100);
				StartPowerAudio(playFx);
				if (playFx)
				{
					if (powerOnBurst != null)
					{
						powerOnBurst.Play();
					}
					AgHaptics.Both(0.45f, 0.12f);
				}
			}
			else
			{
				StopPowerAudio();
				ApplyProgress(0);
			}
		}

		public void ApplyProgress(int progress)
		{
			int num = (IsPowered ? 100 : Mathf.Clamp(progress, 0, 100));
			if (num != Progress)
			{
				bool flag = num < Progress;
				Progress = num;
				RefreshText();
				if (!_visualSeeded || flag)
				{
					SnapWheelVisual();
				}
			}
		}

		private void SnapWheelVisual()
		{
			_visualSeeded = true;
			_localOverlay = 0f;
			_lastTarget = (_visualAngle = (float)Progress * wheelDegreesPerPoint);
			if (crankWheel != null)
			{
				crankWheel.localRotation = _wheelRestRotation * Quaternion.AngleAxis(0f - _visualAngle, wheelLocalSpinAxis);
			}
		}

		private void RefreshText()
		{
			if (!(progressText == null))
			{
				progressText.text = PercentText[Mathf.Clamp(Progress, 0, 100)];
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
				float num = (float)Progress * wheelDegreesPerPoint;
				float num2 = num - _lastTarget;
				_lastTarget = num;
				if (num2 > 0f)
				{
					_localOverlay = Mathf.Max(0f, _localOverlay - num2);
				}
				_localOverlay = Mathf.MoveTowards(_localOverlay, 0f, Time.deltaTime * 12f);
				float num3 = Mathf.Max(num + _localOverlay, _visualAngle);
				if (!Mathf.Approximately(num3, _visualAngle))
				{
					_visualAngle = Mathf.MoveTowards(_visualAngle, num3, wheelVisualMaxSpeed * Time.deltaTime);
					crankWheel.localRotation = _wheelRestRotation * Quaternion.AngleAxis(0f - _visualAngle, wheelLocalSpinAxis);
				}
			}
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

		public void PlayDetentClick(AudioClip clip)
		{
			if (!(clip == null) && !(audioSource == null))
			{
				float pitch = audioSource.pitch;
				audioSource.pitch = UnityEngine.Random.Range(0.92f, 1.08f);
				audioSource.PlayOneShot(clip, 0.6f);
				audioSource.pitch = pitch;
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
				AudioClip clip = ((powerOnClip != null) ? powerOnClip : GetFallbackClip());
				audioSource.PlayOneShot(clip, 1f);
				yield return new WaitForSeconds(Mathf.Max(0f, clip.length - 0.25f));
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
			int num = 19845;
			float[] array = new float[num];
			float num2 = 0f;
			for (int i = 0; i < num; i++)
			{
				float num3 = (float)i / 44100f;
				float num4 = Mathf.Clamp01(num3 / 0.45f);
				float num5 = Mathf.Exp(num3 * -4f) * Mathf.Clamp01(num3 * 60f);
				float num6 = num4 * 520f + 170f;
				num2 += num6 * 6.2831855f / 44100f;
				array[i] = (Mathf.Sin(num2) * 0.6f + Mathf.Sin(num2 * 2f) * 0.2f) * num5;
			}
			_fallbackClip = AudioClip.Create("AgGeneratorPowerOn", num, 1, 44100, false);
			_fallbackClip.SetData(array, 0);
			return _fallbackClip;
		}
	}
}
