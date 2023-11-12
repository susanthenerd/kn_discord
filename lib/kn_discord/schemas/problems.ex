defmodule KnDiscord.Schemas.Problems do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "problems" do
    field(:name, :string)
    field(:default_points, :integer)
    field(:visible, :boolean)
    field(:visible_tests, :boolean)
    field(:time_ms, :float)
    field(:memory_limit, :integer)
    field(:source_size, :integer)
    field(:source_credits, :string)
    field(:console_input, :boolean)
    field(:score_precision, :integer)
    field(:published_at, :utc_datetime)
    field(:scoring_strategy, :string)
  end

  def changeset(problem, attrs) do
    problem
    |> cast(attrs, [
      :id,
      :name,
      :default_points,
      :visible,
      :visible_tests,
      :time_ms,
      :memory_limit,
      :source_size,
      :source_credits,
      :console_input,
      :score_precision,
      :published_at,
      :scoring_strategy
    ])
    |> validate_required([:id, :name, :default_points, :time_ms, :memory_limit])
  end
end
