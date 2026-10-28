using TMPro;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnCharger : MonoBehaviour
	{
		public TMP_Text label;

		public Renderer lamp;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private MaterialPropertyBlock _mpb;

		private float _nextRequest;

		private int _shownDelivered = -1;

		private bool _lampLit;

		private void LateUpdate()
		{
			FnNight night = FnNight.Instance;
			if (night == null || !night.Active)
			{
				return;
			}
			if (label != null && _shownDelivered != night.BatteriesDelivered)
			{
				_shownDelivered = night.BatteriesDelivered;
				label.text = "CHARGER\n" + _shownDelivered.ToString();
			}
			int battery = night.BatteryCarriedBy(FnGame.LocalActor);
			SetLamp(battery >= 0);
			if (battery < 0 || !night.LocalIsAlive || Time.time < _nextRequest)
			{
				return;
			}
			Transform head = FnPlatform.Head;
			float range = FnGame.Settings.tasks.chargerRange * 0.8f;
			if (!(head == null) && !((head.position - transform.position).sqrMagnitude > range * range))
			{
				_nextRequest = Time.time + 0.5f;
				night.RequestDeliverBattery(battery);
			}
		}

		private void SetLamp(bool lit)
		{
			if (!(lamp == null) && _lampLit != lit)
			{
				Color color = (lit ? new Color(1f, 0.75f, 0.1f) : new Color(0.1f, 0.08f, 0.02f));
				_lampLit = lit;
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				lamp.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, color);
				_mpb.SetColor(BaseColorId, color);
				_mpb.SetColor(EmissionId, color);
				lamp.SetPropertyBlock(_mpb);
			}
		}
	}
}
