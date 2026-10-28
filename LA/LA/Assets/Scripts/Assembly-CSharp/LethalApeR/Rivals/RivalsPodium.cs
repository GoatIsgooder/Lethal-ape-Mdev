using System;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Rivals
{
	public class RivalsPodium : MonoBehaviour
	{
		[Header("Rig (any empty field gets a built placeholder)")]
		[Tooltip("Root of the stage geometry winners stand on.")]
		public Transform stageRoot;

		[Tooltip("Winner placement spots spread across the stage center, facing the viewers. Teammates land on distinct spots by team index.")]
		public Transform[] winnerSpawnPoints;

		[Tooltip("Stage-center pivot the cinematic camera circles and aims at.")]
		public Transform cameraOrbitCenter;

		[Header("Loser placement")]
		[Tooltip("Spacing between losers placed around the hub return point (m).")]
		public float loserSpacing = 1.1f;

		[Header("Celebration")]
		[Tooltip("Match-end sting, played 2D for everyone watching the podium. Optional.")]
		public AudioClip winStingClip;

		[Range(0f, 1f)]
		public float winStingVolume = 0.9f;

		[Header("Sky dome")]
		[Tooltip("Radius of the night-sky dome built around the stage on first show (m).")]
		public float skyDomeRadius = 40f;

		private PodiumCamera _orbitCamera;

		private AudioSource _audio;

		private GameObject _skyDome;

		private bool _shown;

		public Camera CinematicCamera => (_orbitCamera != null) ? _orbitCamera.Camera : null;

		private void Start()
		{
			RivalsPodiumBuilder.FillMissing(this);
		}

		public void Show(Team winner, Team localTeam, int localTeamIndex = 0)
		{
			RivalsPodiumBuilder.FillMissing(this);
			EnsureCelebrationRig();
			_shown = true;
			if (_skyDome == null)
			{
				_skyDome = RivalsSkyDome.Build(base.transform, StageCenter(), skyDomeRadius);
			}
			else
			{
				_skyDome.SetActive(true);
			}
			if (winStingClip != null)
			{
				_audio.PlayOneShot(winStingClip, winStingVolume);
			}
			if (localTeam != Team.None)
			{
				PlaceLocalAtHub(localTeamIndex);
				_orbitCamera.Begin(cameraOrbitCenter);
			}
		}

		public void Hide()
		{
			if (_shown)
			{
				_shown = false;
				if (_skyDome != null)
				{
					_skyDome.SetActive(false);
				}
				if (_orbitCamera != null)
				{
					_orbitCamera.End();
				}
				if (_audio != null)
				{
					_audio.Stop();
				}
			}
		}

		private void PlaceLocalAtHub(int teamIndex)
		{
			Transform transform = ((GamemodeManager.Instance != null) ? GamemodeManager.Instance.HubReturnPoint : null);
			if (!(transform == null))
			{
				teamIndex = Math.Abs(teamIndex);
				int num = teamIndex / 3;
				int num2 = teamIndex % 3 - 1;
				Vector3 position = transform.position + transform.right * (loserSpacing * (float)num2) - transform.forward * (loserSpacing * (float)num);
				Teleport(position, transform.rotation);
			}
		}

		private static void Teleport(Vector3 position, Quaternion rotation)
		{
			if (!(Player.Instance == null))
			{
				Player.Instance.TeleportPlayerRaw(position, rotation, true, true);
			}
		}

		private Vector3 StageCenter()
		{
			if (cameraOrbitCenter != null)
			{
				return cameraOrbitCenter.position;
			}
			if (stageRoot != null)
			{
				return stageRoot.position;
			}
			return base.transform.position;
		}

		private void EnsureCelebrationRig()
		{
			if (_orbitCamera == null)
			{
				GameObject gameObject = new GameObject("PodiumCamera");
				gameObject.transform.SetParent(base.transform, false);
				_orbitCamera = gameObject.AddComponent<PodiumCamera>();
			}
			if (_audio == null)
			{
				_audio = base.gameObject.AddComponent<AudioSource>();
				_audio.playOnAwake = false;
				_audio.loop = false;
				_audio.spatialBlend = 0f;
				_audio.spatialize = false;
			}
		}
	}
}
