defmodule KnDiscord.Repo.Migrations.ChangeNullInSubmissions do
  use Ecto.Migration

  def change do
    defmodule KnDiscord.Repo.Migrations.AlterSubmissions do
      use Ecto.Migration

      def change do
        alter table(:submissions) do
          modify(:score, :integer, null: true)
          modify(:compile_error, :boolean, null: true)
          modify(:max_time_ms, :float, null: true)
          modify(:max_memory_bytes, :integer, null: true)
        end
      end
    end
  end
end
