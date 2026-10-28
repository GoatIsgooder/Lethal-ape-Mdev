using UnityEngine;

[ExecuteAlways]
public class PigMoneyFill : MonoBehaviour
{
	[Range(0f, 1f)]
	public float fill = 0.5f;

	public Renderer targetRenderer;

	[Header("Fill Bounds")]
	public bool worldSpaceFill = true;

	public float fillBottom = -0.5f;

	public float fillTop = 0.5f;

	private static readonly int FillID = Shader.PropertyToID("_Fill");

	private static readonly int MinID = Shader.PropertyToID("_FillYMin");

	private static readonly int MaxID = Shader.PropertyToID("_FillYMax");

	private static readonly int SpaceID = Shader.PropertyToID("_FillWorldSpace");

	private MaterialPropertyBlock _mpb;

	private float _lastFill = float.NaN;

	private float _lastBottom = float.NaN;

	private float _lastTop = float.NaN;

	private bool _objectBoundsResolved;

	public float Fill
	{
		get
		{
			return fill;
		}
		set
		{
			fill = Mathf.Clamp01(value);
			RefreshBounds();
			Apply();
		}
	}

	public void SetByAmount(float current, float capacity)
	{
		Fill = ((capacity > 0f) ? (current / capacity) : 0f);
	}

	private void OnEnable()
	{
		_objectBoundsResolved = false;
		RefreshBounds();
		Apply();
	}

	private void OnValidate()
	{
		_objectBoundsResolved = false;
		_lastFill = float.NaN;
	}

	private void Update()
	{
		RefreshBounds();
		if (fill != _lastFill || fillBottom != _lastBottom || fillTop != _lastTop)
		{
			Apply();
		}
	}

	private void ResolveRenderer()
	{
		if (!targetRenderer)
		{
			targetRenderer = GetComponent<Renderer>();
			if (!targetRenderer)
			{
				targetRenderer = GetComponentInChildren<Renderer>();
			}
		}
	}

	private void RefreshBounds()
	{
		ResolveRenderer();
		if (!targetRenderer)
		{
			return;
		}
		if (worldSpaceFill)
		{
			Bounds bounds = targetRenderer.bounds;
			fillBottom = bounds.min.y;
			fillTop = bounds.max.y;
		}
		else if (!_objectBoundsResolved)
		{
			Mesh mesh = GetMesh();
			if ((bool)mesh)
			{
				fillBottom = mesh.bounds.min.y;
				fillTop = mesh.bounds.max.y;
				_objectBoundsResolved = true;
			}
		}
	}

	private Mesh GetMesh()
	{
		if (targetRenderer is SkinnedMeshRenderer skinnedMeshRenderer)
		{
			return skinnedMeshRenderer.sharedMesh;
		}
		MeshFilter component = targetRenderer.GetComponent<MeshFilter>();
		if (!component)
		{
			return null;
		}
		return component.sharedMesh;
	}

	private void Apply()
	{
		ResolveRenderer();
		if ((bool)targetRenderer)
		{
			if (_mpb == null)
			{
				_mpb = new MaterialPropertyBlock();
			}
			targetRenderer.GetPropertyBlock(_mpb);
			_mpb.SetFloat(FillID, Mathf.Clamp01(fill));
			_mpb.SetFloat(MinID, fillBottom);
			_mpb.SetFloat(MaxID, fillTop);
			_mpb.SetFloat(SpaceID, worldSpaceFill ? 1f : 0f);
			targetRenderer.SetPropertyBlock(_mpb);
			_lastFill = fill;
			_lastBottom = fillBottom;
			_lastTop = fillTop;
		}
	}
}
