defmodule Showcase.Seeds do
  alias Showcase.{
    Accounts,
    QA
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

    create_bulk_users()
    |> hd()
    |> create_bulk_qa()
  end

  defp create_bulk_qa({:ok, user}) do
    # Q: same title
    1..5
    |> Enum.map(fn _i ->
      insert_question(user, "dup question")
    end)

    q = insert_question(user, "dup question for answers")

    1..3
    |> Enum.map(fn _i ->
      insert_answer(q, user, 1..1)
    end)
  end

  defp create_bulk_users() do
    4..100
    |> Enum.map(fn i ->
      %{
        nickname: "bulk: #{i}",
        email: "user#{i}@example.com",
        plain_password: "pass",
        permission: 0
      }
      |> Accounts.create_user()
    end)
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
    |> insert_answer(user, 1..3)

    # Q: Ax1
    insert_question(user, 2)
    |> insert_answer(user, 1..1)

    # Q
    insert_question(user, 3)
  end

  defp create_qa(:user2, user) do
    # a question only
    insert_question(user, 1)
  end

  defp create_qa(:user3, user) do
    insert_question(user, 1)
    |> insert_answer(user, 1..15)

    2..15
    |> Enum.map(fn i ->
      insert_question(user, i)
    end)
  end

  defp insert_question(user, i) do
    {:ok, question} =
      %{
        title: "question (user_id: #{user.id}) #{i}",
        body: "body (user_id: #{user.id}) #{i}",
        user_id: user.id
      }
      |> QA.create_question()

    question
  end

  defp insert_answer(question, user, range) do
    range
    |> Enum.map(fn i ->
      %{
        body: "answer (question_id: #{question.id}) #{i}",
        user_id: user.id,
        question_id: question.id
      }
      |> QA.create_answer()
    end)
  end
end
