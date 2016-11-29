defmodule BetterReddit.Post do
  alias BetterReddit.Schemas
  alias BetterReddit.Cache

  use GenServer

  @cache_ms 120_000

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, cache} = Cache.start_link(:post_cache, @cache_ms)
    {:ok, [cache: cache]}
  end

  def get_id(post), do: "#{post.source}-#{post.source_id}"

  def get_by_id(composite_id) do
    GenServer.call(__MODULE__, {:get_by_id, composite_id})
  end

  def hot_for_topic(topic_name) do
    GenServer.call(__MODULE__, {:hot_for_topic, topic_name})
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

  def handle_call({:hot_for_topic, topic_name}, _from, state) do
    [cache: cache] = state
    result = Cache.get_or_calculate(cache, topic_name, fn () ->
      Schemas.Post.hot_for_topic(topic_name)
    end)
    {:reply, result, state}
  end
end
