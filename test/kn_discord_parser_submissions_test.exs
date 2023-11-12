defmodule KnDiscord.Parser.SubmissionsTest do
  use ExUnit.Case
  alias KnDiscord.Parser.Submissions
  alias KnDiscord.Schemas.Submission

  describe "parse_submissions/1" do
    test "parses valid submissions data correctly" do
      data = %{
        "submissions" => [
          %{
            "id" => 1,
            "created_at" => "2021-01-01T00:00:00Z",
            "user_id" => 123,
            "problem_id" => 456,
            "contest_id" => 789,
            "score" => 100,
            "compile_error" => false,
            "max_time" => 2000,
            "max_memory" => 1024,
            "language" => "Elixir",
            "code_size" => 512,
            "score_precision" => 2,
            "submission_type" => "TypeA",
            "icpc_verdict" => "Accepted"
          }
          # Add more submissions as needed for thorough testing
        ]
      }

      result = Submissions.parse_submissions(data)

      assert length(result) == length(data["submissions"])

      assert result == [
               %Submission{
                 id: 1,
                 created_at: DateTime.from_iso8601!("2021-01-01T00:00:00Z"),
                 user_id: 123
                 # ... and so on
               }
             ]
    end

    test "handles invalid data gracefully" do
      # Example of invalid data
      invalid_data = %{"submissions" => [%{"id" => nil}]}

      assert_raise ArgumentError, fn ->
        Submissions.parse_submissions(invalid_data)
      end
    end

    # Additional test cases for edge cases, missing fields, etc.
  end
end
