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

  def answers_for_question(question, _, _) do
    {:ok, QA.answers_for_question(question)}
  end

  def question_for_answer(answer, _, _) do
    {:ok, QA.question_for_answer(answer)}
  end
end
