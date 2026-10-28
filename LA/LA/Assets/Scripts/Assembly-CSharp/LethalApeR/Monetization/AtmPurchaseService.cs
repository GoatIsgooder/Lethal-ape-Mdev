using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.PlayFab;
using Oculus.Platform;
using Oculus.Platform.Models;
using QauthSdk;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Monetization
{
	[Obfuscation(Exclude = true)]
	public sealed class AtmPurchaseService : MonoBehaviour
	{
		private enum RedeemFor
		{
			Checkout = 0,
			Outstanding = 1,
			Unsettled = 2
		}

		private struct Summary
		{
			public bool Listed;

			public int Gold;

			public int Balance;

			public bool Pending;
		}

		private sealed class PurchaseFetch
		{
			public readonly List<Purchase> Items = new List<Purchase>();

			public Action<bool, List<Purchase>> OnComplete;

			public int Pages;

			public bool Done;

			public void Finish(bool listed)
			{
				if (!Done)
				{
					Done = true;
					OnComplete?.Invoke(listed, Items);
				}
			}
		}

		public const string CloudScriptFunction = "RedeemGoldPack";

		private const int QuickRedeemAttempts = 3;

		private const int MaxPurchasePages = 20;

		private const float PlatformTimeoutSeconds = 15f;

		private const float PriceRetrySeconds = 5f;

		private const int PriceFetchAttempts = 4;

		private const float QuietReconcileCooldownSeconds = 20f;

		private const float SetupProblemRetrySeconds = 600f;

		private static readonly float[] PendingRetrySeconds = new float[4] { 20f, 60f, 180f, 600f };

		private const string UnsettledPrefsKey = "ATM_Unsettled";

		private const long UnsettledMaxAgeSeconds = 259200L;

		private readonly Dictionary<string, string> _prices = new Dictionary<string, string>(StringComparer.Ordinal);

		private bool _pricesFetched;

		private bool _pricesFetching;

		private bool _startupReconcileDone;

		private bool _reconcileWanted;

		private bool _setupProblem;

		private int _retryStep;

		private float _lastQuietReconcile = float.NegativeInfinity;

		private Coroutine _retryRoutine;

		private PlayFabManager _boundManager;

		public static AtmPurchaseService Instance { get; private set; }

		public bool IsBusy { get; private set; }

		public bool HasPendingGold { get; private set; }

		public AtmCatalog Catalog { get; private set; }

		public bool IsAvailable => Catalog != null && Core.IsInitialized();

		public bool IsLoggedIn => PlayFabManager.Instance != null && PlayFabManager.Instance.IsLoggedIn;

		public event Action<string, AtmTone> OnStatus;

		public event Action OnPricesUpdated;

		public event Action OnBusyChanged;

		public event Action OnPendingChanged;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void Bootstrap()
		{
			if (Instance != null)
			{
				return;
			}
			AtmCatalog atmCatalog = AtmCatalog.Load();
			if (!(atmCatalog == null) && atmCatalog.AllSkus().Length != 0)
			{
				GameObject gameObject = new GameObject("[AtmPurchaseService]");
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				gameObject.AddComponent<AtmPurchaseService>();
			}
		}

		private void Awake()
		{
			if (Instance != null && Instance != this)
			{
				UnityEngine.Object.Destroy(base.gameObject);
				return;
			}
			Instance = this;
			Catalog = AtmCatalog.Load();
			if (Catalog == null)
			{
				base.enabled = false;
			}
			else
			{
				HasPendingGold = LoadUnsettled().Count > 0;
			}
		}

		private void OnEnable()
		{
			SceneManager.sceneLoaded += HandleSceneLoaded;
		}

		private void OnDisable()
		{
			SceneManager.sceneLoaded -= HandleSceneLoaded;
			Unbind();
		}

		private void Start()
		{
			StartCoroutine(BindWhenManagerExists());
		}

		private void OnDestroy()
		{
			if (Instance == this)
			{
				Instance = null;
			}
		}

		private IEnumerator BindWhenManagerExists()
		{
			WaitForSecondsRealtime wait = new WaitForSecondsRealtime(0.5f);
			while (PlayFabManager.Instance == null)
			{
				yield return wait;
			}
			EnsureBound();
		}

		private void EnsureBound()
		{
			PlayFabManager instance = PlayFabManager.Instance;
			if ((object)instance == _boundManager)
			{
				return;
			}
			Unbind();
			if (!(instance == null))
			{
				_boundManager = instance;
				instance.OnLoggedIn += HandleLoggedIn;
				if (instance.IsLoggedIn)
				{
					HandleLoggedIn();
				}
			}
		}

		private void Unbind()
		{
			if ((object)_boundManager != null)
			{
				_boundManager.OnLoggedIn -= HandleLoggedIn;
				_boundManager = null;
			}
		}

		private void HandleLoggedIn()
		{
			FetchPrices();
			if (!_startupReconcileDone || HasPendingGold || _reconcileWanted)
			{
				QuietReconcile(true);
			}
		}

		private void HandleSceneLoaded(Scene scene, LoadSceneMode mode)
		{
			EnsureBound();
			if (!_startupReconcileDone || HasPendingGold || _reconcileWanted)
			{
				QuietReconcile(false);
			}
		}

		public string GetFormattedPrice(string sku)
		{
			if (string.IsNullOrEmpty(sku))
			{
				return null;
			}
			string value;
			return _prices.TryGetValue(sku.Trim(), out value) ? value : null;
		}

		public void FetchPrices()
		{
			if (!_pricesFetched && !_pricesFetching && !(Catalog == null))
			{
				StartCoroutine(FetchPricesRoutine(PriceFetchAttempts));
			}
		}

		private IEnumerator FetchPricesRoutine(int attemptsLeft)
		{
			_pricesFetching = true;
			string[] skus = Catalog.AllSkus();
			while (attemptsLeft-- > 0 && !_pricesFetched && skus.Length != 0)
			{
				if (!Core.IsInitialized())
				{
					yield return new WaitForSecondsRealtime(PriceRetrySeconds);
					continue;
				}
				bool done = false;
				Request<ProductList> request = IAP.GetProductsBySKU(skus);
				if (request == null)
				{
					yield return new WaitForSecondsRealtime(PriceRetrySeconds);
					continue;
				}
				request.OnComplete(delegate(Message<ProductList> msg)
				{
					done = true;
					if (msg.IsError)
					{
						Error error = msg.GetError();
						Debug.LogWarning(string.Format("[ATM] Price fetch failed (code={0}): {1}. ", error.Code, error.Message) + "Usual causes: the SKU is not in the Meta dashboard, a case mismatch, or the build's release channel has no add-ons published.");
						return;
					}
					foreach (Product product in msg.Data)
					{
						_prices[product.Sku] = product.FormattedPrice;
						if (product.Type != ProductType.CONSUMABLE)
						{
							Debug.LogError(string.Format("[ATM] Add-on '{0}' is {1}, not CONSUMABLE. ", product.Sku, product.Type) + "Gold packs must be Consumable in the Meta dashboard or they can only ever be bought once.");
						}
					}
					_pricesFetched = _prices.Count > 0;
					if (_pricesFetched)
					{
						OnPricesUpdated?.Invoke();
					}
				});
				float deadline = Time.realtimeSinceStartup + PlatformTimeoutSeconds;
				while (!done && Time.realtimeSinceStartup < deadline)
				{
					yield return null;
				}
				if (!_pricesFetched)
				{
					yield return new WaitForSecondsRealtime(PriceRetrySeconds);
				}
			}
			_pricesFetching = false;
		}

		public void Purchase(string sku, Action<AtmResult> onComplete = null)
		{
			if (IsBusy)
			{
				Report(new AtmResult(AtmOutcome.Busy, sku, 0, 0, null), onComplete);
				return;
			}
			string canonical = (Catalog != null) ? Catalog.ResolveCanonicalSku(sku) : null;
			if (canonical == null)
			{
				Debug.LogError("[ATM] SKU '" + sku + "' is not in the ATM catalog.");
				Report(new AtmResult(AtmOutcome.NotConfigured, sku, 0, 0, "Unavailable"), onComplete);
				return;
			}
			if (!IsLoggedIn)
			{
				Report(new AtmResult(AtmOutcome.NotConfigured, canonical, 0, 0, "Not signed in"), onComplete);
				return;
			}
			if (!IsAvailable)
			{
				Debug.LogWarning("[ATM] Oculus Core not initialised — cannot open checkout.");
				Report(new AtmResult(AtmOutcome.Unavailable, canonical, 0, 0, "Store unavailable"), onComplete);
				return;
			}
			SetBusy(true);
			Status("Checking…", AtmTone.Working);
			ReconcileCore(delegate(Summary summary)
			{
				Absorb(summary);
				if (summary.Gold >= 1)
				{
					Finish(new AtmResult(AtmOutcome.Restored, canonical, summary.Gold, summary.Balance, null), onComplete);
				}
				else if (summary.Pending)
				{
					Finish(new AtmResult(AtmOutcome.Deferred, canonical, 0, 0, null), onComplete);
				}
				else
				{
					Status("Opening store…", AtmTone.Working);
					LaunchCheckout(canonical, onComplete);
				}
			});
		}

		private void LaunchCheckout(string sku, Action<AtmResult> onComplete)
		{
			try
			{
				Request<Purchase> request = IAP.LaunchCheckoutFlow(sku);
				if (request == null)
				{
					Finish(new AtmResult(AtmOutcome.Unavailable, sku, 0, 0, "Store unavailable"), onComplete);
					return;
				}
				request.OnComplete(delegate(Message<Purchase> msg)
				{
					if (msg.IsError)
					{
						Error error = msg.GetError();
						if (!string.IsNullOrEmpty(error.Message) && error.Message.IndexOf("user_canceled", StringComparison.Ordinal) >= 0)
						{
							Finish(new AtmResult(AtmOutcome.Cancelled, sku, 0, 0, null), onComplete);
							return;
						}
						Debug.LogWarning(string.Format("[ATM] Checkout reported an error for '{0}' (code={1}): {2} — checking whether it went through.", sku, error.Code, error.Message));
						Status("Checking…", AtmTone.Working);
						ReconcileCore(delegate(Summary summary)
						{
							Absorb(summary);
							if (summary.Gold >= 1)
							{
								Finish(new AtmResult(AtmOutcome.Success, sku, summary.Gold, summary.Balance, null), onComplete);
							}
							else if (summary.Pending)
							{
								Finish(new AtmResult(AtmOutcome.Deferred, sku, 0, 0, null), onComplete);
							}
							else
							{
								Finish(new AtmResult(AtmOutcome.Failed, sku, 0, 0, "Purchase failed"), onComplete);
							}
						});
					}
					else
					{
						RememberUnsettled(sku);
						Status("Adding gold…", AtmTone.Working);
						RedeemAttempt(sku, RedeemFor.Checkout, 1, delegate(AtmResult result)
						{
							if (result.Outcome == AtmOutcome.Deferred)
							{
								SetPending(true);
								ScheduleRetry();
							}
							Finish(result, onComplete);
						});
					}
				});
			}
			catch (Exception ex)
			{
				Debug.LogError("[ATM] LaunchCheckoutFlow threw for '" + sku + "': " + ex.Message);
				Finish(new AtmResult(AtmOutcome.Failed, sku, 0, 0, "Store error"), onComplete);
			}
		}

		public void Reconcile(Action<AtmResult> onComplete = null)
		{
			if (IsBusy)
			{
				onComplete?.Invoke(new AtmResult(AtmOutcome.Busy, null, 0, 0, null));
				return;
			}
			if (!IsAvailable || !IsLoggedIn)
			{
				onComplete?.Invoke(new AtmResult(AtmOutcome.Unavailable, null, 0, 0, null));
				return;
			}
			SetBusy(true);
			ReconcileCore(delegate(Summary summary)
			{
				Absorb(summary);
				if (summary.Gold >= 1)
				{
					Status(string.Format("Restored +{0:N0} gold", summary.Gold), AtmTone.Good);
				}
				SetBusy(false);
				onComplete?.Invoke(ToResult(summary));
			});
		}

		private void QuietReconcile(bool ignoreCooldown)
		{
			if (ignoreCooldown || !(Time.realtimeSinceStartup - _lastQuietReconcile < QuietReconcileCooldownSeconds))
			{
				if (IsBusy || !IsAvailable || !IsLoggedIn)
				{
					_reconcileWanted = true;
					return;
				}
				_reconcileWanted = false;
				_lastQuietReconcile = Time.realtimeSinceStartup;
				Reconcile();
			}
		}

		private void ReconcileCore(Action<Summary> onComplete)
		{
			FetchAllPurchases(delegate(bool listed, List<Purchase> purchases)
			{
				List<string> skus = new List<string>();
				List<RedeemFor> purposes = new List<RedeemFor>();
				for (int i = 0; i < purchases.Count; i++)
				{
					Purchase purchase = purchases[i];
					if (purchase != null && purchase.Type == ProductType.CONSUMABLE)
					{
						string text = Catalog.ResolveCanonicalSku(purchase.Sku);
						if (text != null && !skus.Contains(text))
						{
							skus.Add(text);
							purposes.Add(RedeemFor.Outstanding);
						}
					}
				}
				foreach (string item in LoadUnsettled())
				{
					if (!skus.Contains(item))
					{
						skus.Add(item);
						purposes.Add(RedeemFor.Unsettled);
					}
				}
				if (skus.Count == 0)
				{
					onComplete?.Invoke(new Summary
					{
						Listed = listed
					});
				}
				else
				{
					Debug.Log(string.Format("[ATM] {0} gold pack(s) paid for but not confirmed credited — redeeming.", skus.Count));
					RedeemEach(skus, purposes, 0, new Summary
					{
						Listed = listed
					}, onComplete);
				}
			});
		}

		private void RedeemEach(List<string> skus, List<RedeemFor> purposes, int index, Summary summary, Action<Summary> onComplete)
		{
			if (index < skus.Count)
			{
				Redeem(skus[index], purposes[index], delegate(AtmResult result)
				{
					if (result.Credited)
					{
						summary.Gold += result.GoldGranted;
					}
					if (result.NewBalance > 0)
					{
						summary.Balance = result.NewBalance;
					}
					if (result.Outcome == AtmOutcome.Deferred)
					{
						summary.Pending = true;
					}
					RedeemEach(skus, purposes, index + 1, summary, onComplete);
				});
			}
			else
			{
				onComplete(summary);
			}
		}

		private void Absorb(Summary summary)
		{
			_reconcileWanted = false;
			if (summary.Listed)
			{
				_startupReconcileDone = true;
			}
			SetPending(summary.Pending);
			if (!summary.Pending && summary.Listed)
			{
				_retryStep = 0;
				_setupProblem = false;
			}
			else
			{
				ScheduleRetry();
			}
		}

		private void ScheduleRetry()
		{
			if (_retryRoutine == null)
			{
				float seconds = (_setupProblem ? 600f : PendingRetrySeconds[Mathf.Min(_retryStep, PendingRetrySeconds.Length - 1)]);
				_retryStep++;
				_retryRoutine = StartCoroutine(RetryAfter(seconds));
			}
		}

		private IEnumerator RetryAfter(float seconds)
		{
			yield return new WaitForSecondsRealtime(seconds);
			_retryRoutine = null;
			QuietReconcile(ignoreCooldown: true);
		}

		private void FetchAllPurchases(Action<bool, List<Purchase>> onComplete)
		{
			PurchaseFetch fetch = new PurchaseFetch
			{
				OnComplete = onComplete
			};
			Request<PurchaseList> request = IAP.GetViewerPurchases();
			if (request == null)
			{
				fetch.Finish(listed: false);
				return;
			}
			StartCoroutine(PurchaseFetchTimeout(fetch));
			request.OnComplete(delegate(Message<PurchaseList> msg)
			{
				HandlePurchasePage(msg, fetch);
			});
		}

		private IEnumerator PurchaseFetchTimeout(PurchaseFetch fetch)
		{
			yield return new WaitForSecondsRealtime(15f);
			if (!fetch.Done)
			{
				Debug.LogWarning(string.Format("[ATM] GetViewerPurchases gave no answer within {0:0}s.", 15f));
				fetch.Finish(fetch.Pages > 0);
			}
		}

		private void HandlePurchasePage(Message<PurchaseList> msg, PurchaseFetch fetch)
		{
			if (fetch.Done)
			{
				return;
			}
			if (msg.IsError)
			{
				Debug.LogWarning(string.Format("[ATM] GetViewerPurchases page {0} failed: {1}", fetch.Pages + 1, msg.GetError().Message));
				fetch.Finish(fetch.Pages > 0);
				return;
			}
			fetch.Pages++;
			foreach (Purchase item in msg.Data)
			{
				fetch.Items.Add(item);
			}
			if (msg.Data.HasNextPage && fetch.Pages < 20)
			{
				Request<PurchaseList> nextPage = IAP.GetNextPurchaseListPage(msg.Data);
				if (nextPage != null)
				{
					nextPage.OnComplete(delegate(Message<PurchaseList> m)
					{
						HandlePurchasePage(m, fetch);
					});
					return;
				}
			}
			else if (msg.Data.HasNextPage)
			{
				Debug.LogWarning(string.Format("[ATM] Stopped paging purchases at {0} pages.", 20));
			}
			fetch.Finish(listed: true);
		}

		private void Redeem(string sku, RedeemFor purpose, Action<AtmResult> onComplete)
		{
			RedeemAttempt(sku, purpose, 1, onComplete);
		}

		private async void RedeemAttempt(string sku, RedeemFor purpose, int attempt, Action<AtmResult> onComplete)
		{
			long before = Qauth.Wallet.Last?.Coins ?? (LocalProfileManager.Instance != null ? LocalProfileManager.Instance.GetCurrency() : 0);
			QauthRedeemResult result;
			try
			{
				result = await Qauth.Addons.RedeemAsync(sku);
			}
			catch (Exception ex)
			{
				if (this == null)
				{
					return;
				}
				Debug.LogWarning("[ATM] RedeemGoldPack request failed for '" + sku + "': " + ex.Message);
				RetryOrDefer(sku, purpose, attempt, setupProblem: false, onComplete);
				return;
			}
			if (this == null)
			{
				return;
			}
			HandleReply(sku, purpose, attempt, before, result, onComplete);
		}

		private void HandleReply(string sku, RedeemFor purpose, int attempt, long before, QauthRedeemResult result, Action<AtmResult> onComplete)
		{
			int newBalance = (result.Wallet != null && result.Wallet.Error == null) ? (int)result.Wallet.Coins : 0;
			ApplyBalance(newBalance);
			if (result.Ok)
			{
				int goldGranted = 0;
				if (result.Granted)
				{
					goldGranted = Mathf.Max(0, (int)(newBalance - before));
					if (goldGranted == 0 && Catalog != null && Catalog.TryGetPack(sku, out GoldPack pack))
					{
						goldGranted = pack.gold;
					}
				}
				ForgetUnsettled(sku);
				Debug.Log(string.Format("[ATM] Credited {0} GD ({1}). New balance {2}.", goldGranted, sku, newBalance));
				AtmOutcome outcome = ((purpose != RedeemFor.Checkout) ? AtmOutcome.Restored : AtmOutcome.Success);
				onComplete(new AtmResult(outcome, sku, goldGranted, newBalance, null));
				return;
			}
			string text2 = result.Error ?? "unknown";
			if (text2 == "NOT_PURCHASED")
			{
				if (purpose != RedeemFor.Checkout)
				{
					ForgetUnsettled(sku);
					onComplete(new AtmResult(AtmOutcome.NotEntitled, sku, 0, newBalance, null));
					return;
				}
			}
			else if (text2 == "UNKNOWN_ADDON")
			{
				Debug.LogError(SetupProblem(text2, sku));
				RetryOrDefer(sku, purpose, attempt, setupProblem: true, onComplete);
				return;
			}
			Debug.LogWarning("[ATM] '" + sku + "' not credited yet (" + text2 + ").");
			RetryOrDefer(sku, purpose, attempt, setupProblem: false, onComplete);
		}

		private void RetryOrDefer(string sku, RedeemFor purpose, int attempt, bool setupProblem, Action<AtmResult> onComplete)
		{
			if (!setupProblem && attempt < 3)
			{
				StartCoroutine(InvokeAfter((float)attempt * 1.5f, delegate
				{
					RedeemAttempt(sku, purpose, attempt + 1, onComplete);
				}));
				return;
			}
			_setupProblem = setupProblem;
			Debug.LogWarning("[ATM] '" + sku + "' is paid but not credited yet. Nothing is lost — it is retried automatically.");
			onComplete(new AtmResult(AtmOutcome.Deferred, sku, 0, 0, null));
		}

		private static string SetupProblem(string reason, string sku)
		{
			if (reason == "UNKNOWN_ADDON")
			{
				return "[ATM] '" + sku + "' is not an add-on on the Qauth dashboard (exact case).";
			}
			return "[ATM] Server rejected the request for '" + sku + "' (" + reason + ").";
		}

		private List<string> LoadUnsettled()
		{
			List<string> list = new List<string>();
			string text = PlayerPrefs.GetString("ATM_Unsettled", "");
			if (string.IsNullOrEmpty(text))
			{
				return list;
			}
			long num = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
			bool flag = false;
			string[] array = text.Split(';');
			foreach (string text2 in array)
			{
				int num2 = text2.LastIndexOf(':');
				if (num2 < 1)
				{
					flag = true;
					continue;
				}
				string text3 = Catalog?.ResolveCanonicalSku(text2.Substring(0, num2));
				if (!long.TryParse(text2.Substring(num2 + 1), out var result))
				{
					flag = true;
				}
				else if (text3 == null || num - result >= 259200)
				{
					flag = true;
				}
				else if (list.Contains(text3))
				{
					flag = true;
				}
				else
				{
					list.Add(text3);
				}
			}
			if (flag)
			{
				SaveUnsettled(text, null, null);
			}
			return list;
		}

		private void RememberUnsettled(string sku)
		{
			SaveUnsettled(PlayerPrefs.GetString("ATM_Unsettled", ""), sku, DateTimeOffset.UtcNow.ToUnixTimeSeconds());
		}

		private void ForgetUnsettled(string sku)
		{
			SaveUnsettled(PlayerPrefs.GetString("ATM_Unsettled", ""), sku, null);
		}

		private void SaveUnsettled(string raw, string sku, long? at)
		{
			long num = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
			List<string> list = new List<string>();
			if (!string.IsNullOrEmpty(raw))
			{
				string[] array = raw.Split(';');
				foreach (string text in array)
				{
					int num2 = text.LastIndexOf(':');
					if (num2 >= 1)
					{
						string text2 = text.Substring(0, num2);
						if (!(text2 == sku) && Catalog?.ResolveCanonicalSku(text2) != null && long.TryParse(text.Substring(num2 + 1), out var result) && num - result < 259200)
						{
							list.Add(text);
						}
					}
				}
			}
			if (sku != null && at.HasValue)
			{
				list.Add(sku + ":" + at.Value);
			}
			string text3 = string.Join(";", list);
			if (!(text3 == raw))
			{
				PlayerPrefs.SetString("ATM_Unsettled", text3);
				PlayerPrefs.Save();
			}
		}

		private void ApplyBalance(int newBalance)
		{
			if (newBalance > 0 && !(LocalProfileManager.Instance == null))
			{
				LocalProfileManager.Instance.SeedCurrency(newBalance);
			}
		}

		private void SetBusy(bool busy)
		{
			if (IsBusy != busy)
			{
				IsBusy = busy;
				OnBusyChanged?.Invoke();
				if (!busy && _reconcileWanted)
				{
					QuietReconcile(ignoreCooldown: true);
				}
			}
		}

		private void SetPending(bool pending)
		{
			if (HasPendingGold != pending)
			{
				HasPendingGold = pending;
				OnPendingChanged?.Invoke();
			}
		}

		private void Status(string text, AtmTone tone)
		{
			OnStatus?.Invoke(text, tone);
		}

		private void Finish(AtmResult result, Action<AtmResult> onComplete)
		{
			Status(StatusFor(result), ToneFor(result));
			SetBusy(busy: false);
			onComplete?.Invoke(result);
		}

		private void Report(AtmResult result, Action<AtmResult> onComplete)
		{
			Status(StatusFor(result), ToneFor(result));
			onComplete?.Invoke(result);
		}

		private static AtmResult ToResult(Summary summary)
		{
			if (summary.Gold > 0)
			{
				return new AtmResult(AtmOutcome.Restored, null, summary.Gold, summary.Balance, null);
			}
			if (summary.Pending)
			{
				return new AtmResult(AtmOutcome.Deferred, null, 0, 0, null);
			}
			return new AtmResult(summary.Listed ? AtmOutcome.NotEntitled : AtmOutcome.Failed, null, 0, 0, null);
		}

		private static string StatusFor(AtmResult result)
		{
			switch (result.Outcome)
			{
			case AtmOutcome.Success:
				return string.Format("+{0:N0} gold!", result.GoldGranted);
			case AtmOutcome.Restored:
				return string.Format("Restored +{0:N0} gold", result.GoldGranted);
			case AtmOutcome.Cancelled:
				return "Cancelled";
			case AtmOutcome.Busy:
				return "One at a time";
			case AtmOutcome.NotEntitled:
				return "No purchase found";
			case AtmOutcome.Deferred:
				return "Gold pending - retrying";
			default:
				if (!string.IsNullOrEmpty(result.Message))
				{
					return result.Message;
				}
				return "Something went wrong";
			}
		}

		private static AtmTone ToneFor(AtmResult result)
		{
			switch (result.Outcome)
			{
			case AtmOutcome.Success:
			case AtmOutcome.Restored:
				return AtmTone.Good;
			case AtmOutcome.Deferred:
				return AtmTone.Pending;
			case AtmOutcome.Cancelled:
			case AtmOutcome.Busy:
			case AtmOutcome.Unavailable:
			case AtmOutcome.NotEntitled:
				return AtmTone.Info;
			default:
				return AtmTone.Bad;
			}
		}

		private IEnumerator InvokeAfter(float seconds, Action action)
		{
			yield return new WaitForSecondsRealtime(seconds);
			action();
		}
	}
}
