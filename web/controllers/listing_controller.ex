defmodule BetterReddit.ListingController do
  use BetterReddit.Web, :controller
  alias BetterReddit.Repo

  def index(conn, _params) do
    text conn, "TODO: listing listing"
  end

  def show(conn, %{ "id" => listing_name }) do
    conn
    |> put_title(listing_name)
    |> render("show.html", listing_name: listing_name,
                           listing: Repo.get_listing(listing_name))
  end
end
