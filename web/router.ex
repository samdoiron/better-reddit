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
    pipe_through :browser

    get "/", ListingController, :index
    resources "/listings", ListingController, only: [:index, :show]

    resources "/posts", PostController, only: [:show]
    get "/posts/:id/embed", PostController, :embed
  end
end
