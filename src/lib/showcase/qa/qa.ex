defmodule Showcase.QA do
  @moduledoc """
  The QA context.
  """

  import Ecto.Query, warn: false

  alias Showcase.{
    ContextHelper,
    Repo
  }

  alias ShowcaseWeb.Resolvers

  alias Showcase.QA.{
    Answer,
    Question
  }

  @doc """
  Returns the list of questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  def list_questions(args, info) do
    query =
      from(
        q in Question,
        select: {q.id, q.title, q.body, q.user_id, q.inserted_at, q.updated_at},
        order_by: [asc: q.id]
      )

    [query, args] = ContextHelper.limit_offset(query, args)

    query =
      Enum.reduce(args, query, fn
        {_, nil}, query ->
          query

        {:id, id}, query ->
          from(
            q in query,
            where: q.id == ^id
          )

        {:title, title}, query ->
          from(
            q in query,
            where: q.title == ^title
          )
      end)

    info
    |> ContextHelper.get_query_fields()
    |> Enum.any?(fn field -> field == :total_count end)
    |> do_list_questions(query)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a question.

  ## Examples

      iex> update_question(question, %{field: new_value})
      {:ok, %Question{}}

      iex> update_question(question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Question.

  ## Examples

      iex> delete_question(question)
      {:ok, %Question{}}

      iex> delete_question(question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking question changes.

  ## Examples

      iex> change_question(question)
      %Ecto.Changeset{source: %Question{}}

  """
  def change_question(%Question{} = question) do
    Question.changeset(question, %{})
  end

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  def list_answers(args, info) do
    query =
      from(
        a in Answer,
        select: {a.id, a.body, a.user_id, a.question_id, a.inserted_at, a.updated_at},
        order_by: [asc: a.id]
      )

    [query, args] = ContextHelper.limit_offset(query, args)

    query =
      Enum.reduce(args, query, fn
        {_, nil}, query ->
          query

        {:id, id}, query ->
          from(
            q in query,
            where: q.id == ^id
          )

        {:body, body}, query ->
          from(
            q in query,
            where: q.body == ^body
          )
      end)

    info
    |> ContextHelper.get_query_fields()
    |> Enum.any?(fn field -> field == :total_count end)
    |> do_list_answers(query)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(attrs \\ %{}) do
    %Answer{}
    |> Answer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{source: %Answer{}}

  """
  def change_answer(%Answer{} = answer) do
    Answer.changeset(answer, %{})
  end

  def questions_for_user(user, args) do
    user
    |> Ecto.assoc(:questions)
    |> ContextHelper.limit_offset(:dataloader, args)
    |> Repo.all()
  end

  def answers_for_user(user, args) do
    user
    |> Ecto.assoc(:answers)
    |> ContextHelper.limit_offset(:dataloader, args)
    |> Repo.all()
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  # params is %{limit: 5} for example
  def query(Answer, params) do
    new_params =
      :answers
      |> Resolvers.QA.get_default_params()
      |> Resolvers.QA.set_default_params(params)

    ContextHelper.limit_offset(:dataloader, Answer, new_params)
  end

  def query(queryable, _params) do
    queryable
  end

  def count_answers_by_question(question_id) do
    [total_count] =
      from(
        q in Answer,
        select: count(q.id),
        where: q.question_id == ^question_id
      )
      |> Repo.all()

    total_count
  end

  ##################################################

  defp do_list_questions(true, query) do
    {:ok, select_keys} = TinyEctoHelperMySQL.get_select_keys(query)

    {:ok, %{results: results, count: count}} =
      TinyEctoHelperMySQL.query_and_found_rows(query, select_keys, [Repo, %Question{}, Question])

    results
    |> Enum.map(fn x ->
      Map.put(x, :total_count, Integer.to_string(count))
    end)
  end

  defp do_list_questions(false, query) do
    query
    |> exclude(:select)
    |> Repo.all()
  end

  defp do_list_answers(true, query) do
    {:ok, select_keys} = TinyEctoHelperMySQL.get_select_keys(query)

    {:ok, %{results: results, count: count}} =
      TinyEctoHelperMySQL.query_and_found_rows(query, select_keys, [Repo, %Answer{}, Answer])

    results
    |> Enum.map(fn x ->
      Map.put(x, :total_count, Integer.to_string(count))
    end)
  end

  defp do_list_answers(false, query) do
    query
    |> exclude(:select)
    |> Repo.all()
  end
end
