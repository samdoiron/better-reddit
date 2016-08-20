defmodule BetterReddit.FrontPage do

  alias BetterReddit.Reddit.Post


  def posts do
    [
      %Post{
        title: "Example post",
        ups: 1337,
        downs: 13,
        url: "https://www.google.com",
        author: "TinSnail"
      }
    ]
  end
end