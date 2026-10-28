using System.Collections;
using GorillaLocomotion;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR
{
	public class BreakableGlass : MonoBehaviour
	{
		public const float breakForce = 1f;

		private const float RespawnDelay = 30f;

		public GameObject vfxPrefab;

		private Renderer pane;

		private BoxCollider frame;

		private bool shattered;

		private void Start()
		{
			frame = GetComponent<BoxCollider>();
			pane = GetComponent<Renderer>();
		}

		[ContextMenu("test break glass")]
		public void BreakGlass()
		{
			if (!shattered)
			{
				shattered = true;
				pane.enabled = false;
				frame.enabled = false;
				SpawnShards();
				StartCoroutine(RestoreLater());
			}
		}

		private void OnTriggerEnter(Collider other)
		{
			if (!shattered && CanBeBrokenBy(other))
			{
				BreakGlass();
			}
		}

		private static bool CanBeBrokenBy(Collider other)
		{
			if (other.CompareTag("controller") || other.CompareTag("MainCamera"))
			{
				return Player.Instance.playerRigidBody.linearVelocity.magnitude >= 1f;
			}
			if (other.CompareTag("ChaseTag"))
			{
				return !other.GetComponentInParent<PhotonView>().IsMine;
			}
			return false;
		}

		private void SpawnShards()
		{
			if (Object.Instantiate(vfxPrefab, base.transform.position - frame.center, Quaternion.identity).TryGetComponent<ParticleSystem>(out var component))
			{
				ParticleSystem.ShapeModule shape = component.shape;
				shape.shapeType = ParticleSystemShapeType.Box;
				shape.scale = Vector3.Scale(frame.size, base.transform.lossyScale);
				shape.position = Vector3.zero;
				component.Play();
			}
		}

		private IEnumerator RestoreLater()
		{
			yield return new WaitForSeconds(30f);
			pane.enabled = true;
			frame.enabled = true;
			shattered = false;
		}
	}
}
