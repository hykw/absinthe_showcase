defmodule Showcase.QA.Question do
  use Ecto.Schema
  import Ecto.Changeset


  schema "questions" do
    field :body, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
