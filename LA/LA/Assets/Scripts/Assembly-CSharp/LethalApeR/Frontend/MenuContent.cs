using System;
using System.Collections.Generic;
using System.Globalization;
using UnityEngine;

namespace LethalApeR.Frontend
{
	[CreateAssetMenu(menuName = "Slop/Loading Menu Content", fileName = "LoadingMenuContent")]
	public sealed class MenuContent : ScriptableObject
	{
		public enum PostTag
		{
			News = 0,
			Update = 1,
			Event = 2,
			Hotfix = 3,
			Community = 4
		}

		[Serializable]
		public sealed class Post
		{
			public string title;

			public PostTag tag;

			[Tooltip("yyyy-MM-dd")]
			public string date;

			[TextArea(8, 40)]
			[Tooltip("TextMeshPro rich text is allowed (<b>, <i>, <color=#...>).")]
			public string body;

			[Tooltip("Optional header image.")]
			public Texture2D image;

			[Tooltip("Pinned posts stay at the top of the list.")]
			public bool pinned;

			public string Id => date + "|" + title;

			public bool TryGetDate(out DateTime value)
			{
				return DateTime.TryParseExact(date, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out value);
			}
		}

		[Serializable]
		public sealed class Shot
		{
			public Texture2D image;

			public string title;

			public string caption;
		}

		[SerializeField]
		private Texture2D playCover;

		[SerializeField]
		private List<Post> posts = new List<Post>();

		[SerializeField]
		private List<Shot> gallery = new List<Shot>();

		public Texture2D PlayCover => playCover;

		public IReadOnlyList<Shot> Gallery => gallery;

		public List<Post> SortedPosts()
		{
			List<Post> list = new List<Post>(posts.Count);
			foreach (Post post in posts)
			{
				if (post != null && !string.IsNullOrWhiteSpace(post.title))
				{
					list.Add(post);
				}
			}
			list.Sort(delegate(Post a, Post b)
			{
				if (a.pinned != b.pinned)
				{
					return (!a.pinned) ? 1 : (-1);
				}
				DateTime value;
				bool flag = a.TryGetDate(out value);
				DateTime value2;
				bool flag2 = b.TryGetDate(out value2);
				if (flag != flag2)
				{
					return (!flag) ? 1 : (-1);
				}
				return value2.CompareTo(value);
			});
			return list;
		}
	}
}
