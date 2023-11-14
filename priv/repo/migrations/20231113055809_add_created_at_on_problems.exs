defmodule KnDiscord.Repo.Migrations.AddCreatedAtOnProblems do
  use Ecto.Migration

  def change do
    alter table("problems") do
      add(:created_at, :utc_datetime)
    end
  end
end
