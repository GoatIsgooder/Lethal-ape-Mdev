using GorillaLocomotion;
using LethalApeR.Gameplay.BeTheMonster;
using UnityEngine;
using UnityEngine.UI;

namespace LethalApeR.Social.UI
{
	public sealed class ScrollWheel : MonoBehaviour, IFingerReceiver
	{
		private static readonly int MainTexSt = Shader.PropertyToID("_MainTex_ST");

		private const float JumpMetres = 0.08f;

		private const float GripDown = 0.6f;

		private const float GripUp = 0.35f;

		private const int NoHand = -1;

		private const int LeftHand = 0;

		private const int RightHand = 1;

		[SerializeField]
		private SocialListView list;

		[Tooltip("Hand menu: the tick strip (repeat wrap). Its UVs roll with the wheel.")]
		[SerializeField]
		private RawImage ticks;

		[Tooltip("Board: the wheel's tick rim. Its texture rolls with the wheel through a property block, so the shared quest material is never touched.")]
		[SerializeField]
		private Renderer rim;

		[Tooltip("Board: where a hand can grab the wheel with grip (the wheel's finger box, which the editor's mouse also aims at). Empty on the hand menu.")]
		[SerializeField]
		private BoxCollider grabZone;

		[Tooltip("Canvas units of wheel travel per repeat of the tick texture.")]
		[SerializeField]
		private float tileUnits = 156f;

		[Tooltip("List travel per unit of hand travel. 1 = the rows keep pace with the hand.")]
		[SerializeField]
		private float gain = 1f;

		[Tooltip("Tick this if the list should move against the hand (pull down to bring later rows up, like a mouse wheel).")]
		[SerializeField]
		private bool invertScroll;

		[Tooltip("Haptic strength per metre a second of wheel speed, capped at 1 (the quest board's wheel uses 2).")]
		[SerializeField]
		private float hapticPerSpeed = 2f;

		private readonly bool[] _gripHeld = new bool[2];

		private int _hand = NoHand;

		private Vector3 _lastHand;

		private float _shownTurn = float.NaN;

		private MaterialPropertyBlock _block;

		public SocialListView List => list;

		public RectTransform Rect => base.transform as RectTransform;

		private float Direction => invertScroll ? 1f : (-1f);

		private void OnDisable()
		{
			Release();
			_gripHeld[0] = false;
			_gripHeld[1] = false;
		}

		void IFingerReceiver.FingerEnter(Collider finger, bool leftHand)
		{
		}

		void IFingerReceiver.FingerExit(Collider finger)
		{
		}

		public void DragBy(float canvasDown, float dt)
		{
			list.Drag(canvasDown * gain * Direction, dt);
		}

		private void LateUpdate()
		{
			if (grabZone != null)
			{
				UpdateGrab();
			}
			ShowTurn();
		}

		private void UpdateGrab()
		{
			VRInputController input = VRInputController.Instance;
			Player player = Player.Instance;
			if (input == null || player == null)
			{
				Release();
				return;
			}
			for (int hand = 0; hand < 2; hand++)
			{
				float grip = ((hand == 0) ? input.LeftGripValue : input.RightGripValue);
				bool was = _gripHeld[hand];
				bool held = (was ? (grip > GripUp) : (grip >= GripDown));
				_gripHeld[hand] = held;
				bool pressed = held && !was;
				Transform t = HandOf(player, hand);
				if (_hand == hand && (!held || t == null))
				{
					Release();
				}
				else if (_hand == NoHand && pressed && t != null && InZone(t.position))
				{
					Grab(hand, t.position);
				}
			}
			if (_hand != NoHand)
			{
				Follow(HandOf(player, _hand).position);
			}
		}

		private static Transform HandOf(Player player, int hand)
		{
			if (hand != 0)
			{
				return player.rightHandTransform;
			}
			return player.leftHandTransform;
		}

		private bool InZone(Vector3 world)
		{
			Vector3 local = grabZone.transform.InverseTransformPoint(world);
			Vector3 center = grabZone.center;
			Vector3 size = grabZone.size;
			if (Mathf.Abs(local.x - center.x) <= size.x * 0.5f && Mathf.Abs(local.y - center.y) <= size.y * 0.5f)
			{
				return Mathf.Abs(local.z - center.z) <= size.z * 0.5f;
			}
			return false;
		}

		private void Grab(int hand, Vector3 at)
		{
			_hand = hand;
			_lastHand = at;
			list.BeginHold();
			SocialStyle.Pulse(hand == 0, 0.3f, 0.03f);
		}

		private void Follow(Vector3 now)
		{
			float dt = Time.unscaledDeltaTime;
			Vector3 delta = now - _lastHand;
			_lastHand = now;
			if (delta.sqrMagnitude > JumpMetres * JumpMetres)
			{
				return;
			}
			Vector3 up = base.transform.up;
			Vector3 scale = base.transform.lossyScale;
			float down = 0f - Vector3.Dot(delta, up);
			list.Drag(down / Mathf.Max(scale.y, 1E-06f) * gain * Direction, dt);
			if (dt > 0f)
			{
				float amplitude = Mathf.Clamp01(Mathf.Abs(down) / dt * hapticPerSpeed);
				if (amplitude > 0.01f)
				{
					SocialStyle.Pulse(_hand == 0, amplitude, 0.04f);
				}
			}
		}

		private void Release()
		{
			if (_hand != NoHand)
			{
				_hand = NoHand;
				if (list != null)
				{
					list.EndHold();
				}
			}
		}

		private void ShowTurn()
		{
			if (list == null || (ticks == null && rim == null))
			{
				return;
			}
			float turn = list.WheelTurn;
			if (Mathf.Approximately(_shownTurn, turn))
			{
				return;
			}
			_shownTurn = turn;
			float rolls = turn * Direction / tileUnits;
			float roll = rolls - Mathf.Floor(rolls);
			if (ticks != null)
			{
				float height = ticks.rectTransform.rect.height;
				ticks.uvRect = new Rect(0f, roll, 1f, height / tileUnits);
			}
			if (rim != null)
			{
				if (_block == null)
				{
					_block = new MaterialPropertyBlock();
				}
				rim.GetPropertyBlock(_block);
				_block.SetVector(MainTexSt, new Vector4(1f, 1f, 0f, roll));
				rim.SetPropertyBlock(_block);
			}
		}
	}
}
