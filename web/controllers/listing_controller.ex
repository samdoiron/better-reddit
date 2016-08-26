defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller
  import ExProf.Macro

  def index(conn, params) do
    render conn, "index.html", listing: get_listing(params["listing_name"])
  end

  defp get_listing(nil) do
    get_listing("all")
  end

  defp get_listing(name) do
    case BetterReddit.Repo.get_listing(name) do
      {:ok, listing} -> listing
      _ -> %BetterReddit.Reddit.Listing{}
    end
  end
end