defmodule KnDiscord.Interaction.Handler do
  require Logger
  alias Nostrum.Struct.Interaction
  alias KnDiscord.Interaction.Commands

  def dispatch_command(%Interaction{data: %{:name => "ping"} = _data} = interaction) do
    Commands.Ping.handle(interaction)
  end

  def dispatch_command(%Interaction{data: %{:name => "setoffset"} = _data} = interaction) do
    Commands.SetOffset.handle(interaction)
  end

  def dispatch_command(%Interaction{} = interaction) do
    Logger.error("Unexpected interaction: #{inspect(interaction)}")
  end
end
