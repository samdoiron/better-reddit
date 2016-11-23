defmodule BetterReddit.Cache do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [table_name: name])
  end

  def get_or_calculate(cache, key, fallback_fn) do
    case GenServer.call(cache, {:get, key}) do
      {:found, result} -> result
      :not_found -> set(cache, key, fallback_fn.())
    end
  end

  def set(cache, key, value) do
    GenServer.call(cache, {:set, key, value})
  end

  def handle_call({:get, key}, _from, state) do
    [table_name: name] = state
    case :ets.lookup(name, key) do
      [{_key, value}] -> {:reply, {:found, value}, state}
      _ -> {:reply, :not_found, state}
    end
  end

  def handle_call({:set, key, value}, _from, state) do
    [table_name: name] = state
    true = :ets.insert(name, {key, value})
    {:reply, value, state}
  end

  def init([table_name: name]) do
    :ets.new(name, [:named_table, :set, :private])
    {:ok, [table_name: name]}
  end
end
