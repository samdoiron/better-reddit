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
    field :title, :string
    field :source, :string
    field :url, :string
    field :author, :string
    field :topic, :string
    field :score, :integer
    field :time_posted, Timex.Ecto.DateTime
  end

  def hot_for_topic(topic) do
    Post
    |> where([u], ilike(u.topic, ^topic))
    |> where([u], u.time_posted > ago(1, "day"))
    |> order_by([u], [desc: u.score])
    |> Repo.all()
  end
end
