defmodule Showcase.Seeds do
  alias Showcase.{
    Accounts,
    Repo
  }

  def run() do
    creates()
    :ok
  end

  defp creates() do
    [
      {:ok, user1},
      {:ok, user2},
      {:ok, user3},
      _,
      _
    ] =
      get_users()
      |> Enum.map(fn user ->
        Accounts.create_user(user)
      end)

    create_qa(:user1, user1)
    create_qa(:user2, user2)
    create_qa(:user3, user3)
  end

  defp get_users() do
    [
      %{
        nickname: "Normal1",
        email: "user1@example.jp",
        plain_password: "password1",
        permission: 0
      },
      %{
        nickname: "Normal2",
        email: "user2@example.jp",
        plain_password: "password2",
        permission: 0
      },
      %{
        nickname: "Normal3",
        email: "user3@example.jp",
        plain_password: "password3",
        permission: 0
      },
      %{
        nickname: "Admin1",
        email: "admin1@example.jp",
        plain_password: "password3",
        permission: 1
      },
      %{
        nickname: "Admin2",
        email: "admin2@example.jp",
        plain_password: "password4",
        permission: 1
      }
    ]
  end

  defp create_qa(:user1, user) do
    # Q: Ax3
    insert_question(user, 1)
    |> insert_comment(user, 1..3)

    # Q: Ax1
    insert_question(user, 2)
    |> insert_comment(user, 1..1)

    # Q
    insert_question(user, 3)
  end

  defp create_qa(:user2, user) do
    # a question only
    insert_question(user, 1)
  end

  defp create_qa(:user3, _user) do
    # Do nothing
  end

  defp insert_question(user, i) do
    Ecto.build_assoc(user, :questions, %{
      title: "質問(user_id: #{user.id}) #{i}",
      body: "本文(user_id: #{user.id}) #{i}"
    })
    |> Repo.insert!()
  end

  defp insert_comment(question, user, range) do
    range
    |> Enum.map(fn i ->
      Ecto.build_assoc(question, :answers, %{
        body: "回答(question_id: #{question.id}) #{i}",
        user_id: user.id
      })
      |> Repo.insert!()
    end)
  end
end
