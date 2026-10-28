using LethalApeR.Networking;
using TMPro;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	[DefaultExecutionOrder(10350)]
	public class PlayerColorPicker : MonoBehaviour
	{
		[SerializeField]
		private ColorTouchSurface wheel;

		[SerializeField]
		private ColorTouchSurface shadeSlider;

		[SerializeField]
		private TMP_Text hexLabel;

		[SerializeField]
		private AudioSource touchSound;

		[Header("Haptics")]
		[SerializeField]
		[Range(0f, 1f)]
		private float touchAmplitude = 0.4f;

		[SerializeField]
		[Range(0f, 1f)]
		private float detentAmplitude = 0.12f;

		[Tooltip("Haptic ticks per full turn of hue.")]
		[SerializeField]
		[Min(1f)]
		private int hueDetents = 24;

		[Tooltip("Haptic ticks along the shade slider.")]
		[SerializeField]
		[Min(1f)]
		private int shadeDetents = 12;

		private static readonly int HsvId = Shader.PropertyToID("_HSV");

		private static readonly int PickId = Shader.PropertyToID("_Pick");

		private static readonly int PickColorId = Shader.PropertyToID("_PickColor");

		private static readonly int HubRadiusId = Shader.PropertyToID("_HubRadius");

		private static readonly int SatRadiusId = Shader.PropertyToID("_SatRadius");

		private static readonly int TravelId = Shader.PropertyToID("_Travel");

		private static readonly int ValueRangeId = Shader.PropertyToID("_ValueRange");

		private const string HexDigits = "0123456789ABCDEF";

		private const float PressSpeed = 10f;

		private const float HapticSpacing = 0.03f;

		private Renderer _wheelRenderer;

		private Renderer _sliderRenderer;

		private MaterialPropertyBlock _block;

		private float _hubRadius = 0.028f;

		private float _satRadius = 0.098f;

		private float _travel = 0.088f;

		private Vector2 _valueRange = new Vector2(0.5f, 1f);

		private float _hue;

		private float _saturation;

		private float _value = 1f;

		private Vector2 _pick;

		private Color _color = Color.white;

		private Color _synced;

		private bool _hasSynced;

		private bool _uncommitted;

		private float _wheelPress;

		private float _sliderPress;

		private bool _visualsDirty = true;

		private bool _inHub;

		private int _hueDetent = -1;

		private int _shadeDetent = -1;

		private float _nextHapticLeft;

		private float _nextHapticRight;

		private readonly char[] _hex = new char[7] { '#', '0', '0', '0', '0', '0', '0' };

		private int _hexValue = -1;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			_wheelRenderer = wheel.GetComponent<Renderer>();
			_sliderRenderer = shadeSlider.GetComponent<Renderer>();
			ReadLayout();
		}

		private void OnEnable()
		{
			_hasSynced = false;
			_uncommitted = false;
			SyncFromManager();
		}

		private void OnDisable()
		{
			Commit();
			_wheelPress = 0f;
			_sliderPress = 0f;
			_visualsDirty = true;
		}

		private void LateUpdate()
		{
			bool wheelBegan;
			bool wheelEnded;
			bool wheelTouching = wheel.Tick(out wheelBegan, out wheelEnded);
			bool sliderBegan;
			bool sliderEnded;
			bool sliderTouching = shadeSlider.Tick(out sliderBegan, out sliderEnded);
			bool touching = wheelTouching || sliderTouching;
			if (!touching && !_uncommitted)
			{
				SyncFromManager();
			}
			if (wheelBegan)
			{
				TouchBegan(wheel.TouchIsLeft);
			}
			if (sliderBegan)
			{
				TouchBegan(shadeSlider.TouchIsLeft);
			}
			if (wheelTouching)
			{
				DragWheel(wheel.TouchPoint, wheel.TouchIsLeft, wheelBegan);
			}
			if (sliderTouching)
			{
				DragSlider(shadeSlider.TouchPoint.y, shadeSlider.TouchIsLeft, sliderBegan);
			}
			AnimatePress(ref _wheelPress, wheelTouching);
			AnimatePress(ref _sliderPress, sliderTouching);
			if (!touching && (wheelEnded || sliderEnded))
			{
				Commit();
			}
			if (_visualsDirty)
			{
				PushVisuals();
			}
		}

		private void ReadLayout()
		{
			Material wheelMaterial = _wheelRenderer.sharedMaterial;
			if (wheelMaterial != null && wheelMaterial.HasProperty(HubRadiusId))
			{
				_hubRadius = wheelMaterial.GetFloat(HubRadiusId);
				_satRadius = Mathf.Max(wheelMaterial.GetFloat(SatRadiusId), _hubRadius + 0.001f);
			}
			Material sliderMaterial = _sliderRenderer.sharedMaterial;
			if (sliderMaterial != null && sliderMaterial.HasProperty(TravelId))
			{
				_travel = Mathf.Max(sliderMaterial.GetFloat(TravelId), 0.001f);
				_valueRange = sliderMaterial.GetVector(ValueRangeId);
			}
		}

		private void TouchBegan(bool left)
		{
			Pulse(left, touchAmplitude, 0.03f, true);
			if (touchSound != null && touchSound.clip != null)
			{
				touchSound.PlayOneShot(touchSound.clip);
			}
		}

		private void DragWheel(Vector2 point, bool left, bool began)
		{
			float distance = point.magnitude;
			if (distance > _satRadius)
			{
				point *= _satRadius / distance;
				distance = _satRadius;
			}
			_pick = point;
			_hue = Mathf.Repeat(Mathf.Atan2(point.x, point.y) / (Mathf.PI * 2f), 1f);
			_saturation = Mathf.Clamp01((distance - _hubRadius) / (_satRadius - _hubRadius));
			bool inHub = distance < _hubRadius;
			if (!began && _inHub != inHub)
			{
				Pulse(left, touchAmplitude * 0.6f, 0.02f, true);
			}
			_inHub = inHub;
			int detent;
			if (_saturation > 0.2f)
			{
				detent = Mathf.FloorToInt(_hue * (float)hueDetents) % hueDetents;
				if (detent >= 0 && !began && _hueDetent >= 0 && detent != _hueDetent)
				{
					Pulse(left, detentAmplitude, 0.012f, false);
				}
			}
			else
			{
				detent = -1;
			}
			_hueDetent = detent;
			ApplyPickedColor();
		}

		private void DragSlider(float along, bool left, bool began)
		{
			float t = Mathf.Clamp01((along + _travel) / (_travel * 2f));
			_value = Mathf.Lerp(_valueRange.x, _valueRange.y, t);
			int detent = Mathf.RoundToInt(t * (float)shadeDetents);
			if (!began && detent != _shadeDetent)
			{
				if (detent == 0 || detent == shadeDetents)
				{
					Pulse(left, touchAmplitude * 0.6f, 0.012f, true);
				}
				else
				{
					Pulse(left, detentAmplitude, 0.012f, false);
				}
			}
			_shadeDetent = detent;
			ApplyPickedColor();
		}

		private void ApplyPickedColor()
		{
			_uncommitted = true;
			_visualsDirty = true;
			Color color = Color.HSVToRGB(_hue, _saturation, _value);
			if (!(color == _color))
			{
				_color = color;
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (manager != null && manager.LocalPlayer != null)
				{
					manager.LocalPlayer.PreviewColour(color);
				}
			}
		}

		private void Commit()
		{
			if (_uncommitted)
			{
				_uncommitted = false;
				MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
				if (!(manager == null))
				{
					_hasSynced = true;
					_synced = _color;
					if (!SameRgb(manager.Colour, _color))
					{
						MonkeDevNetworkingManager.SetColour(_color);
						PlayerPrefs.Save();
					}
				}
			}
		}

		private void SyncFromManager()
		{
			MonkeDevNetworkingManager manager = MonkeDevNetworkingManager.Manager;
			Color color = ((manager != null) ? manager.Colour : Color.white);
			if (!_hasSynced || !SameRgb(color, _synced))
			{
				_synced = color;
				_hasSynced = true;
				Color.RGBToHSV(color, out _hue, out _saturation, out var value);
				_value = Mathf.Clamp(value, _valueRange.x, _valueRange.y);
				_color = new Color(color.r, color.g, color.b, 1f);
				_pick = PickFor(_hue, _saturation);
				_visualsDirty = true;
				_inHub = _saturation <= 0f;
			}
		}

		private Vector2 PickFor(float hue, float saturation)
		{
			if (saturation <= 0.001f)
			{
				return Vector2.zero;
			}
			float radius = Mathf.Lerp(_hubRadius, _satRadius, saturation);
			float angle = hue * 2f * Mathf.PI;
			return new Vector2(Mathf.Sin(angle), Mathf.Cos(angle)) * radius;
		}

		private void AnimatePress(ref float press, bool on)
		{
			float target = (on ? 1f : 0f);
			if (press != target)
			{
				_visualsDirty = true;
				press = Mathf.MoveTowards(press, target, Time.deltaTime * PressSpeed);
			}
		}

		private void PushVisuals()
		{
			_visualsDirty = false;
			_wheelRenderer.GetPropertyBlock(_block);
			_block.SetVector(HsvId, new Vector4(_hue, _saturation, _value, _wheelPress));
			_block.SetVector(PickId, _pick);
			_wheelRenderer.SetPropertyBlock(_block);
			_sliderRenderer.GetPropertyBlock(_block);
			_block.SetVector(HsvId, new Vector4(_hue, _saturation, _value, _sliderPress));
			_block.SetColor(PickColorId, _color);
			_sliderRenderer.SetPropertyBlock(_block);
			UpdateHexLabel();
		}

		private void UpdateHexLabel()
		{
			if (hexLabel == null)
			{
				return;
			}
			int rgb = (To8Bit(_color.r) << 16) | (To8Bit(_color.g) << 8) | To8Bit(_color.b);
			if (rgb != _hexValue)
			{
				_hexValue = rgb;
				for (int i = 0; i < 6; i++)
				{
					_hex[6 - i] = HexDigits[(rgb >> i * 4) & 0xF];
				}
				hexLabel.SetCharArray(_hex, 0, _hex.Length);
			}
		}

		private void Pulse(bool left, float amplitude, float duration, bool force)
		{
			float now = Time.unscaledTime;
			if (!force && now < (left ? _nextHapticLeft : _nextHapticRight))
			{
				return;
			}
			if (left)
			{
				_nextHapticLeft = now + HapticSpacing;
			}
			else
			{
				_nextHapticRight = now + HapticSpacing;
			}
			InputDevice device = InputDevices.GetDeviceAtXRNode(left ? XRNode.LeftHand : XRNode.RightHand);
			if (device.isValid)
			{
				device.SendHapticImpulse(0u, amplitude, duration);
			}
		}

		private static int To8Bit(float channel)
		{
			return Mathf.Clamp(Mathf.RoundToInt(channel * 255f), 0, 255);
		}

		private static bool SameRgb(Color a, Color b)
		{
			if (To8Bit(a.r) == To8Bit(b.r) && To8Bit(a.g) == To8Bit(b.g))
			{
				return To8Bit(a.b) == To8Bit(b.b);
			}
			return false;
		}
	}
}
