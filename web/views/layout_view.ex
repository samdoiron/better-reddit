defmodule BetterReddit.LayoutView do
  use BetterReddit.Web, :view

  def site_css do
    case File.read("priv/static/css/app.css") do
      {:ok, css} -> css
      {:err, _} -> ""
    end
  end
end
