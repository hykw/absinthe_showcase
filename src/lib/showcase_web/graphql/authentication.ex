defmodule Showcase.Authentication do
  @user_salt "user salt"

  ### https://hexdocs.pm/phoenix/Phoenix.Token.html
  # Though it is temper free, you shouldn't store any private info in tokens.

  # Notice: "expire" is included in the token. If you want to make the session
  # to be logout on the server side, you have to take another way.

  def sign(data) do
    Phoenix.Token.sign(ShowcaseWeb.Endpoint, @user_salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(ShowcaseWeb.Endpoint, @user_salt, token, max_age: 365 * 24 * 3600)
  end
end
