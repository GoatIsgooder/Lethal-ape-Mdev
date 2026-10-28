using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	[Obfuscation(Exclude = true)]
	public class BtmEscapeDoor : MonoBehaviour
	{
		[Header("Exit beacon")]
		[Tooltip("Played once, flat (2D), for everyone inside the map when the door opens live.")]
		[SerializeField]
		private AudioClip exitAlarmClip;

		[SerializeField]
		[Range(0f, 1f)]
		private float exitAlarmVolume = 0.8f;

		[Tooltip("Living survivors see the open door's leaves through walls in this colour.")]
		[SerializeField]
		private Color xrayColor = new Color(0.15f, 1f, 0.42f, 1f);

		[SerializeField]
		[Range(0f, 1f)]
		private float xrayIntensity = 0.6f;

		[Tooltip("Metres from the door where the x-ray is gone (near) and at full strength (far).")]
		[SerializeField]
		private float xrayFadeNear = 3f;

		[SerializeField]
		private float xrayFadeFar = 8f;

		private static readonly int XrayIntensityId = Shader.PropertyToID("_XrayIntensity");

		private static readonly int XrayColorId = Shader.PropertyToID("_Color");

		private float _openedAt;

		private AudioSource _alarm;

		private readonly List<Renderer> _xray = new List<Renderer>(4);

		private bool _xrayBuilt;

		private bool _xrayShown;

		private MaterialPropertyBlock _xrayMpb;

		[Header("Panels (the two leaves)")]
		[Tooltip("Left door leaf. Its collider (if any) should be on the same object so it stops blocking when open.")]
		[SerializeField]
		private Transform leftPanel;

		[Tooltip("Right door leaf.")]
		[SerializeField]
		private Transform rightPanel;

		[Header("Saved poses — capture via the inspector's Edit Mode buttons")]
		[SerializeField]
		private Vector3 leftClosedPos;

		[SerializeField]
		private Vector3 leftClosedEuler;

		[SerializeField]
		private Vector3 leftOpenPos;

		[SerializeField]
		private Vector3 leftOpenEuler;

		[SerializeField]
		private Vector3 rightClosedPos;

		[SerializeField]
		private Vector3 rightClosedEuler;

		[SerializeField]
		private Vector3 rightOpenPos;

		[SerializeField]
		private Vector3 rightOpenEuler;

		[SerializeField]
		[HideInInspector]
		private bool closedPoseSaved;

		[SerializeField]
		[HideInInspector]
		private bool openPoseSaved;

		[Header("Feel")]
		[SerializeField]
		private float openDuration = 1.6f;

		[Header("Audio")]
		[Tooltip("Optional — played once when the door starts opening. Spatialize must stay 0.")]
		[SerializeField]
		private AudioSource openAudio;

		private float _openT;

		private bool _open;

		private bool _openFxPlayed;

		private float _enableTime;

		private void SoundExitAlarm()
		{
			if (exitAlarmClip == null || !LocalHeadInMap())
			{
				return;
			}
			if (_alarm == null)
			{
				_alarm = base.gameObject.AddComponent<AudioSource>();
				_alarm.playOnAwake = false;
				_alarm.spatialBlend = 0f;
				_alarm.spatialize = false;
				_alarm.dopplerLevel = 0f;
				_alarm.priority = 16;
				_alarm.bypassReverbZones = true;
			}
			_alarm.PlayOneShot(exitAlarmClip, exitAlarmVolume);
		}

		private static bool LocalHeadInMap()
		{
			if (BTMGameManager.Instance == null || !BTMGameManager.Instance.roomProperties.roundActive)
			{
				return false;
			}
			if (!TryGetLocalHead(out var head))
			{
				return false;
			}
			return !BtmSpawnArea.Contains(head);
		}

		private static bool TryGetLocalHead(out Vector3 head)
		{
			if (GorillaLocomotion.Player.HasInstance && GorillaLocomotion.Player.Instance.headCollider != null)
			{
				head = GorillaLocomotion.Player.Instance.headCollider.transform.position;
				return true;
			}
			Camera main = Camera.main;
			head = ((main != null) ? main.transform.position : Vector3.zero);
			return main != null;
		}

		private void UpdateXray()
		{
			if (!_open || !BTMGameManager.IsLocalSurvivor() || !TryGetLocalHead(out var head))
			{
				HideXray();
				return;
			}
			float num = Mathf.InverseLerp(xrayFadeNear, xrayFadeFar, Vector3.Distance(head, base.transform.position));
			float num2 = Mathf.Clamp01((Time.time - _openedAt) / 0.6f);
			float num3 = Mathf.Sin(Time.time * 2.6f) * 0.2f + 0.8f;
			float num4 = xrayIntensity * num * num2 * num3;
			if (num4 <= 0.001f || !BuildXray())
			{
				HideXray();
				return;
			}
			if (_xrayMpb == null)
			{
				_xrayMpb = new MaterialPropertyBlock();
			}
			for (int i = 0; i < _xray.Count; i++)
			{
				Renderer renderer = _xray[i];
				if (!(renderer == null))
				{
					renderer.GetPropertyBlock(_xrayMpb);
					_xrayMpb.SetColor(XrayColorId, xrayColor);
					_xrayMpb.SetFloat(XrayIntensityId, num4);
					renderer.SetPropertyBlock(_xrayMpb);
					if (!renderer.enabled)
					{
						renderer.enabled = true;
					}
				}
			}
			_xrayShown = true;
		}

		private void HideXray()
		{
			if (!_xrayShown)
			{
				return;
			}
			_xrayShown = false;
			for (int i = 0; i < _xray.Count; i++)
			{
				if (_xray[i] != null)
				{
					_xray[i].enabled = false;
				}
			}
		}

		private bool BuildXray()
		{
			if (!_xrayBuilt)
			{
				Material material = ((BtmPingSystem.Instance != null) ? BtmPingSystem.Instance.XrayMaterial : null);
				if (material == null)
				{
					return false;
				}
				_xrayBuilt = true;
				AddXray(leftPanel, material);
				AddXray(rightPanel, material);
			}
			return _xray.Count > 0;
		}

		private void AddXray(Transform leaf, Material material)
		{
			if (leaf == null)
			{
				return;
			}
			MeshRenderer[] componentsInChildren = leaf.GetComponentsInChildren<MeshRenderer>(true);
			foreach (MeshRenderer meshRenderer in componentsInChildren)
			{
				if (meshRenderer.isPartOfStaticBatch)
				{
					continue;
				}
				MeshFilter component = meshRenderer.GetComponent<MeshFilter>();
				if (!(component == null) && !(component.sharedMesh == null))
				{
					GameObject gameObject = new GameObject("ExitXray");
					gameObject.layer = meshRenderer.gameObject.layer;
					gameObject.transform.SetParent(meshRenderer.transform, false);
					gameObject.AddComponent<MeshFilter>().sharedMesh = component.sharedMesh;
					MeshRenderer meshRenderer2 = gameObject.AddComponent<MeshRenderer>();
					Material[] array = new Material[Mathf.Max(1, component.sharedMesh.subMeshCount)];
					for (int j = 0; j < array.Length; j++)
					{
						array[j] = material;
					}
					meshRenderer2.sharedMaterials = array;
					meshRenderer2.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
					meshRenderer2.receiveShadows = false;
					meshRenderer2.lightProbeUsage = UnityEngine.Rendering.LightProbeUsage.Off;
					meshRenderer2.reflectionProbeUsage = UnityEngine.Rendering.ReflectionProbeUsage.Off;
					meshRenderer2.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
					meshRenderer2.enabled = false;
					_xray.Add(meshRenderer2);
				}
			}
		}

		private void Awake()
		{
			if (!closedPoseSaved)
			{
				if (leftPanel != null)
				{
					leftClosedPos = leftPanel.localPosition;
					leftClosedEuler = leftPanel.localEulerAngles;
				}
				if (rightPanel != null)
				{
					rightClosedPos = rightPanel.localPosition;
					rightClosedEuler = rightPanel.localEulerAngles;
				}
				Debug.LogWarning("[BtmEscapeDoor] CLOSED pose never saved — using the panels' scene placement. Select the door and use ENTER EDIT MODE → Save CLOSED Pose.", this);
			}
			if (!openPoseSaved)
			{
				leftOpenPos = leftClosedPos;
				leftOpenEuler = leftClosedEuler;
				rightOpenPos = rightClosedPos;
				rightOpenEuler = rightClosedEuler;
				Debug.LogWarning("[BtmEscapeDoor] OPEN pose never saved — the door will not visibly move. Select the door and use ENTER EDIT MODE → Save OPEN Pose.", this);
			}
		}

		private void OnEnable()
		{
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager instance = BTMGameManager.Instance;
				instance.OnAllGeneratorsPowered = (System.Action)System.Delegate.Combine(instance.OnAllGeneratorsPowered, new System.Action(OnAllPowered));
				instance.OnRoundPropertiesChanged = (System.Action<RoundProperties>)System.Delegate.Combine(instance.OnRoundPropertiesChanged, new System.Action<RoundProperties>(OnPropsChanged));
			}
			_enableTime = Time.time;
			_open = ComputeShouldBeOpen();
			_openFxPlayed = _open;
			_openT = (_open ? 1f : 0f);
			_openedAt = Time.time;
			ApplyPanels();
		}

		private void OnDisable()
		{
			if (BTMGameManager.Instance != null)
			{
				BTMGameManager instance = BTMGameManager.Instance;
				instance.OnAllGeneratorsPowered = (System.Action)System.Delegate.Remove(instance.OnAllGeneratorsPowered, new System.Action(OnAllPowered));
				instance.OnRoundPropertiesChanged = (System.Action<RoundProperties>)System.Delegate.Remove(instance.OnRoundPropertiesChanged, new System.Action<RoundProperties>(OnPropsChanged));
			}
			HideXray();
		}

		private void OnAllPowered()
		{
			if (!_open)
			{
				_open = true;
				_openedAt = Time.time;
				if (Time.time - _enableTime < 2f)
				{
					_openT = 1f;
					_openFxPlayed = true;
					ApplyPanels();
				}
				else
				{
					PlayOpenFx();
				}
			}
		}

		private void OnPropsChanged(RoundProperties props)
		{
			bool flag = ComputeShouldBeOpen();
			if (flag != _open)
			{
				_open = flag;
				if (flag)
				{
					_openedAt = Time.time;
					PlayOpenFx();
				}
				else
				{
					_openFxPlayed = false;
				}
			}
		}

		private void PlayOpenFx()
		{
			if (!_openFxPlayed)
			{
				_openFxPlayed = true;
				if (openAudio != null && openAudio.clip != null)
				{
					openAudio.Play();
				}
				SoundExitAlarm();
			}
		}

		private static bool ComputeShouldBeOpen()
		{
			if (BTMGameManager.Instance == null)
			{
				return false;
			}
			if (!RoundProps.TryRead(out var props) || !props.roundActive)
			{
				return false;
			}
			if (!BTMGameManager.Instance.TryGetGeneratorProgress(out var powered, out var total))
			{
				return false;
			}
			if (total >= 1)
			{
				return powered == total;
			}
			return false;
		}

		private void Update()
		{
			UpdateXray();
			float num = (_open ? 1f : 0f);
			if (!Mathf.Approximately(_openT, num))
			{
				_openT = Mathf.MoveTowards(_openT, num, Time.deltaTime / Mathf.Max(0.05f, openDuration));
				ApplyPanels();
			}
		}

		private void ApplyPanels()
		{
			float t = Mathf.SmoothStep(0f, 1f, _openT);
			if (leftPanel != null)
			{
				leftPanel.localPosition = Vector3.Lerp(leftClosedPos, leftOpenPos, t);
				leftPanel.localRotation = Quaternion.Slerp(Quaternion.Euler(leftClosedEuler), Quaternion.Euler(leftOpenEuler), t);
			}
			if (rightPanel != null)
			{
				rightPanel.localPosition = Vector3.Lerp(rightClosedPos, rightOpenPos, t);
				rightPanel.localRotation = Quaternion.Slerp(Quaternion.Euler(rightClosedEuler), Quaternion.Euler(rightOpenEuler), t);
			}
		}

		private void OnTriggerStay(Collider other)
		{
			if (!(_openT < 0.6f) && other.CompareTag("MainCamera") && !(BTMGameManager.Instance == null) && BTMGameManager.IsLocalSurvivor())
			{
				BTMGameManager.Instance.RequestEscape();
			}
		}
	}
}
