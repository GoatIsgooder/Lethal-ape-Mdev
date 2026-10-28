using System;
using LethalApeR.Social.UI;
using LethalApeR.UI.Notifications;
using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.KevinRift
{
	public sealed class KevinRiftTips : MonoBehaviour
	{
		private enum Tip
		{
			None = 0,
			Found = 1,
			Waves = 2
		}

		private const string FoundKey = "KevinRift.TipFound.v1";

		private const string WavesKey = "KevinRift.TipWaves.v1";

		[Header("Card (built by the Kevin Rift builder)")]
		public RectTransform card;

		public CanvasGroup group;

		public TMP_Text title;

		public TMP_Text body;

		public GameObject foundDiagram;

		public GameObject wavesDiagram;

		[Header("Placement")]
		[Tooltip("Card centre above the hand (m).")]
		public float height = 0.2f;

		[Tooltip("Card height, so hand notifications stack above it (m).")]
		public float cardHeight = 0.15f;

		public float positionSmoothTime = 0.16f;

		public float rotationLerpSpeed = 12f;

		[Header("Timing")]
		public float showFor = 10f;

		public float openTime = 0.18f;

		public float closeTime = 0.12f;

		[Tooltip("The Found tip closes early once you walk this far from the rift (m).")]
		public float walkAwayRadius = 15f;

		[Header("Feel")]
		public AudioClip openClip;

		public AudioClip closeClip;

		[NonSerialized]
		public KevinRiftDirector director;

		private Tip _showing;

		private float _shownAt;

		private float _closingAt = -1f;

		private Vector3 _velocity;

		private bool _placed;

		private Vector3 _scale = Vector3.one;

		private void Awake()
		{
			if (card != null)
			{
				_scale = card.localScale;
				card.gameObject.SetActive(false);
			}
		}

		private void OnDisable()
		{
			HandNotifications.SetReservedHeight(0f);
			if (card != null)
			{
				card.gameObject.SetActive(false);
			}
			_showing = Tip.None;
		}

		public void OfferFound()
		{
			if (_showing == Tip.None && !Seen(FoundKey))
			{
				Show(Tip.Found);
			}
		}

		public void OfferWaves()
		{
			if (_showing != Tip.Waves && !Seen(WavesKey))
			{
				Show(Tip.Waves);
			}
		}

		private static bool Seen(string key)
		{
			return PlayerPrefs.GetInt(key, 0) == 1;
		}

		private void Show(Tip tip)
		{
			if (card == null)
			{
				return;
			}
			PlayerPrefs.SetInt((tip == Tip.Found) ? FoundKey : WavesKey, 1);
			PlayerPrefs.Save();
			_showing = tip;
			_shownAt = Time.unscaledTime;
			_closingAt = -1f;
			if (tip == Tip.Found)
			{
				title.text = "KEVIN RIFT";
				body.text = "3 apes stand on the pads.\nOne touches the crystal.\nZombies rise.";
			}
			else
			{
				title.text = "THEY'RE COMING";
				body.text = "Launcher or fists kill them.\nCaught? Back to the lobby.\nRun too far: the rift closes.";
			}
			if (foundDiagram != null)
			{
				foundDiagram.SetActive(tip == Tip.Found);
			}
			if (wavesDiagram != null)
			{
				wavesDiagram.SetActive(tip == Tip.Waves);
			}
			card.gameObject.SetActive(true);
			card.localScale = Vector3.zero;
			if (group != null)
			{
				group.alpha = 0f;
			}
			_placed = false;
			HandNotifications.SetReservedHeight(cardHeight + 0.02f);
			SocialStyle.Play(openClip, 0.6f);
			SocialStyle.Pulse(true, 0.45f, 0.15f);
		}

		private void Close()
		{
			if (!(_closingAt >= 0f))
			{
				_closingAt = Time.unscaledTime;
				SocialStyle.Play(closeClip, 0.5f);
			}
		}

		private void LateUpdate()
		{
			if (_showing == Tip.None || card == null)
			{
				return;
			}
			float unscaledTime = Time.unscaledTime;
			if (_closingAt < 0f)
			{
				bool flag = _showing == Tip.Found && director != null && director.Anchor != null && RiftPlayers.TryGetLocal(out var avatar) && (avatar.head - director.Anchor.transform.position).sqrMagnitude > walkAwayRadius * walkAwayRadius;
				if (unscaledTime - _shownAt > showFor || flag)
				{
					Close();
				}
			}
			float num;
			if (_closingAt < 0f)
			{
				float num2 = unscaledTime - _shownAt;
				float num3 = Mathf.Clamp01(num2 / Mathf.Max(openTime, 0.01f));
				float t = Mathf.Clamp01((num2 - openTime) / 0.1f);
				num = ((!(num3 < 1f)) ? Mathf.Lerp(1.015f, 1f, t) : Mathf.SmoothStep(0f, 1.015f, num3));
				if (group != null)
				{
					group.alpha = Mathf.Clamp01(num3 * 1.4f);
				}
			}
			else
			{
				float num4 = Mathf.Clamp01((unscaledTime - _closingAt) / Mathf.Max(closeTime, 0.01f));
				if (group != null)
				{
					group.alpha = 1f - num4;
				}
				if (num4 >= 1f)
				{
					card.gameObject.SetActive(false);
					_showing = Tip.None;
					HandNotifications.SetReservedHeight(0f);
					return;
				}
				num = 1f - num4 * num4;
			}
			card.localScale = _scale * num;
			Transform transform = Hand();
			Transform transform2 = Head();
			if (transform == null || transform2 == null)
			{
				return;
			}
			Vector3 target = transform.position + Vector3.up * height;
			if (!_placed)
			{
				_placed = true;
				card.position = transform.position;
				_velocity = Vector3.zero;
			}
			card.position = Vector3.SmoothDamp(card.position, target, ref _velocity, positionSmoothTime, float.PositiveInfinity, Time.unscaledDeltaTime);
			Vector3 forward = card.position - transform2.position;
			if (forward.sqrMagnitude > 1E-06f)
			{
				Quaternion b = Quaternion.LookRotation(forward, Vector3.up);
				card.rotation = Quaternion.Slerp(card.rotation, b, 1f - Mathf.Exp((0f - rotationLerpSpeed) * Time.unscaledDeltaTime));
			}
		}

		private static Transform Hand()
		{
			if (!GorillaLocomotion.Player.HasInstance)
			{
				return null;
			}
			GorillaLocomotion.Player instance = GorillaLocomotion.Player.Instance;
			if (!(instance.leftHandFollower != null))
			{
				return instance.leftHandTransform;
			}
			return instance.leftHandFollower;
		}

		private static Transform Head()
		{
			if (GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance.mainCamera != null)
			{
				return GorillaLocomotion.Player.Instance.mainCamera.transform;
			}
			Camera main = Camera.main;
			if (!(main != null))
			{
				return null;
			}
			return main.transform;
		}

		[ContextMenu("Dev / Reset tips")]
		private void DevReset()
		{
			PlayerPrefs.DeleteKey(FoundKey);
			PlayerPrefs.DeleteKey(WavesKey);
			PlayerPrefs.Save();
		}

		[ContextMenu("Dev / Show Found tip")]
		private void DevFound()
		{
			Show(Tip.Found);
		}

		[ContextMenu("Dev / Show Waves tip")]
		private void DevWaves()
		{
			Show(Tip.Waves);
		}
	}
}
