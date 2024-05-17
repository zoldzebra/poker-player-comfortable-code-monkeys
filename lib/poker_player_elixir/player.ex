defmodule PokerPlayerElixirWeb.Player do
  @version "0.0.2"
  def version(), do: @version

  def bet_request(game_state) do
    IO.inspect(game_state, label: "game_state")
    IO.inspect(game_state.current_buy_in, label: "current_buy_in")

    game_state.current_buy_in
  end

  def showdown(_game_state) do
    ""
  end
end
