defmodule BetterReddit.HTTPFetcher do
  @moduledoc ~S"""
  HTTPFetcher implements the Fetch behaviour, and uses HTTP
  to fetch the requested url.

  If it is successful (receives a 200 response), it will return a
  tuple {:ok, content} where content is a String.

  Otherwise, it will return {:error, reson}
  """

  @behaviour BetterReddit.Fetch

  def fetch(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200}, body: body} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}
      {:ok, %HTTPoison.Response{status_code: 301}} ->
        {:error, :redirect}
      {:ok, %HTTPoison.Response{status_code: 302}} ->
        {:error, :redirect}
      {:ok, _} ->
        {:error, :unknown_status}
      {:error, %HTTPoison.Error{reason: :timeout}} ->
        {:error, :timeout}
      _ ->
        {:error, :unknown_error}
    end
  end
end
