defmodule ShowcaseWeb.Schema.QATypes do
  use Absinthe.Schema.Notation

  alias ShowcaseWeb.Resolvers

  @desc """
  quesions info
  """
  object :question do
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)

    field :user, :user do
      resolve(&Resolvers.Accounts.user_for_question/3)
    end

    field :answers, list_of(:answer) do
      resolve(&Resolvers.QA.answer_for_question/3)
    end
  end

  object :answer do
    field(:id, :id)
    field(:body, :string)

    field :user, :user do
      resolve(&Resolvers.Accounts.user_for_answer/3)
    end

    field :question, :question do
      resolve(&Resolvers.QA.question_for_answer/3)
    end
  end
end
