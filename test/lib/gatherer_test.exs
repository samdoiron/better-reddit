defmodule BetterReddit.GathererTest do
  use ExUnit.Case, async: true
  alias BetterReddit.Gatherer
  alias BetterReddit.TestFetcher

  test "fetch_front_page requests the front page" do
    fetcher = TestFetcher.start_link()
    Gatherer.fetch_front_page(fetcher)
    assert TestFetcher.fetched?("https://www.reddit.com/hot.json")
  end
end