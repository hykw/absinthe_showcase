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

  @desc """
  users info(includes private info)
  """
  object :user_with_priv do
    field(:id, :id)
    field(:nickname, :string)
    field(:email, :string)
    field(:permission, :integer)
  end

  @desc "session value"
  object :session do
    field(:token, :string)
    field(:user, :user_with_priv)
  end

  @desc "permission type"
  enum :permission do
    value(:normal_user)
    value(:admin)
  end

  def parse_permission(:normal_user), do: 0
  def parse_permission(:admin), do: 1
  def parse_permission(0), do: :normal_user
  def parse_permission(1), do: :admin
end
