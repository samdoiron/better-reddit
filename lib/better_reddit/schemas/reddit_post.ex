defmodule BetterReddit.Schemas.RedditPost do
  @moduledoc ~S"""
  A single reddit post, as returned by the reddit API.
  """

  use Ecto.Schema
  import Ecto.Query, only: [from: 2]
  alias Ecto.Multi
  alias BetterReddit.Schemas.RedditPost
  alias BetterReddit.Schemas.RedditComment

  @primary_key {:reddit_id, :string, []}

  schema "reddit_post" do
    has_many :comments, RedditComment

    field :title, :string
    field :ups, :integer
    field :downs, :integer
    field :url, :string
    field :author, :string
    field :subreddit, :string
    field :time_posted, Timex.Ecto.DateTime
    field :thumbnail, :string
  end

  @doc "Insert new rows, or _replace_ (NOT UPSERT) them if they exist"
  def insert_or_replace_all(rows) do
    insert_or_replace_all(Multi.new(), rows)
  end

  def insert_or_replace_all(multi, rows) do
    # Ecto insert_all only operates on maps or keywords, not structs
    row_maps = rows
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(&remove_magic_ecto_values/1)

    multi
    |> delete_all_by_id(pluck_ids(rows))
    |> Multi.insert_all(:insert_posts, RedditPost, row_maps)
  end

  # Values established via joins and metadata must be removed
  @magic_keys [:"__meta__", :comments]
  defp remove_magic_ecto_values(map) do
    Enum.reduce(@magic_keys, map, &(Map.delete(&2, &1)))
  end

  defp pluck_ids(rows), do: for r <- rows, do: r.reddit_id

  defp delete_all_by_id(multi, ids) do
    posts = from p in RedditPost, where: p.reddit_id in ^ids 
    Multi.delete_all(multi, :delete_existing, posts)
  end
end
