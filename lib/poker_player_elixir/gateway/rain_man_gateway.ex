defmodule PokerPlayerElixir.Gateway.RainManGateway do
  @spec fetch_cards_ranking([%{rank: String.t(), suit: String.t()}]) ::
          {:ok, String.t()} | {:error, String.t()}
  def fetch_cards_ranking(cards) do
    cards_json = Jason.encode!(cards)

    query_string = URI.encode_query(cards: cards_json)

    url = "https://rainman.leanpoker.org/rank?" <> query_string

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, decoded_body} ->
            {:ok, decoded_body}

          {:error, _} ->
            {:error, "Failed to decode response body"}
        end

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request error: #{reason}"}
    end
  end
end
