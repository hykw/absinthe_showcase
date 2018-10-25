defmodule ShowcaseWeb.Schema do
  use Absinthe.Schema

  alias ShowcaseWeb.Resolvers

  import_types(__MODULE__.AccountTypes)

  query do
    import_fields(:user_queries)
  end

  object :user_queries do
    @desc """
    query user info(admin accounts are excluded)
    """

    field :users, list_of(:user) do
      resolve(&Resolvers.Accounts.users/3)
    end
  end
end
