using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public class FnHallLight : MonoBehaviour
	{
		public FnDoorSide side;

		[Tooltip("Unlit additive cone (FnLightCone shader).")]
		public Renderer cone;

		public Renderer bulb;

		[Tooltip("Optional realtime spot. Keep its range tight; it is the one hall light allowed to be realtime.")]
		public Light spot;

		[Tooltip("Realtime spot whose culling mask holds only the animatronics' layer (FnConst.MonsterRenderLayer): on whenever the light is.")]
		public Light monsterSpot;

		public Color bulbOn = new Color(1f, 0.92f, 0.7f, 1f);

		public Color bulbOff = new Color(0.05f, 0.05f, 0.05f, 1f);

		private static FnHallLight _realtimeOwner;

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private static readonly int BaseColorId = Shader.PropertyToID("_BaseColor");

		private static readonly int EmissionId = Shader.PropertyToID("_EmissionColor");

		private MaterialPropertyBlock _mpb;

		private bool _wasLit;

		private float _flickerUntil;

		private float _flickerStart;

		private int _appliedState = -1;

		public bool Lit
		{
			get
			{
				FnNight instance = FnNight.Instance;
				if (instance == null || !instance.Active || instance.Blackout)
				{
					return false;
				}
				return instance.LightOn(side);
			}
		}

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			_realtimeOwner = null;
		}

		public void Flicker()
		{
			_flickerStart = Time.time;
			_flickerUntil = Time.time + 0.5f;
		}

		private void LateUpdate()
		{
			bool lit = Lit;
			if (lit)
			{
				if (!_wasLit)
				{
					_realtimeOwner = this;
					if (FnGame.Audio != null)
					{
						FnAudio.Play(FnGame.Audio.lightOn, transform.position, 0.6f, 1f, 10f, 1f);
					}
				}
			}
			else if (_wasLit)
			{
				if (_realtimeOwner == this)
				{
					_realtimeOwner = null;
				}
				if (FnGame.Audio != null)
				{
					FnAudio.Play(FnGame.Audio.lightOff, transform.position, 0.5f, 1f, 10f, 1f);
				}
			}
			_wasLit = lit;
			bool on = lit && !(Time.time < _flickerUntil && Mathf.Repeat(Time.time - _flickerStart, 0.5f) < 0.12f);
			bool spotOn = on && _realtimeOwner == this && !FnFlashlight.LocalBeamOn;
			int state = (on ? 1 : 0) | (spotOn ? 2 : 0);
			if (state == _appliedState)
			{
				return;
			}
			_appliedState = state;
			if (cone != null)
			{
				cone.enabled = on;
			}
			if (spot != null)
			{
				spot.enabled = spotOn;
			}
			if (monsterSpot != null)
			{
				monsterSpot.enabled = on;
			}
			if (!(bulb == null))
			{
				if (_mpb == null)
				{
					_mpb = new MaterialPropertyBlock();
				}
				bulb.GetPropertyBlock(_mpb);
				Color value = on ? bulbOn : bulbOff;
				_mpb.SetColor(ColorId, value);
				_mpb.SetColor(BaseColorId, value);
				_mpb.SetColor(EmissionId, value);
				bulb.SetPropertyBlock(_mpb);
			}
		}
	}
}
