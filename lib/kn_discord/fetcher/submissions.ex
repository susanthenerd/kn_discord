defmodule KnDiscord.Fetcher.Submissions do
  use GenServer
  require Logger
  alias KnDiscord.Parser
  alias KnDiscord.Schemas
  alias KnDiscord.Repo

  @interval 60_000
  @api_url "https://kilonova.ro/api/submissions/get"
  @limit 50
  @error_delay 900_000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_) do
    last_offset = get_last_state()
    state = %{last_offset: last_offset}
    fetch_and_schedule(state)
    {:ok, state}
  end

  defp get_last_state() do
    case fetch_data(0) do
      {:ok, data} ->
        total_submissions = data["data"]["count"]
        div(total_submissions, @limit) * @limit

      {:error, _reason} ->
        schedule_retry()
        # Default offset in case of an error, returned after scheduling a retry
        0
    end
  end

  defp schedule_retry() do
    Process.send_after(self(), :retry_get_last_state, @error_delay)
  end

  def handle_cast({:change_offset, new_offset}, state) do
    new_state = %{state | last_offset: new_offset}
    {:noreply, fetch_and_schedule(new_state)}
  end

  defp doParsing(data) do
    Parser.Users.parse_users(data["users"])
    |> Enum.map(fn attrs ->
      attrs_map = Map.from_struct(attrs)
      Logger.debug(inspect(attrs_map))

      Schemas.Users.changeset(%Schemas.Users{}, attrs_map)
      |> Repo.insert(on_conflict: :nothing, conflict_target: :id)
    end)

    Logger.debug(inspect(data["problems"]))

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

  defp fetch_and_schedule(state) do
    case fetch_data(state.last_offset) do
      {:ok, data} ->
        new_offset = state.last_offset + @limit
        new_state = %{state | last_offset: new_offset}
        doParsing(data["data"])

        if length(data["data"]["count"]) == @limit do
          GenServer.cast(self(), :continue_fetching)
        else
          Process.send_after(self(), :fetch, @interval)
        end

        new_state

      {:error, reason} ->
        Logger.error("Failed to fetch data: #{reason}")
        schedule_fetch_retry()
        state
    end
  end

  defp schedule_fetch_retry() do
    Process.send_after(self(), :retry_fetch, @error_delay)
  end

  defp fetch_data(offset) do
    url = "#{@api_url}?ascending=true&limit=#{@limit}&ordering=id&offset=#{offset}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def handle_info(:retry_fetch, state) do
    fetch_and_schedule(state)
  end

  def handle_info(:fetch, state) do
    fetch_and_schedule(state)
  end

  def handle_info(:continue_fetching, state) do
    fetch_and_schedule(state)
  end

  def change_offset(new_offset) do
    GenServer.cast(__MODULE__, {:change_offset, new_offset})
  end
end
