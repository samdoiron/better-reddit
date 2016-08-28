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

  def rewrite_url(url) do
    parsed = URI.parse(url)
    cond do
      imgur?(parsed) ->
        cond do
          imgur_comments?(parsed) -> imgur_image(parsed)
          :else -> url
        end
      :else -> url
    end
  end

  defp pluralize(word, number) when number == 1, do: "#{number} #{word}"
  defp pluralize(word, number), do: "#{number} #{word}s"

  defp imgur?(uri) do
    String.ends_with?(uri.host, "imgur.com")
  end

  defp imgur_comments?(uri) do
    uri.host == "imgur.com" and imgur_comment_extension?(uri.path)
  end

  defp imgur_comment_extension?(path) do
    chars = String.to_charlist(path)
    Enum.count(chars, &(&1 == '/')) == 1 and
      Enum.count(chars, &(&1 == '.')) == 0
  end

  defp imgur_image(uri) do
    "#https://i.{uri.host}#{uri.path}.png"
  end
end