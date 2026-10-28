using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR.UI
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class AnimationSpeaker : MonoBehaviour
	{
		[Serializable]
		public class Line
		{
			[TextArea(2, 4)]
			public string text;

			public AudioClip clip;

			[Tooltip("Frame of the animation clip this line fires on (same numbers as the Animation window ruler). -1 = don't auto-fire; only via an Animation Event calling Speak(index).")]
			[Min(-1f)]
			public int frame = -1;

			[Tooltip("Optional. Only fire when this Animator state (layer 0) is playing. Leave empty to fire from whatever clip is playing.")]
			public string stateName;

			[NonSerialized]
			public int stateHash;

			[Tooltip("0 = auto: typing finishes exactly when the clip ends. Any other value = fixed typing speed in characters per second.")]
			[Min(0f)]
			public float charsPerSecond;
		}

		private const float FallbackCharsPerSecond = 30f;

		[Header("Targets")]
		[SerializeField]
		private TMP_Text label;

		[SerializeField]
		private AudioSource audioSource;

		[Tooltip("Left empty = the Animator on this GameObject.")]
		[SerializeField]
		private Animator animator;

		[Header("Lines (Animation Event → Speak(int index))")]
		[SerializeField]
		private Line[] lines = Array.Empty<Line>();

		[Header("Behaviour")]
		[Tooltip("Seconds after a line finishes typing before the text is wiped. 0 = leave it up.")]
		[Min(0f)]
		[SerializeField]
		private float clearAfterSeconds;

		[Tooltip("Wipe the label when this component is disabled or the object is turned off.")]
		[SerializeField]
		private bool clearOnDisable = true;

		[Header("Duck While Speaking")]
		[Tooltip("AudioSources (e.g. shop music) to turn down while a line is playing. Restored to their original volume after.")]
		[SerializeField]
		private AudioSource[] duckSources = Array.Empty<AudioSource>();

		[Tooltip("Volume multiplier while speaking. 0.25 = a quarter of the original volume.")]
		[Range(0f, 1f)]
		[SerializeField]
		private float duckTo = 0.25f;

		[Tooltip("Seconds to fade down / back up.")]
		[Min(0f)]
		[SerializeField]
		private float duckFade = 0.3f;

		private Coroutine _routine;

		private Line _current;

		private float[] _duckOriginal;

		private bool _ducked;

		private bool _hasOriginals;

		private Coroutine _duckRoutine;

		private bool _watch;

		private int _lastStateHash;

		private float _lastClipTime = -1f;

		private float _clipFrameRate = 60f;

		private float _clipLength;

		private bool _clipLooping;

		private readonly List<AnimatorClipInfo> _clipInfo = new List<AnimatorClipInfo>(1);

		private void Awake()
		{
			if (animator == null)
			{
				animator = GetComponent<Animator>();
			}
			RefreshLineCache();
		}

		private void RefreshLineCache()
		{
			_watch = false;
			for (int i = 0; i < lines.Length; i++)
			{
				Line line = lines[i];
				if (line != null)
				{
					line.stateHash = (string.IsNullOrEmpty(line.stateName) ? 0 : Animator.StringToHash(line.stateName));
					if (line.frame >= 0)
					{
						_watch = true;
					}
				}
			}
		}

		private void Update()
		{
			if (!_watch || animator == null || !animator.isActiveAndEnabled || animator.runtimeAnimatorController == null)
			{
				return;
			}
			AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);
			if (state.fullPathHash != _lastStateHash || _lastClipTime < 0f)
			{
				_lastStateHash = state.fullPathHash;
				_clipLength = state.length;
				_clipFrameRate = 60f;
				_clipLooping = state.loop;
				animator.GetCurrentAnimatorClipInfo(0, _clipInfo);
				if (_clipInfo.Count > 0 && _clipInfo[0].clip != null)
				{
					AnimationClip clip = _clipInfo[0].clip;
					_clipFrameRate = ((clip.frameRate > 0f) ? clip.frameRate : 60f);
					_clipLength = clip.length;
				}
				_lastClipTime = ClipTime(in state);
				return;
			}
			float lastClipTime = _lastClipTime;
			float num = ClipTime(in state);
			_lastClipTime = num;
			if (num == lastClipTime)
			{
				return;
			}
			bool flag = num < lastClipTime && state.loop;
			for (int i = 0; i < lines.Length; i++)
			{
				Line line = lines[i];
				if (line != null && line.frame >= 0 && (line.stateHash == 0 || line.stateHash == state.shortNameHash))
				{
					float num2 = (float)line.frame / _clipFrameRate;
					if (flag ? (num2 > lastClipTime || num2 <= num) : (num2 > lastClipTime && num2 <= num))
					{
						Play(line);
					}
				}
			}
		}

		private float ClipTime(in AnimatorStateInfo state)
		{
			float normalizedTime = state.normalizedTime;
			return (_clipLooping ? (normalizedTime - Mathf.Floor(normalizedTime)) : Mathf.Clamp01(normalizedTime)) * _clipLength;
		}

		public void Speak(int index)
		{
			if (index >= 0 && index < lines.Length)
			{
				Play(lines[index]);
				return;
			}
			Debug.LogWarning(string.Format("[AnimationSpeaker] '{0}': Speak({1}) — no line at that index (have {2}).", name, index, lines.Length), this);
		}

		public void SpeakText(string text)
		{
			Play(new Line
			{
				text = text,
				charsPerSecond = FallbackCharsPerSecond
			});
		}

		public void Clear()
		{
			StopCurrent();
			if (label != null)
			{
				label.text = string.Empty;
			}
		}

		public void Stop()
		{
			StopCurrent();
		}

		private void Play(Line line)
		{
			if (line == null)
			{
				return;
			}
			if (label == null)
			{
				Debug.LogWarning("[AnimationSpeaker] '" + name + "': no TMP label assigned.", this);
			}
			else if (isActiveAndEnabled)
			{
				StopCurrent();
				_current = line;
				Duck(down: true);
				if (line.clip != null)
				{
					if (audioSource != null)
					{
						audioSource.clip = line.clip;
						audioSource.Play();
					}
					else
					{
						Debug.LogWarning("[AnimationSpeaker] '" + name + "': line has a clip but no AudioSource assigned.", this);
					}
				}
				_routine = StartCoroutine(Typewriter(line));
			}
		}

		private void StopCurrent()
		{
			if (_routine != null)
			{
				StopCoroutine(_routine);
				_routine = null;
			}
			if (_current != null && audioSource != null && audioSource.clip == _current.clip && audioSource.isPlaying)
			{
				audioSource.Stop();
			}
			_current = null;
			Duck(down: false);
		}

		private IEnumerator Typewriter(Line line)
		{
			label.text = line.text ?? string.Empty;
			label.maxVisibleCharacters = 0;
			label.ForceMeshUpdate();
			int count = label.textInfo.characterCount;
			if (count > 0)
			{
				float secondsPerChar = ((line.charsPerSecond > 0f) ? (1f / line.charsPerSecond) : ((line.clip != null) ? (line.clip.length / (float)count) : (1f / FallbackCharsPerSecond)));
				float elapsed = 0f;
				int shown = 0;
				while (shown < count)
				{
					elapsed += Time.deltaTime;
					int num = Mathf.Min(count, Mathf.FloorToInt(elapsed / secondsPerChar));
					if (num != shown)
					{
						shown = num;
						label.maxVisibleCharacters = shown;
					}
					yield return null;
				}
			}
			label.maxVisibleCharacters = int.MaxValue;
			if (line.clip != null && audioSource != null)
			{
				while (audioSource.isPlaying && audioSource.clip == line.clip)
				{
					yield return null;
				}
			}
			Duck(down: false);
			if (clearAfterSeconds > 0f)
			{
				yield return new WaitForSeconds(clearAfterSeconds);
				label.text = string.Empty;
			}
			_routine = null;
			_current = null;
		}

		private void Duck(bool down)
		{
			if (duckSources.Length == 0 || _ducked == down)
			{
				return;
			}
			if (down && !_hasOriginals)
			{
				if (_duckOriginal == null || _duckOriginal.Length != duckSources.Length)
				{
					_duckOriginal = new float[duckSources.Length];
				}
				for (int i = 0; i < duckSources.Length; i++)
				{
					_duckOriginal[i] = ((duckSources[i] != null) ? duckSources[i].volume : 0f);
				}
				_hasOriginals = true;
			}
			if (_duckOriginal != null)
			{
				_ducked = down;
				if (_duckRoutine != null)
				{
					StopCoroutine(_duckRoutine);
				}
				if (duckFade > 0f && isActiveAndEnabled)
				{
					_duckRoutine = StartCoroutine(FadeDuck(down ? duckTo : 1f));
					return;
				}
				ApplyDuck(down ? duckTo : 1f);
				_duckRoutine = null;
			}
		}

		private IEnumerator FadeDuck(float targetMul)
		{
			float startMul = 1f;
			for (int i = 0; i < duckSources.Length; i++)
			{
				if (duckSources[i] != null && _duckOriginal[i] > 0f)
				{
					startMul = duckSources[i].volume / _duckOriginal[i];
					break;
				}
			}
			float t = 0f;
			while (t < duckFade)
			{
				t += Time.deltaTime;
				ApplyDuck(Mathf.Lerp(startMul, targetMul, t / duckFade));
				yield return null;
			}
			ApplyDuck(targetMul);
			_duckRoutine = null;
		}

		private void ApplyDuck(float mul)
		{
			for (int i = 0; i < duckSources.Length; i++)
			{
				if (duckSources[i] != null)
				{
					duckSources[i].volume = _duckOriginal[i] * mul;
				}
			}
			if (mul >= 1f)
			{
				_hasOriginals = false;
			}
		}

		private void OnDisable()
		{
			StopCurrent();
			if (_ducked)
			{
				if (_duckRoutine != null)
				{
					StopCoroutine(_duckRoutine);
				}
				_duckRoutine = null;
				ApplyDuck(1f);
				_ducked = false;
			}
			if (clearOnDisable && label != null)
			{
				label.text = string.Empty;
			}
		}

		private void OnValidate()
		{
			RefreshLineCache();
			if (audioSource != null && audioSource.spatialize)
			{
				Debug.LogWarning("[AnimationSpeaker] '" + name + "': AudioSource has Spatialize on — it will be silent in the Editor. Turn it off unless you need 3D positioning.", this);
			}
		}
	}
}
