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

  @desc """
  result of mutation(user_with_priv)
  """
  object :user_with_priv_result do
    field(:user, :user_with_priv)
    field(:errors, list_of(:input_error))
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

  @desc "input error"
  object :input_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  def parse_perm_to_int(0), do: 0
  def parse_perm_to_int(:normal_user), do: 0
  def parse_perm_to_int(1), do: 1
  def parse_perm_to_int(:admin), do: 1

  def parse_perm_to_atom(0), do: :normal_user
  def parse_perm_to_atom(:normal_user), do: :normal_user
  def parse_perm_to_atom(1), do: :admin
  def parse_perm_to_atom(:admin), do: :admin
end
