defmodule ShowcaseWeb.Resolvers.QA do
  alias Showcase.{
    QA
  }

  def questions(_, args, _) do
    {:ok, QA.list_questions(args)}
  end

  def answers(_, args, _) do
    {:ok, QA.list_answers(args)}
  end

  def questions_for_user(map_user, _, _) do
    user = map_user.user
    {:ok, QA.questions_for_user(user)}
  end

  def answers_for_user(map_user, _, _) do
    user = map_user.user
    {:ok, QA.answers_for_user(user)}
  end
end
