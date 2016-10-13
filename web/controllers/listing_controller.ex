defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller
  alias BetterReddit.Listing

  def index(conn, _params) do
    text conn, "TODO: listing listing"
  end

  def show(conn, %{ "id" => listing_name }) do
    conn
    |> put_title(listing_name)
    |> render("show.html", listing_name: listing_name,
                           listing: Listing.hot(listing_name))
  end
end
