using System.Reflection;
using UnityEngine;

namespace LethalApeR.Vehicles
{
	[Obfuscation(Exclude = true)]
	[DisallowMultipleComponent]
	public class ForkliftSeat : VehicleSeat
	{
		[Header("References")]
		[SerializeField]
		private ForkliftController controller;

		protected override IVehicleSeatHost Host => controller;

		protected override void Awake()
		{
			if (controller == null)
			{
				controller = GetComponent<ForkliftController>();
			}
			base.Awake();
		}
	}
}
