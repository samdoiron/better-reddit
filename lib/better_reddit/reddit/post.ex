defmodule BetterReddit.Reddit.Post do
  @moduledoc ~S"""
  Contains a subset of the data about a reddit post as returned
  by the reddit API (from a listing).
  """
  defstruct title: "", ups: 0, downs: 0, url: "", author: "", subreddit: "", created_timestamp: 0
end
