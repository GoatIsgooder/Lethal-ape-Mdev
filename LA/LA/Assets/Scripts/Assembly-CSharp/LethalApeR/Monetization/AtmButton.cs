using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.CompilerServices;
using TMPro;
using UnityEngine;

namespace LethalApeR.Monetization
{
	[Obfuscation(Exclude = true)]
	public class AtmButton : BaseButton
	{
		[Header("Pack")]
		[Tooltip("Must match a SKU in the ATM Catalog (and the Meta dashboard) exactly.")]
		public string sku;

		[Header("Labels")]
		[Tooltip("Gold amount, e.g. \"5,000 G\".")]
		[SerializeField]
		private TMP_Text goldLabel;

		[Tooltip("Real-money price. Filled in from Meta at runtime.")]
		[SerializeField]
		private TMP_Text priceLabel;

		[Tooltip("Optional \"BEST VALUE\" flash. Hidden automatically when the pack has no badge.")]
		[SerializeField]
		private TMP_Text badgeLabel;

		[Header("Colours")]
		[SerializeField]
		private Color priceColor = new Color(0.55f, 1f, 0.6f, 1f);

		[SerializeField]
		private Color disabledColor = new Color(0.45f, 0.45f, 0.45f, 1f);

		[Header("Feel")]
		[Tooltip("Ignore re-presses for this long. Hand jitter re-enters the trigger volume far more often than you'd think.")]
		[SerializeField]
		private float pressCooldown = 0.75f;

		private GoldPack _pack;

		private float _nextPressTime;

		private bool _subscribed;

		private void Start()
		{
			ResolvePack();
			StartCoroutine(BindWhenServiceReady());
		}

		private void OnDestroy()
		{
			Unsubscribe();
		}

		private void ResolvePack()
		{
			AtmCatalog atmCatalog = AtmCatalog.Load();
			if (atmCatalog == null)
			{
				return;
			}
			if (!atmCatalog.TryGetPack(sku, out _pack))
			{
				UnityEngine.Debug.LogError("[AtmButton] SKU '" + sku + "' is not in the ATM Catalog — this button cannot sell anything.", this);
				return;
			}
			sku = _pack.sku.Trim();
			if (goldLabel != null)
			{
				goldLabel.text = string.Format("{0:N0} G", _pack.gold);
			}
			if (badgeLabel != null)
			{
				bool flag = !string.IsNullOrWhiteSpace(_pack.badge);
				badgeLabel.text = (flag ? _pack.badge : string.Empty);
				if (badgeLabel.gameObject.activeSelf != flag)
				{
					badgeLabel.gameObject.SetActive(flag);
				}
			}
		}

		private IEnumerator BindWhenServiceReady()
		{
			SetPriceText("…", disabledColor);
			WaitForSeconds wait = new WaitForSeconds(0.5f);
			while (AtmPurchaseService.Instance == null)
			{
				yield return wait;
			}
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			instance.OnPricesUpdated += RefreshPrice;
			instance.OnBusyChanged += RefreshInteractable;
			_subscribed = true;
			instance.FetchPrices();
			RefreshPrice();
		}

		private void Unsubscribe()
		{
			if (_subscribed)
			{
				_subscribed = false;
				AtmPurchaseService instance = AtmPurchaseService.Instance;
				if (!(instance == null))
				{
					instance.OnPricesUpdated -= RefreshPrice;
					instance.OnBusyChanged -= RefreshInteractable;
				}
			}
		}

		private void RefreshPrice()
		{
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			if (!(instance == null) && _pack != null)
			{
				string formattedPrice = instance.GetFormattedPrice(sku);
				if (string.IsNullOrEmpty(formattedPrice))
				{
					SetPriceText("…", disabledColor);
				}
				else
				{
					SetPriceText(formattedPrice, priceColor);
				}
			}
		}

		private void RefreshInteractable()
		{
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			if (!(instance == null))
			{
				if (instance.IsBusy)
				{
					SetPriceText("…", disabledColor);
				}
				else
				{
					RefreshPrice();
				}
			}
		}

		private void SetPriceText(string text, Color color)
		{
			if (!(priceLabel == null))
			{
				priceLabel.text = text;
				priceLabel.color = color;
			}
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (Time.unscaledTime < _nextPressTime)
			{
				return;
			}
			_nextPressTime = Time.unscaledTime + pressCooldown;
			if (_pack == null)
			{
				ResolvePack();
				if (_pack == null)
				{
					return;
				}
			}
			AtmPurchaseService instance = AtmPurchaseService.Instance;
			if (instance == null)
			{
				UnityEngine.Debug.LogError("[AtmButton] No AtmPurchaseService — the ATM Catalog is missing from Resources.", this);
				return;
			}
			instance.Purchase(sku, delegate
			{
				RefreshInteractable();
			});
		}
	}
}
