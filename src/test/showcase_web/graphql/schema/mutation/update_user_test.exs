defmodule ShowcaseWeb.Schema.Mutation.UpdateUserTest do
  use ShowcaseWeb.ConnCase, async: false

  alias Showcase.Accounts

  @new_nickname "update:nick"
  @new_email "updated@example.com"
  @new_password "new_pass"

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  defp extract_user_strcut(id) when is_binary(id) do
    id
    |> Accounts.get_user!()
    |> extract_user_strcut()
  end

  defp extract_user_strcut(user) do
    %{
      id: user.id,
      nickname: user.nickname,
      email: user.email,
      plain_password: user.plain_password
    }
  end

  defp get_org_and_updated_user(conn, args) do
    user = Factory.create_user(0)

    resp =
      conn
      |> auth_user(user)
      |> get_response(args)
      |> json_response(200)
      |> Map.get("data")
      |> Map.get("updateUser")

    updated_user = extract_user_strcut(resp["id"])
    original_user = extract_user_strcut(user)

    %{
      org: original_user,
      updated: updated_user
    }
  end

  test "correct: no update", %{conn: conn} do
    query = """
    mutation {
      updateUser {
        id
        nickname
        email
      }
    }
    """

    args = %{
      query: query
    }

    x = get_org_and_updated_user(conn, args)
    assert x.org == x.updated
  end

  test "correct: email", %{conn: conn} do
    query = """
    mutation ($email: String!) {
      updateUser(email: $email) {
        id
        nickname
        email
      }
    }
    """

    args = %{
      query: query,
      variables: %{
        "email" => @new_email
      }
    }

    x = get_org_and_updated_user(conn, args)
    refute x.org == x.updated

    refute x.org.email == x.updated.email
    assert Map.delete(x.org, :email) == Map.delete(x.updated, :email)
  end

  test "correct update at once", %{conn: conn} do
    query = """
    mutation ($nickname: String!, $email: String!, $password: String!) {
      updateUser(nickname: $nickname, email: $email, password: $password) {
        id
        nickname
        email
      }
    }
    """

    args = %{
      query: query,
      variables: %{
        "nickname" => @new_nickname,
        "email" => @new_email,
        "password" => @new_password
      }
    }

    x = get_org_and_updated_user(conn, args)
    refute x.org == x.updated
  end
end
