use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :showcase, ShowcaseWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :showcase, Showcase.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "mysqluser",
  password: "PASSWORD",
  database: "showcase_test",
  hostname: "showcase_mysql",
  pool: Ecto.Adapters.SQL.Sandbox
