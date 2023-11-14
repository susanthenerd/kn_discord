defmodule KnDiscordParserProblemsTest do
  use ExUnit.Case
  alias KnDiscord.Parser.Problems
  alias KnDiscord.Schemas.Problems

  describe "parse_problems/1" do
    test "parses a valid problem correctly" do
      data = %{
        "problems" => [
          %{
            "id" => 123,
            "name" => "Sample Problem",
            "test_name" => "sample_test",
            "default_points" => 10,
            "visible" => true,
            "visible_tests" => 2,
            "time_ms" => 1000,
            "memory_limit" => 512_000,
            "source_size" => 1024,
            "source_credits" => "Some Source",
            "console_input" => false,
            "score_precision" => 2,
            "published_at" => "2021-01-01T00:00:00Z",
            "scoring_strategy" => "Standard"
          }
        ]
      }

      parsed_problems = Problems.parse_problems(data)

      assert length(parsed_problems) == 1

      assert parsed_problems == [
               %Problems{
                 id: 123,
                 name: "Sample Problem",
                 test_name: "sample_test",
                 default_points: 10,
                 visible: true,
                 visible_tests: 2,
                 time_ms: 1000,
                 memory_limit: 512_000,
                 source_size: 1024,
                 source_credits: "Some Source",
                 console_input: false,
                 score_precision: 2,
                 published_at: DateTime.from_iso8601!("2021-01-01T00:00:00Z"),
                 scoring_strategy: "Standard"
               }
             ]
    end

    test "handles incorrect data format" do
      incorrect_data = %{
        "problems" => [
          %{
            # Incorrect id format
            "id" => nil,
            # Name should be a string
            "name" => 123,
            # Incorrect date format
            "published_at" => "invalid-date-format"
            # Other fields omitted for brevity
          }
        ]
      }

      assert_raise FunctionClauseError, fn ->
        Problems.parse_problems(incorrect_data)
      end
    end

    # Additional tests for edge cases, different data scenarios, etc., can be added here.
  end
end
