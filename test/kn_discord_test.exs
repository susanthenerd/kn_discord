defmodule KnDiscordTest do
  use ExUnit.Case
  doctest KnDiscord

  test "greets the world" do
    assert KnDiscord.hello() == :world
  end
end
