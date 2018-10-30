defmodule ShowcaseWeb.Resolvers.Me do
  def me(_, _, %{context: %{current_user: current_user}}) do
    {:ok, %{user: current_user}}
  end

  def me(_, _, _) do
    {:ok, nil}
  end
end
