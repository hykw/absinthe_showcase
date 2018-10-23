defmodule Showcase.QA.Answer do
  use Ecto.Schema
  import Ecto.Changeset


  @timestamps_opts [usec: Mix.env != :test]
  schema "answers" do
    field :body, :string
    field :user_id, :id
    field :question_id, :id

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
