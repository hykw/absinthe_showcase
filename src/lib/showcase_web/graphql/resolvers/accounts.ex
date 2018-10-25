defmodule ShowcaseWeb.Resolvers.Accounts do
  alias Showcase.{
    Accounts
  }

  def users(_, _args, _) do
    {:ok, Accounts.list_users(:normal_user)}
  end
end
