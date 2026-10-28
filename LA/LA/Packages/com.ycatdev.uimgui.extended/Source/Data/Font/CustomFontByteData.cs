using System.IO;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
#endif

[CreateAssetMenu(menuName = "Dear ImGui/Create CustomFontByteData")]
public class CustomFontByteData : ScriptableObject
{
#if UNITY_EDITOR
    [SerializeField] private Font font;
#endif
    
    [HideInInspector, SerializeField] private byte[] fontData;

    public byte[] FontData => fontData;

#if UNITY_EDITOR
    private void OnValidate()
    {
        // GetFullPath resolves both "Assets/..." and embedded "Packages/..." paths against the project folder
        var assetPath = font != null ? AssetDatabase.GetAssetPath(font) : null;
        if (string.IsNullOrEmpty(assetPath))
            return;
        fontData = File.ReadAllBytes(Path.GetFullPath(assetPath));
    }
#endif
}