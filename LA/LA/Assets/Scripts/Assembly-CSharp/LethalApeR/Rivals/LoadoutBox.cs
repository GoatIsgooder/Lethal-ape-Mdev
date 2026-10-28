using System;
using System.Collections;
using System.Collections.Generic;
using LethalApeR.Rivals.Weapons;
using TMPro;
using UnityEngine;
using UnityEngine.Events;

namespace LethalApeR.Rivals
{
	public class LoadoutBox : MonoBehaviour
	{
		[Serializable]
		public class LoadoutPage
		{
			[Tooltip("Slot this page equips.")]
			public LoadoutSlot slot;

			[Tooltip("Root object holding this page's LoadoutSlotButtons + art.")]
			public GameObject root;
		}

		private class Fader
		{
			private readonly GameObject _root;

			private readonly Transform _tr;

			private readonly Vector3 _baseScale;

			private readonly bool _affectScale;

			private readonly TMP_Text[] _texts;

			private readonly float[] _textAlpha;

			private readonly CanvasGroup[] _groups;

			private readonly float[] _groupAlpha;

			private readonly SpriteRenderer[] _sprites;

			private readonly float[] _spriteAlpha;

			private readonly Collider[] _colliders;

			public Fader(GameObject root, bool affectScale)
			{
				_root = root;
				_tr = root.transform;
				_baseScale = _tr.localScale;
				_affectScale = affectScale;
				_texts = root.GetComponentsInChildren<TMP_Text>(true);
				_textAlpha = new float[_texts.Length];
				for (int i = 0; i < _texts.Length; i++)
				{
					_textAlpha[i] = _texts[i].alpha;
				}
				_groups = root.GetComponentsInChildren<CanvasGroup>(true);
				_groupAlpha = new float[_groups.Length];
				for (int j = 0; j < _groups.Length; j++)
				{
					_groupAlpha[j] = _groups[j].alpha;
				}
				_sprites = root.GetComponentsInChildren<SpriteRenderer>(true);
				_spriteAlpha = new float[_sprites.Length];
				for (int k = 0; k < _sprites.Length; k++)
				{
					_spriteAlpha[k] = _sprites[k].color.a;
				}
				_colliders = root.GetComponentsInChildren<Collider>(true);
			}

			public void SetVisible(float t, float scalePop)
			{
				if (_root == null)
				{
					return;
				}
				if (t <= 0.001f)
				{
					_root.SetActive(false);
					return;
				}
				if (!_root.activeSelf)
				{
					_root.SetActive(true);
				}
				for (int i = 0; i < _texts.Length; i++)
				{
					if (_texts[i] != null)
					{
						_texts[i].alpha = _textAlpha[i] * t;
					}
				}
				for (int j = 0; j < _groups.Length; j++)
				{
					if (_groups[j] != null)
					{
						_groups[j].alpha = _groupAlpha[j] * t;
					}
				}
				for (int k = 0; k < _sprites.Length; k++)
				{
					if (_sprites[k] != null)
					{
						Color color = _sprites[k].color;
						color.a = _spriteAlpha[k] * t;
						_sprites[k].color = color;
					}
				}
				if (_affectScale)
				{
					_tr.localScale = _baseScale * Mathf.Lerp(scalePop, 1f, t);
				}
				for (int l = 0; l < _colliders.Length; l++)
				{
					if (_colliders[l] != null)
					{
						_colliders[l].enabled = t >= 0.999f;
					}
				}
			}
		}

		[Header("Root")]
		[Tooltip("The visual + buttons toggled on/off. Defaults to the first child, else this object.")]
		public GameObject boxRoot;

		[Header("Title")]
		[Tooltip("The title object (a TMP text). Animated between the two points below.")]
		public Transform title;

		[Tooltip("Where the title appears first — position/rotation/scale are copied from this point, so scale it up for the big intro.")]
		public Transform titleCenterPoint;

		[Tooltip("Where the title settles (smaller header spot).")]
		public Transform titleHeaderPoint;

		[Tooltip("Seconds the title holds at the center before moving.")]
		public float titleHoldDuration = 0.8f;

		[Tooltip("Seconds the title takes to glide center → header.")]
		public float titleMoveDuration = 0.6f;

		[Header("Pages (in pick order)")]
		public List<LoadoutPage> pages = new List<LoadoutPage>();

		[Tooltip("Fade-in of the FIRST page after the title settles.")]
		public float startFadeDuration = 1f;

		[Tooltip("Total seconds for a page switch (fade out + fade in).")]
		public float pageFadeDuration = 0.5f;

		[Tooltip("Pages scale from this fraction up to 1 while fading in.")]
		[Range(0.5f, 1f)]
		public float fadeScalePop = 0.92f;

		[Header("Events")]
		[Tooltip("Fired each frame during prep with whole seconds remaining (wire to a TMP countdown).")]
		public UnityEvent<int> onSecondsLeft;

		[Tooltip("Fired when the box opens / closes.")]
		public UnityEvent onOpened;

		public UnityEvent onClosed;

		[Tooltip("Fired once every page has a pick (weapons are stocked into the orbs at this moment).")]
		public UnityEvent onAllChosen;

		private readonly List<Fader> _pageFaders = new List<Fader>();

		private Fader _titleFader;

		private Coroutine _sequence;

		private int _currentPage = -1;

		private bool _advanceRequested;

		private GameObject Root
		{
			get
			{
				if (boxRoot != null)
				{
					return boxRoot;
				}
				if (base.transform.childCount > 0)
				{
					return base.transform.GetChild(0).gameObject;
				}
				return base.gameObject;
			}
		}

		private void Awake()
		{
			EnsureOwnPhysicsBody();
			foreach (LoadoutPage page in pages)
			{
				_pageFaders.Add((page != null && page.root != null) ? new Fader(page.root, true) : null);
			}
			if (title != null)
			{
				_titleFader = new Fader(title.gameObject, false);
			}
			ResetHidden();
			GameObject root = Root;
			if (root != null)
			{
				root.SetActive(false);
			}
		}

		private void EnsureOwnPhysicsBody()
		{
			Rigidbody rigidbody = GetComponent<Rigidbody>();
			if (rigidbody == null)
			{
				rigidbody = base.gameObject.AddComponent<Rigidbody>();
			}
			rigidbody.isKinematic = true;
			rigidbody.useGravity = false;
			rigidbody.interpolation = RigidbodyInterpolation.None;
		}

		public void Show(Vector3 worldPos, Quaternion worldRot)
		{
			base.transform.SetPositionAndRotation(worldPos, worldRot);
			if (_sequence != null)
			{
				StopCoroutine(_sequence);
			}
			ResetHidden();
			GameObject root = Root;
			if (root != null)
			{
				root.SetActive(true);
			}
			onOpened?.Invoke();
			_sequence = StartCoroutine(RunSequence());
		}

		public void Hide()
		{
			if (_sequence != null)
			{
				StopCoroutine(_sequence);
				_sequence = null;
			}
			ResetHidden();
			GameObject root = Root;
			if (root != null)
			{
				root.SetActive(false);
			}
			onClosed?.Invoke();
		}

		public void Tick(float secondsRemaining)
		{
			onSecondsLeft?.Invoke(Mathf.Max(0, Mathf.CeilToInt(secondsRemaining)));
		}

		public void NotifyEquipped(LoadoutSlot slot)
		{
			if (_currentPage >= 0 && _currentPage < pages.Count && pages[_currentPage] != null && pages[_currentPage].slot == slot)
			{
				_advanceRequested = true;
			}
		}

		private IEnumerator RunSequence()
		{
			if (title != null && titleCenterPoint != null)
			{
				ApplyPoint(title, titleCenterPoint);
				title.gameObject.SetActive(true);
				yield return FadeTo(_titleFader, 0f, 1f, 0.25f);
				yield return new WaitForSeconds(titleHoldDuration);
				if (titleHeaderPoint != null)
				{
					yield return MoveTitle(titleCenterPoint, titleHeaderPoint, titleMoveDuration);
				}
			}
			for (int i = 0; i < pages.Count; i++)
			{
				if (_pageFaders[i] != null)
				{
					_advanceRequested = false;
					_currentPage = i;
					yield return FadeTo(_pageFaders[i], 0f, 1f, (i == 0) ? startFadeDuration : (pageFadeDuration * 0.5f));
					while (!_advanceRequested)
					{
						yield return null;
					}
					yield return FadeTo(_pageFaders[i], 1f, 0f, pageFadeDuration * 0.5f);
				}
			}
			_currentPage = -1;
			onAllChosen?.Invoke();
			if (RivalsWeaponOrbs.Instance != null)
			{
				RivalsWeaponOrbs.Instance.StockFromLoadout(GunUnlocker.Instance);
			}
			_sequence = null;
		}

		private IEnumerator MoveTitle(Transform from, Transform to, float duration)
		{
			duration = Mathf.Max(0.01f, duration);
			float t = 0f;
			while (t < 1f)
			{
				t += Time.deltaTime / duration;
				float e = Mathf.SmoothStep(0f, 1f, t);
				title.position = Vector3.Lerp(from.position, to.position, e);
				title.rotation = Quaternion.Slerp(from.rotation, to.rotation, e);
				title.localScale = Vector3.Lerp(from.localScale, to.localScale, e);
				yield return null;
			}
			ApplyPoint(title, to);
		}

		private static void ApplyPoint(Transform target, Transform point)
		{
			if (!(point == null))
			{
				target.SetPositionAndRotation(point.position, point.rotation);
				target.localScale = point.localScale;
			}
		}

		private IEnumerator FadeTo(Fader f, float from, float to, float duration)
		{
			if (f == null)
			{
				yield break;
			}
			duration = Mathf.Max(0.01f, duration);
			float t = 0f;
			while (t < 1f)
			{
				t += Time.deltaTime / duration;
				f.SetVisible(Mathf.Lerp(from, to, Mathf.SmoothStep(0f, 1f, t)), fadeScalePop);
				yield return null;
			}
			f.SetVisible(to, fadeScalePop);
		}

		private void ResetHidden()
		{
			_advanceRequested = false;
			_currentPage = -1;
			foreach (Fader pageFader in _pageFaders)
			{
				pageFader?.SetVisible(0f, fadeScalePop);
			}
			_titleFader?.SetVisible(0f, fadeScalePop);
			if (title != null)
			{
				title.gameObject.SetActive(false);
			}
		}
	}
}
