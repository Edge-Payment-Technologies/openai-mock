defmodule AiProvidersWeb.PageController do
  use AiProvidersWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
