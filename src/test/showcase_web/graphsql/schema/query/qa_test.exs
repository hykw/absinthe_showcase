defmodule ShowcaseWeb.Schema.Query.QATest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    Showcase.Seeds.run()
  end

  describe "query question" do
    defp get_response() do
      query = """
      {
        questions {
          id
          title
          body
          user {
            id
            nickname
          }
          answers {
            id
            body
            user {
              id
              nickname
            }
            question {
              id
            }
          }
        }
      }
      """

      apicall_on_json(query)["data"]["questions"]
      #            |> IO.inspect
    end

    test "question list" do
      resp = [r1, r2, r3, r4] = get_response()

      ### confirm question data
      assert Enum.count(resp) == 4

      ### confirm question id for answers
      question_id = r1["id"]

      answer_q_ids =
        r1["answers"]
        |> Enum.map(fn x ->
          x["question"]["id"]
        end)

      expect_q_ids = List.duplicate(question_id, 3)
      assert expect_q_ids == answer_q_ids

      ### confirm user_id
      assert r1["user"]["id"] == r2["user"]["id"]
      assert r2["user"]["id"] == r3["user"]["id"]

      refute r3["user"]["id"] == r4["user"]["id"]

      ### confirm number of answers
      assert [3, 1, 0, 0] ==
               resp
               |> Enum.map(fn x ->
                 Enum.count(x["answers"])
               end)
    end

    test "question by id" do
      {question, _} =
        get_response()
        |> List.pop_at(1)

      q_id = question["id"]

      query = """
      {
        questions(id: #{q_id}) {
          id
          title
          body
          user {
            id
            nickname
          }
          answers {
            id
            body
            user {
              id
              nickname
            }
            question {
              id
            }
          }
        }
      }
      """

      assert hd(apicall_on_json(query)["data"]["questions"]) == question
    end

    test "answer by id" do
      question =
        get_response()
        |> hd()

      answer = hd(question["answers"])
      a_id = answer["id"]

      query = """
      {
        answers(id: #{a_id}) {
          id
          body
          user {
            id
            nickname
          }
          question {
            id
          }
        }
      }
      """

      assert hd(apicall_on_json(query)["data"]["answers"]) == answer
    end
  end
end
