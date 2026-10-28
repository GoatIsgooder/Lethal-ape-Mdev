using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using LethalApeR.Gameplay.BeTheMonster;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.LandmineSystem
{
	public class Landmine : MonoBehaviourPun
	{
		[Header("Arming")]
		[Tooltip("Seconds between the click and the explosion.")]
		public float armDelay = 2f;

		[Header("Heartbeat (local player only)")]
		public float heartbeatAmplitude = 0.8f;

		public float lubDubGap = 0.12f;

		public float beatInterval = 0.55f;

		public float heartbeatPulseDuration = 0.06f;

		[Header("Audio")]
		public AudioSource audioSource;

		public AudioClip clickClip;

		public AudioClip explosionClip;

		[Header("Explosion")]
		[Tooltip("Inactive child that gets enabled on detonation. Must have a LandmineExplosion component.")]
		public GameObject explosionObject;

		public float explosionForce = 18f;

		public float explosionRadius = 6f;

		public float upwardModifier = 1.2f;

		public float monsterStopDuration = 4f;

		public float explosionLifetime = 4f;

		[Header("Visuals")]
		[Tooltip("Mesh / collider roots that should hide once the mine detonates.")]
		public GameObject[] visualsToHide;

		[Tooltip("Transforms that depress (in world-space down) while the mine is armed, so it looks held-down.")]
		public Transform[] pressTransforms;

		public float pressDepth = 0.02f;

		public float pressDuration = 0.08f;

		private bool _armed;

		private bool _detonated;

		private bool _stepDetected;

		[HideInInspector]
		public LandmineManager manager;

		[HideInInspector]
		public int managerIndex = -1;

		private Vector3[] _pressOriginalPositions;

		private void Awake()
		{
			Collider[] componentsInChildren = GetComponentsInChildren<Collider>(true);
			foreach (Collider collider in componentsInChildren)
			{
				if (collider.isTrigger && !(collider.gameObject == base.gameObject))
				{
					LandmineTriggerForwarder landmineTriggerForwarder = collider.GetComponent<LandmineTriggerForwarder>();
					if (landmineTriggerForwarder == null)
					{
						landmineTriggerForwarder = collider.gameObject.AddComponent<LandmineTriggerForwarder>();
					}
					landmineTriggerForwarder.target = this;
				}
			}
			if (pressTransforms != null)
			{
				_pressOriginalPositions = new Vector3[pressTransforms.Length];
				for (int j = 0; j < pressTransforms.Length; j++)
				{
					if (pressTransforms[j] != null)
					{
						_pressOriginalPositions[j] = pressTransforms[j].position;
					}
				}
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			NotifyTriggerEnter(other);
		}

		public void NotifyTriggerEnter(Collider other)
		{
			if (_stepDetected || _armed || _detonated)
			{
				return;
			}
			Rigidbody attachedRigidbody = other.attachedRigidbody;
			bool flag = GorillaLocomotion.Player.Instance != null && attachedRigidbody == GorillaLocomotion.Player.Instance.playerRigidBody;
			if (other.CompareTag("HandTag") || other.CompareTag("ChaseTag") || flag)
			{
				_stepDetected = true;
				int num = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
				if (PhotonNetwork.InRoom && base.photonView != null)
				{
					base.photonView.RPC("RPC_Step", RpcTarget.All, num);
				}
				else
				{
					RPC_Step(num);
				}
			}
		}

		[PunRPC]
		[Obfuscation(Exclude = true)]
		private void RPC_Step(int steppedByActor)
		{
			if (!_armed && !_detonated)
			{
				_armed = true;
				if (audioSource != null && clickClip != null)
				{
					audioSource.PlayOneShot(clickClip, 1f);
				}
				if (PhotonNetwork.LocalPlayer.ActorNumber == steppedByActor)
				{
					StartCoroutine(HeartbeatCoroutine());
				}
				StartCoroutine(PressDownCoroutine());
				StartCoroutine(ArmCoroutine());
			}
		}

		private IEnumerator PressDownCoroutine()
		{
			if (pressTransforms == null || pressTransforms.Length == 0)
			{
				yield break;
			}
			Vector3[] starts = new Vector3[pressTransforms.Length];
			Vector3[] ends = new Vector3[pressTransforms.Length];
			Vector3 vector = base.transform.up * pressDepth;
			for (int i = 0; i < pressTransforms.Length; i++)
			{
				if (!(pressTransforms[i] == null))
				{
					starts[i] = pressTransforms[i].position;
					ends[i] = starts[i] - vector;
				}
			}
			float t = 0f;
			while (t < pressDuration && !_detonated)
			{
				t += Time.deltaTime;
				float t2 = Mathf.SmoothStep(0f, 1f, t / pressDuration);
				for (int j = 0; j < pressTransforms.Length; j++)
				{
					if (!(pressTransforms[j] == null))
					{
						pressTransforms[j].position = Vector3.Lerp(starts[j], ends[j], t2);
					}
				}
				yield return null;
			}
		}

		private IEnumerator HeartbeatCoroutine()
		{
			float endTime = Time.time + armDelay;
			while (!_detonated && Time.time < endTime)
			{
				if (VRInputController.Instance != null)
				{
					VRInputController.Instance.PulseLeft(heartbeatAmplitude, heartbeatPulseDuration);
					VRInputController.Instance.PulseRight(heartbeatAmplitude, heartbeatPulseDuration);
				}
				yield return new WaitForSeconds(lubDubGap);
				if (VRInputController.Instance != null)
				{
					VRInputController.Instance.PulseLeft(heartbeatAmplitude * 0.65f, heartbeatPulseDuration);
					VRInputController.Instance.PulseRight(heartbeatAmplitude * 0.65f, heartbeatPulseDuration);
				}
				yield return new WaitForSeconds(beatInterval);
			}
		}

		private IEnumerator ArmCoroutine()
		{
			yield return new WaitForSeconds(armDelay);
			if (!_detonated)
			{
				Detonate();
			}
		}

		private void Detonate()
		{
			_detonated = true;
			if (audioSource != null && explosionClip != null)
			{
				audioSource.PlayOneShot(explosionClip, 1f);
			}
			if (visualsToHide != null)
			{
				GameObject[] array = visualsToHide;
				foreach (GameObject gameObject in array)
				{
					if (gameObject != null)
					{
						gameObject.SetActive(false);
					}
				}
			}
			if (explosionObject != null)
			{
				explosionObject.SetActive(true);
				LandmineExplosion component = explosionObject.GetComponent<LandmineExplosion>();
				if (component != null)
				{
					component.Trigger(explosionForce, explosionRadius, upwardModifier, monsterStopDuration, explosionLifetime);
				}
			}
			if (manager != null)
			{
				manager.NotifyDetonated(managerIndex);
			}
		}

		public void ResetForRespawn()
		{
			StopAllCoroutines();
			_armed = false;
			_detonated = false;
			_stepDetected = false;
			if (visualsToHide != null)
			{
				GameObject[] array = visualsToHide;
				foreach (GameObject gameObject in array)
				{
					if (gameObject != null)
					{
						gameObject.SetActive(true);
					}
				}
			}
			if (pressTransforms != null && _pressOriginalPositions != null)
			{
				for (int j = 0; j < pressTransforms.Length && j < _pressOriginalPositions.Length; j++)
				{
					if (pressTransforms[j] != null)
					{
						pressTransforms[j].position = _pressOriginalPositions[j];
					}
				}
			}
			if (explosionObject != null)
			{
				explosionObject.SetActive(false);
			}
		}
	}
}
