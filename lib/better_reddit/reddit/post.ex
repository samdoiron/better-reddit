defmodule BetterReddit.Reddit.Post do
  @moduledoc ~S"""
  A single reddit post, as returned by the reddit API.
  """

  use Ecto.Schema
  alias BetterReddit.Reddit.Post

  schema "reddit_post" do
    field :reddit_id, :string
    field :title, :string
    field :ups, :integer
    field :downs, :integer
    field :url, :string
    field :author, :string
    field :subreddit, :string
    field :time_posted, Ecto.DateTime
  end
end
