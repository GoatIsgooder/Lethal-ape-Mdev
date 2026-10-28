using System.Collections.Generic;
using UnityEngine;

namespace LethalApeR.Gameplay.Banshee
{
	public sealed class BansheeRig
	{
		public sealed class Arm
		{
			public bool left;

			public Transform shoulder;

			public Transform upper;

			public Transform lower;

			public Transform hand;

			public Transform[] fingers = new Transform[0];

			public Vector3[] curlAxes = new Vector3[0];

			public Quaternion[] fingerBind = new Quaternion[0];

			public float upperLength;

			public float lowerLength;

			public Vector3 knuckleLocal;

			public Vector3 knuckleDirLocal;

			public Vector3 palmLocal;
		}

		public struct HandPose
		{
			public Vector3 point;

			public Vector3 elbow;

			public Vector3 aim;

			public Vector3 palm;

			public float curl;

			public float shrug;
		}

		public struct Pose
		{
			public Vector3 torso;

			public Vector3 neckTurn;

			public Vector3 headTurn;

			public Vector3 headPoint;

			public float lookWeight;

			public Vector3 lookAt;

			public HandPose l;

			public HandPose r;
		}

		public readonly Transform root;

		public readonly Transform neck;

		public readonly Transform neck2;

		public readonly Transform head;

		public readonly Arm left = new Arm
		{
			left = true
		};

		public readonly Arm right = new Arm
		{
			left = false
		};

		private readonly List<Transform> _bones = new List<Transform>();

		private readonly List<Quaternion> _bindRot = new List<Quaternion>();

		private readonly List<Vector3> _bindPos = new List<Vector3>();

		private readonly Quaternion _neckBindRoot;

		private readonly Vector3 _faceLocal;

		public bool Valid { get; }

		public BansheeRig(Transform modelRoot)
		{
			root = modelRoot;
			Transform armature = Find(root, "Armature");
			neck = Find(armature, "neck");
			neck2 = Find(neck, "Bone.001");
			head = Find(neck2, "head");
			if (armature == null || neck == null || neck2 == null || head == null)
			{
				return;
			}
			if (!Setup(left, "L") || !Setup(right, "R"))
			{
				return;
			}
			Transform[] componentsInChildren = armature.GetComponentsInChildren<Transform>(true);
			foreach (Transform transform in componentsInChildren)
			{
				if (!(transform == armature) && !transform.name.EndsWith("_end") && !(transform.GetComponent<Renderer>() != null))
				{
					_bones.Add(transform);
					_bindRot.Add(transform.localRotation);
					_bindPos.Add(transform.localPosition);
				}
			}
			_neckBindRoot = Quaternion.Inverse(root.rotation) * neck.rotation;
			_faceLocal = Quaternion.Inverse(head.rotation) * root.forward;
			Bind(left);
			Bind(right);
			Valid = true;
		}

		private bool Setup(Arm arm, string side)
		{
			arm.shoulder = Find(neck, "shoulder." + side);
			arm.upper = Find(arm.shoulder, "upperarm." + side);
			arm.lower = Find(arm.upper, "lowerarm." + side);
			arm.hand = Find(arm.lower, "hand." + side);
			if (arm.shoulder == null || arm.upper == null || arm.lower == null || arm.hand == null)
			{
				return false;
			}
			List<Transform> list = new List<Transform>();
			string[] array = new string[9] { "index1", "index2", "index3", "pinkie1", "pinkie2", "pinkie3", "thumb1", "thumb2", "thumb3" };
			foreach (string text in array)
			{
				Transform transform = Find(arm.hand, text + "." + side);
				if (transform != null)
				{
					list.Add(transform);
				}
			}
			arm.fingers = list.ToArray();
			return true;
		}

		private void Bind(Arm arm)
		{
			arm.upperLength = Vector3.Distance(arm.lower.position, arm.upper.position);
			arm.lowerLength = Vector3.Distance(arm.hand.position, arm.lower.position);
			Transform index = Find(arm.hand, "index1." + (arm.left ? "L" : "R"));
			Transform pinkie = Find(arm.hand, "pinkie1." + (arm.left ? "L" : "R"));
			Vector3 knuckle = ((index != null && pinkie != null) ? ((index.position + pinkie.position) * 0.5f) : (arm.hand.position + (arm.hand.position - arm.lower.position).normalized * 0.08f));
			Vector3 forward = (knuckle - arm.hand.position).normalized;
			Vector3 palm = Vector3.ProjectOnPlane(root.right * (arm.left ? 1f : (-1f)), forward).normalized;
			arm.knuckleLocal = arm.hand.InverseTransformPoint(knuckle);
			arm.knuckleDirLocal = arm.hand.InverseTransformDirection(forward).normalized;
			arm.palmLocal = arm.hand.InverseTransformDirection(palm).normalized;
			arm.curlAxes = new Vector3[arm.fingers.Length];
			arm.fingerBind = new Quaternion[arm.fingers.Length];
			for (int i = 0; i < arm.fingers.Length; i++)
			{
				Transform finger = arm.fingers[i];
				arm.fingerBind[i] = finger.localRotation;
				Transform child = ((finger.childCount > 0) ? finger.GetChild(0) : null);
				Vector3 dir = forward;
				if (child != null)
				{
					dir = (child.position - finger.position).normalized;
				}
				Vector3 reference = palm;
				if (finger.name.StartsWith("thumb"))
				{
					reference = Vector3.ProjectOnPlane(-forward, dir).normalized;
				}
				arm.curlAxes[i] = finger.InverseTransformDirection(Vector3.Cross(dir, reference).normalized).normalized;
			}
		}

		private static Transform Find(Transform parent, string name)
		{
			if (parent == null)
			{
				return null;
			}
			Transform[] componentsInChildren = parent.GetComponentsInChildren<Transform>(true);
			foreach (Transform transform in componentsInChildren)
			{
				if (transform.name == name)
				{
					return transform;
				}
			}
			return null;
		}

		private void ResetToBind()
		{
			for (int i = 0; i < _bones.Count; i++)
			{
				_bones[i].localRotation = _bindRot[i];
				_bones[i].localPosition = _bindPos[i];
			}
		}

		public void Apply(in Pose p)
		{
			if (!Valid)
			{
				return;
			}
			ResetToBind();
			Quaternion torso = root.rotation * Quaternion.Euler(p.torso);
			neck.rotation = torso * _neckBindRoot;
			Vector3 rightAxis = torso * Vector3.right;
			Vector3 upAxis = torso * Vector3.up;
			Vector3 forwardAxis = torso * Vector3.forward;
			neck2.rotation = Quaternion.AngleAxis(p.neckTurn.y, upAxis) * Quaternion.AngleAxis(p.neckTurn.x, rightAxis) * Quaternion.AngleAxis(p.neckTurn.z, forwardAxis) * neck2.rotation;
			head.rotation = Quaternion.AngleAxis(p.headTurn.y, upAxis) * Quaternion.AngleAxis(p.headTurn.x, rightAxis) * Quaternion.AngleAxis(p.headTurn.z, forwardAxis) * head.rotation;
			neck.position += root.TransformPoint(p.headPoint) - head.position;
			if (p.lookWeight > 0f)
			{
				Vector3 face = head.rotation * _faceLocal;
				Vector3 to = root.TransformPoint(p.lookAt) - head.position;
				if (to.sqrMagnitude > 1E-06f)
				{
					head.rotation = Quaternion.Slerp(Quaternion.identity, Quaternion.FromToRotation(face, to), p.lookWeight) * head.rotation;
				}
			}
			SolveArm(left, in p.l, torso);
			SolveArm(right, in p.r, torso);
		}

		private void SolveArm(Arm arm, in HandPose h, Quaternion torso)
		{
			if (Mathf.Abs(h.shrug) > 0.01f)
			{
				arm.shoulder.rotation = Quaternion.AngleAxis(0f - h.shrug, torso * Vector3.right) * arm.shoulder.rotation;
			}
			Vector3 aim = root.TransformDirection(h.aim).normalized;
			Vector3 palm = Vector3.ProjectOnPlane(root.TransformDirection(h.palm), aim).normalized;
			if (palm.sqrMagnitude < 1E-06f)
			{
				palm = Vector3.ProjectOnPlane(-root.forward, aim).normalized;
			}
			Quaternion handRot = Quaternion.LookRotation(aim, palm) * Quaternion.Inverse(Quaternion.LookRotation(arm.knuckleDirLocal, arm.palmLocal));
			Vector3 knuckleOffset = handRot * Vector3.Scale(arm.knuckleLocal, arm.hand.lossyScale);
			Vector3 wrist = root.TransformPoint(h.point) - knuckleOffset;
			Vector3 shoulderPos = arm.upper.position;
			float scale = root.lossyScale.y;
			float a = arm.upperLength * scale;
			float b = scale * arm.lowerLength;
			Vector3 delta = wrist - shoulderPos;
			float reach = Mathf.Clamp(delta.magnitude, Mathf.Abs(a - b) + 0.001f, (a + b) * 0.999f);
			Vector3 dir = ((delta.sqrMagnitude > 1E-08f) ? delta.normalized : root.forward);
			Vector3 pole = Vector3.ProjectOnPlane(root.TransformDirection(h.elbow), dir);
			if (pole.sqrMagnitude < 1E-06f)
			{
				pole = Vector3.ProjectOnPlane(-root.forward, dir);
			}
			pole = pole.normalized;
			float along = (a * a - b * b + reach * reach) / (2f * reach);
			float height = Mathf.Sqrt(Mathf.Max(0f, a * a - along * along));
			Vector3 elbow = shoulderPos + dir * along + pole * height;
			arm.upper.rotation = Quaternion.FromToRotation(arm.lower.position - shoulderPos, elbow - shoulderPos) * arm.upper.rotation;
			arm.lower.rotation = Quaternion.FromToRotation(arm.hand.position - arm.lower.position, shoulderPos + dir * reach - arm.lower.position) * arm.lower.rotation;
			arm.hand.rotation = handRot;
			for (int i = 0; i < arm.fingers.Length; i++)
			{
				float angle = (arm.fingers[i].name.StartsWith("thumb") ? 45f : 75f) * Mathf.Clamp01(h.curl);
				arm.fingers[i].localRotation = arm.fingerBind[i] * Quaternion.AngleAxis(angle, arm.curlAxes[i]);
			}
		}
	}
}
