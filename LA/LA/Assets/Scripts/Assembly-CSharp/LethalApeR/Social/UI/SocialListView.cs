using System;
using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Social.UI
{
	public sealed class SocialListView : MonoBehaviour
	{
		[SerializeField]
		private RectTransform viewport;

		[Tooltip("One template per kind (index = adapter.KindOf). Disabled in the prefab; pooled at runtime.")]
		[SerializeField]
		private SocialListItem[] templates;

		[SerializeField]
		private float[] heights;

		[SerializeField]
		private float gap = 8f;

		[Header("Feel")]
		[SerializeField]
		private float friction = 5f;

		[SerializeField]
		private float settleTime = 0.12f;

		[SerializeField]
		private float stopSpeed = 40f;

		[SerializeField]
		private float maxSpeed = 4000f;

		[Tooltip("How far past either end the list can be pulled or flung before the spring brings it back.")]
		[SerializeField]
		private float stretchUnits = 80f;

		private const float SpringStiffness = 200f;

		private const float SpringDamping = 28.3f;

		private const float MaxStep = 0.05f;

		private const float StepTime = 0.14f;

		private ISocialListAdapter _adapter;

		private readonly List<float> _tops = new List<float>(128);

		private readonly List<int> _kinds = new List<int>(128);

		private float _total;

		private float _offset;

		private float _velocity;

		private float _settleVelocity;

		private bool _held;

		private float _heldVelocity;

		private float _raw;

		private float _wheel;

		private float _wheelVelocity;

		private float _stepTarget = -1f;

		private int _firstVisible = -1;

		private List<SocialListItem>[] _pools;

		private readonly Dictionary<int, SocialListItem> _shown = new Dictionary<int, SocialListItem>(16);

		private readonly List<int> _release = new List<int>(16);

		private bool _wasMoving;

		public RectTransform Viewport => viewport;

		public float Offset => _offset;

		public float ViewHeight => viewport.rect.height;

		public float ContentHeight => _total;

		public float MaxOffset => Mathf.Max(0f, _total - ViewHeight);

		public float Normalized
		{
			get
			{
				if (!(MaxOffset > 0f))
				{
					return 0f;
				}
				return Mathf.Clamp01(_offset / MaxOffset);
			}
		}

		public float VisibleFraction
		{
			get
			{
				if (!(_total > 0f))
				{
					return 1f;
				}
				return Mathf.Clamp01(ViewHeight / _total);
			}
		}

		public bool Moving
		{
			get
			{
				if (!_held && _velocity == 0f)
				{
					return Mathf.Abs(_settleVelocity) > 0.5f;
				}
				return true;
			}
		}

		public float WheelTurn => _wheel;

		public bool AtStart
		{
			get
			{
				if (_offset <= 0.5f)
				{
					if (!(_stepTarget < 0f))
					{
						return _stepTarget <= 0.5f;
					}
					return true;
				}
				return false;
			}
		}

		public bool AtEnd
		{
			get
			{
				if (_offset >= MaxOffset - 0.5f)
				{
					if (!(_stepTarget < 0f))
					{
						return _stepTarget >= MaxOffset - 0.5f;
					}
					return true;
				}
				return false;
			}
		}

		public event Action Stepped;

		public event Action ViewsCreated;

		private void Awake()
		{
			EnsurePools();
		}

		private void EnsurePools()
		{
			if (_pools != null)
			{
				return;
			}
			_pools = new List<SocialListItem>[templates.Length];
			for (int i = 0; i < templates.Length; i++)
			{
				_pools[i] = new List<SocialListItem>(12);
				if (templates[i] != null)
				{
					templates[i].gameObject.SetActive(false);
				}
			}
		}

		public void SetAdapter(ISocialListAdapter adapter)
		{
			EnsurePools();
			_adapter = adapter;
			Refresh();
		}

		public void Refresh()
		{
			Measure();
			_offset = Mathf.Clamp(_offset, 0f, MaxOffset);
			ReleaseAll();
			Layout(true);
		}

		public void Rebind()
		{
			if (_adapter == null)
			{
				return;
			}
			foreach (KeyValuePair<int, SocialListItem> item in _shown)
			{
				_adapter.Bind(item.Value, item.Key);
			}
		}

		public void ScrollToTop()
		{
			_offset = 0f;
			_velocity = 0f;
			Layout(false);
		}

		public void StepItems(int items)
		{
			if (_tops.Count == 0 || items == 0)
			{
				return;
			}
			float maxOffset = MaxOffset;
			float num = ((_stepTarget < 0f) ? _offset : _stepTarget);
			int num2 = 0;
			for (int i = 0; i < _tops.Count && !(_tops[i] > num + 1f); i++)
			{
				num2 = i;
			}
			int index = Mathf.Clamp(num2 + items, 0, _tops.Count - 1);
			float num3 = Mathf.Clamp(_tops[index], 0f, maxOffset);
			if (!(Mathf.Abs(num3 - num) < 0.5f))
			{
				_stepTarget = num3;
				_velocity = 0f;
				_wheelVelocity = 0f;
			}
		}

		public void BeginHold()
		{
			_held = true;
			_heldVelocity = 0f;
			_velocity = 0f;
			_settleVelocity = 0f;
			_wheelVelocity = 0f;
			_stepTarget = -1f;
			_raw = Unstretch(_offset);
		}

		public void Drag(float delta, float dt)
		{
			if (dt > 0f)
			{
				_heldVelocity = Mathf.Lerp(_heldVelocity, delta / dt, 0.5f);
			}
			if (delta != 0f)
			{
				_wheel += delta;
				_raw = (_held ? _raw : Unstretch(_offset)) + delta;
				_offset = Stretch(_raw);
				Layout(false);
			}
		}

		public void EndHold()
		{
			if (_held)
			{
				_held = false;
				_velocity = Mathf.Clamp(_heldVelocity, 0f - maxSpeed, maxSpeed);
				_wheelVelocity = _velocity;
			}
		}

		public void Glide(float unitsPerSecond)
		{
			if (!_held)
			{
				_stepTarget = -1f;
				_wheelVelocity = unitsPerSecond;
				float maxOffset = MaxOffset;
				if ((unitsPerSecond > 0f && _offset >= maxOffset) || (unitsPerSecond < 0f && _offset <= 0f))
				{
					unitsPerSecond *= 0.15f;
				}
				_velocity = Mathf.Clamp(unitsPerSecond, 0f - maxSpeed, maxSpeed);
			}
		}

		private float Stretch(float raw)
		{
			float maxOffset = MaxOffset;
			if (raw > maxOffset)
			{
				return maxOffset + stretchUnits * (1f - Mathf.Exp((0f - (raw - maxOffset)) / stretchUnits));
			}
			if (raw < 0f)
			{
				return (0f - stretchUnits) * (1f - Mathf.Exp(raw / stretchUnits));
			}
			return raw;
		}

		private float Unstretch(float offset)
		{
			float maxOffset = MaxOffset;
			if (offset > maxOffset)
			{
				return maxOffset - stretchUnits * Mathf.Log(1f - Mathf.Min((offset - maxOffset) / stretchUnits, 0.99f));
			}
			if (offset < 0f)
			{
				return stretchUnits * Mathf.Log(1f - Mathf.Min((0f - offset) / stretchUnits, 0.99f));
			}
			return offset;
		}

		private void Update()
		{
			if (_adapter == null)
			{
				return;
			}
			float num = Mathf.Min(Time.unscaledDeltaTime, MaxStep);
			if (!(num <= 0f))
			{
				float offset = _offset;
				if (!_held)
				{
					Coast(num);
				}
				bool moving = Moving;
				if (!Mathf.Approximately(offset, _offset) || moving != _wasMoving)
				{
					_wasMoving = moving;
					Layout(false);
				}
			}
		}

		private void Coast(float dt)
		{
			float offset = _offset;
			bool flag = Mathf.Abs(_wheelVelocity) > stopSpeed;
			if (flag)
			{
				float num = Mathf.Exp((0f - friction) * dt);
				_wheel += _wheelVelocity * (1f - num) / friction;
				_wheelVelocity *= num;
			}
			else
			{
				_wheelVelocity = 0f;
			}
			float maxOffset = MaxOffset;
			float num2 = _offset;
			if (num2 >= 0f && num2 <= maxOffset)
			{
				if (Mathf.Abs(_velocity) > stopSpeed)
				{
					float num3 = Mathf.Exp((0f - friction) * dt);
					float velocity = _velocity;
					_velocity = velocity * num3;
					num2 += velocity * (1f - num3) / friction;
					if (num2 > maxOffset)
					{
						num2 = maxOffset + 0.01f;
					}
					else if (num2 < 0f)
					{
						num2 = -0.01f;
					}
					_offset = num2;
				}
				else
				{
					_velocity = 0f;
					float num4 = SnapTarget();
					if (Mathf.Abs(_offset - num4) <= 0.05f)
					{
						_offset = num4;
						_settleVelocity = 0f;
						_stepTarget = -1f;
					}
					else
					{
						_offset = Mathf.SmoothDamp(_offset, num4, ref _settleVelocity, (_stepTarget >= 0f) ? StepTime : settleTime, float.PositiveInfinity, dt);
					}
				}
			}
			else
			{
				while (dt > 0f)
				{
					float num5 = Mathf.Min(dt, 1f / 120f);
					float num6 = ((_offset < 0f) ? _offset : ((_offset > maxOffset) ? (_offset - maxOffset) : 0f));
					_velocity += num5 * ((0f - SpringStiffness) * num6 + (0f - SpringDamping) * _velocity);
					dt -= num5;
					_offset += num5 * _velocity;
				}
				if (_offset > maxOffset + stretchUnits)
				{
					_offset = maxOffset + stretchUnits;
					_velocity = Mathf.Min(_velocity, 0f);
				}
				else if (_offset < 0f - stretchUnits)
				{
					_offset = 0f - stretchUnits;
					_velocity = Mathf.Max(_velocity, 0f);
				}
				float num7 = ((_offset < 0f) ? (0f - _offset) : ((_offset > maxOffset) ? (_offset - maxOffset) : 0f));
				if (num7 < 0.3f && Mathf.Abs(_velocity) < 8f)
				{
					_offset = Mathf.Clamp(_offset, 0f, maxOffset);
					_velocity = 0f;
					_settleVelocity = 0f;
				}
			}
			if (!flag)
			{
				_wheel += _offset - offset;
			}
		}

		private float SnapTarget()
		{
			float maxOffset = MaxOffset;
			if (_stepTarget >= 0f)
			{
				return Mathf.Min(_stepTarget, maxOffset);
			}
			if (_offset <= 0f || _tops.Count == 0)
			{
				return 0f;
			}
			if (_offset >= maxOffset)
			{
				return maxOffset;
			}
			float result = 0f;
			float num = float.MaxValue;
			for (int i = 0; i < _tops.Count; i++)
			{
				float num2 = Mathf.Min(_tops[i], maxOffset);
				float num3 = Mathf.Abs(num2 - _offset);
				if (num3 < num)
				{
					num = num3;
					result = num2;
				}
				if (_tops[i] > _offset + ViewHeight)
				{
					break;
				}
			}
			return result;
		}

		private void Measure()
		{
			_tops.Clear();
			_kinds.Clear();
			_total = 0f;
			if (_adapter == null)
			{
				return;
			}
			int count = _adapter.Count;
			for (int i = 0; i < count; i++)
			{
				int num = Mathf.Clamp(_adapter.KindOf(i), 0, templates.Length - 1);
				_kinds.Add(num);
				_tops.Add(_total);
				_total += heights[num] + ((i < count - 1) ? gap : 0f);
			}
		}

		private void Layout(bool forceBind)
		{
			if (_adapter == null)
			{
				return;
			}
			float viewHeight = ViewHeight;
			_release.Clear();
			float offset = _offset;
			float num = offset + viewHeight;
			foreach (KeyValuePair<int, SocialListItem> item in _shown)
			{
				int key = item.Key;
				if (key >= _tops.Count || !(_tops[key] + heights[_kinds[key]] > offset) || !(_tops[key] < num))
				{
					_release.Add(key);
				}
			}
			for (int i = 0; i < _release.Count; i++)
			{
				Release(_release[i]);
			}
			int num2 = -1;
			for (int j = 0; j < _tops.Count; j++)
			{
				float num3 = _tops[j];
				float num4 = num3 + heights[_kinds[j]];
				if (num4 <= offset)
				{
					continue;
				}
				if (num3 >= num)
				{
					break;
				}
				if (num2 < 0)
				{
					num2 = j;
				}
				SocialListItem value;
				bool flag = _shown.TryGetValue(j, out value);
				if (!flag)
				{
					value = Take(_kinds[j]);
					_shown[j] = value;
				}
				RectTransform rect = value.Rect;
				rect.anchoredPosition = new Vector2(rect.anchoredPosition.x, 0f - (num3 - _offset));
				if (!flag || forceBind)
				{
					_adapter.Bind(value, j);
				}
				value.SetPressable(num3 >= offset - 2f && num4 <= num + 2f && !Moving);
			}
			if (num2 != _firstVisible)
			{
				if (_firstVisible >= 0 && num2 >= 0)
				{
					this.Stepped?.Invoke();
				}
				_firstVisible = num2;
			}
		}

		private SocialListItem Take(int kind)
		{
			List<SocialListItem> list = _pools[kind];
			SocialListItem socialListItem;
			if (list.Count > 0)
			{
				socialListItem = list[list.Count - 1];
				list.RemoveAt(list.Count - 1);
			}
			else
			{
				socialListItem = UnityEngine.Object.Instantiate(templates[kind], templates[kind].transform.parent, worldPositionStays: false);
				socialListItem.name = templates[kind].name;
				this.ViewsCreated?.Invoke();
			}
			if (!socialListItem.gameObject.activeSelf)
			{
				socialListItem.gameObject.SetActive(true);
			}
			return socialListItem;
		}

		private void Release(int index)
		{
			if (_shown.TryGetValue(index, out var value))
			{
				_shown.Remove(index);
				value.gameObject.SetActive(false);
				_pools[(index < _kinds.Count) ? _kinds[index] : KindOfItem(value)].Add(value);
			}
		}

		private int KindOfItem(SocialListItem item)
		{
			for (int i = 0; i < templates.Length; i++)
			{
				if (templates[i] != null && templates[i].name == item.name)
				{
					return i;
				}
			}
			return 0;
		}

		private void ReleaseAll()
		{
			foreach (KeyValuePair<int, SocialListItem> item in _shown)
			{
				SocialListItem value = item.Value;
				value.gameObject.SetActive(false);
				_pools[KindOfItem(value)].Add(value);
			}
			_shown.Clear();
			_firstVisible = -1;
		}

		public void Warm(int kind, int count)
		{
			EnsurePools();
			if (kind < 0 || kind >= templates.Length || templates[kind] == null)
			{
				return;
			}
			bool flag = false;
			while (_pools[kind].Count < count)
			{
				SocialListItem socialListItem = UnityEngine.Object.Instantiate(templates[kind], templates[kind].transform.parent, worldPositionStays: false);
				socialListItem.name = templates[kind].name;
				socialListItem.gameObject.SetActive(false);
				_pools[kind].Add(socialListItem);
				flag = true;
			}
			if (flag)
			{
				this.ViewsCreated?.Invoke();
			}
		}

		public void CollectShown(List<SocialListItem> views, List<int> indices)
		{
			foreach (KeyValuePair<int, SocialListItem> item in _shown)
			{
				views.Add(item.Value);
				indices.Add(item.Key);
			}
		}

		public void CollectViews(List<SocialListItem> into)
		{
			EnsurePools();
			foreach (KeyValuePair<int, SocialListItem> item in _shown)
			{
				into.Add(item.Value);
			}
			for (int i = 0; i < _pools.Length; i++)
			{
				into.AddRange(_pools[i]);
			}
		}
	}
}
