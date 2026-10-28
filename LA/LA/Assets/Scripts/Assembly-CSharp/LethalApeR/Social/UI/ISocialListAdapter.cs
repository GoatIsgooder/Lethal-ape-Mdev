namespace LethalApeR.Social.UI
{
	public interface ISocialListAdapter
	{
		int Count { get; }

		int KindOf(int index);

		void Bind(SocialListItem view, int index);
	}
}
