defmodule BetterReddit.ListingView do
  use BetterReddit.Web, :view
  use Timex
  alias BetterReddit.Endpoint
  alias BetterReddit.Router

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

  def listing_path(listing) do
    Router.Helpers.listing_path(Endpoint, :show, listing)
  end

  def listing_class(listing, current_listing) do
    if listing == current_listing do
      "site-sidebar-item is-current"
    else
      "site-sidebar-item"
    end
  end

  def render_post(post) do
    render("post.html", post: post)
  end

  def sidebar_subreddits do
    @sidebar_subreddits |> Enum.sort 
  end

  def how_long_ago(since) do
    now = Timex.now
    minutes = Timex.diff(now, since, :minutes)
    hours = Timex.diff(now, since, :hours)
    days = Timex.diff(now, since, :days)

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
