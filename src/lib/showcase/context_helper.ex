defmodule Showcase.ContextHelper do
  import Ecto.Query, warn: false

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

  def limit_offset(q, :dataloader, a), do: limit_offset(:dataloader, q, a)

  def limit_offset(:dataloader, query, args) do
    [query, _args] = limit_offset(query, args)
    query
  end
end
