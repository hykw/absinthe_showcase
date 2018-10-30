defmodule ShowcaseWeb.Schema.MultiTypes do
  use Absinthe.Schema.Notation

  @desc """
  me info(user_with_priv, questions and answers)
  """
  object :me do
    field(:user, :user_with_priv)
  end
end
