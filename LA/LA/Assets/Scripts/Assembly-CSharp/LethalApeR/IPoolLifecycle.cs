using System.Reflection;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public interface IPoolLifecycle
	{
		int PoolCallbackOrder { get; }

		void OnPoolReleased();

		void OnPoolAcquired();
	}
}
