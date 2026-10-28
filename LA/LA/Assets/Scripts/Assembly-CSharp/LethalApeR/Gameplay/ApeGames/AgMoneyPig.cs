using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using Photon.Pun;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.ApeGames
{
	[Obfuscation(Exclude = true)]
	public class AgMoneyPig : MonoBehaviour
	{
		[Header("References")]
		public PigMoneyFill pig;

		public TMP_Text aliveCountText;

		public ParticleSystem cashParticles;

		[Header("Audio")]
		public AudioSource audioSource;

		public AudioClip countTickClip;

		public AudioSource cashSfxSource;

		public AudioClip cashClip;

		public float cashSfxScrubTo = 11f;

		[Header("Reveal Animation")]
		public Animator moneyAnimator;

		public string moneyAnimState = "Scene";

		public float moneyAnimDuration;

		public float moneyRewindDuration;

		public float moneyRewindDelay;

		public AudioClip revealClip;

		public AudioSource revealSfxSource;

		[Header("Fill")]
		[Range(0f, 1f)]
		public float fillScale = 1f;

		public float fillDuration = 6f;

		public AnimationCurve fillEase = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		[Header("Count Reveal")]
		public float countdownLead;

		public float readPreviousDelay = 0.6f;

		public float countStepInterval = 0.22f;

		public float countMaxDuration = 4f;

		public float particleDelay = 0.1f;

		[Header("Cash Drop")]
		public float cashLead;

		public float cashDropDuration = 2.5f;

		private bool _hooked;

		private double _matchStamp;

		private int _rosterTotal;

		private int _aliveAtRoundStart;

		private int _lastShownAlive = -1;

		private Coroutine _seq;

		private Coroutine _cashRoutine;

		private Coroutine _rewindRoutine;

		private Coroutine _revealRoutine;

		private Coroutine _cashStartRoutine;

		private int _moneyStateHash;

		private string _moneyStateName;

		private float _moneyAnimLength;

		private int MoneyStateHash
		{
			get
			{
				if (_moneyStateHash == 0 || !string.Equals(_moneyStateName, moneyAnimState))
				{
					_moneyStateName = moneyAnimState;
					_moneyStateHash = Animator.StringToHash(moneyAnimState);
				}
				return _moneyStateHash;
			}
		}

		private void Awake()
		{
			if (!pig)
			{
				pig = GetComponentInChildren<PigMoneyFill>();
			}
		}

		private void OnEnable()
		{
			ParkMoneyAnim();
			Hook();
		}

		private void OnDisable()
		{
			Unhook();
		}

		private void Update()
		{
			if (!_hooked)
			{
				Hook();
			}
		}

		private void Hook()
		{
			if (_hooked)
			{
				return;
			}
			ApeGamesManager instance = ApeGamesManager.Instance;
			if (!(instance == null))
			{
				_hooked = true;
				instance.OnRoundStartedEvent += OnRoundStarted;
				instance.OnRoundEndedEvent += OnRoundEnded;
				instance.OnMatchEnded += OnMatchEnded;
				instance.OnPropsChanged += OnPropsChanged;
				AgRoundProperties props = instance.Props;
				if (props != null && props.queue == "ApeGames" && props.matchStamp != 0.0)
				{
					SnapToCurrent(props);
				}
				else
				{
					ResetForNewMatch();
				}
			}
		}

		private void Unhook()
		{
			if (_hooked)
			{
				_hooked = false;
				StopSub(ref _seq);
				StopSub(ref _cashRoutine);
				StopSub(ref _cashStartRoutine);
				StopSub(ref _revealRoutine);
				StopSub(ref _rewindRoutine);
				EndCashSfx();
				StopRevealSfx();
				if ((bool)cashParticles)
				{
					cashParticles.Stop(true, ParticleSystemStopBehavior.StopEmitting);
				}
				ParkMoneyAnim();
				ApeGamesManager instance = ApeGamesManager.Instance;
				if (!(instance == null))
				{
					instance.OnRoundStartedEvent -= OnRoundStarted;
					instance.OnRoundEndedEvent -= OnRoundEnded;
					instance.OnMatchEnded -= OnMatchEnded;
					instance.OnPropsChanged -= OnPropsChanged;
				}
			}
		}

		private void OnPropsChanged(AgRoundProperties p)
		{
			if (p != null && !(p.queue != "ApeGames") && p.matchStamp != 0.0 && !p.matchStamp.Equals(_matchStamp))
			{
				_matchStamp = p.matchStamp;
				ResetForNewMatch();
			}
		}

		private void OnRoundStarted(int round, AgRoundProperties p)
		{
			if (p != null)
			{
				int num = Count(p.alive);
				_aliveAtRoundStart = num;
				if (_rosterTotal <= 0)
				{
					_rosterTotal = Mathf.Max(1, num + Count(p.eliminated));
				}
				SetCount(num);
			}
		}

		private void OnRoundEnded(int round, AgRoundProperties p)
		{
			if (p == null)
			{
				return;
			}
			int num = Count(p.alive);
			int num2 = Count(p.eliminated);
			int num3 = ((_rosterTotal > 0) ? _rosterTotal : Mathf.Max(1, num2 + num));
			int num4 = ((_aliveAtRoundStart > 0) ? _aliveAtRoundStart : ((_lastShownAlive >= 0) ? _lastShownAlive : num));
			int prev = Mathf.Max(num4, num);
			float num5 = Mathf.Clamp01((float)num2 / (float)num3 * fillScale);
			if (num < num4)
			{
				if (_seq != null)
				{
					StopCoroutine(_seq);
				}
				_seq = StartCoroutine(RoundEndSequence(prev, num, num5));
				return;
			}
			SetCount(num);
			if ((bool)pig)
			{
				pig.Fill = num5;
			}
		}

		private void OnMatchEnded(int[] winners)
		{
			if (base.isActiveAndEnabled && _seq == null && _cashStartRoutine == null)
			{
				StartCash();
			}
			if (PhotonNetwork.LocalPlayer == null)
			{
				return;
			}
			int actorNumber = PhotonNetwork.LocalPlayer.ActorNumber;
			if (winners == null || actorNumber < 1)
			{
				return;
			}
			for (int i = 0; i < winners.Length; i++)
			{
				if (winners[i] == actorNumber)
				{
					AgHaptics.Both(0.9f, 0.2f);
					break;
				}
			}
		}

		private IEnumerator RoundEndSequence(int prev, int newAlive, float targetFill)
		{
			StopSub(ref _revealRoutine);
			StopSub(ref _rewindRoutine);
			StopSub(ref _cashStartRoutine);
			SetCount(prev);
			float num = RevealDuration();
			float landsAt = Time.unscaledTime + num;
			PlayRevealSfx(num);
			_revealRoutine = StartCoroutine(PlayMoneyAnim(0f, 1f, num));
			yield return WaitUntilUnscaled(landsAt - Mathf.Max(0f, countdownLead));
			if (cashLead > 0f)
			{
				_cashStartRoutine = StartCoroutine(StartCashAt(landsAt - cashLead));
			}
			if (readPreviousDelay > 0f)
			{
				yield return new WaitForSecondsRealtime(readPreviousDelay);
			}
			int num2 = prev - newAlive;
			float interval = ((num2 >= 1) ? Mathf.Min(countStepInterval, countMaxDuration / (float)num2) : 0f);
			int cur = prev;
			while (cur > newAlive)
			{
				cur--;
				SetCount(cur);
				PlayClip(countTickClip);
				if (interval > 0f)
				{
					yield return new WaitForSecondsRealtime(interval);
				}
			}
			if (!(cashLead > 0f))
			{
				if (particleDelay > 0f)
				{
					yield return new WaitForSecondsRealtime(particleDelay);
				}
				StartCash();
			}
			yield return WaitUntilUnscaled(landsAt);
			_rewindRoutine = StartCoroutine(RewindMoneyAnim());
			yield return AnimateFill(targetFill);
			_seq = null;
		}

		private IEnumerator StartCashAt(float unscaledTime)
		{
			yield return WaitUntilUnscaled(unscaledTime);
			StartCash();
			_cashStartRoutine = null;
		}

		private void StartCash()
		{
			if ((bool)cashParticles)
			{
				cashParticles.Play(true);
			}
			PlayCashSfx();
			if (_cashRoutine != null)
			{
				StopCoroutine(_cashRoutine);
			}
			_cashRoutine = StartCoroutine(StopCashAfter(cashDropDuration));
		}

		private static IEnumerator WaitUntilUnscaled(float unscaledTime)
		{
			while (Time.unscaledTime < unscaledTime)
			{
				yield return null;
			}
		}

		private float RevealDuration()
		{
			if (moneyAnimDuration > 0f)
			{
				return moneyAnimDuration;
			}
			if (!moneyAnimator || !moneyAnimator.runtimeAnimatorController)
			{
				return 0f;
			}
			return MoneyAnimLength();
		}

		private void StopSub(ref Coroutine routine)
		{
			if (routine != null)
			{
				StopCoroutine(routine);
				routine = null;
			}
		}

		private IEnumerator RewindMoneyAnim()
		{
			if (moneyRewindDelay > 0f)
			{
				yield return new WaitForSecondsRealtime(moneyRewindDelay);
			}
			yield return PlayMoneyAnim(1f, 0f, moneyRewindDuration);
			_rewindRoutine = null;
		}

		private IEnumerator PlayMoneyAnim(float from, float to, float duration)
		{
			if (!moneyAnimator || !moneyAnimator.runtimeAnimatorController)
			{
				yield break;
			}
			if (!(duration > 0f))
			{
				duration = MoneyAnimLength() * Mathf.Abs(to - from);
			}
			if (duration > 0f)
			{
				HoldMoneyAnim(from);
				float t = 0f;
				while (t < duration)
				{
					t += Time.unscaledDeltaTime;
					HoldMoneyAnim(Mathf.Lerp(from, to, t / duration));
					yield return null;
				}
			}
			HoldMoneyAnim(to);
		}

		private void ParkMoneyAnim()
		{
			HoldMoneyAnim(0f);
		}

		private void HoldMoneyAnim(float normalizedTime)
		{
			if ((bool)moneyAnimator && (bool)moneyAnimator.runtimeAnimatorController)
			{
				moneyAnimator.speed = 0f;
				moneyAnimator.Play(MoneyStateHash, 0, Mathf.Clamp01(normalizedTime));
				moneyAnimator.Update(0f);
			}
		}

		private float MoneyAnimLength()
		{
			if (_moneyAnimLength > 0f)
			{
				return _moneyAnimLength;
			}
			AnimationClip[] animationClips = moneyAnimator.runtimeAnimatorController.animationClips;
			for (int i = 0; i < animationClips.Length; i++)
			{
				if ((bool)animationClips[i] && animationClips[i].length > _moneyAnimLength)
				{
					_moneyAnimLength = animationClips[i].length;
				}
			}
			return _moneyAnimLength;
		}

		private IEnumerator StopCashAfter(float delay)
		{
			if (delay > 0f)
			{
				yield return new WaitForSecondsRealtime(delay);
			}
			if ((bool)cashParticles)
			{
				cashParticles.Stop(true, ParticleSystemStopBehavior.StopEmitting);
			}
			EndCashSfx();
			_cashRoutine = null;
		}

		private IEnumerator AnimateFill(float target)
		{
			if (!pig)
			{
				yield break;
			}
			float from = pig.Fill;
			if (fillDuration > 0f)
			{
				float t = 0f;
				while (t < fillDuration)
				{
					t += Time.unscaledDeltaTime;
					float num = Mathf.Clamp01(t / fillDuration);
					if (fillEase != null)
					{
						num = fillEase.Evaluate(num);
					}
					pig.Fill = Mathf.Lerp(from, target, num);
					yield return null;
				}
			}
			pig.Fill = target;
		}

		private void SnapToCurrent(AgRoundProperties p)
		{
			if (p != null)
			{
				_matchStamp = p.matchStamp;
				int num = Count(p.alive);
				int num2 = Count(p.eliminated);
				_rosterTotal = Mathf.Max(1, num2 + num);
				_aliveAtRoundStart = num;
				SetCount(num);
				if ((bool)pig)
				{
					pig.Fill = Mathf.Clamp01(fillScale * ((float)num2 / (float)_rosterTotal));
				}
				ParkMoneyAnim();
			}
		}

		private void ResetForNewMatch()
		{
			StopSub(ref _seq);
			StopSub(ref _cashRoutine);
			StopSub(ref _cashStartRoutine);
			StopSub(ref _revealRoutine);
			StopSub(ref _rewindRoutine);
			ParkMoneyAnim();
			_rosterTotal = 0;
			_aliveAtRoundStart = 0;
			_lastShownAlive = -1;
			if ((bool)pig)
			{
				pig.Fill = 0f;
			}
			if ((bool)cashParticles)
			{
				cashParticles.Stop(true, ParticleSystemStopBehavior.StopEmittingAndClear);
			}
			if ((bool)cashSfxSource)
			{
				cashSfxSource.Stop();
			}
			StopRevealSfx();
			if ((bool)aliveCountText)
			{
				aliveCountText.text = string.Empty;
			}
		}

		private void SetCount(int value)
		{
			_lastShownAlive = value;
			if ((bool)aliveCountText)
			{
				aliveCountText.text = value.ToString();
			}
		}

		private void PlayClip(AudioClip clip)
		{
			if ((bool)audioSource && (bool)clip)
			{
				audioSource.PlayOneShot(clip, 1f);
			}
		}

		private void PlayCashSfx()
		{
			if ((bool)cashClip)
			{
				AudioSource audioSource = EnsureSource(ref cashSfxSource);
				if ((bool)audioSource)
				{
					audioSource.clip = cashClip;
					audioSource.loop = false;
					audioSource.pitch = 1f;
					audioSource.time = 0f;
					audioSource.Play();
				}
			}
		}

		private void PlayRevealSfx(float duration)
		{
			if ((bool)revealClip)
			{
				AudioSource audioSource = EnsureSource(ref revealSfxSource);
				if ((bool)audioSource)
				{
					audioSource.clip = revealClip;
					audioSource.loop = false;
					audioSource.pitch = ((duration > 0f) ? Mathf.Clamp(revealClip.length / duration, 0.1f, 3f) : 1f);
					audioSource.time = 0f;
					audioSource.Play();
				}
			}
		}

		private void StopRevealSfx()
		{
			if ((bool)revealSfxSource && revealSfxSource.isPlaying)
			{
				revealSfxSource.Stop();
			}
		}

		private AudioSource EnsureSource(ref AudioSource field)
		{
			if ((bool)field)
			{
				return field;
			}
			AudioSource audioSource = base.gameObject.AddComponent<AudioSource>();
			audioSource.playOnAwake = false;
			audioSource.loop = false;
			if ((bool)this.audioSource)
			{
				audioSource.outputAudioMixerGroup = this.audioSource.outputAudioMixerGroup;
				audioSource.spatialBlend = this.audioSource.spatialBlend;
				audioSource.rolloffMode = this.audioSource.rolloffMode;
				audioSource.minDistance = this.audioSource.minDistance;
				audioSource.maxDistance = this.audioSource.maxDistance;
				audioSource.dopplerLevel = this.audioSource.dopplerLevel;
				audioSource.spread = this.audioSource.spread;
				audioSource.volume = this.audioSource.volume;
				audioSource.priority = this.audioSource.priority;
			}
			cashSfxSource = audioSource;
			return cashSfxSource;
		}

		private void EndCashSfx()
		{
			if (!cashSfxSource || !cashSfxSource.isPlaying)
			{
				return;
			}
			if ((bool)cashSfxSource.clip)
			{
				float length = cashSfxSource.clip.length;
				float num = Mathf.Clamp(cashSfxScrubTo, 0f, length);
				if (num < length - 0.02f)
				{
					cashSfxSource.time = num;
					return;
				}
			}
			cashSfxSource.Stop();
		}

		private static int Count(int[] a)
		{
			if (a == null)
			{
				return 0;
			}
			return a.Length;
		}
	}
}
