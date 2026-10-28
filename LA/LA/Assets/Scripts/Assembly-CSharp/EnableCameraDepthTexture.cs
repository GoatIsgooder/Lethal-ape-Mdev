using UnityEngine;

[RequireComponent(typeof(Camera))]
[ExecuteAlways]
[DisallowMultipleComponent]
public class EnableCameraDepthTexture : MonoBehaviour
{
	[Tooltip("Add normals to the depth pre-pass. Not needed for the water shader.")]
	public bool includeNormals;

	private void OnEnable()
	{
		Camera component = GetComponent<Camera>();
		component.depthTextureMode |= DepthTextureMode.Depth;
		if (includeNormals)
		{
			component.depthTextureMode |= DepthTextureMode.DepthNormals;
		}
	}
}
