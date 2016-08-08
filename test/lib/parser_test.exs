defmodule BetterReddit.ParserTest do
  use ExUnit.Case
  alias BetterReddit.Parser
  alias BetterReddit.Reddit

  setup do
    listing = File.read!("test/lib/reddit_hot.json")
    {:ok, listing: listing}
  end

  test "parse_listing has correct number of posts", %{listing: listing} do
    {:ok, parsed} = Parser.parse_listing(listing)
    assert 25 == Enum.count(parsed.posts)
  end

  test "parse_listing has no empty titles", %{listing: listing} do
    {:ok, %Reddit.Listing{posts: posts}} = Parser.parse_listing(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.title
      assert "" != post.title
    end)
  end

  test "parse_listing entries have a url", %{listing: listing} do
    {:ok, %Reddit.Listing{posts: posts}} = Parser.parse_listing(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.url
      assert "" != post.url
    end)
  end

  test "parse_listing entries have an author", %{listing: listing} do
    {:ok, %Reddit.Listing{posts: posts}} = Parser.parse_listing(listing)
    Enum.each(posts, fn (post) ->
      assert nil != post.author
      assert "" != post.author
    end)
  end
end
