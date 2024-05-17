defmodule PokerPlayerElixirWeb.PlayerTest do
  use PokerPlayerElixir.DataCase, async: true
  alias PokerPlayerElixirWeb.Player

  describe "bet_request/1" do
    setup do
      game_state = %{
        "players" => [
          %{
            "name" => "Player 1",
            "stack" => 1000,
            "status" => "active",
            "bet" => 0,
            "hole_cards" => [],
            "version" => "Version name 1",
            "id" => 0
          },
          %{
            "name" => "Player 2",
            "stack" => 1000,
            "status" => "active",
            "bet" => 0,
            "hole_cards" => [],
            "version" => "Version name 2",
            "id" => 1
          }
        ],
        "tournament_id" => "550d1d68cd7bd10003000003",
        "game_id" => "550da1cb2d909006e90004b1",
        "round" => 0,
        "bet_index" => 0,
        "small_blind" => 10,
        "orbits" => 0,
        "dealer" => 0,
        "community_cards" => [],
        "current_buy_in" => 15,
        "pot" => 0
      }

      [game_state: game_state]
    end

    test "runs" do
      Player.bet_request(%{"current_buy_in" => 10})
      assert true
    end

    test "bets" do
      assert 10 = Player.bet_request(%{"current_buy_in" => 10})
    end

    test "uses game_state", %{game_state: game_state} do
      assert 15 = Player.bet_request(game_state)
    end
  end
end
