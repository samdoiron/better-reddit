defmodule BetterReddit.Reddit.PostSchema do
  use Ecto.Schema

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
