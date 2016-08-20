defmodule BetterReddit.Reddit.Listing do
  @moduledoc ~S"""
  A Listing is a collection of reddit posts in order, as returned
  by the reddit API. For example, the front-page is a listing.
  """

  defstruct posts: []
end