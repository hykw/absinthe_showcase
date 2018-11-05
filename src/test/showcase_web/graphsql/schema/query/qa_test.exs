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
      #                        |> IO.inspect
    end

    defp split_results(resp) do
      {r1, rest} = Enum.split(resp, 3)
      {r2, r3} = Enum.split(rest, 1)

      [r1, r2, r3]
    end

    test "question list" do
      [r1, r2, r3] =
        get_response()
        |> split_results()

      ### count data for each users
      assert Enum.count(r1) == 3
      assert Enum.count(r2) == 1
      assert Enum.count(r3) == 15

      ### confirm question id for answers
      # user1
      [a1, _a2, _a3] = r1

      a1["answers"]
      |> Enum.map(fn x ->
        assert x["question"]["id"] == a1["id"]
      end)

      assert Enum.count(a1["answers"]) == 3

      assert_resp_user3(r3)
    end
  end

  defp assert_resp_user3(r3) do
    [head | rest] = r3

    assert rest
           |> Enum.all?(fn x -> x["answers"] == [] end)

    assert head["answers"]
           |> Enum.map(fn x ->
             x["question"]["id"] == head["id"]
           end)
           |> Enum.all?()
  end
end
