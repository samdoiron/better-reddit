defmodule BetterReddit.Repo do
  @moduledoc ~S"""
  The primary Ecto storage repo.
  """

  use Ecto.Repo, otp_app: :better_reddit

  def put_listing(_, _) do
  end

  def get_listing(_id) do
    %BetterReddit.Reddit.Listing{
      posts: [
        %BetterReddit.Reddit.Post{
          title: "hello",
          url: "http://www.google.com",
          subreddit: "foo",
          thumbnail: nil
        }
      ]
    }
  end
end
