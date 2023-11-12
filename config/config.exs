import Config

config :nostrum,
  # Replace with your bot's token
  token: "MTE3MjI2NzIzODg1ODk2MTA2Nw.GuREWq.nhdjKpzRdMaoayW-xae47W1DlJy_Uo3nb5oNas",
  # This will automatically set the number of shards
  num_shards: :auto,
  gateway_intents: [
    :guild_messages,
    :guild_message_reactions,
    :message_content
  ]

config :kn_discord,
  admin: ["1010557796971978803"],
  test_server: "1109517921853657148"

config :kn_discord, ecto_repos: [KnDiscord.Repo]


config :kn_discord, KnDiscord.Repo,
  username: "admin",
  password: "password",
  database: "kn_discord",
  hostname: "localhost",
  pool_size: 10
