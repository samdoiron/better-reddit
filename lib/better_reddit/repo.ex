defmodule BetterReddit.Repo do
  @moduledoc ~S"""
  Stores all post state for BetterReddit. Runs as a separate service,
  so that it can be a location-independant service.
  """
  alias BetterReddit.Reddit.Listing

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_listing(name, listing) do
    Agent.update(__MODULE__, fn current ->
      Map.put(current, String.downcase(name), listing)
    end)
  end

  def get_listing(name) do
    Agent.get(__MODULE__, fn listings ->
      listings[String.downcase(name)] || %Listing{}
    end)
  end
end
