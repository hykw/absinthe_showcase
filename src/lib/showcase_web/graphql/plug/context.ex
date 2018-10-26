defmodule ShowcaseWeb.Context do
  @behaviour Plug
  import Plug.Conn

  alias Showcase.Accounts

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  ##################################################

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, data} <- Showcase.Authentication.verify(token),
         %{} = user <- get_user(data) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp get_user(%{id: id, permission: permission}) do
    Accounts.get_user(id, permission)
  end
end
