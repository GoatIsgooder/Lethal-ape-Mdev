using System;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

namespace LethalApeR.Frontend
{
	public sealed class UpdatesCard : MonoBehaviour
	{
		private const string ReadKey = "LoadingMenu.ReadPosts";

		[SerializeField]
		private MenuContent content;

		[SerializeField]
		private UpdateRow rowTemplate;

		[SerializeField]
		private MenuScroll scroll;

		[SerializeField]
		private RectTransform listContent;

		[SerializeField]
		private ReaderPanel reader;

		[SerializeField]
		private TMP_Text emptyText;

		[Tooltip("Posts newer than this many days are marked NEW until opened.")]
		[SerializeField]
		private int newForDays = 30;

		private readonly List<UpdateRow> _rows = new List<UpdateRow>();

		private HashSet<string> _read;

		private void Start()
		{
			LoadRead();
			Build();
		}

		private void Build()
		{
			rowTemplate.gameObject.SetActive(false);
			List<MenuContent.Post> list = ((content != null) ? content.SortedPosts() : new List<MenuContent.Post>());
			if (emptyText != null)
			{
				emptyText.gameObject.SetActive(list.Count == 0);
			}
			float num = 0f;
			foreach (MenuContent.Post item in list)
			{
				UpdateRow row = UnityEngine.Object.Instantiate(rowTemplate, listContent);
				row.name = "Row - " + item.title;
				row.gameObject.SetActive(true);
				row.Clip = scroll.Rect;
				row.Rect.anchoredPosition = new Vector2(0f, 0f - num);
				num += row.Bind(item, IsNew(item));
				row.Clicked += delegate
				{
					Open(row);
				};
				_rows.Add(row);
			}
			scroll.SetContentHeight(num, true);
		}

		private void Open(UpdateRow row)
		{
			reader.Open(row.Post);
			if (_read.Add(row.Post.Id))
			{
				SaveRead();
			}
			row.SetUnread(false);
		}

		private bool IsNew(MenuContent.Post post)
		{
			if (_read.Contains(post.Id))
			{
				return false;
			}
			if (!post.TryGetDate(out var value))
			{
				return false;
			}
			return (DateTime.UtcNow.Date - value.Date).TotalDays <= (double)newForDays;
		}

		private void LoadRead()
		{
			_read = new HashSet<string>();
			string text = PlayerPrefs.GetString("LoadingMenu.ReadPosts", string.Empty);
			if (text.Length == 0)
			{
				return;
			}
			string[] array = text.Split('\n');
			foreach (string text2 in array)
			{
				if (text2.Length > 0)
				{
					_read.Add(text2);
				}
			}
		}

		private void SaveRead()
		{
			List<string> list = new List<string>();
			if (content != null)
			{
				foreach (MenuContent.Post item in content.SortedPosts())
				{
					if (_read.Contains(item.Id))
					{
						list.Add(item.Id);
					}
				}
			}
			PlayerPrefs.SetString("LoadingMenu.ReadPosts", string.Join("\n", list));
			PlayerPrefs.Save();
		}
	}
}
