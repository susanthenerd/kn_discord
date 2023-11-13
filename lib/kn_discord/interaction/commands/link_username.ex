defmodule KnDiscord.Interaction.Commands.LinkUsername do
  use Nostrum
  alias KnDiscord.Schemas
  alias KnDiscord.Repo
  alias Ecto.Query
  require Logger

  @command_definition %{
    name: "linkusername",
    description: "Link Kilonova account to discord",
    options: [
      %{
        type: 3,
        name: "Username",
        description: "Username on Kilonova",
        required: true
      }
    ]
  }

  def command_definition, do: @command_definition

  def handle(
        %Nostrum.Struct.Interaction{
          id: id,
          data: %{options: [%{value: username}]},
          token: token,
          member: member
        } = interaction
      ) do
    Api.create_interaction_response(id, token, %{type: 5})

    random_problem =
      Repo.one(
        from(p in Schemas.Problems,
          order_by: fragment("RANDOM()"),
          limit: 1
        )
      )

    response = %{
      type: 4,
      data: %{
        content:
          "Submit a compile error to https://kilonova.ro/problems/#{random_problem.id} in the next minute"
      }
    }

    Api.create_interaction_response(interaction.id, interaction.token, response)

    Task.start(fn ->
      :timer.sleep(120_000)
      check_for_submission(username, random_problem.id, interaction, member.user.id)
    end)
  end

  defp check_for_submission(username, problem_id, interaction, discord_id) do
    user = Repo.get_by(Users, name: username)

    if user do
      submission =
        Repo.one(
          from(s in Submissions,
            where: s.user_id == ^user.id and s.problem_id == ^problem_id,
            limit: 1
          )
        )

      if submission do
        link_accounts(user, discord_id)
        send_discord_response(interaction, "Your Kilonova account has been successfully linked.")
      else
        send_discord_response(
          interaction,
          "Failed to link Kilonova account. No matching submission found."
        )
      end
    else
      send_discord_response(interaction, "Kilonova username not found.")
    end
  end

  defp link_accounts(user, discord_id) do
    changeset = Users.changeset(user, %{discord_id: discord_id})
    Repo.update(changeset)
  end

  defp send_discord_response(interaction, message) do
    Nostrum.Api.create_followup_message(interaction.token, %{
      content: message
    })
  end
end
