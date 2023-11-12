defmodule KnDiscord.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications

  use Application

  def start(_type, _args) do
    children = [
      KnDiscord.Consumer,
      KnDiscord.Repo,
      KnDiscord.Fetcher.Submissions
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KnDiscord.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
