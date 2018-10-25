defmodule ShowcaseWeb.Schema.AccountTypes do
  use Absinthe.Schema.Notation

  # suppress password
  @desc """
  users info(excludes password)
  """
  object :user do
    field(:id, :id)
    field(:nickname, :string)
  end
end
