defmodule ShowcaseWeb.Resolvers.QA do
  alias Showcase.{
    QA
  }

  def questions(_, args, _) do
    {:ok, %{results: results, count: count}} =
      :questions
      |> getset_params(args)
      |> QA.list_questions()

    result_with_totalcount =
      results
      |> Enum.map(fn x ->
        Map.put(x, :total_count, count)
      end)

    {:ok, result_with_totalcount}
  end

  def answers(_, args, _) do
    {:ok, %{results: results, count: count}} =
      :answers
      |> getset_params(args)
      |> QA.list_answers()

    result_with_totalcount =
      results
      |> Enum.map(fn x ->
        Map.put(x, :total_count, count)
      end)

    {:ok, result_with_totalcount}
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
