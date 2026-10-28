using System.Reflection;

namespace LethalApeR.CustomMaps
{
	[Obfuscation(Exclude = true)]
	public sealed class MapButtonTrigger : BaseButton
	{
		private MapRuntime _runtime;

		private int _index;

		public void Bind(MapRuntime runtime, int index)
		{
			_runtime = runtime;
			_index = index;
		}

		public override void OnButtonPressed(bool isLeft)
		{
			if (_runtime != null)
			{
				_runtime.OnLocalButtonPress(_index, false);
			}
		}
	}
}
