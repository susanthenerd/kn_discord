defmodule KnDiscord.Repo.Migrations.DateTimeMigration do
  use Ecto.Migration

  def change do
    alter table("submissions") do
      modify(:created_at, :utc_datetime, from: :naive_datetime)
    end

    alter table("problems") do
      remove(:published_at)
      add(:published_at, :utc_datetime)
    end
  end
end
