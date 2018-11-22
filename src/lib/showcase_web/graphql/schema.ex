defmodule ShowcaseWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  alias ShowcaseWeb.Schema.Middleware

  alias Showcase.{
    Accounts,
    QA
  }

  import_types(__MODULE__.AccountTypes)
  import_types(__MODULE__.QATypes)
  import_types(__MODULE__.MultiTypes)

  query do
    import_fields(:user_queries)
    import_fields(:me_queries)
    import_fields(:question_queries)
    import_fields(:answer_queries)
  end

  mutation do
    import_fields(:login_mutations)
    import_fields(:create_user_mutations)
  end

  ##################################################

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> Dataloader.add_source(QA, QA.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end
end
