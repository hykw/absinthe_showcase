defmodule Showcase.QA.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias Showcase.Accounts.{
    User
  }

  alias Showcase.QA.{
    Answer
  }

  @timestamps_opts [usec: Mix.env() != :test]
  schema "questions" do
    field(:total_count, :integer, virtual: true)
    field(:body, :string)
    field(:title, :string)

    belongs_to(:user, User)
    has_many(:answers, Answer)

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
    |> validate_number(:user_id, greater_than_or_equal_to: 1)
  end
end
