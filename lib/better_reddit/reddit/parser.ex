defmodule BetterReddit.Reddit.Parser do
  alias BetterReddit.Reddit

  @moduledoc ~S"""
  Parser parser a Reddit API response, and returns an internal representation
  of the parsed data.
  """

  def parse_listing(listing) do
    posts = listing
    |> Poison.decode!
    |> extract_posts()

    {:ok, %Reddit.Listing{posts: posts}}
  end

  defp extract_posts(json) do
    json
    |> Map.get("data")
    |> Map.get("children")
    |> Enum.map(&parse_post/1)
  end

  defp parse_post(entry) do
    post = Map.get(entry, "data")

    %Reddit.Post{
      title: Map.get(post, "title"),
      ups: Map.get(post, "ups"),
      downs: Map.get(post, "downs"),
      url: Map.get(post, "url") |> String.replace("&amp;", "&"),
      author: Map.get(post, "author"),
      subreddit: Map.get(post, "subreddit"),
      created_timestamp: Map.get(post, "created_utc") |> trunc()
    }
  end
end
