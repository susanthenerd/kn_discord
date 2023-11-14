defmodule KnDiscord.Parser.Problems do
  alias KnDiscord.Schemas.Problems
  require Logger

  def parse_problems(data) do
    parse_problems_data(data)
  end

  defp parse_problems_data(problems_map) do
    Enum.map(problems_map, fn {_problem_id, problem_data} ->
      parse_problem_data(problem_data)
    end)
  end

  defp parse_problem_data(problem_data) do
    published_at_utc = parse_datetime(Map.get(problem_data, "published_at"))
    created_at_utc = parse_datetime(Map.get(problem_data, "created_at"))

    %Problems{
      id: Map.get(problem_data, "id"),
      name: Map.get(problem_data, "name"),
      test_name: Map.get(problem_data, "test_name"),
      default_points: Map.get(problem_data, "default_points"),
      visible: Map.get(problem_data, "visible"),
      visible_tests: Map.get(problem_data, "visible_tests"),
      time_ms: Map.get(problem_data, "time_limit"),
      memory_limit: Map.get(problem_data, "memory_limit"),
      source_size: Map.get(problem_data, "source_size"),
      source_credits: Map.get(problem_data, "source_credits"),
      console_input: Map.get(problem_data, "console_input"),
      score_precision: Map.get(problem_data, "score_precision"),
      published_at: published_at_utc,
      created_at: created_at_utc,
      scoring_strategy: Map.get(problem_data, "scoring_strategy")
    }
  end

  defp parse_datetime(nil), do: nil

  defp parse_datetime(datetime_str) do
    case DateTime.from_iso8601(datetime_str) do
      {:ok, datetime, _} ->
        datetime

      {:error, reason} ->
        Logger.debug(reason)
        Logger.debug(inspect(datetime_str))
        nil
    end
  end
end
