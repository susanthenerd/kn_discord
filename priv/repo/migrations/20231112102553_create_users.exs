defmodule KnDiscord.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :integer, primary_key: true)
      add(:name, :string, null: false)
      add(:display_name, :string)
      add(:discord_id, :string)
    end
  end
end
