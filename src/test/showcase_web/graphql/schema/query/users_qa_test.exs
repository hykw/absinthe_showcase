defmodule ShowcaseWeb.Schema.Query.UsersQATest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    _ = Factory.create_user(0)

    user2 = Factory.create_user(0)

    user2
    |> Factory.create_qa()

    _ = Factory.create_user(0)

    %{user: user2}
  end

  test "users and q and a", %{user: user} do
    query = """
    {
      users(id: #{user.id}) {
        questions {
          totalCount
        }
        answers {
          totalCount
        }
      }
    }
    """

    results =
      apicall_on_json(query)["data"]["users"]
      |> hd()

    questions = results["questions"]
    answers = results["answers"]

    assert Enum.count(questions) == 3
    assert Enum.count(answers) == 5

    assert Enum.all?(questions, fn x -> x["totalCount"] == "3" end)
    assert Enum.all?(answers, fn x -> x["totalCount"] == "15" end)
  end
end
