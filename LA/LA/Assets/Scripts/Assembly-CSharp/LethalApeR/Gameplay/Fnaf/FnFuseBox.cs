using System;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnFuseBox : MonoBehaviour
	{
		[Tooltip("Index = breaker id on the wire (A = 0 ... F = 5).")]
		public FnButton[] breakers = new FnButton[6];

		[Tooltip("Lever pivots, same order. Rotated down once pulled in the right order.")]
		public Transform[] levers = new Transform[6];

		public Vector3 leverUpEuler = new Vector3(-35f, 0f, 0f);

		public Vector3 leverDownEuler = new Vector3(35f, 0f, 0f);

		[Tooltip("Shows the order at the box, for a solo guard only.")]
		public TMP_Text soloOrderLabel;

		public TMP_Text usesLabel;

		private readonly Action<bool>[] _handlers = new Action<bool>[6];

		private string _shownOrder;

		private int _shownUses = -1;

		public static FnFuseBox Instance { get; private set; }

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Instance = null;
		}

		public static char Letter(int breaker)
		{
			return (char)(65 + Mathf.Clamp(breaker, 0, 25));
		}

		private void Awake()
		{
			Instance = this;
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private void OnEnable()
		{
			for (int i = 0; i < breakers.Length && i < _handlers.Length; i++)
			{
				int index = i;
				if (!(breakers[i] == null))
				{
					_handlers[i] = delegate
					{
						Pull(index);
					};
					breakers[i].Pressed += _handlers[i];
				}
			}
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.BreakerResult += OnResult;
				instance.Rejected += OnRejected;
			}
		}

		private void OnDisable()
		{
			for (int i = 0; i < breakers.Length && i < _handlers.Length; i++)
			{
				if (breakers[i] != null && _handlers[i] != null)
				{
					breakers[i].Pressed -= _handlers[i];
				}
			}
			FnNight instance = FnNight.Instance;
			if (instance != null)
			{
				instance.BreakerResult -= OnResult;
				instance.Rejected -= OnRejected;
			}
		}

		private static void Pull(int breaker)
		{
			FnNight instance = FnNight.Instance;
			if (!(instance == null) && instance.LocalIsAlive)
			{
				instance.RequestBreaker(breaker);
			}
		}

		private void OnResult(int breaker, FnBreakerResult result)
		{
			FnAudioBank audio = FnGame.Audio;
			if (!(audio == null))
			{
				switch (result)
				{
				case FnBreakerResult.Correct:
					FnAudio.Play(audio.breakerPull, base.transform.position, 0.9f, 1f, 18f, 1f);
					break;
				case FnBreakerResult.Wrong:
					FnAudio.Play(audio.breakerWrong, base.transform.position, 1f, 1f, 18f, 1f);
					break;
				default:
					FnAudio.Play(audio.breakerClunk, base.transform.position, 1f, 1f, 40f, 1f);
					break;
				}
			}
		}

		private void OnRejected(FnRpc request, FnReject reason, int subject)
		{
			if (reason == FnReject.Blackout && subject >= 0 && subject < breakers.Length && !(breakers[subject] == null))
			{
				breakers[subject].FlashRefused();
			}
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.Active)
			{
				return;
			}
			byte[] fuseOrder = instance.FuseOrder;
			int fuseProgress = instance.FuseProgress;
			for (int i = 0; i < levers.Length; i++)
			{
				if (levers[i] == null)
				{
					continue;
				}
				bool flag = false;
				if (fuseProgress >= 1)
				{
					for (int j = 0; j < fuseProgress && j < fuseOrder.Length; j++)
					{
						flag |= fuseOrder[j] == i;
					}
				}
				Quaternion to = Quaternion.Euler(flag ? leverDownEuler : leverUpEuler);
				levers[i].localRotation = Quaternion.RotateTowards(levers[i].localRotation, to, 360f * Time.deltaTime);
			}
			if (usesLabel != null && _shownUses != instance.FuseUsesLeft)
			{
				_shownUses = instance.FuseUsesLeft;
				usesLabel.text = string.Format("RESETS LEFT {0}", _shownUses);
			}
			if (!(soloOrderLabel == null))
			{
				string text = ((instance.TeamSize < 2) ? OrderText(fuseOrder) : "");
				if (!(text == _shownOrder))
				{
					_shownOrder = text;
					soloOrderLabel.text = text;
				}
			}
		}

		public static string OrderText(byte[] order)
		{
			if (order == null || order.Length == 0)
			{
				return "";
			}
			char[] array = new char[order.Length * 4 - 3];
			int num = 0;
			for (int i = 0; i < order.Length; i++)
			{
				if (i > 0)
				{
					array[num++] = ' ';
					array[num++] = '-';
					array[num++] = ' ';
				}
				array[num++] = Letter(order[i]);
			}
			return new string(array);
		}
	}
}
