using UnityEngine;

namespace LethalApeR
{
	public class EmissionFlash : MonoBehaviour
	{
		private static readonly int FlashColorId = Shader.PropertyToID("_FlashColor");

		private static readonly int FlashTimeId = Shader.PropertyToID("_FlashTime");

		private static readonly int FlashSpeedId = Shader.PropertyToID("_FlashSpeed");

		private const float InactiveTime = -9999f;

		[SerializeField]
		private Color defaultFlashColor = Color.white;

		[SerializeField]
		private float defaultFlashSpeed = 3f;

		[Tooltip("Flash every renderer under this object, not just the ones on it.")]
		[SerializeField]
		private bool includeChildren = true;

		[SerializeField]
		private bool flashOnStart = true;

		private Renderer[] _renderers;

		private MaterialPropertyBlock _block;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			_renderers = (includeChildren ? GetComponentsInChildren<Renderer>() : GetComponents<Renderer>());
		}

		private void Start()
		{
			Write(-9999f, default(Color), 0f, writeColorAndSpeed: false);
			if (flashOnStart)
			{
				Flash();
			}
		}

		private void OnDisable()
		{
			Write(-9999f, default(Color), 0f, writeColorAndSpeed: false);
		}

		public void Flash()
		{
			Flash(defaultFlashColor, defaultFlashSpeed);
		}

		public void Flash(Color color)
		{
			Flash(color, defaultFlashSpeed);
		}

		public void Flash(Color color, float speed)
		{
			Write(Time.timeSinceLevelLoad, color, speed, writeColorAndSpeed: true);
		}

		public void ClearFlash()
		{
			Write(-9999f, default(Color), 0f, writeColorAndSpeed: false);
		}

		[ContextMenu("Test Flash")]
		public void TestFlash()
		{
			Flash();
		}

		private void Write(float startTime, Color color, float speed, bool writeColorAndSpeed)
		{
			if (_renderers == null)
			{
				return;
			}
			for (int i = 0; i < _renderers.Length; i++)
			{
				Renderer renderer = _renderers[i];
				if (!(renderer == null))
				{
					renderer.GetPropertyBlock(_block);
					if (writeColorAndSpeed)
					{
						_block.SetColor(FlashColorId, color);
						_block.SetFloat(FlashSpeedId, speed);
					}
					_block.SetFloat(FlashTimeId, startTime);
					renderer.SetPropertyBlock(_block);
				}
			}
		}
	}
}
