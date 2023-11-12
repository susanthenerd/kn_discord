defmodule KnDiscord.Repo.Migrations.CreateProblems do
  use Ecto.Migration

  def change do
    create table(:problems, primary_key: false) do
      add(:id, :integer, primary_key: true)
      add(:name, :string, null: false)
      add(:test_name, :string)
      add(:default_points, :integer, null: false)
      add(:visible, :boolean)
      add(:visible_tests, :boolean)
      add(:time_ms, :float, null: false)
      add(:memory_limit, :integer, null: false)
      add(:source_size, :integer)
      add(:source_credits, :string)
      add(:console_input, :boolean)
      add(:score_precision, :integer)
      add(:published_at, :string)
      add(:scoring_strategy, :string)
    end
  end
end
