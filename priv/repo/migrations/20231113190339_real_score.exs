defmodule KnDiscord.Repo.Migrations.RealScore do
  use Ecto.Migration

  def change do
    alter table("submissions") do
      modify(:score, :float, from: :integer)
    end
  end
end
