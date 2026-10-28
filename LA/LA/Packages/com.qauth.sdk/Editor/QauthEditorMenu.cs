using System.IO;
using UnityEditor;
using UnityEngine;

namespace QauthSdk.Editor
{
	// Tools > Qauth: make / find the settings asset, and set this PC's editor login key.
	public static class QauthEditorMenu
	{
		private const string Folder = "Assets/Resources";
		private const string AssetPath = Folder + "/" + QauthSettings.ResourceName + ".asset";

		[MenuItem("Tools/Qauth/Settings")]
		public static void OpenSettings()
		{
			QauthSettings s = AssetDatabase.LoadAssetAtPath<QauthSettings>(AssetPath);
			if (s == null)
			{
				Directory.CreateDirectory(Folder);
				s = ScriptableObject.CreateInstance<QauthSettings>();
				AssetDatabase.CreateAsset(s, AssetPath);
				AssetDatabase.SaveAssets();
				Debug.Log("[Qauth] made " + AssetPath + ": set your game id and Meta app id");
			}
			Selection.activeObject = s;
			EditorGUIUtility.PingObject(s);
		}

		[MenuItem("Tools/Qauth/Set Editor Login Key...")]
		public static void SetEditorKey()
		{
			QauthEditorKeyWindow.Open();
		}
	}

	// The dashboard can make a personal editor key so staff can log in from the editor (Meta's attestation can't
	// pass there). It's stored in this PC's EditorPrefs only: never in the project, a scene or a build.
	public class QauthEditorKeyWindow : EditorWindow
	{
		private string key;

		public static void Open()
		{
			QauthEditorKeyWindow w = GetWindow<QauthEditorKeyWindow>(true, "Qauth editor key");
			w.key = EditorPrefs.GetString(QauthEditorKey.Pref, "");
			w.minSize = new Vector2(420, 110);
		}

		private void OnGUI()
		{
			EditorGUILayout.HelpBox("Paste the 32-character editor key from the Qauth dashboard. It stays on this PC.", MessageType.Info);
			key = EditorGUILayout.PasswordField("Editor key", key ?? "");
			using (new EditorGUILayout.HorizontalScope())
			{
				if (GUILayout.Button("Save"))
				{
					EditorPrefs.SetString(QauthEditorKey.Pref, (key ?? "").Trim());
					Close();
				}
				if (GUILayout.Button("Clear"))
				{
					EditorPrefs.DeleteKey(QauthEditorKey.Pref);
					key = "";
				}
			}
		}
	}
}
