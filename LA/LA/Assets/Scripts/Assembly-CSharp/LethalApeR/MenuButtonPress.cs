using System;
using System.Collections.Generic;
using LethalApeR.Gameplay.BeTheMonster;
using TMPro;
using UnityEngine;

namespace LethalApeR
{
	[DisallowMultipleComponent]
	public sealed class MenuButtonPress : MonoBehaviour
	{
		private sealed class Visual
		{
			public Transform transform;

			public Vector3 baseScale;

			public Vector3 pressedFactor;

			public Vector3 faceLocal;

			public Vector3 centerLocal;

			public Vector3 menuCenter;

			public Vector3 menuLong;

			public Vector3 menuShort;

			public int depthAxis;

			public int longAxis;

			public int shortAxis;

			public Renderer renderer;

			public bool hasPressProperty;

			public BoxCollider box;

			public Vector3 baseBoxSize;

			public int holders;

			public float amount;

			public float velocity;

			public float target;

			public bool moving;
		}

		private sealed class Label
		{
			public TMP_Text text;

			public Visual visual;

			public int[] materials;

			public int[] vertices;

			public Vector3[] original;

			public Vector3 center;

			public Vector3 faceInText;
		}

		private sealed class Target
		{
			public Collider collider;

			public string tag;

			public bool rightHand;

			public bool ownHaptics;

			public readonly List<Visual> visuals = new List<Visual>(3);

			public readonly List<Collider> fingers = new List<Collider>(2);

			public Label label;

			public bool labelResolved;
		}

		[Tooltip("Parents of the button visuals, one per theme. Children whose names contain \"_Btn_\" are the buttons.")]
		[SerializeField]
		private Transform[] visualRoots;

		[Tooltip("Scale of a fully pressed button. X = depth (toward the board), Y = long side, Z = short side.")]
		[SerializeField]
		private Vector3 pressedScale = new Vector3(0.4f, 0.93f, 0.9f);

		[SerializeField]
		[Min(0.001f)]
		private float pressTime = 0.025f;

		[SerializeField]
		[Min(0.001f)]
		private float releaseTime = 0.07f;

		[Tooltip("How far apart (metres, across the menu face) a collider and a visual button can be and still be the same button.")]
		[SerializeField]
		[Min(0.001f)]
		private float matchRadius = 0.02f;

		[SerializeField]
		private bool moveLabels = true;

		[SerializeField]
		private bool hapticOnPress = true;

		private static readonly int PressId = Shader.PropertyToID("_Press");

		private readonly List<Visual> _visuals = new List<Visual>(64);

		private readonly List<Target> _targets = new List<Target>(64);

		private readonly List<Visual> _moving = new List<Visual>(8);

		private readonly List<Target> _held = new List<Target>(4);

		private readonly List<Label> _labels = new List<Label>(4);

		private MaterialPropertyBlock _block;

		private MenuPressGate _gate;

		private bool _gateResolved;

		private void Awake()
		{
			_block = new MaterialPropertyBlock();
			if (visualRoots != null)
			{
				foreach (Transform root in visualRoots)
				{
					if (root == null)
					{
						continue;
					}
					for (int i = 0; i < root.childCount; i++)
					{
						Transform child = root.GetChild(i);
						if (child.name.IndexOf("_Btn_", StringComparison.Ordinal) >= 0)
						{
							_visuals.Add(CreateVisual(child, null));
						}
					}
				}
			}
			foreach (TriggerEvent trigger in GetComponentsInChildren<TriggerEvent>(true))
			{
				AddTarget(trigger.GetComponent<Collider>(), trigger.targetTag, false);
			}
			foreach (BaseButton button in GetComponentsInChildren<BaseButton>(true))
			{
				AddTarget(button.GetComponent<Collider>(), "HandTag", true);
			}
			foreach (Visual visual in _visuals)
			{
				Apply(visual);
			}
		}

		private void OnDisable()
		{
			_held.Clear();
			foreach (Target target in _targets)
			{
				target.fingers.Clear();
			}
			foreach (Visual visual in _visuals)
			{
				visual.holders = 0;
				visual.amount = 0f;
				visual.velocity = 0f;
				visual.target = 0f;
				visual.moving = false;
				Apply(visual);
			}
			foreach (Target target2 in _targets)
			{
				foreach (Visual visual2 in target2.visuals)
				{
					if (visual2.box != null)
					{
						visual2.holders = 0;
						visual2.amount = 0f;
						visual2.velocity = 0f;
						visual2.target = 0f;
						visual2.moving = false;
						Apply(visual2);
					}
				}
			}
			foreach (Label label in _labels)
			{
				Restore(label);
			}
			_labels.Clear();
			_moving.Clear();
		}

		private Visual CreateVisual(Transform t, BoxCollider box)
		{
			MeshFilter meshFilter = t.GetComponent<MeshFilter>();
			Bounds bounds = ((meshFilter != null && meshFilter.sharedMesh != null) ? meshFilter.sharedMesh.bounds : new Bounds(Vector3.zero, Vector3.one));
			Vector3 size = Vector3.Scale(bounds.size, t.localScale);
			int depth = ((size.x <= size.y && size.x <= size.z) ? 0 : ((size.y <= size.z) ? 1 : 2));
			int a = (depth + 1) % 3;
			int b = (depth + 2) % 3;
			int longAxis = ((size[a] >= size[b]) ? a : b);
			int shortAxis = ((size[a] >= size[b]) ? b : a);
			Visual visual = new Visual
			{
				transform = t,
				baseScale = t.localScale,
				depthAxis = depth,
				longAxis = longAxis,
				shortAxis = shortAxis,
				centerLocal = bounds.center,
				renderer = t.GetComponent<Renderer>(),
				box = box
			};
			visual.baseBoxSize = ((box != null) ? box.size : Vector3.zero);
			Vector3 factor = Vector3.one;
			factor[depth] = pressedScale.x;
			factor[longAxis] = pressedScale.y;
			factor[shortAxis] = pressedScale.z;
			visual.pressedFactor = factor;
			Vector3 min = bounds.min;
			Vector3 max = bounds.max;
			float faceDepth = ((Mathf.Abs(min[depth]) > Mathf.Abs(max[depth])) ? min[depth] : max[depth]);
			Vector3 face = Vector3.zero;
			face[depth] = faceDepth;
			visual.faceLocal = face;
			visual.hasPressProperty = visual.renderer != null && visual.renderer.sharedMaterial != null && visual.renderer.sharedMaterial.HasProperty(PressId);
			Matrix4x4 menu = MenuSpace(t);
			visual.menuCenter = menu.MultiplyPoint3x4(visual.centerLocal);
			visual.menuLong = menu.MultiplyVector(Axis(longAxis)).normalized;
			visual.menuShort = menu.MultiplyVector(Axis(shortAxis)).normalized;
			return visual;
		}

		private Matrix4x4 MenuSpace(Transform t)
		{
			Matrix4x4 m = Matrix4x4.identity;
			while (t != null && t != transform)
			{
				m = Matrix4x4.TRS(t.localPosition, t.localRotation, t.localScale) * m;
				t = t.parent;
			}
			return m;
		}

		private void AddTarget(Collider col, string tag, bool ownHaptics)
		{
			if (col == null || string.IsNullOrEmpty(tag))
			{
				return;
			}
			Target target = new Target
			{
				collider = col,
				tag = tag,
				rightHand = tag != "LFinger",
				ownHaptics = ownHaptics
			};
			MeshRenderer meshRenderer = col.GetComponent<MeshRenderer>();
			if (meshRenderer != null && meshRenderer.enabled && col is BoxCollider box)
			{
				target.visuals.Add(CreateVisual(col.transform, box));
			}
			else
			{
				Vector3 center = ColliderCenter(col);
				if (visualRoots != null)
				{
					foreach (Transform root in visualRoots)
					{
						Visual best = null;
						float bestDistance = matchRadius;
						foreach (Visual visual in _visuals)
						{
							if (!(visual.transform.parent != root))
							{
								float distance = FaceDistance(visual, center, visual.menuCenter);
								if (distance < bestDistance)
								{
									best = visual;
									bestDistance = distance;
								}
							}
						}
						if (best != null)
						{
							target.visuals.Add(best);
						}
					}
				}
			}
			if (target.visuals.Count != 0)
			{
				int index = _targets.Count;
				_targets.Add(target);
				MenuButtonPressRelay relay = col.GetComponent<MenuButtonPressRelay>();
				if (relay == null)
				{
					relay = col.gameObject.AddComponent<MenuButtonPressRelay>();
				}
				relay.Bind(this, index, tag);
			}
		}

		private Vector3 ColliderCenter(Collider col)
		{
			Matrix4x4 menu = MenuSpace(col.transform);
			Vector3 local = Vector3.zero;
			if (col is BoxCollider boxCollider)
			{
				local = boxCollider.center;
			}
			else if (col is SphereCollider sphereCollider)
			{
				local = sphereCollider.center;
			}
			else if (col is CapsuleCollider capsuleCollider)
			{
				local = capsuleCollider.center;
			}
			return menu.MultiplyPoint3x4(local);
		}

		private static float FaceDistance(Visual v, Vector3 a, Vector3 b)
		{
			Vector3 d = a - b;
			float along = Vector3.Dot(d, v.menuLong);
			float across = Vector3.Dot(d, v.menuShort);
			return Mathf.Sqrt(along * along * 0.0625f + across * across);
		}

		private static Vector3 Axis(int i)
		{
			switch (i)
			{
			case 0:
				return Vector3.right;
			case 1:
				return Vector3.up;
			default:
				return Vector3.forward;
			}
		}

		internal void FingerEnter(int index, Collider finger)
		{
			if (index < 0 || index >= _targets.Count)
			{
				return;
			}
			Target target = _targets[index];
			if (target.fingers.Contains(finger) || (target.fingers.Count == 0 && !MayPress(target)))
			{
				return;
			}
			target.fingers.Add(finger);
			if (target.fingers.Count > 1)
			{
				return;
			}
			_held.Add(target);
			foreach (Visual visual in target.visuals)
			{
				Hold(visual, 1);
			}
			if (moveLabels)
			{
				TrackLabel(target);
			}
			if (hapticOnPress && !target.ownHaptics && VRInputController.Instance != null)
			{
				if (target.rightHand)
				{
					VRInputController.Instance.PulseRight(0.25f, 0.025f);
				}
				else
				{
					VRInputController.Instance.PulseLeft(0.25f, 0.025f);
				}
			}
		}

		private bool MayPress(Target t)
		{
			if (!_gateResolved)
			{
				_gate = MenuPressGate.Find(this);
				_gateResolved = true;
			}
			if (_gate == null)
			{
				return true;
			}
			return _gate.TryPress(t.collider.gameObject);
		}

		internal void FingerExit(int index, Collider finger)
		{
			if (index >= 0 && index < _targets.Count)
			{
				Target target = _targets[index];
				if (target.fingers.Remove(finger) && target.fingers.Count <= 0)
				{
					Release(target);
				}
			}
		}

		internal void TargetDisabled(int index)
		{
			if (index >= 0 && index < _targets.Count)
			{
				Target target = _targets[index];
				if (target.fingers.Count != 0)
				{
					target.fingers.Clear();
					Release(target);
				}
			}
		}

		private void Release(Target t)
		{
			_held.Remove(t);
			foreach (Visual visual in t.visuals)
			{
				Hold(visual, -1);
			}
		}

		private void Hold(Visual v, int delta)
		{
			v.holders = Mathf.Max(0, v.holders + delta);
			v.target = ((v.holders > 0) ? 1f : 0f);
			if (!v.moving)
			{
				v.moving = true;
				_moving.Add(v);
			}
		}

		private void Update()
		{
			if (_held.Count > 0)
			{
				DropLostFingers();
			}
			if (_moving.Count == 0)
			{
				return;
			}
			float deltaTime = Time.unscaledDeltaTime;
			for (int num = _moving.Count - 1; num >= 0; num--)
			{
				Visual visual = _moving[num];
				visual.amount = Mathf.SmoothDamp(visual.amount, visual.target, ref visual.velocity, (visual.target > visual.amount) ? pressTime : releaseTime, float.PositiveInfinity, deltaTime);
				if (Mathf.Abs(visual.amount - visual.target) < 0.002f && Mathf.Abs(visual.velocity) < 0.05f)
				{
					visual.amount = visual.target;
					visual.velocity = 0f;
					visual.moving = false;
					_moving.RemoveAt(num);
				}
				Apply(visual);
			}
			for (int num2 = _labels.Count - 1; num2 >= 0; num2--)
			{
				if (!UpdateLabel(_labels[num2]))
				{
					_labels.RemoveAt(num2);
				}
			}
		}

		private void DropLostFingers()
		{
			for (int num = _held.Count - 1; num >= 0; num--)
			{
				Target target = _held[num];
				for (int num2 = target.fingers.Count - 1; num2 >= 0; num2--)
				{
					Collider collider = target.fingers[num2];
					if (collider == null || !collider.enabled || !collider.gameObject.activeInHierarchy || (collider.bounds.center - target.collider.bounds.center).sqrMagnitude > 0.04f)
					{
						target.fingers.RemoveAt(num2);
					}
				}
				if (target.fingers.Count == 0)
				{
					Release(target);
				}
			}
		}

		private void Apply(Visual v)
		{
			Vector3 scale = Vector3.LerpUnclamped(Vector3.one, v.pressedFactor, v.amount);
			v.transform.localScale = Vector3.Scale(v.baseScale, scale);
			if (v.box != null)
			{
				v.box.size = new Vector3(v.baseBoxSize.x / scale.x, v.baseBoxSize.y / scale.y, v.baseBoxSize.z / scale.z);
			}
			if (v.hasPressProperty)
			{
				_block.SetFloat(PressId, v.amount);
				v.renderer.SetPropertyBlock(_block);
			}
		}

		private void TrackLabel(Target t)
		{
			if (!t.labelResolved)
			{
				t.labelResolved = true;
				t.label = FindLabel(t);
			}
			Label label = t.label;
			if (label != null && !(label.text == null) && label.text.isActiveAndEnabled && !_labels.Contains(label))
			{
				Capture(label);
				_labels.Add(label);
			}
		}

		private Label FindLabel(Target t)
		{
			Transform root = t.collider.transform;
			while (root.parent != null && root.parent != transform)
			{
				root = root.parent;
			}
			if (root.parent != transform)
			{
				return null;
			}
			Vector3 center = ColliderCenter(t.collider);
			Visual visual = t.visuals[0];
			float best = matchRadius;
			Label result = null;
			TMP_Text[] texts = root.GetComponentsInChildren<TMP_Text>(false);
			foreach (TMP_Text text in texts)
			{
				TMP_TextInfo info = text.textInfo;
				if (info == null || info.characterCount == 0)
				{
					continue;
				}
				Matrix4x4 menu = MenuSpace(text.transform);
				for (int i = 0; i < info.lineCount; i++)
				{
					TMP_LineInfo line = info.lineInfo[i];
					if (line.visibleCharacterCount == 0 || line.firstCharacterIndex > line.lastCharacterIndex)
					{
						continue;
					}
					Vector3 min = new Vector3(float.MaxValue, float.MaxValue, 0f);
					Vector3 max = new Vector3(float.MinValue, float.MinValue, 0f);
					int visible = 0;
					for (int j = line.firstCharacterIndex; j <= line.lastCharacterIndex; j++)
					{
						TMP_CharacterInfo character = info.characterInfo[j];
						if (character.isVisible)
						{
							visible++;
							min = Vector3.Min(min, character.bottomLeft);
							max = Vector3.Max(max, character.topRight);
						}
					}
					if (visible != 0)
					{
						Vector3 local = (min + max) * 0.5f;
						float distance = FaceDistance(visual, menu.MultiplyPoint3x4(local), center);
						if (distance < best)
						{
							best = distance;
							result = BuildLabel(text, info, line, local, visual);
						}
					}
				}
			}
			if (result != null)
			{
				result.faceInText = FaceInText(result);
			}
			return result;
		}

		private Vector3 FaceInText(Label label)
		{
			Visual visual = label.visual;
			Quaternion localRotation = visual.transform.localRotation;
			Matrix4x4 parentSpace = MenuSpace(visual.transform.parent);
			Matrix4x4 textSpace = MenuSpace(label.text.transform);
			Vector3 face = parentSpace.MultiplyVector(localRotation * Vector3.Scale(visual.baseScale, visual.faceLocal));
			return textSpace.inverse.MultiplyVector(face);
		}

		private static Label BuildLabel(TMP_Text text, TMP_TextInfo info, TMP_LineInfo li, Vector3 center, Visual visual)
		{
			List<int> materials = new List<int>();
			List<int> vertices = new List<int>();
			for (int i = li.firstCharacterIndex; i <= li.lastCharacterIndex; i++)
			{
				TMP_CharacterInfo character = info.characterInfo[i];
				if (character.isVisible)
				{
					for (int j = 0; j < 4; j++)
					{
						materials.Add(character.materialReferenceIndex);
						vertices.Add(character.vertexIndex + j);
					}
				}
			}
			return new Label
			{
				text = text,
				visual = visual,
				materials = materials.ToArray(),
				vertices = vertices.ToArray(),
				original = new Vector3[vertices.Count],
				center = center
			};
		}

		private static void Capture(Label label)
		{
			TMP_TextInfo info = label.text.textInfo;
			for (int i = 0; i < label.vertices.Length; i++)
			{
				label.original[i] = info.meshInfo[label.materials[i]].vertices[label.vertices[i]];
			}
		}

		private static void Restore(Label label)
		{
			if (label.text == null)
			{
				return;
			}
			TMP_TextInfo info = label.text.textInfo;
			for (int i = 0; i < label.vertices.Length; i++)
			{
				Vector3[] vertices = info.meshInfo[label.materials[i]].vertices;
				int index = label.vertices[i];
				if (index < vertices.Length)
				{
					vertices[index] = label.original[i];
				}
			}
			label.text.UpdateVertexData(TMP_VertexDataUpdateFlags.Vertices);
		}

		private bool UpdateLabel(Label label)
		{
			if (label.text == null || !label.text.isActiveAndEnabled)
			{
				return false;
			}
			Visual visual = label.visual;
			if (visual.amount <= 0f && visual.target <= 0f)
			{
				Restore(label);
				return false;
			}
			Vector3 scale = Vector3.LerpUnclamped(Vector3.one, visual.pressedFactor, visual.amount);
			float squeeze = Mathf.Min(scale[(visual.depthAxis + 1) % 3], scale[(visual.depthAxis + 2) % 3]);
			float depth = scale[visual.depthAxis];
			Vector3 offset = label.faceInText * (depth - 1f);
			TMP_TextInfo info = label.text.textInfo;
			for (int i = 0; i < label.vertices.Length; i++)
			{
				Vector3[] vertices = info.meshInfo[label.materials[i]].vertices;
				int index = label.vertices[i];
				if (index >= vertices.Length)
				{
					return false;
				}
				vertices[index] = offset + (label.center + (label.original[i] - label.center) * squeeze);
			}
			label.text.UpdateVertexData(TMP_VertexDataUpdateFlags.Vertices);
			return true;
		}
	}
}
