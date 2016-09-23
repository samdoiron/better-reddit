defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller
  alias BetterReddit.Repo

  def index(conn, params) do
    listing_name = params["listing_name"] || "All"
    conn
    |> put_title(listing_name)
    |> render("index.html", listing_name: listing_name,
                            listing: Repo.get_listing(listing_name))
  end
end
