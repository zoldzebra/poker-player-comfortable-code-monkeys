defmodule PokerPlayerElixirWeb.Player do
  alias PokerPlayerElixir.Gateway.RainManGateway

  @version "0.0.3"
  def version(), do: @version

  def bet_request(game_state) do
    # high_cards = [
    #   "10",
    #   "J",
    #   "Q",
    #   "K",
    #   "A"
    # ]

    players = game_state["players"]
    [our_player | _] = players
    hole_cards = our_player["hole_cards"]
    ranks = Enum.map(hole_cards, fn card -> card["rank"] end)
    community_cards = game_state["community_cards"]

    our_cards = hole_cards ++ community_cards
    IO.inspect(game_state, label: "game_state")
    IO.inspect(our_cards, label: "our cards")

    if Enum.count(our_cards) >= 5 do
      IO.inspect(
        RainManGateway.fetch_cards_ranking(our_cards),
        label: "cards_ranking"
      )
    end

    cond do
      hole_cards_has_pair(ranks) -> game_state["current_buy_in"] * 2
      hole_has_only_low_cards(ranks) -> 0
      true -> game_state["current_buy_in"]
    end
  end

  defp hole_has_only_low_cards([rank_1, rank_2]) do
    if rank_1 <= "7" && rank_2 <= "7" do
      true
    end
  end

  defp hole_cards_has_pair([rank_1, rank_2]) do
    rank_1 == rank_2
  end

  def showdown(_game_state) do
    ""
  end
end
