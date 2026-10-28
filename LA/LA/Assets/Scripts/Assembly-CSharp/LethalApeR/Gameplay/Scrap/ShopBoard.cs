using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using Photon.Pun;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.Scrap
{
	public class ShopBoard : MonoBehaviour
	{
		public enum PurchaseResult
		{
			NoItem = 0,
			ComingSoon = 1,
			CantAfford = 2,
			Failed = 3,
			Busy = 4,
			Purchased = 5
		}

		[Header("Catalog")]
		[SerializeField]
		private ShopCatalog catalog;

		[Header("Buy page (wired by the scaffolder)")]
		[Tooltip("Root of the normal shop UI — hidden while the sale overlay shows.")]
		[SerializeField]
		private GameObject buyPagePanel;

		[SerializeField]
		private TMP_Text nameText;

		[SerializeField]
		private TMP_Text priceText;

		[Tooltip("Optional focused-item icon.")]
		[SerializeField]
		private Image iconImage;

		[Header("Sale overlay")]
		[Tooltip("Overlay shown on a sale; disables the buy page while up.")]
		[SerializeField]
		private GameObject salePanel;

		[SerializeField]
		private TMP_Text salePayoutText;

		[Tooltip("{0} is the payout amount.")]
		[SerializeField]
		private string saleFormat = "+{0:N0}";

		[Tooltip("Seconds the sale overlay covers the buy page before auto-returning.")]
		[SerializeField]
		private float saleOverlaySeconds = 2.2f;

		[Tooltip("On = the page-disabling overlay fires only when the LOCAL player sells, so a teammate's sale won't interrupt your shopping. Off = any lobby sale shows it.")]
		[SerializeField]
		private bool localOverlayOnly = true;

		[Header("Purchase")]
		[Tooltip("Where bought items spawn. Defaults to this transform.")]
		[SerializeField]
		private Transform purchasePoint;

		[Tooltip("Optional 2D buy/spawn confirm sound (spatialize OFF).")]
		[SerializeField]
		private AudioSource spawnSource;

		[SerializeField]
		private AudioClip spawnClip;

		[Tooltip("Scale-pop time for a freshly spawned item.")]
		[SerializeField]
		private float spawnPopTime = 0.18f;

		[Header("Colors")]
		public Color affordableColor = new Color(0.55f, 1f, 0.55f, 1f);

		public Color tooExpensiveColor = new Color(1f, 0.35f, 0.3f, 1f);

		public Color unavailableColor = new Color(0.6f, 0.6f, 0.6f, 1f);

		private ShopTab _tab;

		private readonly Dictionary<ShopTab, int> _index = new Dictionary<ShopTab, int>();

		private bool _saleLockout;

		private float _saleClearAt;

		public ShopTab CurrentTab => _tab;

		public ShopItemData Focused
		{
			get
			{
				if (catalog == null)
				{
					return null;
				}
				List<ShopItemData> list = catalog.ForTab(_tab);
				if (list == null || list.Count == 0)
				{
					return null;
				}
				return list[IndexFor(_tab, list.Count)];
			}
		}

		public event Action<ShopTab> onTabChanged;

		public event Action<ShopItemData> onFocusChanged;

		private void Awake()
		{
			if (purchasePoint == null)
			{
				purchasePoint = base.transform;
			}
			if (salePanel != null)
			{
				salePanel.SetActive(false);
			}
			if (buyPagePanel != null)
			{
				buyPagePanel.SetActive(true);
			}
		}

		private void OnEnable()
		{
			ScrapEvents.OnBalanceChanged += HandleBalanceChanged;
			ScrapEvents.OnScrapSold += HandleScrapSold;
			RefreshInfo();
		}

		private void OnDisable()
		{
			ScrapEvents.OnBalanceChanged -= HandleBalanceChanged;
			ScrapEvents.OnScrapSold -= HandleScrapSold;
		}

		private void Update()
		{
			if (_saleLockout && Time.time >= _saleClearAt)
			{
				EndSaleOverlay();
			}
		}

		public void SetTab(ShopTab tab)
		{
			_tab = tab;
			this.onTabChanged?.Invoke(tab);
			RefreshInfo();
			this.onFocusChanged?.Invoke(Focused);
		}

		public void ScrollNext()
		{
			Scroll(1);
		}

		public void ScrollPrev()
		{
			Scroll(-1);
		}

		private void Scroll(int dir)
		{
			if (!(catalog != null))
			{
				return;
			}
			List<ShopItemData> list = catalog.ForTab(_tab);
			if (list != null && list.Count != 0)
			{
				int num = IndexFor(_tab, list.Count);
				_index[_tab] = Mod(num + dir, list.Count);
				RefreshInfo();
				this.onFocusChanged?.Invoke(Focused);
			}
		}

		private int IndexFor(ShopTab tab, int count)
		{
			int value;
			int v = (_index.TryGetValue(tab, out value) ? value : 0);
			return Mod(v, Mathf.Max(1, count));
		}

		public PurchaseResult TryBuyFocused()
		{
			if (_saleLockout)
			{
				return PurchaseResult.Busy;
			}
			ShopItemData focused = Focused;
			if (focused == null)
			{
				return PurchaseResult.NoItem;
			}
			if (!focused.available)
			{
				return PurchaseResult.ComingSoon;
			}
			if (!focused.CanSpawn)
			{
				return PurchaseResult.Failed;
			}
			ScrapWallet instance = ScrapWallet.Instance;
			if (instance == null)
			{
				return PurchaseResult.Failed;
			}
			if (!instance.CanAfford(focused.price))
			{
				return PurchaseResult.CantAfford;
			}
			instance.TrySpend(focused.price);
			GameObject gameObject = Grant(focused);
			if (gameObject == null)
			{
				instance.Add(focused.price);
				return PurchaseResult.Failed;
			}
			if (spawnSource != null && spawnClip != null)
			{
				spawnSource.PlayOneShot(spawnClip);
			}
			PulseBuyer();
			RefreshInfo();
			return PurchaseResult.Purchased;
		}

		private GameObject Grant(ShopItemData it)
		{
			Vector3 position = purchasePoint.position;
			Quaternion rotation = purchasePoint.rotation;
			GameObject gameObject = null;
			if (it.networkedSpawn)
			{
				if (PhotonNetwork.InRoom)
				{
					gameObject = PhotonNetwork.Instantiate(it.networkPrefabName, position, rotation);
				}
				else
				{
					GameObject gameObject2 = Resources.Load<GameObject>(it.networkPrefabName);
					if (gameObject2 != null)
					{
						gameObject = UnityEngine.Object.Instantiate(gameObject2, position, rotation);
					}
				}
			}
			else if (it.localPrefab != null)
			{
				gameObject = UnityEngine.Object.Instantiate(it.localPrefab, position, rotation);
			}
			if (gameObject != null && spawnPopTime > 0f)
			{
				StartCoroutine(ScalePop(gameObject.transform));
			}
			return gameObject;
		}

		private IEnumerator ScalePop(Transform t)
		{
			if (t == null)
			{
				yield break;
			}
			Vector3 target = t.localScale;
			t.localScale = target * 0.01f;
			float e = 0f;
			while (e < spawnPopTime && t != null)
			{
				e += Time.deltaTime;
				float t2 = Mathf.SmoothStep(0f, 1f, Mathf.Clamp01(e / spawnPopTime));
				t.localScale = Vector3.LerpUnclamped(target * 0.01f, target, t2);
				yield return null;
			}
			if (t != null)
			{
				t.localScale = target;
			}
		}

		private void PulseBuyer()
		{
			if (!(VRInputController.Instance == null))
			{
				VRInputController.Instance.PulseLeft(0.5f, 0.08f);
				VRInputController.Instance.PulseRight(0.5f, 0.08f);
			}
		}

		private void HandleScrapSold(int payout, Vector3 worldPos, int sellerActor)
		{
			if (localOverlayOnly && (PhotonNetwork.InRoom ? PhotonNetwork.LocalPlayer.ActorNumber : 1) != sellerActor)
			{
				return;
			}
			if (salePayoutText != null)
			{
				salePayoutText.text = string.Format(saleFormat, payout);
			}
			if (salePanel != null)
			{
				salePanel.SetActive(true);
			}
			if (buyPagePanel != null)
			{
				buyPagePanel.SetActive(false);
			}
			_saleLockout = true;
			_saleClearAt = Time.time + Mathf.Max(0.2f, saleOverlaySeconds);
		}

		private void EndSaleOverlay()
		{
			_saleLockout = false;
			if (salePanel != null)
			{
				salePanel.SetActive(false);
			}
			if (buyPagePanel != null)
			{
				buyPagePanel.SetActive(true);
			}
			RefreshInfo();
		}

		private void HandleBalanceChanged(int _)
		{
			RefreshInfo();
		}

		private void RefreshInfo()
		{
			ShopItemData focused = Focused;
			if (nameText != null)
			{
				nameText.text = ((focused != null) ? focused.displayName : "COMING SOON");
			}
			if (iconImage != null)
			{
				iconImage.sprite = ((focused != null) ? focused.icon : null);
				iconImage.enabled = focused != null && focused.icon != null;
			}
			if (priceText == null)
			{
				return;
			}
			if (focused == null)
			{
				priceText.text = "";
				return;
			}
			if (!focused.available)
			{
				priceText.text = "COMING SOON";
				priceText.color = unavailableColor;
				return;
			}
			ScrapWallet instance = ScrapWallet.Instance;
			bool flag = instance != null && !instance.CanAfford(focused.price);
			priceText.text = ((focused.price > 0) ? string.Format("{0:N0}", focused.price) : "FREE");
			priceText.color = (flag ? tooExpensiveColor : affordableColor);
		}

		private static int Mod(int v, int n)
		{
			return (v % n + n) % n;
		}
	}
}
