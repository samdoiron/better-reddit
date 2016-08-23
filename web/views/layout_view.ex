defmodule BetterReddit.LayoutView do
  use BetterReddit.Web, :view


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
  )

  defp sidebar_subreddits do
    @sidebar_subreddits |> Enum.sort 
  end
end
