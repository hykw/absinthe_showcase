defmodule Showcase.QA.Answer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Showcase.Accounts.{
    User,
  }

  alias Showcase.QA.{
    Question,
  }

  @timestamps_opts [usec: Mix.env != :test]
  schema "answers" do
    field :body, :string

    belongs_to :user, User
    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:body])
    |> validate_required([:body, :user_id, :question_id])
  end
end
