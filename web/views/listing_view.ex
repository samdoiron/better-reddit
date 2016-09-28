defmodule BetterReddit.ListingView do
  use BetterReddit.Web, :view
  use Timex

  @sidebar_subreddits ~w(
    Programming
    AskReddit
    Funny
    Gifs
    Videos
    Technology
    ShowerThoughts
    ExplainLikeImFive
    Overwatch
    TodayILearned
    AskScience
    UpliftingNews
    Pics
  )

  defp sidebar_subreddits do
    @sidebar_subreddits |> Enum.sort 
  end

  def how_long_ago(since) do
    now = Timex.now() |> Timex.to_unix()

    minutes = div(now - since, 60)
    hours = div(minutes, 60)
    days = div(hours, 24)

    cond do
      days > 0 -> pluralize("day", days)
      hours > 0 -> pluralize("hour", hours)
      minutes > 0 -> pluralize("minute", minutes)
      :else -> "no time"
    end
  end
  def rewrite_title(_title) do
  end

  defp pluralize(word, number) when number == 1, do: "#{number} #{word}"
  defp pluralize(word, number), do: "#{number} #{word}s"
end
