defmodule KnDiscord.Repo do
  use Ecto.Repo,
    otp_app: :kn_discord,
    adapter: Ecto.Adapters.Postgres
end
