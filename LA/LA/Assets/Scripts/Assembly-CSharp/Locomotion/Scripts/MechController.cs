using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;

namespace Locomotion.Scripts
{
	public class MechController : MonoBehaviour
	{
		[Header("Frame")]
		public Transform cockpit;

		[Header("Left side")]
		public MechArm leftArm;

		public Transform leftHandle;

		public MechHandleAnchor leftAnchor;

		[Header("Right side")]
		public MechArm rightArm;

		public Transform rightHandle;

		public MechHandleAnchor rightAnchor;

		[Header("Climb (spherecast locomotion)")]
		[Tooltip("Drive the pilot by gripping the world with the fists. Off = arms move but you don't.")]
		public bool climbLocomotion = true;

		[Tooltip("Sphere radius around the fist used to detect a grippable surface.")]
		public float gripCheckRadius = 0.25f;

		[Tooltip("Layers you can grip/climb. Leave empty to use the pilot's locomotionEnabledLayers.")]
		public LayerMask climbLayers;

		[Tooltip("Cap on climb-driven speed (m/s) — bounds the launch.")]
		public float maxClimbSpeed = 14f;

		[Header("Misc")]
		[Tooltip("Stop the arms physically colliding with the pilot/handles/cockpit/each other. Arms still rest on the world.")]
		public bool ignoreSelfCollisions = true;

		private GrabInteractor[] _interactors;

		private float _nextInteractorRefresh;

		private const float InteractorRefreshInterval = 1f;

		private Rigidbody _leftHandleRb;

		private Rigidbody _rightHandleRb;

		private GrabInteractor _leftHolder;

		private GrabInteractor _rightHolder;

		private Player _wiredPlayer;

		private bool _leftGrip;

		private bool _rightGrip;

		private Vector3 _leftAnchor;

		private Vector3 _rightAnchor;

		private void Awake()
		{
			if (leftHandle != null)
			{
				leftHandle.TryGetComponent<Rigidbody>(out _leftHandleRb);
			}
			if (rightHandle != null)
			{
				rightHandle.TryGetComponent<Rigidbody>(out _rightHandleRb);
			}
		}

		private void OnEnable()
		{
			RefreshInteractors(force: true);
			_wiredPlayer = null;
			_leftGrip = (_rightGrip = false);
		}

		private void OnDisable()
		{
			if (leftArm != null)
			{
				leftArm.Disengage();
			}
			if (rightArm != null)
			{
				rightArm.Disengage();
			}
			if (leftAnchor != null)
			{
				leftAnchor.Held = false;
			}
			if (rightAnchor != null)
			{
				rightAnchor.Held = false;
			}
			_leftHolder = (_rightHolder = null);
			_wiredPlayer = null;
			_leftGrip = (_rightGrip = false);
		}

		private void Update()
		{
			Player player = (Player.HasInstance ? Player.Instance : null);
			if (player != null && player != _wiredPlayer)
			{
				if (ignoreSelfCollisions)
				{
					SetupIgnores(player);
				}
				_wiredPlayer = player;
			}
			if (Time.time >= _nextInteractorRefresh)
			{
				RefreshInteractors(force: false);
			}
			UpdateSide(leftHandle, _leftHandleRb, leftArm, leftAnchor, ref _leftHolder);
			UpdateSide(rightHandle, _rightHandleRb, rightArm, rightAnchor, ref _rightHolder);
		}

		private void FixedUpdate()
		{
			if (!climbLocomotion || !Player.HasInstance)
			{
				_leftGrip = (_rightGrip = false);
				return;
			}
			Rigidbody playerRigidBody = Player.Instance.playerRigidBody;
			if (playerRigidBody == null || playerRigidBody.isKinematic)
			{
				_leftGrip = (_rightGrip = false);
				return;
			}
			int mask = ((climbLayers.value != 0) ? climbLayers.value : Player.Instance.locomotionEnabledLayers.value);
			float radius = gripCheckRadius * Player.Instance.CurrentScale;
			bool flag = IsGripping(leftArm, _leftHolder, mask, radius);
			bool flag2 = IsGripping(rightArm, _rightHolder, mask, radius);
			if (flag != _leftGrip || flag2 != _rightGrip)
			{
				_leftGrip = flag;
				_rightGrip = flag2;
				if (flag)
				{
					_leftAnchor = _leftHolder.palm.position;
				}
				if (flag2)
				{
					_rightAnchor = _rightHolder.palm.position;
				}
				if (flag || flag2)
				{
					playerRigidBody.linearVelocity = Vector3.zero;
				}
			}
			else if (flag || flag2)
			{
				Vector3 zero = Vector3.zero;
				int num = 0;
				if (flag)
				{
					zero += _leftAnchor - _leftHolder.palm.position;
					num++;
				}
				if (flag2)
				{
					zero += _rightAnchor - _rightHolder.palm.position;
					num++;
				}
				Vector3 linearVelocity = zero / num / Time.fixedDeltaTime;
				if (linearVelocity.sqrMagnitude > maxClimbSpeed * maxClimbSpeed)
				{
					linearVelocity = linearVelocity.normalized * maxClimbSpeed;
				}
				playerRigidBody.linearVelocity = linearVelocity;
			}
		}

		private bool IsGripping(MechArm arm, GrabInteractor holder, int mask, float radius)
		{
			if (arm == null || holder == null || holder.palm == null)
			{
				return false;
			}
			return Physics.CheckSphere(arm.GripPoint.position, radius, mask, QueryTriggerInteraction.Ignore);
		}

		private void UpdateSide(Transform handle, Rigidbody handleRb, MechArm arm, MechHandleAnchor anchor, ref GrabInteractor holder)
		{
			GrabInteractor grabInteractor = FindHolder(handle, handleRb);
			if (grabInteractor != holder)
			{
				holder = grabInteractor;
				if (arm != null)
				{
					if (grabInteractor != null)
					{
						arm.Engage(grabInteractor.palm);
					}
					else
					{
						arm.Disengage();
					}
				}
			}
			if (anchor != null)
			{
				anchor.Held = grabInteractor != null;
			}
		}

		private GrabInteractor FindHolder(Transform handle, Rigidbody handleRb)
		{
			if (handle == null)
			{
				return null;
			}
			if (_interactors == null)
			{
				return null;
			}
			for (int i = 0; i < _interactors.Length; i++)
			{
				GrabInteractor grabInteractor = _interactors[i];
				if (!(grabInteractor == null) && grabInteractor.IsGrabbing)
				{
					if (grabInteractor.HeldTransform == handle)
					{
						return grabInteractor;
					}
					if (handleRb != null && grabInteractor.HeldRigidbody == handleRb)
					{
						return grabInteractor;
					}
				}
			}
			return null;
		}

		private void RefreshInteractors(bool force)
		{
			_nextInteractorRefresh = Time.time + InteractorRefreshInterval;
			if (!force && _interactors != null)
			{
				bool flag = false;
				for (int i = 0; i < _interactors.Length; i++)
				{
					if (_interactors[i] == null)
					{
						flag = true;
						break;
					}
				}
				if (!flag)
				{
					return;
				}
			}
			_interactors = Object.FindObjectsByType<GrabInteractor>(FindObjectsSortMode.None);
		}

		private void SetupIgnores(Player p)
		{
			HashSet<Collider> hashSet = new HashSet<Collider>();
			AddColliders((leftArm != null) ? leftArm.transform : null, hashSet);
			AddColliders((rightArm != null) ? rightArm.transform : null, hashSet);
			AddColliders(cockpit, hashSet);
			if (p != null)
			{
				if (p.headCollider != null)
				{
					hashSet.Add(p.headCollider);
				}
				if (p.bodyCollider != null)
				{
					hashSet.Add(p.bodyCollider);
				}
			}
			if (_interactors != null)
			{
				GrabInteractor[] interactors = _interactors;
				foreach (GrabInteractor grabInteractor in interactors)
				{
					if (grabInteractor != null)
					{
						AddColliders(grabInteractor.transform, hashSet);
					}
				}
			}
			List<Collider> list = new List<Collider>(hashSet);
			for (int j = 0; j < list.Count; j++)
			{
				for (int k = j + 1; k < list.Count; k++)
				{
					Physics.IgnoreCollision(list[j], list[k], ignore: true);
				}
			}
		}

		private static void AddColliders(Transform t, HashSet<Collider> into)
		{
			if (!(t == null))
			{
				Collider[] componentsInChildren = t.GetComponentsInChildren<Collider>();
				foreach (Collider item in componentsInChildren)
				{
					into.Add(item);
				}
			}
		}
	}
}
