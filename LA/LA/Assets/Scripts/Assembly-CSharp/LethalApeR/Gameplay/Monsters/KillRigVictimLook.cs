using System.Collections.Generic;
using LethalApeR.Networking;
using UnityEngine;

namespace LethalApeR.Gameplay.Monsters
{
	internal sealed class KillRigVictimLook
	{
		private const string SkinnableBodyName = "LAR_Ape_LOD0.001";

		private const string ColourOnlyBodyName = "LAR_Ape";

		private static readonly int ColorId = Shader.PropertyToID("_Color");

		private readonly List<Renderer> _bodies = new List<Renderer>();

		private readonly List<bool> _bodySkinnable = new List<bool>();

		private readonly List<Material[]> _bodyDefaults = new List<Material[]>();

		private readonly MaterialPropertyBlock _mpb = new MaterialPropertyBlock();

		public bool IsEmpty => _bodies.Count == 0;

		public KillRigVictimLook(GameObject killRig)
		{
			if (killRig == null)
			{
				return;
			}
			SkinnedMeshRenderer[] renderers = killRig.GetComponentsInChildren<SkinnedMeshRenderer>(true);
			for (int i = 0; i < renderers.Length; i++)
			{
				SkinnedMeshRenderer smr = renderers[i];
				bool skinnable = smr.name == SkinnableBodyName;
				if (skinnable || smr.name == ColourOnlyBodyName)
				{
					_bodies.Add(smr);
					_bodySkinnable.Add(skinnable);
					_bodyDefaults.Add(smr.sharedMaterials);
				}
			}
		}

		public void Apply(MonkeDevNetworkingPlayer victim)
		{
			if (IsEmpty)
			{
				return;
			}
			if (victim == null)
			{
				Restore();
				return;
			}
			victim.GetApeAppearance(out Material skin, out Color colour);
			for (int i = 0; i < _bodies.Count; i++)
			{
				Renderer body = _bodies[i];
				if (body == null)
				{
					continue;
				}
				Material[] materials = (Material[])_bodyDefaults[i].Clone();
				if (_bodySkinnable[i] && skin != null && materials.Length > 0)
				{
					materials[0] = skin;
				}
				body.sharedMaterials = materials;
				body.GetPropertyBlock(_mpb);
				_mpb.SetColor(ColorId, colour);
				body.SetPropertyBlock(_mpb);
			}
		}

		private void Restore()
		{
			_mpb.Clear();
			for (int i = 0; i < _bodies.Count; i++)
			{
				if (!(_bodies[i] == null))
				{
					_bodies[i].sharedMaterials = _bodyDefaults[i];
					_bodies[i].SetPropertyBlock(_mpb);
				}
			}
		}
	}
}
