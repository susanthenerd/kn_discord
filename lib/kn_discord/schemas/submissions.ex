defmodule KnDiscord.Schemas.Submissions do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "submissions" do
    field(:created_at, :utc_datetime)
    field(:score, :float)
    field(:compile_error, :boolean)
    field(:max_time_ms, :float)
    field(:max_memory_bytes, :integer)
    field(:language, :string)
    field(:code_size, :integer)
    field(:score_precision, :integer)
    field(:submission_type, :string)
    field(:icpc_verdict, :string)
    field(:contest_id, :integer)

    belongs_to(:users, KnDiscord.Schemas.Users, foreign_key: :user_id, type: :integer)
    belongs_to(:problems, KnDiscord.Schemas.Problems, foreign_key: :problem_id, type: :integer)
  end

  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [
      :id,
      :created_at,
      :user_id,
      :problem_id,
      :contest_id,
      :score,
      :compile_error,
      :max_time_ms,
      :max_memory_bytes,
      :language,
      :code_size,
      :score_precision,
      :submission_type,
      :icpc_verdict
    ])
    |> validate_required([
      :id,
      :user_id,
      :problem_id
    ])
  end
end
