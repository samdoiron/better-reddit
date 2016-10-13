defmodule BetterReddit.Listing do
  alias BetterReddit.Listing
  alias BetterReddit.Post

  defstruct name: "", posts: []

  def hot(topic) do
    %Listing{
      name: topic,
      posts: Post.hot_for_topic(topic)
    }
  end
end
