defmodule PokerPlayerElixirWeb.Player do
  alias PokerPlayerElixir.Gateway.RainManGateway

  @version "0.0.3"
  def version(), do: @version

  def bet_request(game_state) do
    Kernel.round(do_bet_request(game_state))
  end

  def do_bet_request(game_state) do
    players = game_state["players"]
    [our_player | others] = players
    hole_cards = our_player["hole_cards"]
    ranks = Enum.map(hole_cards, fn card -> map_rank_to_number(card["rank"]) end)
    community_cards = game_state["community_cards"]
    current_buy_in = game_state["current_buy_in"]
    stack = our_player["stack"]
    other_player_states = Enum.map(others, fn player -> player["status"] end)

    our_cards = hole_cards ++ community_cards
    IO.inspect(game_state, label: "game_state")
    IO.inspect(our_cards, label: "our cards")

    case get_card_ranking(our_cards) do
      :not_enough_cards ->
        cond do
          hole_cards_has_pair(ranks) ->
            game_state["current_buy_in"] * 2

          hole_has_only_low_cards(ranks) ->
            low_cards_logic(current_buy_in, stack, other_player_states)

          true ->
            high_cards_logic(current_buy_in, stack, other_player_states)
        end

      rank ->
        IO.inspect(rank, label: "rank when we have 5 cards")

        cond do
          rank > 3 -> our_player["stack"]
          rank > 0 -> game_state["current_buy_in"]
          true -> 0
        end
    end
  end

  defp hole_has_only_low_cards([rank_1, rank_2]) do
    if rank_1 < 8 && rank_2 < 8 do
      true
    end
  end

  defp hole_cards_has_pair([rank_1, rank_2]) do
    rank_1 == rank_2
  end

  defp map_rank_to_number(rank) do
    case rank do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      _ -> String.to_integer(rank)
    end
  end

  defp get_card_ranking(our_cards) do
    if Enum.count(our_cards) >= 5 do
      case RainManGateway.fetch_cards_ranking(our_cards) do
        {:ok, cards_ranking} -> cards_ranking["rank"]
        {:error, _} -> :not_enough_cards
      end
    else
      :not_enough_cards
    end
  end

  defp low_cards_logic(current_buy_in, stack, other_player_states) do
    cond do
      current_buy_in > stack * low_cards_limiter(other_player_states) -> 0
      true -> current_buy_in
    end
  end

  defp high_cards_logic(current_buy_in, stack, other_player_states) do
    cond do
      current_buy_in > stack * high_cards_limiter(other_player_states) -> 0
      true -> current_buy_in
    end
  end

  defp low_cards_limiter(other_player_states) do
    case two_of_us_left(other_player_states) do
      true -> 0.4
      false -> 0.1
    end
  end

  defp high_cards_limiter(other_player_states) do
    case two_of_us_left(other_player_states) do
      true -> 0.9
      false -> 0.75
    end
  end

  defp two_of_us_left(other_player_states) do
    Enum.count(other_player_states, fn state -> state == "out" end) > 0
  end

  def showdown(_game_state) do
    ""
  end
end
