defmodule ShowcaseWeb.Resolvers.Accounts do
  alias Showcase.{
    Accounts
  }

  def users(_, args, _) do
    {:ok, Accounts.list_users(:normal_user, args)}
  end
end
