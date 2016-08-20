defmodule BetterReddit.Reddit do
  @moduledoc ~S"""
  The Reddit behaviour describes any way of getting access to the
  Reddit data api.
  """

  @callback get_front_page() :: BetterReddit.Reddit.Listing
end
