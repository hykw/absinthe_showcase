defmodule ShowcaseWeb.Resolvers.QA do
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  alias Showcase.{
    QA
  }

  def questions(_, args, info) do
    results =
      :questions
      |> getset_params(args)
      |> QA.list_questions(info)

    {:ok, results}
  end

  def answers(_, args, info) do
    results =
      :answers
      |> getset_params(args)
      |> QA.list_answers(info)

    {:ok, results}
  end

  def answers_for_question(source, key) do
    fn parent, args, %{context: %{loader: loader}} ->
      total_count = QA.count_answers_by_question(parent.id)

      loader
      |> Dataloader.load(source, {key, args}, parent)
      |> on_load(fn loader ->
        result =
          Dataloader.get(loader, source, {key, args}, parent)
          |> Enum.map(fn x ->
            Map.put(x, :total_count, Integer.to_string(total_count))
          end)

        {:ok, result}
      end)
    end
  end

  def questions_for_user(map_user, args, _) do
    new_args = getset_params(:questions, args)

    user = map_user.user
    {:ok, QA.questions_for_user(user, new_args)}
  end

  def answers_for_user(map_user, args, _) do
    new_args = getset_params(:answers, args)

    user = map_user.user
    {:ok, QA.answers_for_user(user, new_args)}
  end

  def get_default_params(:questions), do: %{limit: 5, offset: 0}
  def get_default_params(:answers), do: %{limit: 5, offset: 0}

  def set_default_params(set_params, args) do
    set_params
    |> Enum.reduce(args, fn {key, value}, acc ->
      Map.put_new(acc, key, value)
    end)
  end

  defp getset_params(key, args) do
    key
    |> get_default_params()
    |> set_default_params(args)
  end
end
