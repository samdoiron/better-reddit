defmodule BetterReddit.Post do
  alias BetterReddit.Schemas

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_id(post), do: "#{post.source}-#{post.source_id}"

  def get_by_id(composite_id) do
    GenServer.call(__MODULE__, {:get_by_id, composite_id})
  end

  def hot_posts_in_community(topic_name) do
    GenServer.call(__MODULE__, {:hot_posts_in_community, topic_name})
  end

  def hot_discussions_in_community(topic_name) do
    GenServer.call(__MODULE__, {:hot_discussions_in_community, topic_name})
  end

  defp split_id(composite_id) do
    String.split(composite_id, "-")
  end

  def handle_call({:get_by_id, composite_id}, _from, state) do
    result = case split_id(composite_id) do
      [source, id] -> Schemas.Post.get_by_source_and_id(source, id)
      _ -> {:error, "wrong number of sections in id"}
    end
    {:reply, result, state}
  end

  def handle_call({:hot_posts_in_community, topic_name}, _from, state) do
    result = Schemas.Post.hot_posts_in_community(topic_name)
    {:reply, result, state}
  end

  def handle_call({:hot_discussions_in_community, topic_name}, _from, state) do
    result = Schemas.Post.hot_discussions_in_community(topic_name)
    {:reply, result, state}
  end
end
