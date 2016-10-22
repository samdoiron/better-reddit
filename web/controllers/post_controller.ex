defmodule BetterReddit.PostController do
  use BetterReddit.Web, :controller
  alias BetterReddit.Post

  def index(conn, _params) do
    text conn, "post listing"
  end

  def show(conn, %{ "id" => post_id }) do
    case Post.get_by_id(post_id) do
      {:ok, post} -> render_post(conn, post)
      {:error, :not_found} -> render_404(conn)
      _ -> render_error(conn)
    end
  end

  defp render_post(conn, post) do
    conn
    |> put_title(post.title)
    |> render("show.html", post: post)
  end

  defp render_404(conn) do
    conn
    |> put_status(:not_found)
    |> render(BetterReddit.ErrorView, "404.html")
  end

  defp render_error(conn) do
    text conn, "uh oh"
  end
end
