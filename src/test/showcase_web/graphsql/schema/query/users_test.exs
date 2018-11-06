defmodule ShowcaseWeb.Schema.Query.UsersTest do
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

  describe "query users" do
    test "no login query" do
      query = """
      {
        users(limit: 100) {
          nickname
        }
      }
      """

      {normal, bulk} =
        apicall_on_json(query)["data"]["users"]
        |> Enum.split(3)

      assert normal == get_users(:normal_user)

      expects =
        4..100
        |> Enum.map(fn i ->
          %{"nickname" => "bulk: #{i}"}
        end)

      assert bulk == expects
    end

    test "filter with args" do
      query = """
      {
        users(nickname: "Normal1") {
          nickname
        }
      }
      """

      assert apicall_on_json(query) == %{
               "data" => %{
                 "users" => [hd(get_users(:normal_user))]
               }
             }
    end
  end

  describe "filter with id and id/nickname" do
    defp assert_id_nickname(query, id, nickname) do
      assert apicall_on_json(query) == %{
               "data" => %{
                 "users" => [
                   %{
                     "id" => id,
                     "nickname" => nickname
                   }
                 ]
               }
             }
    end

    defp assert_no_user(query) do
      assert apicall_on_json(query) == %{
               "data" => %{"users" => []}
             }
    end

    defp create_user(permission) do
      user = Factory.create_user(permission)

      user_id =
        user.id
        |> Integer.to_string()

      [user, user_id]
    end

    test "filter with id" do
      [user, user_id] = create_user(0)

      ### with id
      query = """
      {
        users(id: #{user.id}) {
          id
          nickname
        }
      }
      """

      assert_id_nickname(query, user_id, user.nickname)
    end

    test "filter with id and nickname" do
      [user, user_id] = create_user(0)

      query = """
      {
        users(id: #{user_id}, nickname: "#{user.nickname}") {
          id
          nickname
        }
      }
      """

      assert_id_nickname(query, user_id, user.nickname)

      ### Error case
      # wrong nickname
      query = """
      {
        users(id: #{user_id}, nickname: "unexist nickname") {
          id
          nickname
        }
      }
      """

      assert_no_user(query)

      # wrong id
      query = """
      {
        users(id: -1, nickname: "#{user.nickname}") {
          id
          nickname
        }
      }
      """

      assert_no_user(query)
    end
  end

  describe "limit/offset" do
    test "default" do
      query = """
      {
        users {
          nickname
        }
      }
      """

      # default
      assert apicall_on_json(query)["data"]["users"]
             |> Enum.count() == 5
    end

    test "limit" do
      query = """
      {
        users(limit: 10) {
          nickname
        }
      }
      """

      x = apicall_on_json(query)["data"]["users"]
      assert Enum.count(x) == 10

      {_normal, bulk} = Enum.split(x, 3)
      assert Enum.count(bulk) == 7
    end

    test "offset" do
      query = """
      {
        users(limit: 1, offset: 2) {
          nickname
        }
      }
      """

      assert apicall_on_json(query)["data"]["users"] == [%{"nickname" => "Normal3"}]
    end
  end
end
