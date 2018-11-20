defmodule ShowcaseWeb.Schema.Query.TotalCountMeTest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    user1 = Factory.create_user(0)
    user2 = Factory.create_user(0)
    user3 = Factory.create_user(0)

    [user1, user2, user3]
    |> Enum.map(fn user ->
      Factory.create_qa(user)
    end)

    %{user: user2}
  end

  defp authcall_me(user, query) do
    build_conn()
    |> auth_user(user)
    |> post("/api", query: query)
    |> json_response(200)
    |> Map.get("data")
    |> Map.get("me")
  end

  test "no totalCount", %{user: user} do
    query = """
    {
      me {
        questions {
          title
        }
        answers {
          body
        }
      }
    }
    """

    result = authcall_me(user, query)
    assert Enum.count(result["questions"]) == 3
    assert Enum.count(result["answers"]) == 5
  end

  test "totalCount", %{user: user} do
    query = """
    {
      me {
        questions(limit: 3, offset: 1) {
          title
          totalCount
        }
        answers(limit: 10, offset: 1) {
          body
          totalCount
          question {
            id
          }
        }
      }
    }
    """

    result = authcall_me(user, query)

    questions = result["questions"]
    assert Enum.count(questions) == 2

    assert questions == [
             %{"title" => "title: #{user.id}-2", "totalCount" => "3"},
             %{"title" => "title: #{user.id}-3", "totalCount" => "3"}
           ]

    answers = result["answers"]

    base_question_id =
      answers
      |> get_base_question_id()
      |> String.to_integer()

    [answer1, answer2, answer3] = split_answers(answers)
    assert Enum.count(answer1) == 4
    assert Enum.count(answer2) == 5
    assert Enum.count(answer3) == 1

    assert_answers(answer1, base_question_id + 0, user.id, 2..5)
    assert_answers(answer2, base_question_id + 1, user.id, 1..5)
    assert_answers(answer3, base_question_id + 2, user.id, 1..1)
  end

  defp assert_answers(answers, question_id, user_id, range) do
    expect =
      range
      |> Enum.map(fn i ->
        %{
          "body" => "body: #{user_id}-#{i}",
          "question" => %{"id" => Integer.to_string(question_id)},
          "totalCount" => "15"
        }
      end)

    assert answers == expect
  end

  defp get_base_question_id(answers) do
    answers
    |> hd()
    |> Map.get("question")
    |> Map.get("id")
  end

  defp split_answers(answers) do
    {answer1, rest} = Enum.split(answers, 4)
    {answer2, answer3} = Enum.split(rest, 5)

    [answer1, answer2, answer3]
  end
end
