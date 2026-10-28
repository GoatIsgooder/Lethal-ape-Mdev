using System.Collections;
using System.Collections.Generic;
using GorillaLocomotion;
using LethalApeR.Gameplay.Monsters;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Backrooms
{
	public class StillLifeEntity : MonoBehaviour
	{
		[Tooltip("Unique, stable index across clients. Set by the editor builder.")]
		[SerializeField]
		private int watcherIndex;

		[SerializeField]
		private BackroomsConfig config;

		[Header("Stare (cosmetic)")]
		[Tooltip("The bone/transform that rotates to face the nearest player. Usually the head.")]
		[SerializeField]
		private Transform head;

		[Tooltip("How fast the head turns to track.")]
		[SerializeField]
		private float stareTurnSpeed = 5f;

		[Tooltip("If true the head only yaws (stays upright); if false it aims fully.")]
		[SerializeField]
		private bool stareYawOnly = true;

		[Header("Scream FX (host-triggered, plays on all clients)")]
		[SerializeField]
		private AudioSource screamSource;

		[SerializeField]
		private AudioClip screamClip;

		[Header("Scream blend shape (e.g. MouthOpen)")]
		[Tooltip("The SkinnedMeshRenderer carrying the scream blend shape (the face/body mesh).")]
		[SerializeField]
		private SkinnedMeshRenderer screamRenderer;

		[Tooltip("Index of the blend shape driven on scream. 1 = the SECOND shape (MouthOpen).")]
		[SerializeField]
		private int screamBlendShapeIndex = 1;

		[Tooltip("Peak weight the blend shape is driven to (Unity allows >100).")]
		[SerializeField]
		private float screamBlendMax = 400f;

		[Header("Procedural body reaction (optional, on top of the blend shape)")]
		[Tooltip("Also do a small scale-punch + lunge toward the player on scream.")]
		[SerializeField]
		private bool proceduralScream = true;

		[SerializeField]
		private float screamPunchScale = 1.15f;

		[SerializeField]
		private float screamLungeDistance = 0.2f;

		[SerializeField]
		private float screamReactionDuration = 0.7f;

		private float _localReportCooldownUntil;

		private Vector3 _baseScale = Vector3.one;

		private Vector3 _basePos;

		private Coroutine _screamFx;

		private void Awake()
		{
			_baseScale = base.transform.localScale;
			_basePos = base.transform.position;
		}

		private void OnEnable()
		{
			BackroomsEvents.OnWatcherScream += HandleScream;
		}

		private void OnDisable()
		{
			BackroomsEvents.OnWatcherScream -= HandleScream;
		}

		private void Update()
		{
			TickStare();
			TickScreamDetect();
		}

		private void TickStare()
		{
			if (head == null)
			{
				return;
			}
			Transform transform = NearestPlayer((config != null) ? config.watcherStareRadius : 14f);
			if (transform == null)
			{
				return;
			}
			Vector3 forward = transform.position - head.position;
			if (stareYawOnly)
			{
				forward.y = 0f;
			}
			if (!(forward.sqrMagnitude < 0.0001f))
			{
				head.rotation = Quaternion.Slerp(head.rotation, Quaternion.LookRotation(forward), stareTurnSpeed * Time.deltaTime);
			}
		}

		private Transform NearestPlayer(float radius)
		{
			IReadOnlyList<Transform> targets = ChaseTargetRegistry.Targets;
			Transform result = null;
			float num = radius * radius;
			for (int i = 0; i < targets.Count; i++)
			{
				Transform transform = targets[i];
				if (!(transform == null))
				{
					float sqrMagnitude = (transform.position - base.transform.position).sqrMagnitude;
					if (sqrMagnitude < num)
					{
						num = sqrMagnitude;
						result = transform;
					}
				}
			}
			return result;
		}

		private void TickScreamDetect()
		{
			if (Player.Instance == null || Player.Instance.headCollider == null || Time.time < _localReportCooldownUntil)
			{
				return;
			}
			float num = ((config != null) ? config.watcherScreamRadius : 4f);
			if (!((Player.Instance.headCollider.transform.position - base.transform.position).sqrMagnitude > num * num))
			{
				_localReportCooldownUntil = Time.time + ((config != null) ? config.watcherScreamCooldown : 12f);
				int screamerActor = ((PhotonNetwork.InRoom && PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : 1);
				BackroomsMonsterDirector.Instance?.LocalReportWatcherScream(watcherIndex, base.transform.position, screamerActor);
			}
		}

		private void HandleScream(int index, Vector3 pos)
		{
			if (index != watcherIndex)
			{
				return;
			}
			if (screamSource != null)
			{
				if (screamClip != null)
				{
					screamSource.PlayOneShot(screamClip);
				}
				else if (!screamSource.isPlaying)
				{
					screamSource.Play();
				}
			}
			if (_screamFx != null)
			{
				StopCoroutine(_screamFx);
			}
			_screamFx = StartCoroutine(ScreamReaction());
		}

		private IEnumerator ScreamReaction()
		{
			bool hasBlend = screamRenderer != null && screamRenderer.sharedMesh != null && screamBlendShapeIndex >= 0 && screamBlendShapeIndex < screamRenderer.sharedMesh.blendShapeCount;
			Vector3 lungeDir = Vector3.zero;
			if (proceduralScream)
			{
				Transform transform = NearestPlayer((config != null) ? config.watcherStareRadius : 14f);
				if (transform != null)
				{
					lungeDir = transform.position - _basePos;
					lungeDir.y = 0f;
					lungeDir = ((lungeDir.sqrMagnitude > 0.0001f) ? lungeDir.normalized : Vector3.zero);
				}
			}
			Vector3 home = _basePos;
			float dur = Mathf.Max(0.1f, screamReactionDuration);
			float t = 0f;
			while (t < dur)
			{
				t += Time.deltaTime;
				float num = ScreamCurve(Mathf.Clamp01(t / dur));
				if (hasBlend)
				{
					screamRenderer.SetBlendShapeWeight(screamBlendShapeIndex, num * screamBlendMax);
				}
				if (proceduralScream)
				{
					base.transform.localScale = _baseScale * (1f + (screamPunchScale - 1f) * num);
					base.transform.position = home + lungeDir * (screamLungeDistance * num);
				}
				yield return null;
			}
			if (hasBlend)
			{
				screamRenderer.SetBlendShapeWeight(screamBlendShapeIndex, 0f);
			}
			if (proceduralScream)
			{
				base.transform.localScale = _baseScale;
				base.transform.position = home;
			}
			_screamFx = null;
		}

		private static float ScreamCurve(float u)
		{
			if (u < 0.18f)
			{
				return u / 0.18f;
			}
			if (u < 0.72f)
			{
				return 1f;
			}
			return 1f - (u - 0.72f) / 0.28f;
		}

		private void OnDrawGizmos()
		{
			float radius = ((config != null) ? config.watcherScreamRadius : 4f);
			Gizmos.color = new Color(1f, 0.2f, 0.12f, 0.9f);
			Gizmos.DrawWireSphere(base.transform.position, radius);
		}

		private void OnDrawGizmosSelected()
		{
			float radius = ((config != null) ? config.watcherStareRadius : 14f);
			Gizmos.color = new Color(1f, 0.85f, 0.2f, 0.45f);
			Gizmos.DrawWireSphere(base.transform.position, radius);
		}
	}
}
