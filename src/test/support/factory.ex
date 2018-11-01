defmodule Factory do
  alias Showcase.{
    Accounts,
    Repo,
    QA
  }

  def create_user(permission) do
    int = :erlang.unique_integer([:positive, :monotonic])

    params = %{
      nickname: "Factory Person #{int}",
      email: "factory-#{int}@example.com",
      plain_password: "plain_password-#{int}",
      permission: permission
    }

    %Accounts.User{}
    |> Accounts.User.changeset(params)
    |> Repo.insert!()
  end

  def create_qa(user) do
    user_id = user.id

    1..3
    |> Enum.map(fn i ->
      params = %{
        user_id: user_id,
        title: "title: #{user_id}-#{i}",
        body: "body: #{user_id}-#{i}"
      }

      question =
        %QA.Question{}
        |> QA.Question.changeset(params)
        |> Repo.insert!()

      ### answers
      answers =
        1..5
        |> Enum.map(fn i ->
          params = %{
            user_id: user_id,
            question_id: question.id,
            body: "body: #{user_id}-#{i}"
          }

          %QA.Answer{}
          |> QA.Answer.changeset(params)
          |> Repo.insert!()
        end)

      %{
        question: question,
        answers: answers
      }
    end)
  end
end
