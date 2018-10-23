defmodule Showcase.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nickname, :string
      add :email, :string
      add :plain_password, :string
      add :permission, :integer

      timestamps()
    end

  end
end
