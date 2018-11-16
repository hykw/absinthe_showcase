defmodule ShowcaseWeb.Schema.QATypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  alias Showcase.{
    Accounts,
    QA
  }

  alias ShowcaseWeb.Resolvers

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
