defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller


  def index(conn, params) do
    render_listing(conn, params["listing_name"] || "All")
  end

  defp render_listing(conn, listing_name) do
    render conn, "index.html", listing_name: listing_name,
                               listing: get_listing(listing_name)
  end

  defp get_listing(name) do
    IO.puts("trying to find listing |#{name}|")
    case BetterReddit.Repo.get_listing(name) do
      {:ok, listing} -> listing
      _ -> %BetterReddit.Reddit.Listing{}
    end
  end
end