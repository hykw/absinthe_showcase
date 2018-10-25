defmodule Factory do
  alias Showcase.{
    Accounts
  }

  def create_user(permission) do
    int = :erlang.unique_integer([:positive, :monotonic])

    params = %{
      nickname: "Factory Person #{int}",
      email: "factory-#{int}@example.com",
      plain_password: "plain_password-#{int}",
      permission: permission
    }

    %Showcase.Accounts.User{}
    |> Showcase.Accounts.User.changeset(params)
    |> Showcase.Repo.insert!()
  end
end
