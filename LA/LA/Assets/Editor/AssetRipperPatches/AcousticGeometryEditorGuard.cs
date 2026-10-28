using System;
using System.Reflection;
using UnityEditor;

// MetaXRAcousticGeometry rebuilds its acoustic mesh from every child renderer in OnValidate when a scene
// opens. On BeTheMonster's TheMines (~55M vertices) the native allocator runs out of memory and Unity
// crashes. The game ships baked .xrageo files for these components, so skip the edit-time gather.
[InitializeOnLoad]
internal static class AcousticGeometryEditorGuard
{
	static AcousticGeometryEditorGuard()
	{
		foreach (Assembly assembly in AppDomain.CurrentDomain.GetAssemblies())
		{
			Type type = assembly.GetType("MetaXRAcousticGeometry");
			if (type == null)
			{
				continue;
			}
			FieldInfo field = type.GetField("AUTO_VALIDATE", BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.Public);
			if (field != null)
			{
				field.SetValue(null, false);
			}
			return;
		}
	}
}
