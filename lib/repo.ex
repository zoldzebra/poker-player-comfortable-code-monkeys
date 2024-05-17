defmodule PokerPlayerElixir.Repo do
  use Ecto.Repo,
    otp_app: :poker_player_elixir,
    adapter: Ecto.Adapters.Postgres
end
