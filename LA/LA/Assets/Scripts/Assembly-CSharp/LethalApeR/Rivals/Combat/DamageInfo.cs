using LethalApeR.Rivals.Weapons;
using UnityEngine;

namespace LethalApeR.Rivals.Combat
{
	public struct DamageInfo
	{
		public float Amount;

		public int AttackerActorNumber;

		public WeaponType WeaponType;

		public string Source;

		public Vector3 HitPoint;

		public Vector3 HitNormal;

		public bool IsHeadshot;

		public float HeadshotMultiplier;

		public float ResolvedAmount => IsHeadshot ? (Amount * Mathf.Max(1f, HeadshotMultiplier)) : Amount;

		public static DamageInfo Create(float amount, int attackerActor, WeaponType type, string source, Vector3 hitPoint, Vector3 hitNormal, bool headshot, float headshotMultiplier)
		{
			return new DamageInfo
			{
				Amount = amount,
				AttackerActorNumber = attackerActor,
				WeaponType = type,
				Source = source ?? string.Empty,
				HitPoint = hitPoint,
				HitNormal = hitNormal,
				IsHeadshot = headshot,
				HeadshotMultiplier = headshotMultiplier
			};
		}
	}
}
