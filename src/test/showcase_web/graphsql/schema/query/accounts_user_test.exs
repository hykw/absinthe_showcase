defmodule ShowcaseWeb.Schema.Query.AccountsUserTest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    Showcase.Seeds.run()
  end

  defp get_users(:normal_user) do
    [
      %{"nickname" => "Normal1"},
      %{"nickname" => "Normal2"},
      %{"nickname" => "Normal3"}
    ]
  end

  describe "query" do
    @query """
    {
      users {
        nickname
      }
    }
    """
    test "no login query" do
      conn =
        build_conn()
        |> get("/api", query: @query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "users" => get_users(:normal_user)
               }
             }
    end
  end
end
