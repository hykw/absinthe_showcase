defmodule Showcase.ContextHelper do
  import Ecto.Query, warn: false

  alias Showcase.Repo

  def limit_offset(query, args) do
    query =
      Enum.reduce(args, query, fn
        {:limit, limit}, query ->
          from(
            q in query,
            limit: ^limit
          )

        {:offset, offset}, query ->
          from(
            q in query,
            offset: ^offset
          )

        {_, _}, query ->
          query
      end)

    new_args =
      args
      |> Map.delete(:limit)
      |> Map.delete(:offset)

    [query, new_args]
  end

  def limit_offset(query, args, :discard_args) do
    [query, _new_args] = limit_offset(query, args)
    query
  end

  def limit_offset(q, :dataloader, a), do: limit_offset(:dataloader, q, a)

  def limit_offset(:dataloader, query, args) do
    [query, _args] = limit_offset(query, args)
    query
  end

  def get_query_fields(info) do
    info
    |> Absinthe.Resolution.project()
    |> Enum.map(& &1.name)
    |> Enum.map(&Macro.underscore(&1))
    |> Enum.map(&String.to_atom(&1))
  end

  def query_with_count(query) do
    results = Repo.all(query)

    count_query =
      query
      |> Ecto.Query.exclude(:limit)
      |> Ecto.Query.exclude(:offset)

    [count] =
      from(
        q in count_query,
        select: count(q.id)
      )
      |> Repo.all()

    {:ok, %{results: results, count: count}}
  end
end
