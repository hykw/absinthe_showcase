defmodule Factory do
  alias Showcase.{
    Accounts,
    Repo
  }

  def create_user(permission) do
    int = :erlang.unique_integer([:positive, :monotonic])

    params = %{
      nickname: "Factory Person #{int}",
      email: "factory-#{int}@example.com",
      plain_password: "plain_password-#{int}",
      permission: permission
    }

    %Accounts.User{}
    |> Accounts.User.changeset(params)
    |> Repo.insert!()
  end
end
