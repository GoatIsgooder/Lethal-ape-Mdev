using UnityEngine;
using UnityEditor;

public class MeshColliderSyncWindow : EditorWindow
{
    [MenuItem("Tools/Mesh Collider Sync Tool")]
    public static void ShowWindow()
    {
        GetWindow<MeshColliderSyncWindow>("Mesh Collider Sync");
    }

    private void OnGUI()
    {
        GUILayout.Label("🧠 Mesh Collider to Mesh Filter Sync", EditorStyles.boldLabel);
        GUILayout.Space(5);
        EditorGUILayout.HelpBox("This tool scans every GameObject in the scene. If it has a MeshCollider, it assigns its mesh to the MeshFilter on the same object.", MessageType.Info);
        GUILayout.Space(10);

        if (GUILayout.Button("🚀 Sync All MeshColliders to MeshFilters"))
        {
            SyncMeshes();
        }

        GUILayout.Space(20);
        EditorGUILayout.LabelField("— Made by Warrant", EditorStyles.miniLabel);
        EditorGUILayout.LabelField("🤖 I am not AI, I am human", EditorStyles.miniLabel);
        EditorGUILayout.LabelField("💬 Discord: discord.gg/unitycentral", EditorStyles.miniLabel);
    }

    private void SyncMeshes()
    {
        int count = 0;

        foreach (GameObject obj in FindObjectsOfType<GameObject>())
        {
            MeshCollider meshCol = obj.GetComponent<MeshCollider>();
            if (meshCol == null || meshCol.sharedMesh == null)
                continue;

            MeshFilter meshFilter = obj.GetComponent<MeshFilter>();
            if (meshFilter == null)
                meshFilter = obj.AddComponent<MeshFilter>();

            meshFilter.sharedMesh = meshCol.sharedMesh;
            count++;
        }

        Debug.Log($"[Mesh Sync] Synced {count} MeshCollider meshes to MeshFilters.");
        Debug.Log("Thanks for using my mesh syncer tool - warrant");
    }
}