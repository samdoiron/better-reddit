defmodule BetterReddit.Post do
  alias BetterReddit.Schemas

  def get_by_id(composite_id) do
    case split_id(composite_id) do
      [source, id] -> Schemas.Post.get_by_source_and_id(source, id)
      _ -> {:error, "wrong number of sections in id"}
    end
  end

  def hot_for_topic(topic_name) do
    Schemas.Post.hot_for_topic(topic_name)
  end

  defp split_id(composite_id) do
    String.split(composite_id, "-")
  end
end
