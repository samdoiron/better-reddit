defmodule BetterReddit.Post do
  alias BetterReddit.Schemas

  def hot_for_topic(topic_name) do
    Schemas.Post.hot_for_topic(topic_name)
  end
end
