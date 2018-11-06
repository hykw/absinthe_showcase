defmodule ShowcaseWeb.Schema.MultiTypes do
  use Absinthe.Schema.Notation

  alias ShowcaseWeb.Resolvers

  @desc """
  me info(user_with_priv, questions and answers)
  """
  object :me do
    field(:user, :user_with_priv)

    field :questions, list_of(:question) do
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.questions_for_user/3)
    end

    field :answers, list_of(:answer) do
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.QA.answers_for_user/3)
    end
  end
end
