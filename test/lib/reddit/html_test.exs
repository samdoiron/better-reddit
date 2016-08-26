defmodule BetterReddit.HTMLTest do
  use ExUnit.Case
  alias BetterReddit.HTML

  describe "minify" do
    test "removes spaces between tag-node siblings" do
      assert "<a></a><b></b>" == HTML.minify("<a></a> <b></b>")
    end

    test "does not remove spaces between text-node siblings" do
      assert "<a></a> things <b></b>" == HTML.minify("<a></a> things <b></b>")
    end
  end
end