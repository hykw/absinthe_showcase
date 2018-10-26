defmodule ShowcaseWeb.Schema.Mutation.LoginTest do
  use ShowcaseWeb.ConnCase, async: false

  defp get_response(args) do
    post(build_conn(), "/api", args)
  end

  @query """
    mutation ($email: String!, $password: String!, $permission: Permission!) {
      login(email: $email, password: $password, permission: $permission) {
        token
        user {
          nickname
          email
        }
      }
    }
  """

  test "login test(correct)" do
    user = Factory.create_user(0)

    args = %{
      query: @query,
      variables: %{
        "email" => user.email,
        "password" => user.plain_password,
        "permission" => "NORMAL_USER"
      }
    }

    response = get_response(args)

    assert %{
             "data" => %{
               "login" => %{
                 "token" => token,
                 "user" => user_data
               }
             }
           } = json_response(response, 200)

    assert %{
             "nickname" => user.nickname,
             "email" => user.email
           } == user_data

    assert {:ok,
            %{
              permission: 0,
              id: user.id
            }} == Showcase.Authentication.verify(token)
  end

  test "login test(error)" do
    user = Factory.create_user(0)

    variables_correct = %{
      "email" => user.email,
      "password" => user.plain_password,
      "permission" => "NORMAL_USER"
    }

    [
      ["email", "xxxx@example.jp"],
      ["password", "wrong password"],
      ["permission", "ADMIN"]
    ]
    |> Enum.map(fn [key, value] ->
      variables = Map.put(variables_correct, key, value)

      args = %{
        query: @query,
        variables: variables
      }

      response = get_response(args)

      assert %{
               "data" => %{"login" => nil}
             } = json_response(response, 200)
    end)
  end
end
