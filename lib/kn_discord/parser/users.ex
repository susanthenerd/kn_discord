defmodule KnDiscord.Parser.Users do
  alias KnDiscord.Schemas.Users

  def parse_users(data) do
    parse_users_data(data)
  end

  defp parse_users_data(user_map) do
    Enum.map(user_map, fn {_user_id, user_data} ->
      parse_user(user_data)
    end)
  end

  defp parse_user(user_data) do
    %Users{
      id: Map.get(user_data, "id", ""),
      name: Map.get(user_data, "name", ""),
      display_name: Map.get(user_data, "display_name", "")
    }
  end
end
