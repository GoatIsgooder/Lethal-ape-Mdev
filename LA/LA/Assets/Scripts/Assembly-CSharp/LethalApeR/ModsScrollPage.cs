using System.Reflection;
using TMPro;
using UnityEngine;

namespace LethalApeR
{
	[Obfuscation(Exclude = true)]
	public class ModsScrollPage : MonoBehaviour
	{
		[Header("Pages (in display order)")]
		[SerializeField]
		private GameObject[] pages;

		[Header("Options")]
		[Tooltip("Wrap from the last page back to the first (and vice-versa).")]
		[SerializeField]
		private bool wrap = true;

		[Tooltip("Jump back to the first page each time the menu is shown.")]
		[SerializeField]
		private bool resetToFirstOnEnable = true;

		[Header("Optional")]
		[Tooltip("Shows the current page, e.g. \"1/3\". Leave empty to disable.")]
		[SerializeField]
		private TMP_Text pageIndicator;

		[Tooltip("Arrow objects to hide at the ends when Wrap is OFF. Leave empty to always show.")]
		[SerializeField]
		private GameObject previousArrow;

		[SerializeField]
		private GameObject nextArrow;

		private int _index;

		public int PageCount
		{
			get
			{
				if (pages == null)
				{
					return 0;
				}
				return pages.Length;
			}
		}

		public int CurrentPage => _index;

		private void OnEnable()
		{
			if (resetToFirstOnEnable)
			{
				_index = 0;
			}
			ShowPage(_index);
		}

		[ContextMenu("Next Page")]
		public void NextPage()
		{
			int pageCount = PageCount;
			if (pageCount != 0)
			{
				_index = (wrap ? ((_index + 1) % pageCount) : Mathf.Min(_index + 1, pageCount - 1));
				ShowPage(_index);
			}
		}

		[ContextMenu("Previous Page")]
		public void PreviousPage()
		{
			int pageCount = PageCount;
			if (pageCount != 0)
			{
				_index = (wrap ? ((_index - 1 + pageCount) % pageCount) : Mathf.Max(_index - 1, 0));
				ShowPage(_index);
			}
		}

		public void ShowPage(int index)
		{
			int pageCount = PageCount;
			if (pageCount == 0)
			{
				return;
			}
			_index = Mathf.Clamp(index, 0, pageCount - 1);
			for (int i = 0; i < pages.Length; i++)
			{
				if (pages[i] != null)
				{
					pages[i].SetActive(i == _index);
				}
			}
			if (pageIndicator != null)
			{
				pageIndicator.text = string.Format("{0}/{1}", _index + 1, PageCount);
			}
			if (!wrap)
			{
				if (previousArrow != null)
				{
					previousArrow.SetActive(_index > 0);
				}
				if (nextArrow != null)
				{
					nextArrow.SetActive(_index < PageCount - 1);
				}
			}
		}
	}
}
