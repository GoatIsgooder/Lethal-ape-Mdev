using System;
using System.Collections;
using System.IO;
using System.Reflection;
using ExitGames.Client.Photon;
using GorillaLocomotion;
using LethalApeR.Gameplay.ApeGames;
using LethalApeR.Gameplay.BeTheMonster;
using LethalApeR.Networking;
using LethalApeR.SceneFlow;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace LethalApeR.Gameplay.Fnaf
{
	[Obfuscation(Exclude = true)]
	public static class FnPlatform
	{
		private sealed class FnPlatformDriver : MonoBehaviour
		{
			private Player _rig;

			private bool _holding;

			private Vector3 _holdPosition;

			private bool _heldKinematic;

			private bool _heldDisableMovement;

			private bool _ghost;

			private float _ghostGravity;

			private bool _pendingRise;

			private float _riseSpeed;

			private float _savedDamping;

			private bool _savedUseGravity;

			public bool Holding => _holding;

			private void OnEnable()
			{
				SceneManager.sceneLoaded += OnSceneLoaded;
			}

			private void OnDisable()
			{
				SceneManager.sceneLoaded -= OnSceneLoaded;
			}

			private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
			{
				if (mode == LoadSceneMode.Single)
				{
					_rig = null;
					_holding = false;
					_ghost = false;
					_pendingRise = false;
				}
			}

			public void BeginHold(Player r)
			{
				Rigidbody rigidbody = RigBodyOf(r);
				if (!(rigidbody == null))
				{
					if (!_holding)
					{
						_heldKinematic = rigidbody.isKinematic;
						_heldDisableMovement = r.disableMovement;
					}
					_rig = r;
					_holding = true;
					_holdPosition = r.transform.position;
					rigidbody.linearVelocity = Vector3.zero;
					rigidbody.isKinematic = true;
					r.disableMovement = true;
				}
			}

			public void EndHold(Player r)
			{
				if (_holding)
				{
					_holding = false;
					Rigidbody rigidbody = RigBodyOf(r);
					if (!(rigidbody == null))
					{
						rigidbody.isKinematic = _heldKinematic;
						rigidbody.linearVelocity = Vector3.zero;
						r.disableMovement = _heldDisableMovement;
						r.AcceptExternalHeadPosition();
					}
				}
			}

			public void BeginGhost(Player r, float gravity, float drag, float riseSpeed)
			{
				Rigidbody rigidbody = RigBodyOf(r);
				if (!(rigidbody == null))
				{
					if (!_ghost)
					{
						_savedDamping = rigidbody.linearDamping;
						_savedUseGravity = rigidbody.useGravity;
					}
					_rig = r;
					_ghostGravity = gravity;
					_ghost = true;
					_riseSpeed = riseSpeed;
					_pendingRise = riseSpeed > 0f;
					rigidbody.linearDamping = drag;
					rigidbody.useGravity = false;
				}
			}

			public void EndGhost(Player r)
			{
				if (_ghost)
				{
					_ghost = false;
					_pendingRise = false;
					Rigidbody rigidbody = RigBodyOf(r);
					if (!(rigidbody == null))
					{
						rigidbody.linearDamping = _savedDamping;
						rigidbody.useGravity = _savedUseGravity;
					}
				}
			}

			private void FixedUpdate()
			{
				if (!_ghost || _rig == null)
				{
					return;
				}
				Rigidbody rigidbody = RigBodyOf(_rig);
				if (!(rigidbody == null) && !rigidbody.isKinematic)
				{
					rigidbody.AddForce(Vector3.down * _ghostGravity * Mathf.Max(_rig.CurrentScale, 0.01f), ForceMode.Acceleration);
					if (_pendingRise)
					{
						_pendingRise = false;
						rigidbody.linearVelocity += Vector3.up * _riseSpeed;
					}
				}
			}

			private void LateUpdate()
			{
				if (_holding && !(_rig == null))
				{
					Rigidbody rigidbody = RigBodyOf(_rig);
					if (!(rigidbody == null))
					{
						_rig.transform.position = _holdPosition;
						rigidbody.position = _holdPosition;
						_rig.AcceptExternalHeadPosition();
					}
				}
			}

			private static Rigidbody RigBodyOf(Player r)
			{
				if (!(r == null))
				{
					return r.playerRigidBody;
				}
				return null;
			}
		}

		public const string BuildTag = "LA";

		private static FnPlatformDriver _driver;

		private static Player LocalRig
		{
			get
			{
				if (!Player.HasInstance)
				{
					return null;
				}
				return Player.Instance;
			}
		}

		public static bool HasRig => LocalRig != null;

		public static Transform Head
		{
			get
			{
				Player localRig = LocalRig;
				if (!(localRig != null) || !(localRig.headCollider != null))
				{
					return null;
				}
				return localRig.headCollider.transform;
			}
		}

		public static Transform LeftHand
		{
			get
			{
				Player localRig = LocalRig;
				if (!(localRig != null))
				{
					return null;
				}
				return localRig.leftHandFollower;
			}
		}

		public static Transform RightHand
		{
			get
			{
				Player localRig = LocalRig;
				if (!(localRig != null))
				{
					return null;
				}
				return localRig.rightHandFollower;
			}
		}

		public static Transform RigRoot
		{
			get
			{
				Player localRig = LocalRig;
				if (!(localRig != null))
				{
					return null;
				}
				return localRig.transform;
			}
		}

		public static Rigidbody RigBody
		{
			get
			{
				Player localRig = LocalRig;
				if (!(localRig != null))
				{
					return null;
				}
				return localRig.playerRigidBody;
			}
		}

		public static Camera Eye
		{
			get
			{
				Player localRig = LocalRig;
				if (localRig != null && localRig.mainCamera != null)
				{
					return localRig.mainCamera;
				}
				return Camera.main;
			}
		}

		public static Vector3 RigVelocity
		{
			get
			{
				Rigidbody rigBody = RigBody;
				if (!(rigBody != null))
				{
					return Vector3.zero;
				}
				return rigBody.linearVelocity;
			}
		}

		public static bool IsFrozen
		{
			get
			{
				if (_driver != null)
				{
					return _driver.Holding;
				}
				return false;
			}
		}

		public static bool InCrossplayScene
		{
			get
			{
				if (MonkeDevNetworkingManager.Manager != null)
				{
					return MonkeDevNetworkingManager.Manager.crossplay;
				}
				return false;
			}
		}

		public static bool RightPrimaryButton
		{
			get
			{
				if (VRInputController.Instance != null)
				{
					return VRInputController.Instance.RightPrimaryButton;
				}
				return false;
			}
		}

		public static bool LeftPrimaryButton
		{
			get
			{
				if (VRInputController.Instance != null)
				{
					return VRInputController.Instance.LeftPrimaryButton;
				}
				return false;
			}
		}

		public static float RightGrip
		{
			get
			{
				if (!(VRInputController.Instance != null))
				{
					return 0f;
				}
				return VRInputController.Instance.RightGripValue;
			}
		}

		public static float LeftGrip
		{
			get
			{
				if (!(VRInputController.Instance != null))
				{
					return 0f;
				}
				return VRInputController.Instance.LeftGripValue;
			}
		}

		private static FnPlatformDriver Driver
		{
			get
			{
				if (_driver != null)
				{
					return _driver;
				}
				GameObject gameObject = new GameObject("~FnPlatform");
				gameObject.hideFlags = HideFlags.HideInHierarchy | HideFlags.DontSave;
				UnityEngine.Object.DontDestroyOnLoad(gameObject);
				_driver = gameObject.AddComponent<FnPlatformDriver>();
				return _driver;
			}
		}

		public static event Action Teleported;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			FnPlatform.Teleported = null;
			_driver = null;
		}

		public static void Teleport(Vector3 position, float? headYaw = null)
		{
			Player localRig = LocalRig;
			if (localRig == null || localRig.headCollider == null)
			{
				return;
			}
			Transform transform = localRig.transform;
			Transform transform2 = localRig.headCollider.transform;
			Quaternion rotation = transform.rotation;
			if (headYaw.HasValue)
			{
				float num = Mathf.DeltaAngle(transform.eulerAngles.y, transform2.eulerAngles.y);
				rotation = Quaternion.Euler(0f, headYaw.Value - num, 0f);
				transform.rotation = rotation;
			}
			Vector3 position2 = transform2.position;
			Vector3 position3 = transform.position;
			localRig.TeleportPlayerRaw(new Vector3(position.x - (position2.x - position3.x), position.y, position.z - (position2.z - position3.z)), rotation, headYaw.HasValue);
			FnPlatform.Teleported?.Invoke();
		}

		public static void Freeze(bool frozen)
		{
			Player localRig = LocalRig;
			if (!(localRig == null))
			{
				if (frozen)
				{
					Driver.BeginHold(localRig);
				}
				else
				{
					Driver.EndHold(localRig);
				}
			}
		}

		public static void SetGhostMotion(bool ghost, float gravity, float drag, float riseSpeed)
		{
			Player localRig = LocalRig;
			if (!(localRig == null))
			{
				if (ghost)
				{
					Driver.BeginGhost(localRig, gravity, drag, riseSpeed);
				}
				else
				{
					Driver.EndGhost(localRig);
				}
			}
		}

		public static bool LoadScene(string sceneName)
		{
			return SceneTransition.Go(sceneName, new SceneTransition.Options
			{
				fadeOut = 0.35f,
				fadeIn = 0.5f,
				leaveRoom = true
			});
		}

		public static IEnumerator FadeOut(float seconds)
		{
			yield return SceneTransition.FadeOut(seconds);
		}

		public static IEnumerator FadeIn(float seconds)
		{
			yield return SceneTransition.FadeIn(seconds);
		}

		public static int BuildIndexOf(string sceneName)
		{
			for (int i = 0; i < SceneManager.sceneCountInBuildSettings; i++)
			{
				if (string.Equals(Path.GetFileNameWithoutExtension(SceneUtility.GetScenePathByBuildIndex(i)), sceneName, StringComparison.OrdinalIgnoreCase))
				{
					return i;
				}
			}
			return -1;
		}

		public static void JoinPrivateRoom(string roomName, int maxPlayers, ExitGames.Client.Photon.Hashtable roomProperties)
		{
			MonkeDevNetworkingManager.JoinCrossplayPrivateRoom(roomName, maxPlayers, roomProperties);
		}

		public static void JoinPublicHub()
		{
			MonkeDevNetworkingManager.JoinCrossplayHub();
		}

		public static void Haptics(float amplitude, float duration)
		{
			AgHaptics.Both(amplitude, duration);
		}

		public static void HapticsLeft(float amplitude, float duration)
		{
			AgHaptics.Left(amplitude, duration);
		}

		public static void HapticsRight(float amplitude, float duration)
		{
			AgHaptics.Right(amplitude, duration);
		}
	}
}
