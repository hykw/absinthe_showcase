defmodule ShowcaseWeb.Resolvers.Accounts do
  alias Showcase.{
    Accounts
  }

  alias ShowcaseWeb.Schema.AccountTypes

  def users(_, args, _) do
    {:ok, Accounts.list_users(:normal_user, args)}
  end

  def me(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_, _, _) do
    {:ok, nil}
  end

  def login(_, %{email: email, password: password, permission: perm_atom}, _) do
    permission = AccountTypes.parse_permission(perm_atom)

    case Accounts.authenticate(permission, email, password) do
      {:ok, user} ->
        token =
          Showcase.Authentication.sign(%{
            id: user.id,
            permission: permission
          })

        {:ok, %{token: token, user: user}}

      _ ->
        {:error, "incorrect email or password"}
    end
  end
end
