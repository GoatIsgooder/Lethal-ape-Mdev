using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;
using UnityEngine.XR;

namespace LethalApeR
{
	public class TurnController : MonoBehaviour
	{
		public enum TurnMode
		{
			None = 0,
			Snap = 1,
			Smooth = 2
		}

		public static TurnMode currentTurnMode = TurnMode.None;

		[Tooltip("Pivot for the fallback rotation. Empty = Player head collider, then Camera.main.")]
		public Transform mainCamera;

		[Tooltip("Transform rotated by the fallback path. Empty = Player turnParent, then the Player itself.")]
		public Transform target;

		public float snapAngle = 45f;

		public float smoothSpeed = 180f;

		[Tooltip("Stick deflection that fires a snap turn.")]
		public float snapTriggerThreshold = 0.5f;

		[Tooltip("Stick has to return under this deflection before the next snap can fire.")]
		public float snapReleaseThreshold = 0.1f;

		private const string TurnModeKey = "TurnMode";

		private static readonly List<InputDevice> DeviceScratch = new List<InputDevice>();

		private static TurnController _instance;

		private InputDevice rightController;

		private bool snapOnCooldown;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.AfterSceneLoad)]
		private static void EnsureRuntimeInstance()
		{
			if (!(_instance != null))
			{
				TurnController turnController = Object.FindObjectOfType<TurnController>();
				if (turnController != null)
				{
					_instance = turnController;
					return;
				}
				GameObject gameObject = new GameObject("[Auto] TurnController");
				Object.DontDestroyOnLoad(gameObject);
				_instance = gameObject.AddComponent<TurnController>();
			}
		}

		public static void SetTurnMode(TurnMode mode)
		{
			currentTurnMode = mode;
			PlayerPrefs.SetInt(TurnModeKey, (int)mode);
			PlayerPrefs.Save();
		}

		private void Awake()
		{
			if (_instance == null)
			{
				_instance = this;
			}
			RestoreTurnMode();
		}

		private void Update()
		{
			if (currentTurnMode != TurnMode.None && ReadRightStickX(out var x))
			{
				if (currentTurnMode == TurnMode.Snap)
				{
					TickSnap(x);
				}
				else if (currentTurnMode == TurnMode.Smooth)
				{
					TickSmooth(x);
				}
			}
		}

		private void TickSnap(float x)
		{
			float num = Mathf.Abs(x);
			if (!snapOnCooldown && num > snapTriggerThreshold)
			{
				Rotate((x < 0f) ? (0f - snapAngle) : snapAngle);
				snapOnCooldown = true;
			}
			else if (num < snapReleaseThreshold)
			{
				snapOnCooldown = false;
			}
		}

		private void TickSmooth(float x)
		{
			if (Mathf.Abs(x) > snapReleaseThreshold)
			{
				Rotate(smoothSpeed * x * Time.deltaTime);
			}
		}

		private bool ReadRightStickX(out float x)
		{
			x = 0f;
			if (!rightController.isValid)
			{
				InputDevices.GetDevicesWithCharacteristics(InputDeviceCharacteristics.Controller | InputDeviceCharacteristics.Right, DeviceScratch);
				if (DeviceScratch.Count > 0)
				{
					rightController = DeviceScratch[0];
				}
			}
			if (!rightController.isValid)
			{
				rightController = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);
			}
			if (rightController.isValid && rightController.TryGetFeatureValue(CommonUsages.primary2DAxis, out Vector2 value))
			{
				x = Mathf.Clamp(value.x, -1f, 1f);
				return true;
			}
			return false;
		}

		private void Rotate(float degrees)
		{
			Player instance = Player.Instance;
			if (instance != null && mainCamera == null && target == null)
			{
				instance.Turn(degrees);
				return;
			}
			Transform transform = ResolvePivot(instance);
			Transform transform2 = ResolveRotated(instance);
			if (!(transform == null) && !(transform2 == null))
			{
				transform2.RotateAround(transform.position, Vector3.up, degrees);
			}
		}

		private Transform ResolvePivot(Player rig)
		{
			if (mainCamera != null)
			{
				return mainCamera;
			}
			if (rig != null && rig.headCollider != null)
			{
				return rig.headCollider.transform;
			}
			Camera main = Camera.main;
			if (!(main != null))
			{
				return null;
			}
			return main.transform;
		}

		private Transform ResolveRotated(Player rig)
		{
			if (target != null)
			{
				return target;
			}
			if (rig == null)
			{
				return null;
			}
			if (rig.turnParent != null)
			{
				return rig.turnParent.transform;
			}
			return rig.transform;
		}

		private void RestoreTurnMode()
		{
			if (PlayerPrefs.HasKey(TurnModeKey))
			{
				currentTurnMode = (TurnMode)PlayerPrefs.GetInt(TurnModeKey);
			}
			else
			{
				SetTurnMode(TurnMode.Snap);
			}
		}
	}
}
