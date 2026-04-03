defmodule OpenAIMockWeb.PageController do
  use OpenAIMockWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
