defmodule KnDiscord.Parser.Submissions do
  require Logger
  alias KnDiscord.Schemas.Submissions

  def parse_submissions(data) do
    parse_submissions_data(data["submissions"])
  end

  defp parse_submissions_data(submissions_map) do
    Enum.map(submissions_map, fn {_submission_id, submission_data} ->
      parse_submission(submission_data)
    end)
  end

  defp parse_submission(submission_data) do
    created_at_value = Map.get(submission_data, "created_at")

    created_at = DateTime.from_iso8601(created_at_value)

    %Submissions{
      id: Map.get(submission_data, "submission_id"),
      created_at: created_at,
      user_id: Map.get(submission_data, "user_id"),
      problem_id: Map.get(submission_data, "problem_id"),
      contest_id: Map.get(submission_data, "contest_id"),
      score: Map.get(submission_data, "score"),
      compile_error: Map.get(submission_data, "compile_error"),
      max_time_ms: Map.get(submission_data, "max_time"),
      max_memory_bytes: Map.get(submission_data, "max_memory"),
      language: Map.get(submission_data, "language"),
      code_size: Map.get(submission_data, "code_size"),
      score_precision: Map.get(submission_data, "score_precision"),
      submission_type: Map.get(submission_data, "submission_type"),
      icpc_verdict: Map.get(submission_data, "icpc_verdict")
    }
  end
end
