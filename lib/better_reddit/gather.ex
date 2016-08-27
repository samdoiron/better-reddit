defmodule BetterReddit.Gather do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and stores it in the database.
  """

  require Logger

  @reddit_api_timeout_ms 2_000

  def start_link do
    case Task.start_link(fn -> run(load_subreddits()) end) do
      {:ok, pid} ->
        Process.register(pid, __MODULE__)
        {:ok, pid}
      other -> other
    end
  end

  def run(subreddits) do
    for subreddit <- subreddits do
      sleep_timeout()
      update_subreddit(subreddit)
    end
    run(subreddits)
  end

  defp update_subreddit(name) do
    Logger.debug("updating subreddit #{name}")
    listing = BetterReddit.Reddit.HTTP.get_subreddit(name)
    BetterReddit.Repo.put_listing(name, listing)
  end

  defp sleep_timeout do
    :timer.sleep(@reddit_api_timeout_ms)
  end

  defp load_subreddits do
    case File.read("config/subreddits.txt") do
      {:ok, content} -> content |> String.split("\n")
      {:err, err} -> raise "could not load subreddit list: #{err}"
    end
  end
end