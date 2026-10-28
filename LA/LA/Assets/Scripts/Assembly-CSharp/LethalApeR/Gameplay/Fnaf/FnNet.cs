using System;
using System.Diagnostics;
using ExitGames.Client.Photon;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

namespace LethalApeR.Gameplay.Fnaf
{
	public static class FnNet
	{
		private static readonly FnHandler[] Handlers = new FnHandler[256];

		private static readonly RaiseEventOptions ToOthers = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.Others
		};

		private static readonly RaiseEventOptions ToMaster = new RaiseEventOptions
		{
			Receivers = ReceiverGroup.MasterClient
		};

		private static readonly RaiseEventOptions ToActors = new RaiseEventOptions();

		private static bool _subscribed;

		[RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.SubsystemRegistration)]
		private static void ResetStatics()
		{
			Array.Clear(Handlers, 0, Handlers.Length);
			_subscribed = false;
		}

		public static void On(FnRpc id, FnHandler handler)
		{
			Subscribe();
			Handlers[(byte)id] = handler;
		}

		public static void Off(FnRpc id, FnHandler handler)
		{
			if (Handlers[(byte)id] == handler)
			{
				Handlers[(byte)id] = null;
			}
		}

		private static void Subscribe()
		{
			if (!_subscribed && PhotonNetwork.NetworkingClient != null)
			{
				PhotonNetwork.NetworkingClient.EventReceived -= OnEvent;
				PhotonNetwork.NetworkingClient.EventReceived += OnEvent;
				_subscribed = true;
			}
		}

		public static void ToAll(FnRpc id, params object[] args)
		{
			Dispatch(id, args, PhotonNetwork.LocalPlayer);
			Raise(id, args, ToOthers);
		}

		public static void ToOthersOnly(FnRpc id, params object[] args)
		{
			Raise(id, args, ToOthers);
		}

		public static void ToMasterClient(FnRpc id, params object[] args)
		{
			if (!PhotonNetwork.InRoom || PhotonNetwork.IsMasterClient)
			{
				Dispatch(id, args, PhotonNetwork.LocalPlayer);
			}
			else
			{
				Raise(id, args, ToMaster);
			}
		}

		public static void ToActorsList(int[] actors, FnRpc id, params object[] args)
		{
			if (actors == null || actors.Length == 0)
			{
				return;
			}
			int num = ((PhotonNetwork.LocalPlayer != null) ? PhotonNetwork.LocalPlayer.ActorNumber : (-1));
			int num2 = 0;
			for (int i = 0; i < actors.Length; i++)
			{
				if (actors[i] == num)
				{
					Dispatch(id, args, PhotonNetwork.LocalPlayer);
				}
				else
				{
					num2++;
				}
			}
			if (num2 == 0 || !PhotonNetwork.InRoom)
			{
				return;
			}
			int[] array = new int[num2];
			int num3 = 0;
			foreach (int num4 in actors)
			{
				if (num4 != num)
				{
					array[num3++] = num4;
				}
			}
			ToActors.TargetActors = array;
			Raise(id, args, ToActors);
		}

		public static void ToActor(int actor, FnRpc id, params object[] args)
		{
			if (PhotonNetwork.LocalPlayer != null && PhotonNetwork.LocalPlayer.ActorNumber == actor)
			{
				Dispatch(id, args, PhotonNetwork.LocalPlayer);
				return;
			}
			ToActors.TargetActors = new int[1] { actor };
			Raise(id, args, ToActors);
		}

		private static void Raise(FnRpc id, object[] args, RaiseEventOptions options)
		{
			if (PhotonNetwork.InRoom)
			{
				if (args == null)
				{
					args = Array.Empty<object>();
				}
				object[] array = new object[args.Length + 1];
				array[0] = (byte)id;
				Array.Copy(args, 0, array, 1, args.Length);
				PhotonNetwork.RaiseEvent(FnConst.WireEvent, array, options, SendOptions.SendReliable);
			}
		}

		[Conditional("UNITY_EDITOR")]
		[Conditional("DEVELOPMENT_BUILD")]
		private static void CheckWireTypes(FnRpc id, object[] args)
		{
			for (int i = 0; i < args.Length; i++)
			{
				object obj = args[i];
				if (obj != null && !(obj is byte) && !(obj is bool) && !(obj is short) && !(obj is int) && !(obj is long) && !(obj is float) && !(obj is double) && !(obj is string) && !(obj is byte[]) && !(obj is int[]) && !(obj is float[]) && !(obj is string[]) && !(obj is object[]))
				{
					UnityEngine.Debug.LogError(string.Format("[FnNet] {0} arg {1} is a {2}: Photon can't serialize it.", id, i, obj.GetType().Name));
				}
			}
		}

		private static void OnEvent(EventData e)
		{
			if (e.Code != FnConst.WireEvent || !(e.CustomData is object[] array) || array.Length < 1 || PhotonNetwork.CurrentRoom == null)
			{
				return;
			}
			Player player = PhotonNetwork.CurrentRoom.GetPlayer(e.Sender);
			if (player == null)
			{
				return;
			}
			byte id;
			try
			{
				id = Convert.ToByte(array[0]);
			}
			catch
			{
				// RE: unsure - binary has a catch-all that returns; exact extent of the try block not recoverable from the listing
				return;
			}
			object[] array2 = new object[array.Length - 1];
			Array.Copy(array, 1, array2, 0, array2.Length);
			Dispatch((FnRpc)id, array2, player);
		}

		private static void Dispatch(FnRpc id, object[] args, Player sender)
		{
			FnHandler fnHandler = Handlers[(byte)id];
			if (fnHandler == null)
			{
				return;
			}
			try
			{
				fnHandler(args ?? Array.Empty<object>(), new PhotonMessageInfo(sender, PhotonNetwork.ServerTimestamp, null));
			}
			catch (Exception ex)
			{
				UnityEngine.Debug.LogError(string.Format("[FnNet] {0} from actor {1} failed: {2}", id, (sender != null) ? sender.ActorNumber : (-1), ex));
			}
		}

		public static byte B(object o)
		{
			if (o is byte)
			{
				return (byte)o;
			}
			return Convert.ToByte(o);
		}

		public static int I(object o)
		{
			if (o is int)
			{
				return (int)o;
			}
			return Convert.ToInt32(o);
		}

		public static float F(object o)
		{
			if (o is float)
			{
				return (float)o;
			}
			return Convert.ToSingle(o);
		}

		public static bool Bool(object o)
		{
			if (o is bool)
			{
				return (bool)o;
			}
			return Convert.ToBoolean(o);
		}

		public static string S(object o)
		{
			return (o as string) ?? "";
		}
	}
}
