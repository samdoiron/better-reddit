defmodule BetterReddit.Schemas.RedditPost do
  @moduledoc ~S"""
  A single reddit post, as returned by the reddit API.
  """

  use Ecto.Schema
  import Ecto.Changeset, only: [change: 2]

  alias Ecto.Multi
  alias BetterReddit.Schemas.RedditComment
  alias BetterReddit.Schemas.Thumbnail

  @primary_key {:reddit_id, :string, []}
  @association_fields [:comments, :thumbnail]

  schema "reddit_post" do
    has_many :comments, RedditComment

    field :title, :string
    field :ups, :integer
    field :downs, :integer
    field :url, :string
    field :author, :string
    field :subreddit, :string
    field :time_posted, Timex.Ecto.DateTime
    field :thumbnail_url, :string
    has_one :thumbnail, Thumbnail
  end

  @doc "Insert new rows, or _replace_ (NOT UPSERT) them if they exist"
  def insert_all(posts) do
    Enum.reduce(posts, Multi.new(), fn (post, multi) ->
      Multi.insert(multi, {:insert_post, post.reddit_id}, post)
    end)
  end

  def update_all(posts) do
    Enum.reduce(posts, Multi.new(), fn (post, multi) ->
      changes = post
      |> change(ups: post.ups)
      |> change(downs: post.downs)
      Multi.update(multi, {:update_post, post.reddit_id}, changes)
    end)
  end
end
