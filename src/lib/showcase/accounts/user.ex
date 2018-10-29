defmodule Showcase.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Showcase.QA.{
    Question,
    Answer
  }

  @timestamps_opts [usec: Mix.env() != :test]
  schema "users" do
    field(:email, :string)
    field(:nickname, :string)
    field(:permission, :integer)
    field(:plain_password, :string)

    has_many(:questions, Question)
    has_many(:answers, Answer)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nickname, :email, :plain_password, :permission])
    |> validate_required([:nickname, :email, :plain_password, :permission])
    |> unique_constraint(:nickname)
  end
end
