defmodule ShowcaseWeb.Schema.QATypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Showcase.{
    Accounts,
    QA
  }

  alias ShowcaseWeb.Resolvers

  object :question_queries do
    @desc """
    query questions(includes answers)
    """

    field :questions, list_of(:question) do
      arg(:id, :id)
      arg(:title, :string)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.questions/3)
    end
  end

  object :answer_queries do
    @desc """
    answer questions(includes user and question)
    """

    field :answers, list_of(:answer) do
      arg(:id, :id)
      arg(:body, :string)
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.answers/3)
    end
  end

  @desc """
  quesions info
  """
  object :question do
    field(:total_count, :integer)
    field(:id, :id)
    field(:title, :string)
    field(:body, :string)

    field :user, :user do
      resolve(dataloader(Accounts, :user))
    end

    field :answers, list_of(:answer) do
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(Resolvers.QA.answers_for_question(QA, :answers))
    end
  end

  object :answer do
    field(:total_count, :integer)
    field(:id, :id)
    field(:body, :string)

    field :user, :user do
      resolve(dataloader(Accounts, :user))
    end

    field :question, :question do
      resolve(dataloader(QA, :question))
    end
  end
end
