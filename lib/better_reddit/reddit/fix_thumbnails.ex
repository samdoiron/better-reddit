defmodule BetterReddit.Reddit.FixThumbnails do
  import Ecto.Query
  require Logger
  alias BetterReddit.Repo
  alias BetterReddit.Schemas.RedditPost
  alias BetterReddit.Schemas.Thumbnail

  @fix_chunk_size 50

  def start_link do
    Task.start_link(fn -> run end)
  end

  def run do
    posts = posts_without_thumbnails()
    Enum.each(posts, &fix_thumbnail/1)
    Process.sleep(5_000)
  end

  defp fix_thumbnail(post) do
    Task.start_link(fn ->
      case Thumbnail.download_and_insert_for(post) do
        {:ok, _} -> Logger.debug("Fixed thumbnail for post #{post.reddit_id}")
        {:error, :removed} ->
          Logger.debug("Removed 404-ing thumbnail for #{post.reddit_id}")
        {:error, err} ->
          Logger.error(
          "Error fixing thumbnail for post #{post.reddit_id}: #{inspect(err)}"
          )
      end
    end)
  end

  defp posts_without_thumbnails do
    Repo.all(from post in RedditPost,
      left_join: thumbnail in Thumbnail,
        on: (thumbnail.reddit_post_id == post.reddit_id),
      where: not is_nil(post.thumbnail_url),
      where: is_nil(thumbnail.reddit_post_id),
      order_by: [desc: post.time_posted],
      select: post,
      limit: @fix_chunk_size)
  end
end
