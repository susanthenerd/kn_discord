defmodule KnDiscord.Repo.Migrations.AddIndexToDiscordIdInUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify(:discord_id, :string, index: true)
    end
  end
end
