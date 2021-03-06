defmodule ShowcaseWeb.Router do
  use ShowcaseWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(ShowcaseWeb.Context)
  end

  scope "/", ShowcaseWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug, schema: ShowcaseWeb.Schema)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: ShowcaseWeb.Schema)
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShowcaseWeb do
  #   pipe_through :api
  # end
end
