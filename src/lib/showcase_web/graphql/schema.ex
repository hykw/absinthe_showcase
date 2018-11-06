defmodule ShowcaseWeb.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)

  alias ShowcaseWeb.Resolvers
  alias ShowcaseWeb.Schema.Middleware

  alias Showcase.{
    Accounts,
    QA
  }

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

  ##################################################

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
    import_fields(:login)
    import_fields(:create_user)
  end

  object :user_queries do
    @desc """
    query user info(admin accounts are excluded)
    """

    field :users, list_of(:user) do
      arg(:id, :id)
      arg(:nickname, :string)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.Accounts.users/3)
    end
  end

  object :me_queries do
    @desc """
    query one's own info
    """

    field :me, :me do
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.Me.me/3)
    end
  end

  object :question_queries do
    @desc """
    query questions(includes answers)
    """

    field :questions, list_of(:question) do
      arg(:id, :id)
      arg(:title, :string)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.questions/3)
    end
  end

  object :answer_queries do
    @desc """
    answer questions(includes user and question)
    """

    field :answers, list_of(:answer) do
      arg(:id, :id)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.answers/3)
    end
  end

  object :login do
    @desc """
    login with the params
    """

    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:permission, non_null(:permission))
      resolve(&Resolvers.Accounts.login/3)
    end
  end

  object :create_user do
    @desc """
    create user account
    """

    field :create_user, :user_with_priv_result do
      arg(:email, non_null(:string))
      arg(:nickname, non_null(:string))
      arg(:password, non_null(:string))
      arg(:permission, non_null(:permission))

      middleware(Middleware.Authorize, :admin)
      resolve(&Resolvers.Accounts.create_user/3)
    end
  end
end
