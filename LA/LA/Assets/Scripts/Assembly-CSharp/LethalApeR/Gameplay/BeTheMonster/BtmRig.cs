using System;
using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.BeTheMonster
{
	public sealed class BtmRig
	{
		private static readonly string[][] UpperNames = new string[2][]
		{
			new string[5] { "upperarm.L", "UpperArm.L", "left_arm_upper", "upperarm_L", "upper_arm.L" },
			new string[5] { "upperarm.R", "UpperArm.R", "right_arm_upper", "upperarm_R", "upper_arm.R" }
		};

		private static readonly string[][] LowerNames = new string[2][]
		{
			new string[5] { "lowerarm.L", "ForeArm.L", "left_arm_lower", "forearm.L", "lowerarm_L" },
			new string[5] { "lowerarm.R", "ForeArm.R", "right_arm_lower", "forearm.R", "lowerarm_R" }
		};

		private static readonly string[][] HandNames = new string[2][]
		{
			new string[4] { "hand.L", "Hand.L", "wrist_left", "hand_L" },
			new string[4] { "hand.R", "Hand.R", "wrist_right", "hand_R" }
		};

		public SkinnedMeshRenderer Body;

		public Transform Root;

		public Transform Torso;

		public Transform Neck;

		public Transform Head;

		public readonly Transform[] Upper = new Transform[2];

		public readonly Transform[] Lower = new Transform[2];

		public readonly Transform[] Hand = new Transform[2];

		private static readonly List<SkinnedMeshRenderer> BodyScratch = new List<SkinnedMeshRenderer>();

		public bool Valid
		{
			get
			{
				if ((bool)Torso)
				{
					return Head;
				}
				return false;
			}
		}

		public float Size
		{
			get
			{
				if (!Valid)
				{
					return 0.5f;
				}
				return Mathf.Max(Vector3.Distance(Torso.position, Head.position), 0.05f);
			}
		}

		public static SkinnedMeshRenderer FindBody(MonkeDevNetworkingPlayer player)
		{
			if (!player)
			{
				return null;
			}
			Transform transform = null;
			if (player.availablePlayerModels != null)
			{
				foreach (MonkeDevNetworkingPlayer.PlayerModelEntry availablePlayerModel in player.availablePlayerModels)
				{
					if (availablePlayerModel != null && (bool)availablePlayerModel.ModelGameObject && availablePlayerModel.ModelGameObject.activeInHierarchy)
					{
						transform = availablePlayerModel.ModelGameObject.transform;
						break;
					}
				}
			}
			if (!transform)
			{
				return null;
			}
			transform.GetComponentsInChildren(false, BodyScratch);
			SkinnedMeshRenderer result = null;
			int num = -1;
			foreach (SkinnedMeshRenderer item in BodyScratch)
			{
				if (item.enabled && (bool)item.sharedMesh && item.bones.Length != 0 && !item.name.EndsWith(" Highlight"))
				{
					int vertexCount = item.sharedMesh.vertexCount;
					if (vertexCount > num)
					{
						num = vertexCount;
						result = item;
					}
				}
			}
			BodyScratch.Clear();
			return result;
		}

		public static BtmRig Resolve(SkinnedMeshRenderer body)
		{
			BtmRig btmRig = new BtmRig();
			btmRig.Body = body;
			if (!body)
			{
				return btmRig;
			}
			Transform[] bones = body.bones;
			HashSet<Transform> hashSet = new HashSet<Transform>();
			Transform[] array = bones;
			foreach (Transform transform in array)
			{
				if ((bool)transform)
				{
					hashSet.Add(transform);
				}
			}
			btmRig.Head = Find(bones, "head") ?? Find(bones, "Head");
			if (!btmRig.Head)
			{
				array = bones;
				foreach (Transform transform2 in array)
				{
					if ((bool)transform2 && transform2.name.IndexOf("head", StringComparison.OrdinalIgnoreCase) >= 0 && !Ignored(transform2.name))
					{
						btmRig.Head = transform2;
						break;
					}
				}
			}
			if ((bool)btmRig.Head)
			{
				Transform parent = btmRig.Head.parent;
				if ((bool)parent && hashSet.Contains(parent))
				{
					Transform parent2 = parent.parent;
					if ((bool)parent2 && hashSet.Contains(parent2))
					{
						btmRig.Neck = parent;
						btmRig.Torso = parent2;
					}
					else
					{
						btmRig.Torso = parent;
					}
				}
			}
			if (!btmRig.Torso)
			{
				btmRig.Torso = body.rootBone;
			}
			btmRig.Root = btmRig.Torso;
			while ((bool)btmRig.Root && (bool)btmRig.Root.parent && hashSet.Contains(btmRig.Root.parent))
			{
				btmRig.Root = btmRig.Root.parent;
			}
			for (int j = 0; j < 2; j++)
			{
				btmRig.Upper[j] = FindAny(bones, UpperNames[j]);
				btmRig.Lower[j] = FindAny(bones, LowerNames[j]) ?? FirstSkinChild(btmRig.Upper[j], hashSet);
				btmRig.Hand[j] = FindAny(bones, HandNames[j]) ?? FirstSkinChild(btmRig.Lower[j], hashSet);
			}
			return btmRig;
		}

		private static bool Ignored(string name)
		{
			if (name.IndexOf("_end", StringComparison.OrdinalIgnoreCase) < 0 && name.IndexOf("ctrl", StringComparison.OrdinalIgnoreCase) < 0)
			{
				return name.IndexOf("target", StringComparison.OrdinalIgnoreCase) >= 0;
			}
			return true;
		}

		private static Transform Find(Transform[] bones, string name)
		{
			foreach (Transform transform in bones)
			{
				if ((bool)transform && transform.name == name)
				{
					return transform;
				}
			}
			return null;
		}

		private static Transform FindAny(Transform[] bones, string[] names)
		{
			foreach (string b in names)
			{
				foreach (Transform transform in bones)
				{
					if ((bool)transform && string.Equals(transform.name, b, StringComparison.OrdinalIgnoreCase))
					{
						return transform;
					}
				}
			}
			return null;
		}

		private static Transform FirstSkinChild(Transform bone, HashSet<Transform> set)
		{
			if (!bone)
			{
				return null;
			}
			Transform result = null;
			int num = -1;
			foreach (Transform item in bone)
			{
				if (set.Contains(item) && !Ignored(item.name))
				{
					int num2 = item.GetComponentsInChildren<Transform>(true).Length;
					if (num2 > num)
					{
						num = num2;
						result = item;
					}
				}
			}
			return result;
		}
	}
}
