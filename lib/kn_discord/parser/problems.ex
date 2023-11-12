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
    published_at_value = Map.get(problem_data, "published_at")

    published_at = DateTime.from_iso8601(published_at_value)

    %Problems{
      id: Map.get(problem_data, "id"),
      name: Map.get(problem_data, "name"),
      default_points: Map.get(problem_data, "default_points"),
      visible: Map.get(problem_data, "visible"),
      visible_tests: Map.get(problem_data, "visible_tests"),
      time_ms: Map.get(problem_data, "time_ms"),
      memory_limit: Map.get(problem_data, "memory_limit"),
      source_size: Map.get(problem_data, "source_size"),
      source_credits: Map.get(problem_data, "source_credits"),
      console_input: Map.get(problem_data, "console_input"),
      score_precision: Map.get(problem_data, "score_precision"),
      published_at: published_at,
      scoring_strategy: Map.get(problem_data, "scoring_strategy")
    }
  end
end
