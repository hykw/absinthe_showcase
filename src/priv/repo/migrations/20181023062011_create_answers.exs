defmodule Showcase.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :body, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :question_id, references(:questions, on_delete: :delete_all)

      timestamps()
    end

    create index(:answers, [:user_id])
    create index(:answers, [:question_id])
  end
end
