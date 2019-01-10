defmodule ShowcaseWeb.Schema.Query.TotalCountQATest do
  use ShowcaseWeb.ConnCase, async: false

  setup do
    Showcase.Seeds.run()
  end

  defp assert_value_for_key(value, key, expect) do
    assert Map.get(value, key) == expect
  end

  describe "query questions" do
    test "no totalCount" do
      query = """
      {
        questions(limit: 1){
          title
        }
      }
      """

      results = apicall_on_json(query)["data"]["questions"]
      assert Enum.count(results) == 1

      result = hd(results)
      assert Map.keys(result) == ["title"]

      result
      |> assert_value_for_key("totalCount", nil)
    end

    test "with totalCount:limit" do
      query = """
      {
        questions(limit: 1){
          title
          totalCount
        }
      }
      """

      result = apicall_on_json(query)["data"]["questions"]
      assert Enum.count(result) == 1

      result
      |> hd()
      |> assert_value_for_key("totalCount", "25")
    end

    test "with totalCount:limit, offset" do
      query = """
      {
        questions(limit: 3, offset: 23){
          title
          totalCount
        }
      }
      """

      results = apicall_on_json(query)["data"]["questions"]
      assert Enum.count(results) == 2

      results
      |> Enum.map(fn result ->
        assert Map.get(result, "totalCount", "25")
      end)
    end

    test "arg: title" do
      query = """
      {
        questions(title: "question", limit: 2) {
          title
          totalCount
        }
      }
      """

      results = apicall_on_json(query)["data"]["questions"]
      assert Enum.count(results) == 2

      results
      |> Enum.map(fn result ->
        assert result["title"] == "question"
        assert result["totalCount"] == "6"
      end)
    end
  end

  describe "answer questions" do
    test "no totalCount" do
      query = """
      {
        answers(limit: 3){
          body
        }
      }
      """

      results = apicall_on_json(query)["data"]["answers"]
      assert Enum.count(results) == 3

      results
      |> Enum.map(fn result ->
        assert Map.keys(result) == ["body"]
        assert_value_for_key(result, "totalCount", nil)
      end)
    end

    test "with totalCount:limit" do
      query = """
      {
        answers(limit: 3){
          body
          totalCount
        }
      }
      """

      results = apicall_on_json(query)["data"]["answers"]
      assert Enum.count(results) == 3

      results
      |> Enum.map(fn result ->
        assert_value_for_key(result, "totalCount", "22")
      end)
    end

    test "with totalCount:limit, offset" do
      query = """
      {
        answers(limit: 3, offset: 20){
          body
          totalCount
        }
      }
      """

      results = apicall_on_json(query)["data"]["answers"]
      assert Enum.count(results) == 2

      results
      |> Enum.map(fn result ->
        assert_value_for_key(result, "totalCount", "22")
      end)
    end

    test "arg: body" do
      query = """
      {
        answers(body: "answer", limit: 2) {
          body
          totalCount
        }
      }
      """

      results = apicall_on_json(query)["data"]["answers"]
      assert Enum.count(results) == 2

      results
      |> Enum.map(fn result ->
        assert result["body"] == "answer"
        assert result["totalCount"] == "3"
      end)
    end
  end

  describe "questions > answers" do
    test "totalCount: questions > answers" do
      query = """
      {
        questions(title: "question", limit: 10) {
          answers(limit: 2, offset: 1) {
            body
            totalCount
          }
        }
      }
      """

      results = apicall_on_json(query)["data"]["questions"]
      assert Enum.count(results) == 6

      # the first 5 are empty
      assert results
             |> Enum.take(5)
             |> Enum.all?(fn x -> x == %{"answers" => []} end)

      results
      |> List.last()
      |> Map.get("answers")
      |> Enum.map(fn result ->
        assert result == %{"body" => "answer", "totalCount" => "3"}
      end)
    end
  end
end
