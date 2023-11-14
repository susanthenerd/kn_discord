defmodule KnDiscord.Interaction.Commands.SetOffset do
  alias Nostrum.Api
  alias Nostrum.Struct.Interaction
  alias KnDiscord.Fetcher.Submissions

  @command_definition %{
    name: "setoffset",
    description: "Sets the offset",
    options: [
      %{
        type: 4,
        name: "offset",
        description: "New offset to apply",
        required: true
      }
    ]
  }

  def command_definition, do: @command_definition

  def handle(%Interaction{data: %{options: [%{value: offset_value}]}} = interaction) do
    Submissions.change_offset(offset_value)

    response = %{
      type: 4,
      data: %{
        content: "Applied offset: #{offset_value}"
      }
    }

    Api.create_interaction_response(interaction.id, interaction.token, response)
  end
end
