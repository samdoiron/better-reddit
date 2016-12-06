defmodule BetterReddit.Schemas.Post do
  @moduledoc ~S"""
  A single post, which could come from many different sources
  """
  use Ecto.Schema
  import Ecto.Query
  alias BetterReddit.Repo
  alias BetterReddit.Schemas.Post


  @primary_key false
  schema "post" do
    field :source_id, :string
    field :title, :string
    field :source, :string
    field :url, :string
    field :author, :string
    field :topic, :string
    field :thumbnail, :string
    field :score, :integer
    field :time_posted, Timex.Ecto.DateTime
  end

  def hot_for_topic(topic) do
    Post
    |> where([u], ilike(u.topic, ^topic))
    |> where([u], u.time_posted > ago(7, "day"))
    |> order_by_hotness()
    |> limit(25)
    |> Repo.all()
  end

  def order_by_hotness(multi) do
    multi
    |> order_by([u], desc:
    # Hot sorting: Score with a halflife of 5 hours
    fragment("power(2.71828, -1 * (1.0/5) * least(24 * 30, greatest(0, extract(epoch from now() - ?) / 3600))) * ?", u.time_posted, u.score))
  end

  def get_by_source_and_id(source, id) do
    post = Post
    |> where([u], u.source == ^source)
    |> where([u], u.source_id == ^id)
    |> Repo.one()

    if post do
      {:ok, post}
    else
      {:error, :not_found}
    end
  end
end
