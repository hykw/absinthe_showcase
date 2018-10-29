defmodule ShowcaseWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  alias ShowcaseWeb.Schema.AccountTypes

  def call(res, permission) do
    with %{current_user: current_user} <- res.context,
         true <- correct_permission?(current_user, permission) do
      res
    else
      _ ->
        res
        |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end

  ##################################################

  defp correct_permission?(%{}, :any) do
    true
  end

  defp correct_permission?(%{permission: current_permission}, permission) do
    if current_permission == AccountTypes.parse_perm_to_int(permission) do
      true
    else
      false
    end
  end

  defp correct_permission?(_, _) do
    false
  end
end
