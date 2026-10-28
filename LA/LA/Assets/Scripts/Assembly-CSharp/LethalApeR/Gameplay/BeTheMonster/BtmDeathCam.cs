using System;
using System.Collections;
using GorillaLocomotion;
using LethalApeR.SceneFlow;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmDeathCam : MonoBehaviour
	{
		private const float BlinkOut = 0.15f;

		private const float BlinkIn = 0.3f;

		private const float Watch = 2.4f;

		private const float CardDelay = 0.35f;

		private const float BackOff = 2.6f;

		private const float Rise = 1.9f;

		private const float HeadRoom = 0.25f;

		private const float ThrownSpeed = 1.5f;

		private static BtmDeathCam _instance;

		private SlopColorGrade _grade;

		private float _baseSaturation;

		private float _baseKeepRed;

		private Player _rig;

		private bool _rigHeld;

		private bool _moving;

		private bool _ownsFade;

		private float _finishBy;

		private Coroutine _run;

		private GameObject _card;

		private CanvasGroup _cardGroup;

		private const string CardText = "<color=#DC143C><b>YOU DIED</b>\n<size=50%>{0}</color>";

		private static readonly Vector3 DefaultCardOffset = new Vector3(0f, 0.2f, 0.6f);

		private TMP_Text _cardText;

		public bool Watching { get; private set; }

		public static BtmDeathCam Begin(Vector3 diedAt, Vector3 thrown, Vector3 killerAt, string killerName)
		{
			if (!Player.HasInstance)
			{
				return null;
			}
			if (!Player.Instance.headCollider)
			{
				return null;
			}
			if (!_instance)
			{
				_instance = new GameObject("BTM Death Cam").AddComponent<BtmDeathCam>();
			}
			_instance.Play(diedAt, thrown, killerAt, killerName);
			return _instance;
		}

		public void Finish()
		{
			if (_run != null)
			{
				StopCoroutine(_run);
			}
			_run = StartCoroutine(FadeIn());
		}

		private void Play(Vector3 diedAt, Vector3 thrown, Vector3 killerAt, string killerName)
		{
			Restore();
			if (_run != null)
			{
				StopCoroutine(_run);
			}
			Watching = true;
			_ownsFade = true;
			_finishBy = float.PositiveInfinity;
			Player.Teleported -= OnTeleported;
			Player.Teleported += OnTeleported;
			_run = StartCoroutine(Run(diedAt, thrown, killerAt, killerName));
		}

		private IEnumerator Run(Vector3 diedAt, Vector3 thrown, Vector3 killerAt, string killerName)
		{
			SceneFadeOverlay fade = SceneFadeOverlay.Ensure();
			yield return Blink(fade, fade.Alpha, 1f, BlinkOut);
			_rig = Player.Instance;
			if (!_rig)
			{
				End();
				yield break;
			}
			int world = _rig.locomotionEnabledLayers.value;
			if (world == 0)
			{
				world = 1;
			}
			Vantage(diedAt, thrown, killerAt, world, out var eye, out var look);
			Place(eye, look);
			HoldRig();
			Drain();
			yield return null;
			yield return Blink(fade, 1f, 0f, BlinkIn);
			float cardAt = Time.unscaledTime + CardDelay;
			while (Time.unscaledTime < cardAt)
			{
				yield return null;
			}
			ShowCard(killerName);
			float until = Time.unscaledTime + Watch - CardDelay;
			while (Time.unscaledTime < until)
			{
				yield return null;
			}
			yield return Blink(fade, 0f, 1f, 0.24f);
			HideCard();
			ReleaseRig();
			Watching = false;
			_finishBy = Time.unscaledTime + 3f;
			_run = null;
		}

		private IEnumerator FadeIn()
		{
			Watching = false;
			Restore();
			if (_ownsFade)
			{
				SceneFadeOverlay fade = SceneFadeOverlay.Ensure();
				yield return Blink(fade, fade.Alpha, 0f, BlinkIn);
			}
			_run = null;
			_ownsFade = false;
		}

		private void Update()
		{
			if (!Watching && _run == null && Time.unscaledTime >= _finishBy)
			{
				_finishBy = float.PositiveInfinity;
				Finish();
			}
		}

		private static IEnumerator Blink(SceneFadeOverlay fade, float from, float to, float seconds)
		{
			float t = 0f;
			while (t < seconds)
			{
				fade.Alpha = Mathf.Lerp(from, to, t / seconds);
				yield return null;
				t += Time.unscaledDeltaTime;
			}
			fade.Alpha = to;
		}

		private static void Vantage(Vector3 diedAt, Vector3 thrown, Vector3 killerAt, LayerMask world, out Vector3 eye, out Vector3 look)
		{
			Vector3 flat = Vector3.ProjectOnPlane(thrown, Vector3.up);
			Vector3 away = flat.sqrMagnitude > ThrownSpeed * ThrownSpeed ? flat.normalized : Vector3.ProjectOnPlane(diedAt - killerAt, Vector3.up);
			if (away.sqrMagnitude < 0.0001f)
			{
				away = Vector3.forward;
			}
			away = away.normalized;
			look = diedAt + away * Mathf.Clamp(flat.magnitude * 0.35f, 0f, 3f);
			if (Physics.Raycast(look + Vector3.up * 0.5f, Vector3.down, out var hit, 4f, world, QueryTriggerInteraction.Ignore))
			{
				look = hit.point + Vector3.up * 0.3f;
			}
			else
			{
				look -= Vector3.up * 1.2f;
			}
			eye = look - away * BackOff + Vector3.up * Rise;
			Vector3 to = eye - look;
			float dist = to.magnitude;
			to /= dist;
			if (Physics.SphereCast(look, HeadRoom, to, out var block, dist, world, QueryTriggerInteraction.Ignore))
			{
				eye = look + to * Mathf.Max(block.distance - 0.1f, 0.6f);
			}
		}

		private void Place(Vector3 eye, Vector3 look)
		{
			Transform head = _rig.headCollider.transform;
			Vector3 fwd = Vector3.ProjectOnPlane(head.forward, Vector3.up);
			Vector3 want = Vector3.ProjectOnPlane(look - eye, Vector3.up);
			Quaternion turn = (fwd.sqrMagnitude > 0.0001f && want.sqrMagnitude > 0.0001f) ? Quaternion.AngleAxis(Vector3.SignedAngle(fwd, want, Vector3.up), Vector3.up) : Quaternion.identity;
			Transform root = _rig.transform;
			Player rig = _rig;
			_moving = true;
			Vector3 offset = turn * (head.position - root.position);
			rig.TeleportPlayerRaw(eye - offset, turn * root.rotation, true, true);
			_moving = false;
		}

		private void HoldRig()
		{
			if (!_rigHeld && _rig)
			{
				RigHold.Take(this, RigHold.What.All);
				_rigHeld = true;
			}
		}

		private void ReleaseRig()
		{
			Player.Teleported -= OnTeleported;
			if (_rigHeld)
			{
				_rigHeld = false;
				RigHold.Give(this, RigHold.What.All);
			}
		}

		private void FixedUpdate()
		{
			if (_rigHeld && _rig)
			{
				Rigidbody body = _rig.playerRigidBody;
				if (body && !body.isKinematic)
				{
					body.linearVelocity = Vector3.zero;
				}
			}
		}

		private void OnTeleported(Player rig)
		{
			if (!_moving && Watching)
			{
				End();
			}
		}

		private void End()
		{
			if (_run != null)
			{
				StopCoroutine(_run);
			}
			_run = null;
			Watching = false;
			Restore();
			HideCard();
			if (_ownsFade)
			{
				SceneFadeOverlay current = SceneFadeOverlay.Current;
				if (current)
				{
					current.Alpha = 0f;
				}
			}
			_ownsFade = false;
		}

		private void Drain()
		{
			Camera cam = (_rig && _rig.mainCamera) ? _rig.mainCamera : Camera.main;
			_grade = cam ? cam.GetComponent<SlopColorGrade>() : null;
			if (_grade)
			{
				_baseSaturation = _grade.saturation;
				_baseKeepRed = _grade.keepRed;
				_grade.saturation = -100f;
				_grade.keepRed = 1f;
			}
		}

		private void Restore()
		{
			ReleaseRig();
			if (_grade)
			{
				_grade.saturation = _baseSaturation;
				_grade.keepRed = _baseKeepRed;
				_grade = null;
			}
		}

		private void OnDisable()
		{
			End();
		}

		private void OnDestroy()
		{
			End();
			if (_card)
			{
				UnityEngine.Object.Destroy(_card);
			}
			if (_instance == this)
			{
				_instance = null;
			}
		}

		private void ShowCard(string killerName)
		{
			if (!_card)
			{
				BuildCard();
			}
			if (!_card || !_rig)
			{
				return;
			}
			Transform head = _rig.headCollider.transform;
			Vector3 flat = Vector3.ProjectOnPlane(head.forward, Vector3.up);
			if (flat.sqrMagnitude < 0.0001f)
			{
				flat = Vector3.forward;
			}
			Quaternion rot = Quaternion.LookRotation(flat.normalized, Vector3.up);
			BtmSelectedRole role = BtmSelectedRole.Instance;
			Vector3 offset = role ? role.FollowOffset : DefaultCardOffset;
			_card.transform.SetPositionAndRotation(head.position + rot * offset, rot);
			string line = string.IsNullOrWhiteSpace(killerName) ? "Killed by the monster" : ("Killed by <noparse>" + killerName.Trim() + "</noparse>");
			if (_cardText)
			{
				_cardText.text = string.Format(CardText, line);
			}
			_card.SetActive(true);
			_card.transform.localScale = Vector3.zero;
			_cardGroup.alpha = 0f;
			StartCoroutine(PopCard());
		}

		private IEnumerator PopCard()
		{
			StartCoroutine(BtmTween.FadeCanvas(_cardGroup, 0f, 1f, 0.25f, BtmTween.OutQuad));
			yield return StartCoroutine(BtmTween.ScaleTo(_card.transform, 0f, 1f, 0.35f, BtmTween.OutBack));
			yield return StartCoroutine(BtmTween.PunchScale(_card.transform, 0.12f, 0.4f, 5, 0.5f));
		}

		private void HideCard()
		{
			if (_card)
			{
				_card.SetActive(false);
			}
		}

		private void BuildCard()
		{
			_card = new GameObject("YOU DIED Card");
			_card.transform.SetParent(transform, false);
			_cardGroup = _card.AddComponent<CanvasGroup>();
			_cardGroup.interactable = false;
			_cardGroup.blocksRaycasts = false;
			BtmSelectedRole role = BtmSelectedRole.Instance;
			Canvas source = (role && role.displayText) ? role.displayText.canvas : null;
			if (source)
			{
				GameObject copy = UnityEngine.Object.Instantiate(source.gameObject, _card.transform, false);
				copy.name = "Canvas";
				GraphicRaycaster[] raycasters = copy.GetComponents<GraphicRaycaster>();
				foreach (GraphicRaycaster raycaster in raycasters)
				{
					UnityEngine.Object.Destroy(raycaster);
				}
				_cardText = copy.GetComponentInChildren<TMP_Text>(true);
			}
			else
			{
				BuildPlainCard();
			}
			Graphic[] graphics = _card.GetComponentsInChildren<Graphic>(true);
			foreach (Graphic graphic in graphics)
			{
				graphic.raycastTarget = false;
			}
			_card.SetActive(false);
		}

		private void BuildPlainCard()
		{
			GameObject canvasGo = new GameObject("Canvas", typeof(RectTransform));
			canvasGo.transform.SetParent(_card.transform, false);
			canvasGo.AddComponent<Canvas>().renderMode = RenderMode.WorldSpace;
			RectTransform rect = (RectTransform)canvasGo.transform;
			rect.sizeDelta = new Vector2(600f, 280f);
			rect.localScale = Vector3.one * 0.001f;
			Stretch("Background", canvasGo.transform).AddComponent<Image>().color = new Color(0f, 0f, 0f, 0.9f);
			TextMeshProUGUI text = Stretch("DisplayText", canvasGo.transform).AddComponent<TextMeshProUGUI>();
			if (TMP_Settings.defaultFontAsset)
			{
				text.font = TMP_Settings.defaultFontAsset;
			}
			text.fontSize = 44f;
			text.alignment = TextAlignmentOptions.Center;
			text.color = Color.white;
			_cardText = text;
		}

		private static GameObject Stretch(string name, Transform parent)
		{
			GameObject go = new GameObject(name, typeof(RectTransform));
			go.transform.SetParent(parent, false);
			RectTransform rect = (RectTransform)go.transform;
			rect.anchorMin = Vector2.zero;
			rect.anchorMax = Vector2.one;
			rect.offsetMin = Vector2.zero;
			rect.offsetMax = Vector2.zero;
			return go;
		}
	}
}
