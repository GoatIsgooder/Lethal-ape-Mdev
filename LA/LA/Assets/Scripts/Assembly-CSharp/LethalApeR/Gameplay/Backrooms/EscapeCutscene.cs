using System.Collections;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public class EscapeCutscene : MonoBehaviour
	{
		[Tooltip("The whole cutscene rig (peeking monster + props). Toggled on only during Escape.")]
		[SerializeField]
		private GameObject cutsceneRoot;

		[Tooltip("Animator on the peeking monster. Plays the peek/jump state via the trigger below.")]
		[SerializeField]
		private Animator cutsceneAnimator;

		[Tooltip("Trigger param that fires the peek/jump state (e.g. StillLifeGusCutscene).")]
		[SerializeField]
		private string animTrigger = "Escape";

		[Tooltip("One-shot sting/roar. Spatialize = OFF.")]
		[SerializeField]
		private AudioSource sting;

		[Tooltip("Optional: the peeking monster's head/root — kept aimed at the local player's camera for the duration.")]
		[SerializeField]
		private Transform faceAtCamera;

		[Tooltip("How long to keep facing the camera (≈ escapeCutsceneDuration).")]
		[SerializeField]
		private float faceDuration = 7f;

		private Coroutine _face;

		private void Awake()
		{
			if (cutsceneRoot != null)
			{
				cutsceneRoot.SetActive(false);
			}
		}

		private void OnEnable()
		{
			BackroomsEvents.OnStateChanged += HandleState;
		}

		private void OnDisable()
		{
			BackroomsEvents.OnStateChanged -= HandleState;
		}

		private void HandleState(BackroomsState s)
		{
			if (s != BackroomsState.Escape)
			{
				// RE: unsure - the not-Escape branch target (0x16E7F14) is missing from the dump; it sits directly before Hide() and is read as a tail call to it
				Hide();
			}
		}

		public void Play()
		{
			if (cutsceneRoot != null)
			{
				cutsceneRoot.SetActive(true);
			}
			if (cutsceneAnimator != null && !string.IsNullOrEmpty(animTrigger))
			{
				cutsceneAnimator.SetTrigger(animTrigger);
			}
			if (sting != null)
			{
				sting.Play();
			}
			if (faceAtCamera != null)
			{
				if (_face != null)
				{
					StopCoroutine(_face);
				}
				_face = StartCoroutine(FaceCameraRoutine());
			}
		}

		public void Hide()
		{
			if (_face != null)
			{
				StopCoroutine(_face);
				_face = null;
			}
			if (cutsceneRoot != null)
			{
				cutsceneRoot.SetActive(false);
			}
		}

		private IEnumerator FaceCameraRoutine()
		{
			float t = 0f;
			while (t < faceDuration)
			{
				t += Time.deltaTime;
				if (faceAtCamera != null && Player.Instance != null && Player.Instance.headCollider != null)
				{
					Vector3 to = Player.Instance.headCollider.transform.position - faceAtCamera.position;
					to.y = 0f;
					if (to.sqrMagnitude > 0.0001f)
					{
						faceAtCamera.rotation = Quaternion.Slerp(faceAtCamera.rotation, Quaternion.LookRotation(to, Vector3.up), Time.deltaTime * 6f);
					}
				}
				yield return null;
			}
			_face = null;
		}
	}
}
