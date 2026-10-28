using UnityEngine;

[ExecuteAlways]
public class GlobalShaderTextures : MonoBehaviour
{
	[SerializeField]
	private Texture shineNoiseTex;

	private void OnEnable()
	{
		Apply();
	}

	private void OnValidate()
	{
		Apply();
	}

	private void Apply()
	{
		if ((bool)shineNoiseTex)
		{
			Shader.SetGlobalTexture("_ShineNoiseTex", shineNoiseTex);
		}
	}
}
