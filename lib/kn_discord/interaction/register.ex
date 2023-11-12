defmodule KnDiscord.Interaction.Register do
  use Application
  alias Nostrum.Api
  require Logger

  @command_modules [
    KnDiscord.Interaction.Commands.Ping
    # Add other command modules here
  ]

  def start(_type, _args) do
    Enum.each(@command_modules, &register_global_command(&1.command_definition()))
  end

  def register_commands_test_on_start() do
    test_guild_id = Application.get_env(:kn_discord, :test_server)
    Logger.info("Starting registration of commands in test_server")
    Enum.each(@command_modules, &register_guild_command(test_guild_id, &1.command_definition()))
  end

  def reload_global_command(command_module) do
    command = command_module.command_definition()
    delete_global_command(command.name)
    register_global_command(command)
    Logger.info("#{command.name} command globally reloaded.")
  end

  def reload_guild_command(guild_id, command_module) do
    command = command_module.command_definition()
    delete_guild_command(guild_id, command.name)
    register_guild_command(guild_id, command)
    Logger.info("#{command.name} command reloaded in #{guild_id} guild.")
  end

  defp register_global_command(command) do
    try do
      Api.create_global_application_command(command)
      Logger.info("Command #{command["name"]} was registered")
    rescue
      exception ->
        Logger.error("Failed to register global command: #{inspect(exception)}")
    end
  end

  defp register_guild_command(guild_id, command) do
    try do
      Api.create_guild_application_command(guild_id, command)
      Logger.info("Command #{command["name"]} was registered in #{guild_id}")
    rescue
      exception ->
        Logger.error("Failed to register guild command in #{guild_id}: #{inspect(exception)}")
    end
  end

  defp delete_global_command(command_name) do
    try do
      {:ok, commands} = Api.get_global_application_commands()
      command = Enum.find(commands, &(&1.name == command_name))

      if command, do: Api.delete_global_application_command(command.id)
      Logger.info("Global #{command_name} command deleted.")
    rescue
      exception ->
        Logger.error("Failed to delete global command: #{inspect(exception)}")
    end
  end

  defp delete_guild_command(guild_id, command_name) do
    try do
      {:ok, commands} = Api.get_guild_application_commands(guild_id)
      command = Enum.find(commands, &(&1.name == command_name))

      if command, do: Api.delete_guild_application_command(guild_id, command.id)
      Logger.info("Guild #{command_name} command deleted in #{guild_id} guild.")
    rescue
      exception ->
        Logger.error("Failed to delete guild command in #{guild_id}: #{inspect(exception)}")
    end
  end
end
