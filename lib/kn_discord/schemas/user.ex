defmodule KnDiscord.Schemas.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :integer, autogenerate: false}
  schema "users" do
    field(:name, :string)
    field(:display_name, :string)
    field(:discord_id, :string)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :name, :display_name, :discord_id])
    |> validate_required([:id, :name])
  end
end
