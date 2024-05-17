defmodule PokerPlayerElixirWeb.Player do
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

    if has_pair(ranks) do
      game_state["current_buy_in"] * 2
    else
      game_state["current_buy_in"]
    end
  end

  defp has_pair([card_1, card_2]) do
    card_1 == card_2
  end

  def showdown(_game_state) do
    ""
  end
end
