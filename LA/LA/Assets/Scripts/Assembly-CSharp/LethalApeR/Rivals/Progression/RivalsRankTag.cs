using LethalApeR.Networking;
using Photon.Pun;
using Photon.Realtime;
using TMPro;
using UnityEngine;

namespace LethalApeR.Rivals.Progression
{
	public class RivalsRankTag : MonoBehaviour
	{
		private MonkeDevNetworkingPlayer _player;

		private RivalsRankIcons _icons;

		private float _textScale;

		private float _lineGap;

		private float _iconSize;

		private GameObject _holder;

		private TextMeshPro _text;

		private SpriteRenderer _icon;

		private bool _subscribedLocal;

		private const float RefreshPeriod = 3f;

		private float _nextRefresh;

		public void Init(MonkeDevNetworkingPlayer player, RivalsRankIcons icons, float textScale, float lineGap, float iconSize)
		{
			_player = player;
			_icons = icons;
			_textScale = textScale;
			_lineGap = lineGap;
			_iconSize = iconSize;
		}

		private void Update()
		{
			if (_player == null)
			{
				Object.Destroy(this);
			}
			else if (_holder == null)
			{
				if (!(_player.NameText == null))
				{
					BuildVisuals(_player.NameText);
					Refresh();
				}
			}
			else if (Time.time >= _nextRefresh)
			{
				Refresh();
			}
		}

		private void BuildVisuals(TextMeshPro nameText)
		{
			float lineHeight = Mathf.Max(nameText.fontSize * 0.1f, 0.1f);
			_holder = new GameObject("RivalsRankTag");
			_holder.layer = nameText.gameObject.layer;
			_holder.transform.SetParent(nameText.transform, false);
			_holder.transform.localPosition = Vector3.zero;
			_holder.transform.localRotation = Quaternion.identity;
			_holder.transform.localScale = Vector3.one;
			GameObject textObject = new GameObject("LevelText");
			textObject.layer = _holder.layer;
			textObject.transform.SetParent(_holder.transform, false);
			textObject.transform.localPosition = new Vector3(0f, lineHeight * _lineGap, 0f);
			_text = textObject.AddComponent<TextMeshPro>();
			_text.font = nameText.font;
			if (nameText.fontSharedMaterial != null)
			{
				_text.fontSharedMaterial = nameText.fontSharedMaterial;
			}
			_text.fontSize = _textScale * nameText.fontSize;
			_text.alignment = TextAlignmentOptions.Center;
			_text.textWrappingMode = TextWrappingModes.NoWrap;
			_text.overflowMode = TextOverflowModes.Overflow;
			_text.text = "";
			GameObject iconObject = new GameObject("RankIcon");
			iconObject.layer = _holder.layer;
			iconObject.transform.SetParent(_holder.transform, false);
			iconObject.transform.localPosition = new Vector3(0f, lineHeight * _lineGap + lineHeight * (_textScale * 0.5f + _iconSize * 0.5f + 0.15f), 0f);
			_icon = iconObject.AddComponent<SpriteRenderer>();
		}

		public void Refresh()
		{
			_nextRefresh = Time.time + 3f;
			if (_holder == null || _player == null)
			{
				return;
			}
			PhotonView view = _player.photonView;
			bool hasLevel;
			int level;
			RivalsRank rank;
			if ((view == null || view.IsMine) && RivalsProgression.Instance != null)
			{
				level = RivalsProgression.Instance.Level;
				rank = RivalsRanked.Rank;
				SubscribeLocalChanges();
				hasLevel = true;
			}
			else
			{
				Player owner = ((view != null) ? view.Owner : null);
				hasLevel = RivalsProgression.TryGetLevel(owner, out level);
				int rp;
				rank = (RivalsRanked.TryGetRp(owner, out rp) ? RankDefs.RankForRp(rp) : RankDefs.RankForLevel(level));
			}
			if (!hasLevel || level <= 0)
			{
				_holder.SetActive(false);
				return;
			}
			_holder.SetActive(true);
			_text.text = string.Format("<color=#{0}>{1}</color> {2}", RankDefs.RankColorHex(rank), RankDefs.DisplayName(rank), level);
			Sprite sprite = ((_icons != null) ? _icons.GetIcon(rank) : null);
			if (sprite != null)
			{
				_icon.sprite = sprite;
				_icon.color = Color.white;
				float lineHeight = Mathf.Max(_player.NameText.fontSize * 0.1f, 0.1f);
				float spriteHeight = Mathf.Max(sprite.bounds.size.y, 0.0001f);
				_icon.transform.localScale = Vector3.one * (lineHeight * _iconSize / spriteHeight);
				_icon.enabled = true;
			}
			else
			{
				_icon.enabled = false;
			}
		}

		private void SubscribeLocalChanges()
		{
			if (!_subscribedLocal && !(RivalsProgression.Instance == null))
			{
				_subscribedLocal = true;
				RivalsProgression.Instance.OnLevelChanged += HandleLocalLevelChanged;
				RivalsRanked.OnRpChanged += HandleLocalRpChanged;
			}
		}

		private void HandleLocalLevelChanged(int level, RivalsRank rank)
		{
			Refresh();
		}

		private void HandleLocalRpChanged(int delta, int newRp)
		{
			Refresh();
		}

		private void OnDestroy()
		{
			if (_subscribedLocal)
			{
				if (RivalsProgression.Instance != null)
				{
					RivalsProgression.Instance.OnLevelChanged -= HandleLocalLevelChanged;
				}
				RivalsRanked.OnRpChanged -= HandleLocalRpChanged;
			}
			if (_holder != null)
			{
				Object.Destroy(_holder);
			}
		}
	}
}
