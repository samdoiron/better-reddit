defmodule BetterReddit.Reddit.PostProcessor do
  alias BetterReddit.Repo
  alias BetterReddit.Schemas.RedditPost
  alias BetterReddit.Schemas.Thumbnail
  import Ecto.Query, only: [from: 2]
  require Logger

  def process(posts) do
    {new, not_new} = split_new_and_old(posts)
    insert_posts(new)
    update_posts(not_new)

    Enum.each(new, &after_insert/1)
  end

  defp insert_posts(posts) do
    posts
    |> RedditPost.insert_all()
    |> Repo.transaction()
    Enum.each(posts, &after_insert/1)
  end

  # run after the first insert of a post
  defp after_insert(post) do
    if has_thumbnail?(post) do
      {:ok, _ } = Task.start_link(fn -> download_thumbnail(post) end)
    end
  end

  defp update_posts(posts) do
    posts
    |> RedditPost.update_all()
    |> Repo.transaction()
  end
  
  defp download_thumbnail(post) do
    case Thumbnail.download_and_insert_for(post) do
      {:ok, _} ->
        Logger.debug("downloaded thumbnail for post #{post.reddit_id}")
      other ->
        IO.puts("failed to download thumbnail")
        other
    end
  end

  defp split_new_and_old(posts) do
    not_new = already_existing(posts)
    not_new_ids = Enum.map(not_new, &(&1.reddit_id))
    new = Enum.reject(posts, fn post ->
      Enum.member?(not_new_ids, post.reddit_id)
    end)
    {new, not_new}
  end

  defp already_existing(posts) do
    ids = Enum.map(posts, &(&1.reddit_id))
    query = from p in RedditPost, where: p.reddit_id in ^ids 
    Repo.all(query)
  end

  defp has_thumbnail?(post), do: post.thumbnail_url != nil
end
