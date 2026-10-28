using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Frontend
{
	public sealed class GalleryCard : MonoBehaviour
	{
		[SerializeField]
		private MenuContent content;

		[SerializeField]
		private MenuSurface surface;

		[Tooltip("The shots only advance once this card has finished its intro.")]
		[SerializeField]
		private MenuCard card;

		[SerializeField]
		private RawImage back;

		[SerializeField]
		private RawImage front;

		[SerializeField]
		private TMP_Text title;

		[SerializeField]
		private TMP_Text caption;

		[SerializeField]
		private CanvasGroup captionGroup;

		[SerializeField]
		private MenuButton previous;

		[SerializeField]
		private MenuButton next;

		[Header("Indicators")]
		[SerializeField]
		private RectTransform indicatorRoot;

		[SerializeField]
		private RectTransform segmentTemplate;

		[SerializeField]
		private float segmentGap = 10f;

		[Header("Timing")]
		[SerializeField]
		private float interval = 6.5f;

		[SerializeField]
		private float crossfade = 1.1f;

		[Tooltip("Push-in over one shot, as a fraction of the image (0.04 = 4%).")]
		[SerializeField]
		private float zoom = 0.04f;

		private readonly List<RectTransform> _fills = new List<RectTransform>();

		private IReadOnlyList<MenuContent.Shot> _shots;

		private int _index;

		private float _elapsed;

		private float _fade = 1f;

		private bool _captionPending;

		private void Start()
		{
			_shots = ((content != null) ? content.Gallery : null);
			int num = ((_shots != null) ? _shots.Count : 0);
			previous.Clicked += delegate
			{
				Step(-1);
			};
			next.Clicked += delegate
			{
				Step(1);
			};
			next.Interactable = num > 1;
			previous.Interactable = num > 1;
			BuildIndicators(num);
			if (num != 0)
			{
				ShowInstant(0);
				return;
			}
			front.enabled = false;
			back.enabled = false;
			title.SetText(string.Empty);
			caption.SetText(string.Empty);
		}

		private void BuildIndicators(int count)
		{
			segmentTemplate.gameObject.SetActive(value: false);
			if (count >= 2)
			{
				float num = (indicatorRoot.rect.width - segmentGap * (float)(count - 1)) / (float)count;
				for (int i = 0; i < count; i++)
				{
					RectTransform rectTransform = Object.Instantiate(segmentTemplate, indicatorRoot);
					rectTransform.gameObject.SetActive(value: true);
					rectTransform.anchoredPosition = new Vector2((num + segmentGap) * (float)i, 0f);
					rectTransform.sizeDelta = new Vector2(num, rectTransform.sizeDelta.y);
					_fills.Add((RectTransform)rectTransform.GetChild(0));
				}
			}
		}

		private void ShowInstant(int index)
		{
			_index = index;
			_elapsed = 0f;
			_fade = 1f;
			MenuContent.Shot shot = _shots[index];
			back.texture = shot.image;
			back.color = Color.white;
			front.color = new Color(1f, 1f, 1f, 0f);
			MenuImage.Fill(back, shot.image, 0f);
			SetCaption(shot);
			RefreshIndicators();
		}

		private void Step(int direction)
		{
			if (_shots != null && _shots.Count >= 2)
			{
				Go((_index + direction + _shots.Count) % _shots.Count);
			}
		}

		private void Go(int index)
		{
			if (_fade < 1f)
			{
				FinishFade();
			}
			_elapsed = 0f;
			_fade = 0f;
			_index = index;
			MenuContent.Shot shot = _shots[index];
			front.texture = shot.image;
			front.color = new Color(1f, 1f, 1f, 0f);
			MenuImage.Fill(front, shot.image, 0f);
			_captionPending = true;
			RefreshIndicators();
		}

		private void FinishFade()
		{
			_fade = 1f;
			if (_captionPending)
			{
				SetCaption(_shots[_index]);
				_captionPending = false;
			}
			SetCaptionAlpha(1f);
			back.texture = front.texture;
			back.uvRect = front.uvRect;
			back.color = Color.white;
			front.color = new Color(1f, 1f, 1f, 0f);
		}

		private void Update()
		{
			if (_shots == null || _shots.Count == 0 || (card != null && !card.Shown))
			{
				return;
			}
			float unscaledDeltaTime = Time.unscaledDeltaTime;
			if (!surface.Hovered)
			{
				_elapsed += unscaledDeltaTime;
			}
			RawImage rawImage = ((_fade < 1f) ? front : back);
			MenuImage.Fill(rawImage, rawImage.texture, zoom * Mathf.Clamp01(_elapsed / (interval + crossfade)));
			if (_fade < 1f)
			{
				_fade = Mathf.MoveTowards(_fade, 1f, unscaledDeltaTime / Mathf.Max(crossfade, 0.01f));
				front.color = new Color(1f, 1f, 1f, Mathf.SmoothStep(0f, 1f, _fade));
				if (_captionPending && _fade >= 0.5f)
				{
					SetCaption(_shots[_index]);
					_captionPending = false;
				}
				SetCaptionAlpha(Mathf.SmoothStep(0f, 1f, Mathf.Abs(1f - _fade * 2f)));
				if (_fade >= 1f)
				{
					FinishFade();
				}
			}
			if (_index < _fills.Count)
			{
				RectTransform rectTransform = _fills[_index];
				float num = Mathf.Clamp01(_elapsed / interval);
				if (!Mathf.Approximately(rectTransform.anchorMax.x, num))
				{
					rectTransform.anchorMax = new Vector2(num, rectTransform.anchorMax.y);
				}
			}
			if (_elapsed >= interval && _shots.Count >= 2)
			{
				Step(1);
			}
		}

		private void SetCaptionAlpha(float alpha)
		{
			if (captionGroup != null && !Mathf.Approximately(captionGroup.alpha, alpha))
			{
				captionGroup.alpha = alpha;
			}
		}

		private void SetCaption(MenuContent.Shot shot)
		{
			title.SetText(string.IsNullOrEmpty(shot.title) ? string.Empty : shot.title.ToUpperInvariant());
			caption.SetText(shot.caption ?? string.Empty);
		}

		private void RefreshIndicators()
		{
			for (int i = 0; i < _fills.Count; i++)
			{
				_fills[i].anchorMax = new Vector2((i < _index) ? 1f : 0f, _fills[i].anchorMax.y);
			}
		}
	}
}
