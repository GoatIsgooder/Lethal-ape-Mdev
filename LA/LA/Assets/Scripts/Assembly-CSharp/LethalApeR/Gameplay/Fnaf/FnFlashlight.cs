using ExitGames.Client.Photon;
using Photon.Pun;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnFlashlight : MonoBehaviour
	{
		[Tooltip("The spot light. Parent it anywhere; it is placed on the right hand each frame.")]
		public Light beam;

		[Tooltip("Wrist toggle, placed on the right wrist each frame.")]
		public FnButton wristButton;

		public Vector3 beamLocalOffset = new Vector3(0f, 0f, 0.08f);

		public Vector3 wristLocalOffset = new Vector3(0f, 0.035f, -0.07f);

		public Vector3 wristLocalEuler = new Vector3(-90f, 0f, 0f);

		[Tooltip("Optional binding: right controller primary button toggles too.")]
		public bool bindPrimaryButton = true;

		private bool _wantOn;

		private bool _published;

		private bool _sentValue;

		private float _sentAt;

		private bool _lastButton;

		private int _lastNightStamp;

		public static bool LocalBeamOn { get; private set; }

		public static float Charge01 { get; private set; } = 1f;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			LocalBeamOn = false;
			Charge01 = 1f;
		}

		private void OnEnable()
		{
			if (wristButton != null)
			{
				wristButton.Pressed += OnWrist;
			}
		}

		private void OnDisable()
		{
			if (wristButton != null)
			{
				wristButton.Pressed -= OnWrist;
			}
			_wantOn = false;
			Apply(on: false);
		}

		private void OnWrist(bool isLeft)
		{
			Toggle();
		}

		public void Toggle()
		{
			FnNight instance = FnNight.Instance;
			if (instance == null || !instance.LocalIsAlive)
			{
				return;
			}
			if (!_wantOn && Charge01 <= 0f)
			{
				FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.flashlightDead : null, 0.7f);
				return;
			}
			_wantOn = !_wantOn;
			FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.flashlightClick : null, 0.6f);
		}

		private void LateUpdate()
		{
			FnNight instance = FnNight.Instance;
			bool flag = !(instance != null) || !instance.LocalIsAlive || instance.Phase == FnPhase.Gathering || instance.Phase >= FnPhase.Dawn;
			if (flag)
			{
				_wantOn = false;
			}
			int num = ((instance != null) ? ((int)instance.PhaseStart) : 0);
			if (instance != null && instance.Phase == FnPhase.Briefing && num != _lastNightStamp)
			{
				_lastNightStamp = num;
				Charge01 = 1f;
			}
			if (!flag && bindPrimaryButton)
			{
				bool rightPrimaryButton = FnPlatform.RightPrimaryButton;
				if (rightPrimaryButton && !_lastButton)
				{
					Toggle();
				}
				_lastButton = rightPrimaryButton;
			}
			FnSettings.FlashlightSettings flashlight = FnGame.Settings.flashlight;
			if (!flag && instance.LocalHeadInOffice())
			{
				Charge01 = Mathf.Min(1f, Charge01 + flashlight.officeRechargePerSecond * Time.deltaTime);
			}
			if (_wantOn)
			{
				Charge01 = Mathf.Max(0f, Charge01 - Time.deltaTime / Mathf.Max(1f, flashlight.batterySeconds));
				if (Charge01 <= 0f)
				{
					_wantOn = false;
					FnAudio.Flat((FnGame.Audio != null) ? FnGame.Audio.flashlightDead : null, 0.7f);
				}
			}
			Place(flashlight);
			Apply(_wantOn);
		}

		private void Place(FnSettings.FlashlightSettings s)
		{
			Transform rightHand = FnPlatform.RightHand;
			if (rightHand == null)
			{
				return;
			}
			if (beam != null)
			{
				beam.transform.SetPositionAndRotation(rightHand.TransformPoint(beamLocalOffset), rightHand.rotation);
				beam.range = s.range;
				beam.spotAngle = s.spotAngle;
				beam.intensity = s.intensity;
			}
			if (wristButton != null)
			{
				bool flag = FnNight.Instance != null && FnNight.Instance.LocalIsAlive;
				if (wristButton.gameObject.activeSelf != flag)
				{
					wristButton.gameObject.SetActive(flag);
				}
				wristButton.transform.SetPositionAndRotation(rightHand.TransformPoint(wristLocalOffset), rightHand.rotation * Quaternion.Euler(wristLocalEuler));
				wristButton.SetLit(_wantOn);
			}
		}

		private void Apply(bool on)
		{
			LocalBeamOn = on;
			if (beam != null && beam.enabled != on)
			{
				beam.enabled = on;
			}
			if (PhotonNetwork.InRoom && FnProps.PlayerBool(PhotonNetwork.LocalPlayer, "fnFl") != on && (!_published || _sentValue != on || !(Time.unscaledTime - _sentAt < 1f)))
			{
				_sentValue = on;
				_published = true;
				_sentAt = Time.unscaledTime;
				FnProps.WriteLocal(new Hashtable { ["fnFl"] = on });
			}
		}
	}
}
