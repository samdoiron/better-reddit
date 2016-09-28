defmodule BetterReddit.Gather do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and stores it in the database.
  """

  alias BetterReddit.Schedule
  alias BetterReddit.Repo
  require Logger

  @reddit_api_timeout_ms 2_000

  def start_link do
    case Task.start_link(fn -> run(load_priorities()) end) do
      {:ok, pid} ->
        Process.register(pid, __MODULE__)
        {:ok, pid}
      other -> other
    end
  end

  def run(priorities) do
    priorities
    |> Schedule.with_priorities()
    |> Enum.each(fn (subreddit) ->
      sleep_timeout()
      update_subreddit(subreddit)
    end)
  end

  defp update_subreddit(name) do
    Logger.debug("updating subreddit #{name}")
    case BetterReddit.Reddit.HTTP.get_subreddit(name) do
      {:ok, listing} -> save_listing(name, listing)
      {:error, _} ->
        Logger.warn("failed to fetch subreddit #{name}")
    end
  end

  defp sleep_timeout do
    :timer.sleep(@reddit_api_timeout_ms)
  end

  defp load_priorities do
    case File.read("config/subreddits.json") do
      {:ok, content} -> content |> Poison.decode!() |> make_priorities()
      {:error, err} -> raise "could not load subreddit list: #{err}"
    end
  end

  defp make_priorities(subreddits) do
    Enum.reduce(subreddits, %{}, fn (subreddit, priorities) ->
      Map.put(priorities, subreddit["name"], subreddit["subscribers"])
    end)
  end

  defp save_listing(name, listing) do
    Repo.put_listing(name, listing)
  end
end
