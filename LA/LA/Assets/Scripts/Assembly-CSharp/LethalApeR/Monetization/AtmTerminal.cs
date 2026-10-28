using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using LethalApeR.PlayFab;
using TMPro;
using UnityEngine;

namespace LethalApeR.Monetization
{
	[Obfuscation(Exclude = true)]
	public class AtmTerminal : MonoBehaviour
	{
		[Header("Screen")]
		[SerializeField]
		private TMP_Text balanceLabel;

		[SerializeField]
		private TMP_Text statusLabel;

		[Header("Copy")]
		[SerializeField]
		private string idleMessage = "SELECT A PACK";

		[Tooltip("Idle line while a paid pack is waiting to be credited. The service retries by itself.")]
		[SerializeField]
		private string pendingMessage = "GOLD PENDING - RETRYING";

		[Tooltip("How long a result stays up before the screen returns to the idle line.")]
		[SerializeField]
		private float statusHoldSeconds = 4f;

		[Header("Colours")]
		[SerializeField]
		private Color idleColor = new Color(0.7f, 0.85f, 1f, 1f);

		[SerializeField]
		private Color goodColor = new Color(0.45f, 1f, 0.5f, 1f);

		[SerializeField]
		private Color pendingColor = new Color(1f, 0.78f, 0.3f, 1f);

		[SerializeField]
		private Color badColor = new Color(1f, 0.45f, 0.4f, 1f);

		[Header("Audio")]
		[Tooltip("Plays when gold lands. Meta XR Audio is the project spatializer — leave Spatialize OFF on this source unless the ATM needs true 3D falloff, or it goes silent in the Editor.")]
		[SerializeField]
		private AudioSource successSfx;

		private Coroutine _statusRoutine;

		private bool _subscribed;

		private void OnEnable()
		{
			ShowIdle();
			StartCoroutine(BindAndReconcile());
		}

		private void OnDisable()
		{
			Unsubscribe();
			if (_statusRoutine != null)
			{
				StopCoroutine(_statusRoutine);
				_statusRoutine = null;
			}
		}

		private IEnumerator BindAndReconcile()
		{
			WaitForSeconds wait = new WaitForSeconds(0.5f);
			while (AtmPurchaseService.Instance == null || LocalProfileManager.Instance == null)
			{
				yield return wait;
			}
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			instance.OnStatus += HandleStatus;
			instance.OnPendingChanged += HandlePendingChanged;
			LocalProfileManager.Instance.OnCurrencyChanged += HandleCurrencyChanged;
			_subscribed = true;
			RefreshBalance();
			if (_statusRoutine == null)
			{
				ShowIdle();
			}
			instance.Reconcile();
		}

		private void Unsubscribe()
		{
			if (_subscribed)
			{
				_subscribed = false;
				AtmPurchaseService instance = AtmPurchaseService.Instance;
				if (instance != null)
				{
					instance.OnStatus -= HandleStatus;
					instance.OnPendingChanged -= HandlePendingChanged;
				}
				if (LocalProfileManager.Instance != null)
				{
					LocalProfileManager.Instance.OnCurrencyChanged -= HandleCurrencyChanged;
				}
			}
		}

		private void HandleCurrencyChanged(int amount)
		{
			SetBalance(amount);
		}

		private void RefreshBalance()
		{
			SetBalance(LocalProfileManager.Instance?.GetCurrency() ?? 0);
		}

		private void SetBalance(int amount)
		{
			if (balanceLabel != null)
			{
				balanceLabel.text = string.Format("{0:N0} G", amount);
			}
		}

		private void HandlePendingChanged()
		{
			if (_statusRoutine == null)
			{
				ShowIdle();
			}
		}

		private void HandleStatus(string message, AtmTone tone)
		{
			if (string.IsNullOrEmpty(message))
			{
				ShowIdle();
				return;
			}
			if (tone == AtmTone.Working)
			{
				if (_statusRoutine != null)
				{
					StopCoroutine(_statusRoutine);
					_statusRoutine = null;
				}
				Write(message, idleColor);
				return;
			}
			ShowStatus(message, ColorFor(tone));
			if (tone == AtmTone.Good)
			{
				PlaySuccess();
			}
		}

		private Color ColorFor(AtmTone tone)
		{
			return tone switch
			{
				AtmTone.Good => goodColor,
				AtmTone.Pending => pendingColor,
				AtmTone.Bad => badColor,
				_ => idleColor,
			};
		}

		private void ShowStatus(string message, Color color)
		{
			if (_statusRoutine != null)
			{
				StopCoroutine(_statusRoutine);
			}
			_statusRoutine = StartCoroutine(StatusRoutine(message, color));
		}

		private IEnumerator StatusRoutine(string message, Color color)
		{
			Write(message, color);
			yield return new WaitForSeconds(statusHoldSeconds);
			_statusRoutine = null;
			ShowIdle();
		}

		private void ShowIdle()
		{
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			bool flag = instance != null && instance.HasPendingGold;
			Write(flag ? pendingMessage : idleMessage, flag ? pendingColor : idleColor);
		}

		private void Write(string message, Color color)
		{
			if (!(statusLabel == null))
			{
				statusLabel.text = message;
				statusLabel.color = color;
			}
		}

		private void PlaySuccess()
		{
			if (successSfx != null && successSfx.clip != null)
			{
				successSfx.PlayOneShot(successSfx.clip);
			}
		}
	}
}
