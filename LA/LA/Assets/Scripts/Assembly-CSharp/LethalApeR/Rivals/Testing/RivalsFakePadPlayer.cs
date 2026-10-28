using UnityEngine;
using UnityEngine.InputSystem;

namespace LethalApeR.Rivals.Testing
{
	public class RivalsFakePadPlayer : MonoBehaviour
	{
		[Header("Target pad")]
		[Tooltip("The pad to occupy. Leave empty to auto-pick the nearest ReadyPad to this object.")]
		public ReadyPad targetPad;

		[Tooltip("Fake actor number — MUST be negative and unique per fake player (-2, -3, …). Negative = a bot slot: it's seeded into the match room directly (it can't actually join), but you still go through the REAL leave-hub → join-match-room flow.")]
		public int fakeActor = -2;

		[Header("When to claim")]
		[Tooltip("Claim the pad automatically shortly after the scene loads.")]
		public bool claimOnStart = true;

		[Tooltip("Seconds to wait before the first claim so the pads + manager have registered.")]
		public float startDelay = 1f;

		[Tooltip("Re-claim if the pad loses our slot (e.g. after a room reset). Off = claim once.")]
		public bool keepClaimed = true;

		[Header("Hotkey (optional)")]
		[Tooltip("Toggles this fake player's claim on/off. None to disable.")]
		public Key toggleKey;

		private ReadyPad _cachedPad;

		private float _nextTry;

		private bool _wantClaimed;

		private void Start()
		{
			_wantClaimed = claimOnStart;
			_nextTry = Time.time + Mathf.Max(0f, startDelay);
		}

		private void Update()
		{
			Keyboard current = Keyboard.current;
			if (current != null && toggleKey != Key.None && current[toggleKey].wasPressedThisFrame)
			{
				ToggleClaim();
			}
			if (!_wantClaimed || Time.time < _nextTry)
			{
				return;
			}
			_nextTry = Time.time + 0.75f;
			ReadyPad readyPad = ResolvePad();
			RivalsReadyPads instance = RivalsReadyPads.Instance;
			if (!(readyPad == null) && !(instance == null))
			{
				if (readyPad.HasOccupant(fakeActor))
				{
					if (!keepClaimed)
					{
						_wantClaimed = false;
					}
				}
				else
				{
					instance.ForceOccupy(readyPad.groupId, readyPad.team, readyPad.slot, fakeActor);
				}
			}
		}

		[ContextMenu("Toggle Claim")]
		public void ToggleClaim()
		{
			_wantClaimed = !_wantClaimed;
			_nextTry = 0f;
			if (!_wantClaimed)
			{
				ReleaseNow();
			}
		}

		[ContextMenu("Claim Pad")]
		public void ClaimPad()
		{
			_wantClaimed = true;
			_nextTry = 0f;
		}

		[ContextMenu("Release Pad")]
		public void ReleasePad()
		{
			_wantClaimed = false;
			_nextTry = 0f;
			ReleaseNow();
		}

		public void SetClaimed(bool claimed)
		{
			_wantClaimed = claimed;
			_nextTry = 0f;
			if (!claimed)
			{
				ReleaseNow();
			}
		}

		private void OnDisable()
		{
			ReleaseNow();
		}

		private void ReleaseNow()
		{
			ReadyPad readyPad = ResolvePad();
			RivalsReadyPads instance = RivalsReadyPads.Instance;
			if (readyPad != null && instance != null)
			{
				instance.ForceRelease(readyPad.groupId, readyPad.team, readyPad.slot, fakeActor);
			}
		}

		private ReadyPad ResolvePad()
		{
			if (targetPad != null)
			{
				return targetPad;
			}
			if (_cachedPad != null)
			{
				return _cachedPad;
			}
			ReadyPad[] array = Object.FindObjectsOfType<ReadyPad>();
			float num = float.MaxValue;
			ReadyPad readyPad = null;
			foreach (ReadyPad readyPad2 in array)
			{
				float sqrMagnitude = (readyPad2.transform.position - base.transform.position).sqrMagnitude;
				if (sqrMagnitude < num)
				{
					num = sqrMagnitude;
					readyPad = readyPad2;
				}
			}
			_cachedPad = readyPad;
			return readyPad;
		}

		private void OnDrawGizmosSelected()
		{
			ReadyPad readyPad = ((targetPad != null) ? targetPad : _cachedPad);
			if (!(readyPad == null))
			{
				Gizmos.color = Color.yellow;
				Gizmos.DrawLine(base.transform.position, readyPad.transform.position);
			}
		}
	}
}
