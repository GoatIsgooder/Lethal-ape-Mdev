using UnityEngine;
using UnityEngine.XR;

public class GrappleGunController : MonoBehaviour
{
	private enum GrappleState
	{
		Ready = 0,
		Flying = 1,
		Latched = 2
	}

	[Header("Script written by ElmoPM - Use credit.")]
	[Space(4f)]
	[Header("Main References")]
	public Transform gorillaPlayer;

	public Transform hookBone;

	public BoxCollider hookCollider;

	[Header("Launch Direction")]
	public Transform launchDirectionSource;

	[Header("Hook Movement")]
	public float launchSpeed = 25f;

	public float fallSpeed = 9.81f;

	public float maxHookDistance = 60f;

	[Header("Hook Visual Rotation Offset")]
	[Tooltip("Rotation offset used while the hook is flying.")]
	public Vector3 hookRotationOffset;

	[Tooltip("Rotation offset used after the hook has latched onto something.")]
	public Vector3 landedHookRotationOffset;

	[Header("Extra Hook Bones")]
	public Transform extraBone1;

	public Vector3 extraBone1ShotRotation;

	public Transform extraBone2;

	public Vector3 extraBone2ShotRotation;

	public Transform extraBone3;

	public Vector3 extraBone3ShotRotation;

	public Transform extraBone4;

	public Vector3 extraBone4ShotRotation;

	[Header("Latch Settings")]
	public LayerMask latchLayers = -1;

	public float surfaceOffset = 0.03f;

	public float boxCastShrink = 0.95f;

	public float latchDelayAfterFire = 1f;

	[Header("Reel Yank Settings")]
	[Tooltip("How much velocity gets added per metre of distance to the hook.")]
	public float yankStrengthPerDistance = 1.5f;

	[Tooltip("Minimum yank strength no matter how close the hook is.")]
	public float minimumYankStrength = 6f;

	[Tooltip("Maximum yank strength so it doesn't become ridiculous.")]
	public float maximumYankStrength = 30f;

	[Header("Gun Audio")]
	public AudioSource gunAudioSource;

	public AudioClip shootSound;

	public AudioClip reelSound;

	[Header("Hook Audio")]
	public AudioSource hookAudioSource;

	public AudioClip hookFlyingLoop;

	public AudioClip hookLatchSound;

	private GrappleState currentState;

	private Rigidbody playerRb;

	private Transform originalHookParent;

	private Vector3 originalHookLocalPosition;

	private Quaternion originalHookLocalRotation;

	private Vector3 originalHookLocalScale;

	private Quaternion extraBone1OriginalRotation;

	private Quaternion extraBone2OriginalRotation;

	private Quaternion extraBone3OriginalRotation;

	private Quaternion extraBone4OriginalRotation;

	private Vector3 hookVelocity;

	private Vector3 latchedPoint;

	private float ropeLength;

	private float latchDelayTimer;

	private bool previousTriggerPressed;

	private Vector3 fireStartPosition;

	private void Awake()
	{
		if (hookBone == null || hookCollider == null)
		{
			Debug.LogError("GrappleGunController: Hook bone and hook collider must be assigned.", this);
			base.enabled = false;
			return;
		}
		originalHookParent = hookBone.parent;
		originalHookLocalPosition = hookBone.localPosition;
		originalHookLocalRotation = hookBone.localRotation;
		originalHookLocalScale = hookBone.localScale;
		if (extraBone1 != null)
		{
			extraBone1OriginalRotation = extraBone1.localRotation;
		}
		if (extraBone2 != null)
		{
			extraBone2OriginalRotation = extraBone2.localRotation;
		}
		if (extraBone3 != null)
		{
			extraBone3OriginalRotation = extraBone3.localRotation;
		}
		if (extraBone4 != null)
		{
			extraBone4OriginalRotation = extraBone4.localRotation;
		}
		if (gorillaPlayer != null)
		{
			playerRb = gorillaPlayer.GetComponent<Rigidbody>() ?? gorillaPlayer.GetComponentInChildren<Rigidbody>() ?? gorillaPlayer.GetComponentInParent<Rigidbody>();
		}
	}

	private void Update()
	{
		if (GetRightTriggerDown())
		{
			SimulateTriggerPress();
		}
		if (currentState == GrappleState.Flying)
		{
			latchDelayTimer -= Time.deltaTime;
			UpdateFlyingHook(Time.deltaTime);
		}
	}

	private void FixedUpdate()
	{
		if (currentState == GrappleState.Latched)
		{
			KeepPlayerInsideRopeLength();
		}
	}

	private bool GetRightTriggerDown()
	{
		bool value = false;
		InputDevice deviceAtXRNode = InputDevices.GetDeviceAtXRNode(XRNode.RightHand);
		bool pressed = deviceAtXRNode.isValid && deviceAtXRNode.TryGetFeatureValue(CommonUsages.triggerButton, out value) && value;
		bool result = pressed && !previousTriggerPressed;
		previousTriggerPressed = pressed;
		return result;
	}

	public void SimulateTriggerPress()
	{
		if (currentState == GrappleState.Latched)
		{
			ReelInWithInstantYank();
		}
		else if (currentState == GrappleState.Flying)
		{
			ResetHookVisualOnly();
			currentState = GrappleState.Ready;
		}
		else
		{
			FireHook();
		}
	}

	private void FireHook()
	{
		Vector3 normalized = (launchDirectionSource ? launchDirectionSource : base.transform).forward.normalized;
		Vector3 position = hookBone.position;
		hookBone.SetParent(null, true);
		hookBone.position = position;
		hookBone.rotation = Quaternion.LookRotation(normalized, Vector3.up) * Quaternion.Euler(hookRotationOffset);
		ApplyShotBoneRotations();
		fireStartPosition = position;
		hookVelocity = normalized * launchSpeed;
		latchDelayTimer = latchDelayAfterFire;
		PlayOneShotWithRandomPitch(gunAudioSource, shootSound);
		PlayLoopWithRandomPitch(hookAudioSource, hookFlyingLoop);
		currentState = GrappleState.Flying;
	}

	private void UpdateFlyingHook(float dt)
	{
		Vector3 position = hookBone.position;
		hookVelocity += Vector3.down * fallSpeed * dt;
		Vector3 step = hookVelocity * dt;
		float magnitude = step.magnitude;
		if (magnitude > 0.0001f && latchDelayTimer <= 0f)
		{
			Vector3 center = hookCollider.bounds.center;
			Quaternion rotation = hookCollider.transform.rotation;
			Vector3 halfExtents = hookCollider.bounds.extents * boxCastShrink;
			if (Physics.BoxCast(center, halfExtents, step / magnitude, out var hitInfo, rotation, magnitude, latchLayers, QueryTriggerInteraction.Ignore))
			{
				hookBone.position = hitInfo.point + hitInfo.normal * surfaceOffset;
				hookBone.rotation = Quaternion.LookRotation(-hitInfo.normal, Vector3.up) * Quaternion.Euler(landedHookRotationOffset);
				latchedPoint = hookBone.position;
				ropeLength = Vector3.Distance(GetPlayerPosition(), latchedPoint);
				if ((bool)hookAudioSource)
				{
					hookAudioSource.Stop();
					hookAudioSource.loop = false;
					hookAudioSource.clip = null;
				}
				PlayOneShotWithRandomPitch(hookAudioSource, hookLatchSound);
				currentState = GrappleState.Latched;
				return;
			}
		}
		hookBone.position = position + step;
		if (hookVelocity.sqrMagnitude > 0.001f)
		{
			hookBone.rotation = Quaternion.LookRotation(hookVelocity.normalized, Vector3.up) * Quaternion.Euler(hookRotationOffset);
		}
		if (Vector3.Distance(fireStartPosition, hookBone.position) >= maxHookDistance)
		{
			ResetHookVisualOnly();
			currentState = GrappleState.Ready;
		}
	}

	private void ReelInWithInstantYank()
	{
		Vector3 vector = latchedPoint - GetPlayerPosition();
		float magnitude = vector.magnitude;
		if (magnitude > 0.0001f)
		{
			Vector3 normalized = vector.normalized;
			float num = Mathf.Clamp(magnitude * yankStrengthPerDistance, minimumYankStrength, maximumYankStrength);
			if (playerRb != null)
			{
				playerRb.AddForce(normalized * num, ForceMode.VelocityChange);
			}
			else if (gorillaPlayer != null)
			{
				gorillaPlayer.position += normalized * num * 0.02f;
			}
		}
		PlayOneShotWithRandomPitch(gunAudioSource, reelSound);
		ResetHookVisualOnly();
		currentState = GrappleState.Ready;
	}

	private void KeepPlayerInsideRopeLength()
	{
		Vector3 vector = GetPlayerPosition() - latchedPoint;
		float magnitude = vector.magnitude;
		if (!(magnitude > 0.0001f) || !(magnitude > ropeLength))
		{
			return;
		}
		Vector3 vector2 = latchedPoint + vector.normalized * ropeLength;
		if ((bool)playerRb)
		{
			playerRb.position = vector2;
			float num = Vector3.Dot(playerRb.linearVelocity, vector.normalized);
			if (num > 0f)
			{
				playerRb.linearVelocity -= num * vector.normalized;
			}
		}
		else if ((bool)gorillaPlayer)
		{
			gorillaPlayer.position = vector2;
		}
	}

	private Vector3 GetPlayerPosition()
	{
		if ((bool)playerRb)
		{
			return playerRb.position;
		}
		if ((bool)gorillaPlayer)
		{
			return gorillaPlayer.position;
		}
		return Vector3.zero;
	}

	private void ResetHookToStart()
	{
		ResetHookVisualOnly();
		currentState = GrappleState.Ready;
	}

	private void ResetHookVisualOnly()
	{
		hookVelocity = Vector3.zero;
		hookBone.SetParent(originalHookParent, false);
		hookBone.localPosition = originalHookLocalPosition;
		hookBone.localRotation = originalHookLocalRotation;
		hookBone.localScale = originalHookLocalScale;
		ResetExtraBoneRotations();
		if ((bool)hookAudioSource)
		{
			hookAudioSource.Stop();
			hookAudioSource.loop = false;
			hookAudioSource.clip = null;
		}
	}

	private void ApplyShotBoneRotations()
	{
		if (extraBone1 != null)
		{
			extraBone1.localRotation = extraBone1OriginalRotation * Quaternion.Euler(extraBone1ShotRotation);
		}
		if (extraBone2 != null)
		{
			extraBone2.localRotation = extraBone2OriginalRotation * Quaternion.Euler(extraBone2ShotRotation);
		}
		if (extraBone3 != null)
		{
			extraBone3.localRotation = extraBone3OriginalRotation * Quaternion.Euler(extraBone3ShotRotation);
		}
		if (extraBone4 != null)
		{
			extraBone4.localRotation = extraBone4OriginalRotation * Quaternion.Euler(extraBone4ShotRotation);
		}
	}

	private void ResetExtraBoneRotations()
	{
		if (extraBone1 != null)
		{
			extraBone1.localRotation = extraBone1OriginalRotation;
		}
		if (extraBone2 != null)
		{
			extraBone2.localRotation = extraBone2OriginalRotation;
		}
		if (extraBone3 != null)
		{
			extraBone3.localRotation = extraBone3OriginalRotation;
		}
		if (extraBone4 != null)
		{
			extraBone4.localRotation = extraBone4OriginalRotation;
		}
	}

	private void PlayOneShotWithRandomPitch(AudioSource source, AudioClip clip)
	{
		if (!(source == null) && !(clip == null))
		{
			source.pitch = Random.Range(0.9f, 1.1f);
			source.PlayOneShot(clip);
		}
	}

	private void PlayLoopWithRandomPitch(AudioSource source, AudioClip clip)
	{
		if (!(source == null) && !(clip == null))
		{
			source.Stop();
			source.pitch = Random.Range(0.9f, 1.1f);
			source.clip = clip;
			source.loop = true;
			source.Play();
		}
	}
}
