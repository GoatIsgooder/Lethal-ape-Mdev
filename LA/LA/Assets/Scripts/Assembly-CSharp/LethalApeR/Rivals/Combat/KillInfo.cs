using LethalApeR.Rivals.Weapons;

namespace LethalApeR.Rivals.Combat
{
	public struct KillInfo
	{
		public PlayerHealth Victim;

		public int VictimActorNumber;

		public int KillerActorNumber;

		public WeaponType WeaponType;

		public string WeaponName;

		public bool WasHeadshot;
	}
}
