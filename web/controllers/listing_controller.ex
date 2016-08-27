defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller


  def index(conn, params) do
    render conn, "index.html", listing_name: params["listing_name"],
                               listing: get_listing(params["listing_name"])
  end

  defp get_listing(nil) do
    get_listing("all")
  end

  defp get_listing(name) do
    IO.puts("trying to find listing |#{name}|")
    case BetterReddit.Repo.get_listing(name) do
      {:ok, listing} -> listing
      _ -> %BetterReddit.Reddit.Listing{}
    end
  end
end