using System;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	public class MimicMonster : FOVMonster
	{
		[Header("Mimic — Body")]
		[Tooltip("The model root that scales. On the Mimic prefab this is MimicRedesignRun.")]
		[SerializeField]
		private Transform bodyRoot;

		[Tooltip("Renderers driven by the Slop/MimicTransform morph. Auto-filled from bodyRoot when empty.")]
		[SerializeField]
		private Renderer[] bodyRenderers;

		[Header("Mimic — Forms")]
		[Tooltip("Uniform localScale while disguised / patrolling.")]
		[SerializeField]
		private float walkScale = 1f;

		[Tooltip("Uniform localScale while chasing.")]
		[SerializeField]
		private float chaseScale = 1.540604f;

		[Tooltip("bodyRoot.localPosition.y in the chase form. This is the authored, eyeballed value.")]
		[SerializeField]
		private float chaseLocalY = -0.667f;

		[Tooltip("bodyRoot.localPosition.y in the walk form. Left to the solver unless you untick Auto Solve.")]
		[SerializeField]
		private float walkLocalY = -0.667f;

		[Tooltip("Derive Walk Local Y at Awake so the feet stay on the floor in BOTH forms. Untick to hand-author the value above.")]
		[SerializeField]
		private bool autoSolveWalkY = true;

		[Header("Mimic — Timing")]
		[Tooltip("Seconds to go player -> monster. Fast: this is the scare.")]
		[SerializeField]
		private float morphInDuration = 0.55f;

		[Tooltip("Seconds to go monster -> player. Slower, so it reads as calming down.")]
		[SerializeField]
		private float morphOutDuration = 1.1f;

		[Tooltip("Stay monstrous this long after losing sight. Keep it >= the base trackAfterLoseSightDuration or it will shrink while still hunting you.")]
		[SerializeField]
		private float holdAfterLostSight = 2.5f;

		[Tooltip("Shaping of the morph. X = raw 0..1 progress, Y = applied 0..1.")]
		[SerializeField]
		private AnimationCurve morphCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);

		[Header("Mimic — Blend Shapes")]
		[Tooltip("Blend shapes driven from 0 to Blend Shape Weight as the mimic transforms. Matched by name, case-insensitively, across every skinned mesh under bodyRoot.")]
		[SerializeField]
		private string[] morphBlendShapes = new string[2] { "MouthOpen", "MonsterTransformation" };

		[SerializeField]
		[Range(0f, 100f)]
		private float blendShapeWeight = 100f;

		[Header("Mimic — Disguise")]
		[Tooltip("Nametag, cosmetics, anything that sells 'this is just a player'. Hidden once the transformation passes the threshold below, restored on the way back.")]
		[SerializeField]
		private GameObject[] disguiseObjects;

		[Tooltip("The exact mirror: monster-only extras — claws, gore, VFX. Hidden while disguised, shown from the same threshold the disguise drops at, so the swap happens in one frame with no gap where both are visible.")]
		[SerializeField]
		private GameObject[] monsterObjects;

		[Tooltip("Morph value at which the disguise drops and the monster objects appear.")]
		[SerializeField]
		[Range(0f, 1f)]
		private float disguiseHideAtMorph = 0.12f;

		[Header("Mimic — Shader")]
		[Tooltip("Push the morph into the body material via MaterialPropertyBlock. Needs Slop/MimicTransform (or any shader with a _Morph float).")]
		[SerializeField]
		private bool driveShader = true;

		private static readonly int MorphId = Shader.PropertyToID("_Morph");

		private MaterialPropertyBlock _mpb;

		private SkinnedMeshRenderer[] _shapeRenderers;

		private int[] _shapeIndices;

		private float _morph;

		private float _appliedMorph = -1f;

		private float _holdUntil;

		private bool _pinnedMonster;

		private bool _disguiseVisible;

		private bool _disguiseApplied;

		private float _bodyLocalX;

		private float _bodyLocalZ;

		private bool _ready;

		public bool IsTransformed => _morph > 0.5f;

		public float MorphAmount => Mathf.Clamp01(morphCurve.Evaluate(Mathf.Clamp01(_morph)));

		private void Awake()
		{
			CacheBody();
			if (_ready)
			{
				if (autoSolveWalkY)
				{
					walkLocalY = SolveWalkLocalY();
				}
				_morph = 0f;
				_appliedMorph = -1f;
				ApplyForm(0f);
			}
		}

		protected override void LateUpdate()
		{
			base.LateUpdate();
			if (!_ready)
			{
				return;
			}
			if (canSeePlayer)
			{
				_holdUntil = Time.time + Mathf.Max(0f, holdAfterLostSight);
			}
			bool monster = _pinnedMonster || canSeePlayer || Time.time < _holdUntil;
			float target = (monster ? 1f : 0f);
			float duration = (monster ? morphInDuration : morphOutDuration);
			float step = ((duration > 0.0001f) ? (Time.deltaTime / duration) : 1f);
			_morph = Mathf.MoveTowards(_morph, target, step);
			float eased = Mathf.Clamp01(morphCurve.Evaluate(_morph));
			if (!Mathf.Approximately(eased, _appliedMorph) || (_morph > 0f && _morph < 1f))
			{
				ApplyForm(eased);
			}
		}

		private void ApplyForm(float eased)
		{
			_appliedMorph = eased;
			float scale = Mathf.LerpUnclamped(walkScale, chaseScale, eased);
			bodyRoot.localScale = new Vector3(scale, scale, scale);
			bodyRoot.localPosition = new Vector3(_bodyLocalX, Mathf.LerpUnclamped(walkLocalY, chaseLocalY, eased), _bodyLocalZ);
			if (_shapeRenderers != null)
			{
				float weight = blendShapeWeight * eased;
				for (int i = 0; i < _shapeRenderers.Length; i++)
				{
					if (_shapeRenderers[i] != null)
					{
						_shapeRenderers[i].SetBlendShapeWeight(_shapeIndices[i], weight);
					}
				}
			}
			SetDisguiseVisible(eased < disguiseHideAtMorph);
			if (driveShader)
			{
				PushShaderMorph(eased);
			}
		}

		private void PushShaderMorph(float eased)
		{
			if (bodyRenderers == null)
			{
				return;
			}
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			for (int i = 0; i < bodyRenderers.Length; i++)
			{
				Renderer r = bodyRenderers[i];
				if (!(r == null))
				{
					r.GetPropertyBlock(_mpb);
					_mpb.SetFloat(MorphId, eased);
					r.SetPropertyBlock(_mpb);
				}
			}
		}

		private void SetDisguiseVisible(bool visible)
		{
			bool hasDisguise = HasAny(disguiseObjects);
			bool hasMonster = HasAny(monsterObjects);
			if (!hasDisguise && !hasMonster)
			{
				return;
			}
			if (_disguiseApplied && _disguiseVisible == visible)
			{
				return;
			}
			_disguiseVisible = visible;
			_disguiseApplied = true;
			if (hasDisguise)
			{
				for (int i = 0; i < disguiseObjects.Length; i++)
				{
					if (disguiseObjects[i] != null)
					{
						disguiseObjects[i].SetActive(visible);
					}
				}
			}
			if (hasMonster)
			{
				for (int j = 0; j < monsterObjects.Length; j++)
				{
					if (monsterObjects[j] != null)
					{
						monsterObjects[j].SetActive(!visible);
					}
				}
			}
		}

		protected override void OnJumpscareStarted()
		{
			_pinnedMonster = true;
			_morph = 1f;
			if (_ready)
			{
				ApplyForm(Mathf.Clamp01(morphCurve.Evaluate(1f)));
			}
		}

		protected override void OnJumpscareEnded()
		{
			_pinnedMonster = false;
			_holdUntil = Time.time + Mathf.Max(0f, holdAfterLostSight);
		}

		private void CacheBody()
		{
			_ready = false;
			if (bodyRoot == null)
			{
				Debug.LogError("[MimicMonster] " + base.name + ": Body Root is not assigned — the mimic cannot transform.", this);
				return;
			}
			_bodyLocalX = bodyRoot.localPosition.x;
			_bodyLocalZ = bodyRoot.localPosition.z;
			if (bodyRenderers == null || bodyRenderers.Length == 0)
			{
				bodyRenderers = CollectBodyRenderers();
			}
			if (morphCurve == null || morphCurve.length < 2)
			{
				morphCurve = AnimationCurve.EaseInOut(0f, 0f, 1f, 1f);
			}
			BuildBlendShapeTable();
			_ready = true;
		}

		private Renderer[] CollectBodyRenderers()
		{
			Renderer[] all = bodyRoot.GetComponentsInChildren<Renderer>(true);
			if (!HasAny(disguiseObjects) && !HasAny(monsterObjects))
			{
				return all;
			}
			Renderer[] kept = new Renderer[all.Length];
			int count = 0;
			for (int i = 0; i < all.Length; i++)
			{
				Transform t = all[i].transform;
				if (!IsUnder(t, disguiseObjects) && !IsUnder(t, monsterObjects))
				{
					kept[count++] = all[i];
				}
			}
			Renderer[] result = new Renderer[count];
			Array.Copy(kept, result, count);
			return result;
		}

		private static bool HasAny(GameObject[] set)
		{
			if (set != null)
			{
				return set.Length != 0;
			}
			return false;
		}

		private static bool IsUnder(Transform t, GameObject[] set)
		{
			if (set == null)
			{
				return false;
			}
			for (int i = 0; i < set.Length; i++)
			{
				if (set[i] != null && t.IsChildOf(set[i].transform))
				{
					return true;
				}
			}
			return false;
		}

		private void BuildBlendShapeTable()
		{
			_shapeRenderers = null;
			_shapeIndices = null;
			if (morphBlendShapes == null || morphBlendShapes.Length == 0)
			{
				return;
			}
			SkinnedMeshRenderer[] smrs = bodyRoot.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			if (smrs.Length == 0)
			{
				return;
			}
			SkinnedMeshRenderer[] renderers = new SkinnedMeshRenderer[morphBlendShapes.Length * smrs.Length];
			int[] indices = new int[renderers.Length];
			int count = 0;
			for (int i = 0; i < morphBlendShapes.Length; i++)
			{
				string wanted = morphBlendShapes[i];
				if (string.IsNullOrEmpty(wanted))
				{
					continue;
				}
				bool found = false;
				for (int j = 0; j < smrs.Length; j++)
				{
					int index = FindBlendShape(smrs[j], wanted);
					if (index >= 0)
					{
						renderers[count] = smrs[j];
						indices[count] = index;
						count++;
						found = true;
					}
				}
				if (!found)
				{
					Debug.LogWarning("[MimicMonster] " + base.name + ": no blend shape named '" + wanted + "' under " + bodyRoot.name + ". The mimic will still scale, but that shape will not animate.", this);
				}
			}
			if (count != 0)
			{
				_shapeRenderers = new SkinnedMeshRenderer[count];
				_shapeIndices = new int[count];
				Array.Copy(renderers, _shapeRenderers, count);
				Array.Copy(indices, _shapeIndices, count);
			}
		}

		private static int FindBlendShape(SkinnedMeshRenderer smr, string wanted)
		{
			Mesh mesh = ((smr != null) ? smr.sharedMesh : null);
			if (mesh == null)
			{
				return -1;
			}
			int index = mesh.GetBlendShapeIndex(wanted);
			if (index >= 0)
			{
				return index;
			}
			for (int i = 0; i < mesh.blendShapeCount; i++)
			{
				string shapeName = mesh.GetBlendShapeName(i);
				if (string.Equals(shapeName, wanted, StringComparison.OrdinalIgnoreCase))
				{
					return i;
				}
				int dot = shapeName.LastIndexOf('.');
				if (dot >= 0 && dot < shapeName.Length - 1 && string.Equals(shapeName.Substring(dot + 1), wanted, StringComparison.OrdinalIgnoreCase))
				{
					return i;
				}
			}
			return -1;
		}

		private float SolveWalkLocalY()
		{
			if (bodyRenderers == null || bodyRenderers.Length == 0)
			{
				return walkLocalY;
			}
			float scaleY = bodyRoot.localScale.y;
			if (Mathf.Abs(scaleY) < 0.0001f)
			{
				return walkLocalY;
			}
			float minY = float.MaxValue;
			for (int i = 0; i < bodyRenderers.Length; i++)
			{
				Renderer r = bodyRenderers[i];
				if (!(r == null))
				{
					float bottom = r.bounds.min.y;
					if (bottom < minY)
					{
						minY = bottom;
					}
				}
			}
			if (minY == float.MaxValue)
			{
				return walkLocalY;
			}
			Transform parent = bodyRoot.parent;
			float parentY = ((parent != null) ? parent.position.y : 0f);
			float parentScale = ((parent != null) ? parent.lossyScale.y : 1f);
			if (Mathf.Abs(parentScale) < 0.0001f)
			{
				return walkLocalY;
			}
			float footOffset = ((minY - parentY) / parentScale - bodyRoot.localPosition.y) / scaleY;
			return chaseLocalY + chaseScale * footOffset - walkScale * footOffset;
		}
	}
}
