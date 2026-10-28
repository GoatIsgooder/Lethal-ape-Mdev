using LethalApeR.Gameplay.ApeGames;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnPad : MonoBehaviour
	{
		[Range(1f, 3f)]
		public int size = 1;

		public Renderer padRenderer;

		[Tooltip("One lamp per slot (up to 3); lit while that slot is ready.")]
		public Renderer[] slotLamps = new Renderer[0];

		public FnPadConsole console;

		[Tooltip("Stand-on area in the pad's local XZ (width, depth), centred on the pad. Zero keeps the hub's circular padRadius.")]
		public Vector2 zone;

		public Color emptyColor = new Color(0.18f, 0.18f, 0.2f, 1f);

		public Color filledColor = new Color(0.95f, 0.72f, 0.2f, 1f);

		public Color readyColor = new Color(0.25f, 1f, 0.4f, 1f);

		public Color refusedColor = new Color(1f, 0.15f, 0.12f, 1f);

		[Tooltip("Slot lamps of open slots. Kept apart from emptyColor so an idle pad sign can glow while its lamps stay dark.")]
		public Color slotEmptyColor = new Color(0.18f, 0.18f, 0.2f, 1f);

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private FnHub _hub;

		private int _index = -1;

		private MaterialPropertyBlock _mpb;

		private bool _localOn;

		private float _nextNotify;

		private float _refusedUntil;

		private int _lastTickSecond = -1;

		private int _appliedHash;

		private int _refusedKey = -1;

		public int Index => _index;

		public void Bind(FnHub hub, int index)
		{
			_hub = hub;
			_index = index;
			if (console != null)
			{
				console.Bind(hub, this);
			}
		}

		public void OnRefused(FnRpc request, FnReject reason)
		{
			if (request == FnRpc.PadClaim && _localOn)
			{
				_refusedKey = StateKey((_hub != null) ? _hub.Pad(_index) : default(FnPadState));
			}
			_refusedUntil = Time.time + 0.6f;
			_appliedHash = 0;
			AgHaptics.Both(0.6f, 0.15f);
			FnAudioBank audio = FnGame.Audio;
			if (audio != null)
			{
				FnAudio.Play(audio.padReject, base.transform.position, 0.8f, 1f, 8f, 1f);
			}
			if (console != null)
			{
				console.ShowRefusal(request, reason);
			}
		}

		private void Update()
		{
			if (_hub == null || !_hub.InHubRoom)
			{
				_localOn = false;
				return;
			}
			FnPadState state = _hub.Pad(_index);
			bool flag = LocalOnPad();
			if (flag != _localOn)
			{
				_localOn = flag;
				_nextNotify = 0f;
				_refusedKey = -1;
			}
			else if (_refusedKey >= 0 && _refusedKey != StateKey(state))
			{
				_refusedKey = -1;
			}
			bool flag2 = state.Contains(FnGame.LocalActor);
			if ((FnMatchmaker.Instance == null || !FnMatchmaker.Instance.Busy) && flag != flag2 && Time.time >= _nextNotify && !state.Locked && (!flag || _refusedKey < 0))
			{
				_nextNotify = Time.time + FnGame.Settings.hub.claimRetrySeconds;
				if (flag)
				{
					_hub.RequestClaim(_index);
				}
				else
				{
					_hub.RequestRelease(_index);
				}
			}
			CountdownTicks(state);
		}

		private static int StateKey(FnPadState state)
		{
			return state.Count | ((state.Difficulty == FnDifficulty.Nightmare) ? 16 : 0) | (state.Locked ? 32 : 0);
		}

		private bool LocalOnPad()
		{
			Transform head = FnPlatform.Head;
			if (head == null)
			{
				return false;
			}
			Vector3 vector = head.position - base.transform.position;
			if (vector.y < -0.2f || vector.y > FnGame.Settings.hub.padMaxHeight)
			{
				return false;
			}
			if (zone.x > 0f && zone.y > 0f)
			{
				Vector3 vector2 = Quaternion.Inverse(base.transform.rotation) * vector;
				if (Mathf.Abs(vector2.x) <= zone.x * 0.5f)
				{
					return Mathf.Abs(vector2.z) <= zone.y * 0.5f;
				}
				return false;
			}
			float padRadius = FnGame.Settings.hub.padRadius;
			return vector.x * vector.x + vector.z * vector.z <= padRadius * padRadius;
		}

		private void CountdownTicks(FnPadState state)
		{
			if (state.Deadline == 0)
			{
				_lastTickSecond = -1;
				return;
			}
			int num = Mathf.CeilToInt((float)FnClock.MsUntil(state.Deadline) / 1000f);
			if (num >= 0 && num != _lastTickSecond)
			{
				_lastTickSecond = num;
				FnAudioBank audio = FnGame.Audio;
				if (audio != null)
				{
					FnAudio.Play((num != 0) ? audio.padTick : audio.padGo, base.transform.position, 0.8f, 1f, 10f, 1f);
				}
			}
		}

		private void LateUpdate()
		{
			if (_hub == null)
			{
				return;
			}
			FnPadState state = _hub.Pad(_index);
			int count = state.Count;
			int num = Mathf.Max(1, size);
			bool flag = state.Deadline != 0 && Mathf.Repeat((float)FnClock.MsUntil(state.Deadline) / 1000f, 0.5f) < 0.25f;
			bool flag2 = Time.time < _refusedUntil && Mathf.Repeat(_refusedUntil - Time.time, 0.5f) > 0.25f;
			int num2 = count * 1000 + state.ReadyCount * 100 + (state.Locked ? 5000 : 0) + (flag ? 10 : 0) + (flag2 ? 1 : 0);
			if (num2 == _appliedHash)
			{
				return;
			}
			_appliedHash = num2;
			Tint(padRenderer, flag2 ? refusedColor : Color.Lerp(emptyColor, filledColor, (float)count / (float)num));
			for (int i = 0; i < slotLamps.Length; i++)
			{
				Color c;
				if (i < size && state.Occupant(i) != 0)
				{
					if (state.Ready(i))
					{
						c = (flag ? Color.white : readyColor);
					}
					else
					{
						c = filledColor * 0.6f;
					}
				}
				else
				{
					c = slotEmptyColor;
				}
				Tint(slotLamps[i], c);
			}
		}

		private void Tint(Renderer r, Color c)
		{
			if (!(r == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				r.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, c);
				_mpb.SetColor(BaseColorId, c);
				_mpb.SetColor(EmissionId, c * 0.6f);
				r.SetPropertyBlock(_mpb);
			}
		}

		private void OnDrawGizmos()
		{
			Gizmos.color = ((size > 2) ? Color.magenta : ((size == 2) ? Color.cyan : Color.yellow));
			if (zone.x > 0f && zone.y > 0f)
			{
				Gizmos.matrix = Matrix4x4.TRS(base.transform.position + Vector3.up * 0.02f, base.transform.rotation, Vector3.one);
				Gizmos.DrawWireCube(Vector3.zero, new Vector3(zone.x, 0f, zone.y));
				Gizmos.matrix = Matrix4x4.identity;
				return;
			}
			float num = ((FnGame.Instance != null) ? FnGame.Settings.hub.padRadius : 0.9f);
			Vector3 from = base.transform.position + new Vector3(num, 0.02f, 0f);
			for (int i = 1; i <= 24; i++)
			{
				float f = (float)i / 24f * Mathf.PI * 2f;
				Vector3 vector = base.transform.position + new Vector3(Mathf.Cos(f) * num, 0.02f, Mathf.Sin(f) * num);
				Gizmos.DrawLine(from, vector);
				from = vector;
			}
		}
	}
}
