defmodule ShowcaseWeb.Resolvers.Accounts do
  alias Showcase.{
    Accounts
  }

  alias ShowcaseWeb.Schema.AccountTypes

  def users(_, args, info) do
    new_args =
      args
      |> Map.put_new(:limit, 5)
      |> Map.put_new(:offset, 0)

    {:ok, Accounts.list_users(:normal_user, new_args, info)}
  end

  def login(_, %{email: email, password: password, permission: perm_atom}, _) do
    permission = AccountTypes.parse_perm_to_int(perm_atom)

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

  def create_user(
        _,
        %{email: _email, nickname: _nickname, password: password, permission: perm_atom} = params,
        _
      ) do
    permission = AccountTypes.parse_perm_to_int(perm_atom)

    new_params =
      params
      |> Map.put(:permission, permission)
      |> Map.put(:plain_password, password)
      |> Map.delete(:password)

    with {:ok, user} <- Accounts.create_user(new_params) do
      {:ok, %{user: user}}
    end
  end

  def update_user(_, params, %{context: %{current_user: current_user}}) do
    Accounts.update_user(current_user, params)
  end
end
