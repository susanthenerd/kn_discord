defmodule KnDiscord.Fetcher.Submissions do
  use GenServer
  require Logger
  import Ecto.Query

  alias KnDiscord.Parser.MultiParser
  alias KnDiscord.Repo
  alias KnDiscord.Schemas

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
    try do
      count_query = from(s in Schemas.Submissions, select: count())
      total_submissions = Repo.one!(count_query)
      div(total_submissions, @limit) * @limit
    rescue
      e in [Ecto.QueryError, Postgrex.Error] ->
        Logger.error("Error fetching submission count: #{inspect(e)}")
        0
    end
  end

  defp fetch_and_schedule(state) do
    case fetch_data(state.last_offset) do
      {:ok, data} ->
        MultiParser.doParsing(data["data"])
        submissions_length = length(data["data"]["submissions"])

        new_offset = calculate_new_offset(submissions_length, state.last_offset)

        determine_action(submissions_length)
        |> perform_action()

        %{state | last_offset: new_offset}

      {:error, reason} ->
        Logger.error("Failed to fetch data: #{reason}")
        schedule_fetch_retry()
        state
    end
  end

  defp calculate_new_offset(submissions_length, last_offset) do
    if submissions_length == @limit, do: last_offset + @limit, else: last_offset
  end

  defp determine_action(submissions_length) do
    if submissions_length == @limit, do: :continue_fetching, else: :fetch
  end

  defp perform_action(:continue_fetching) do
    GenServer.cast(self(), :continue_fetching)
  end

  defp perform_action(:fetch) do
    Process.send_after(self(), :fetch, @interval)
  end

  def handle_cast({:change_offset, new_offset}, state) do
    Logger.debug("Offset is set now to #{new_offset}")
    new_state = fetch_and_schedule(%{state | last_offset: new_offset})
    {:noreply, new_state}
  end

  def handle_cast(:continue_fetching, state) do
    new_state = fetch_and_schedule(state)
    {:noreply, new_state}
  end

  def handle_info(:retry_fetch, state) do
    new_state = fetch_and_schedule(state)
    {:noreply, new_state}
  end

  def handle_info(:fetch, state) do
    new_state = fetch_and_schedule(state)
    {:noreply, new_state}
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

  def change_offset(new_offset) do
    GenServer.cast(__MODULE__, {:change_offset, new_offset})
  end
end
