defmodule BetterReddit.Router do
  use BetterReddit.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BetterReddit.Plugs.MinifyHTML
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", BetterReddit do
    pipe_through :browser # Use the default browser stack

    get "/", ListingController, :index
    resources "/listings", ListingController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BetterReddit do
  #   pipe_through :api
  # end
end
