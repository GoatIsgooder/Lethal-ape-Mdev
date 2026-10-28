using System;
using System.Collections.Generic;
using GorillaLocomotion;
using UnityEngine;

namespace LethalApeR.Gameplay
{
	public static class RigHold
	{
		[Flags]
		public enum What
		{
			Gravity = 1,
			Movement = 2,
			All = 3
		}

		private sealed class Channel
		{
			public readonly What Kind;

			public readonly HashSet<object> Holders = new HashSet<object>();

			public bool Before;

			public Channel(What kind)
			{
				Kind = kind;
			}
		}

		private static readonly Channel[] Channels = new Channel[2]
		{
			new Channel(What.Gravity),
			new Channel(What.Movement)
		};

		private static readonly List<object> Gone = new List<object>();

		private static Player _rig;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				channel.Holders.Clear();
			}
			_rig = null;
			Player.Teleported -= OnTeleported;
			Player.Teleported += OnTeleported;
		}

		public static void Take(object holder, What what)
		{
			if (holder == null || !Rig(out var rig))
			{
				return;
			}
			Prune();
			Rigidbody playerRigidBody = rig.playerRigidBody;
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				if ((channel.Kind & what) != 0 && !channel.Holders.Contains(holder))
				{
					if (channel.Holders.Count == 0)
					{
						channel.Before = Read(channel.Kind, rig, playerRigidBody);
					}
					channel.Holders.Add(holder);
					Write(channel.Kind, rig, playerRigidBody, true);
				}
			}
		}

		public static void Give(object holder, What what = What.All)
		{
			if (holder == null)
			{
				return;
			}
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				if ((channel.Kind & what) != 0 && channel.Holders.Remove(holder) && channel.Holders.Count == 0)
				{
					Restore(channel);
				}
			}
			Prune();
		}

		public static bool Anyone(What what)
		{
			Prune();
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				if ((channel.Kind & what) != 0 && channel.Holders.Count > 0)
				{
					return true;
				}
			}
			return false;
		}

		public static bool Holds(object holder, What what)
		{
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				if ((channel.Kind & what) != 0 && channel.Holders.Contains(holder))
				{
					return true;
				}
			}
			return false;
		}

		private static void OnTeleported(Player rig)
		{
			Prune();
		}

		private static void Prune()
		{
			Channel[] channels = Channels;
			foreach (Channel channel in channels)
			{
				Gone.Clear();
				foreach (object holder in channel.Holders)
				{
					if (holder is UnityEngine.Object obj && !obj)
					{
						Gone.Add(holder);
					}
				}
				if (Gone.Count == 0)
				{
					continue;
				}
				foreach (object item in Gone)
				{
					channel.Holders.Remove(item);
				}
				if (channel.Holders.Count == 0)
				{
					Restore(channel);
				}
			}
			Gone.Clear();
		}

		private static bool Rig(out Player rig)
		{
			rig = (Player.HasInstance ? Player.Instance : null);
			bool flag = rig;
			if (flag && rig != _rig)
			{
				Channel[] channels = Channels;
				foreach (Channel channel in channels)
				{
					channel.Holders.Clear();
				}
				_rig = rig;
			}
			return flag;
		}

		private static void Restore(Channel channel)
		{
			if ((bool)_rig)
			{
				Write(channel.Kind, _rig, _rig.playerRigidBody, false, channel.Before);
			}
		}

		private static bool Read(What kind, Player rig, Rigidbody body)
		{
			switch (kind)
			{
			case What.Gravity:
				return true;
			case What.Movement:
				return rig.disableMovement;
			default:
				return false;
			}
		}

		private static void Write(What kind, Player rig, Rigidbody body, bool held, bool before = false)
		{
			switch (kind)
			{
			case What.Gravity:
				if ((bool)body)
				{
					body.useGravity = !held;
				}
				break;
			case What.Movement:
				rig.disableMovement = held || before;
				break;
			}
		}
	}
}
