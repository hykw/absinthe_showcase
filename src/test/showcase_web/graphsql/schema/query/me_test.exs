defmodule ShowcaseWeb.Schema.Query.MeTest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    Showcase.Seeds.run()
  end

  test "me user_with_priv" do
    user = Factory.create_user(0)

    query = """
    {
      me {
        user {
          id
          nickname
          email
        }
      }
    }
    """

    resp =
      build_conn()
      |> auth_user(user)
      |> post("/api", query: query)
      |> json_response(200)

    assert resp == %{
             "data" => %{
               "me" => %{
                 "user" => %{
                   "id" => Integer.to_string(user.id),
                   "email" => user.email,
                   "nickname" => user.nickname
                 }
               }
             }
           }
  end
end
