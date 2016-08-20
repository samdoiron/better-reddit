defmodule BetterReddit.ListingView do
  use BetterReddit.Web, :view
  use Timex

  def how_long_ago(since) do
    now = Timex.now() |> Timex.to_unix()

    minutes = div(now - since, 60)
    hours = div(minutes, 60)
    days = div(hours, 24)

    cond do
      days > 0 -> "#{days} days"
      hours > 0 -> "#{hours} hours"
      minutes > 0 -> "#{minutes} minutes"
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