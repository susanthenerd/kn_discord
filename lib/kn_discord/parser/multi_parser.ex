defmodule KnDiscord.Parser.MultiParser do
  alias KnDiscord.Repo
  alias KnDiscord.Parser
  alias KnDiscord.Schemas
  require Logger

  def doParsing(data) do
    Logger.debug("Starting parsing for next batch")

    Parser.Users.parse_users(data["users"])
    |> Enum.map(fn attrs ->
      attrs_map = Map.from_struct(attrs)

      Schemas.Users.changeset(%Schemas.Users{}, attrs_map)
      |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
    end)

    Parser.Problems.parse_problems(data["problems"])
    |> Enum.map(fn attrs ->
      attrs_map = Map.from_struct(attrs)

      Schemas.Problems.changeset(%Schemas.Problems{}, attrs_map)
      |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
    end)

    Parser.Submissions.parse_submissions(data["submissions"])
    |> Enum.map(fn attrs ->
      attrs_map = Map.from_struct(attrs)
      Logger.debug(inspect(attrs_map))

      Schemas.Submissions.changeset(%Schemas.Submissions{}, attrs_map)
      |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
    end)
  end
end
