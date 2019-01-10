defmodule ShowcaseWeb.Schema.Mutation.CreateUserTest do
  use ShowcaseWeb.ConnCase, async: false

  defp get_response(conn, args) do
    conn
    |> post("/api", args)
  end

  @query """
    mutation ($email: String!, $nickname: String!, $password: String!, $permission: Permission!) {
      user: createUser(email: $email, nickname: $nickname, password: $password, permission: $permission) {
        errors {
          key
          message
        }
        user {
          nickname
          email
          permission
        }
      }
    }
  """

  defp get_post_args(:correct) do
    %{
      query: @query,
      variables: %{
        "email" => "foo@example.com",
        "nickname" => "foo user",
        "password" => "pass",
        "permission" => "NORMAL_USER"
      }
    }
  end

  @auth_error %{
    "data" => %{"user" => nil},
    "errors" => [
      %{
        "message" => "unauthorized",
        "locations" => [%{"column" => 0, "line" => 2}],
        "path" => ["user"]
      }
    ]
  }

  test "error: no auth", %{conn: conn} do
    args = get_post_args(:correct)

    response = get_response(conn, args)

    assert json_response(response, 200) == @auth_error
  end

  test "error: normal user", %{conn: conn} do
    user = Factory.create_user(0)
    args = get_post_args(:correct)

    response =
      conn
      |> auth_user(user)
      |> get_response(args)

    assert json_response(response, 200) == @auth_error
  end

  test "correct: create user", %{conn: conn} do
    admin_user = Factory.create_user(1)
    args = get_post_args(:correct)

    response =
      conn
      |> auth_user(admin_user)
      |> get_response(args)

    assert json_response(response, 200) == %{
             "data" => %{
               "user" => %{
                 "errors" => nil,
                 "user" => %{
                   "email" => "foo@example.com",
                   "nickname" => "foo user",
                   "permission" => 0
                 }
               }
             }
           }
  end

  test "error: unique constraint fail", %{conn: conn} do
    admin_user = Factory.create_user(1)
    args = get_post_args(:correct)

    response =
      conn
      |> auth_user(admin_user)
      |> get_response(args)

    # 1st time(correct)
    result = json_response(response, 200)
    refute result["data"]["user"]["errors"]

    # 2nd time(not unique error)
    response =
      conn
      |> auth_user(admin_user)
      |> get_response(args)

    assert json_response(response, 200) == %{
             "data" => %{
               "user" => %{
                 "user" => nil,
                 "errors" => [
                   %{"key" => "nickname", "message" => "has already been taken"}
                 ]
               }
             }
           }
  end
end
