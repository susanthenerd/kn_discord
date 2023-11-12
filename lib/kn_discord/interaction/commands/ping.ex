defmodule KnDiscord.Interaction.Commands.Ping do
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction

  @command_definition %{
    name: "ping",
    description: "Responds with 'Pong!'",
    options: []
  }

  def command_definition, do: @command_definition

  def handle(%Interaction{} = interaction) do
    response = %{
      type: 4,
      data: %{
        content: "Pong!"
      }
    }

    Api.create_interaction_response(interaction.id, interaction.token, response)
  end
end
