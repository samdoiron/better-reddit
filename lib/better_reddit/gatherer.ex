defmodule BetterReddit.Gatherer do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and stores it in the database.
  """

  def start_link do
    Task.start_link(fn -> run() end)
  end

  def fetch_front_page(_fetcher) do
  end

  def run do
    fetch_front_page(0)
    run
  end
end
