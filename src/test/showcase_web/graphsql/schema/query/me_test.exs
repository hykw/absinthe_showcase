defmodule ShowcaseWeb.Schema.Query.MeTest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    Showcase.Seeds.run()
  end

  defp get_query() do
    """
    {
      me {
        user {
          id
          nickname
          email
        }
        questions {
          user {
            id
          }
        }
        answers {
          user {
            id
          }
        }
      }
    }
    """
  end

  defp assert_qa_with_userid(qa, user_id) do
    assert qa
           |> Enum.map(fn %{"user" => %{"id" => user_id_in_qa}} ->
             user_id_in_qa == user_id
           end)
           |> Enum.all?()
  end

  test "me: user, questions and answers" do
    user = Factory.create_user(0)
    _qa = Factory.create_qa(user)

    query = get_query()

    resp =
      build_conn()
      |> auth_user(user)
      |> post("/api", query: query)
      |> json_response(200)
      |> Map.get("data")
      |> Map.get("me")

    user_id = Integer.to_string(user.id)

    assert resp["user"] == %{
             "email" => user.email,
             "id" => user_id,
             "nickname" => user.nickname
           }

    assert_qa_with_userid(resp["questions"], user_id)
    assert_qa_with_userid(resp["answers"], user_id)
  end

  test "me: neither question nor ansswer" do
    user = Factory.create_user(0)
    query = get_query()

    resp =
      build_conn()
      |> auth_user(user)
      |> post("/api", query: query)
      |> json_response(200)
      |> Map.get("data")
      |> Map.get("me")

    assert %{
             "user" => %{
               "email" => user.email,
               "id" => Integer.to_string(user.id),
               "nickname" => user.nickname
             },
             "questions" => [],
             "answers" => []
           } == resp
  end
end
