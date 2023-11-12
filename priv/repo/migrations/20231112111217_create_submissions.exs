defmodule KnDiscord.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions, primary_key: false) do
      add(:id, :integer, primary_key: true)
      add(:created_at, :naive_datetime, null: false)
      add(:user_id, references(:users, on_delete: :nothing), null: false, index: true)
      add(:problem_id, references(:problems, on_delete: :nothing), null: false, index: true)
      add(:contest_id, :integer)
      add(:score, :integer, null: false)
      add(:compile_error, :boolean, null: false)
      add(:max_time_ms, :float, null: false)
      add(:max_memory_bytes, :integer, null: false)
      add(:language, :string)
      add(:code_size, :integer)
      add(:score_precision, :integer)
      add(:submission_type, :string)
      add(:icpc_verdict, :string)
    end
  end
end
