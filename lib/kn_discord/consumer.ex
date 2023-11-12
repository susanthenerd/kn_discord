defmodule KnDiscord.Consumer do
  require Logger
  use Nostrum.Consumer

  alias Nostrum.Api

  def handle_event({:READY, _event, _ws_state}) do
    KnDiscord.Interaction.Register.register_commands_test_on_start()
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Logger.debug(msg)

    case msg.content do
      "!ping" ->
        Api.create_message(msg.channel_id, "Pong!")

      "!raise" ->
        raise "No problems here!"

      _ ->
        :ignore
    end
  end

  def handle_event({:INTERACTION_CREATE, interaction, _ws_state}) do
    Logger.debug(interaction)
    KnDiscord.Interaction.Handler.dispatch_command(interaction)
  end

  def handle_event(_event) do
    :noop
  end
end
