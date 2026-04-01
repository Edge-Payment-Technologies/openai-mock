defmodule AiProvidersWeb.OpenAIController do
  use AiProvidersWeb, :controller

  alias AiProviders.OpenAI

  def models(conn, _params) do
    render(conn, :models, response: OpenAI.list_models())
  end

  def model(conn, %{"id" => id}) do
    case OpenAI.get_model(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          error: %{
            message: "The model `#{id}` does not exist or is not available in this mock.",
            type: "invalid_request_error",
            param: "model",
            code: "model_not_found"
          }
        })

      model ->
        render(conn, :model, response: model)
    end
  end

  def chat_completions(conn, params) do
    with {:ok, response} <- OpenAI.create_chat_completion(params) do
      render(conn, :chat_completion, response: response)
    else
      {:error, status, error_payload} ->
        conn
        |> put_status(status)
        |> json(error_payload)
    end
  end

  def embeddings(conn, params) do
    with {:ok, response} <- OpenAI.create_embeddings(params) do
      render(conn, :embeddings, response: response)
    else
      {:error, status, error_payload} ->
        conn
        |> put_status(status)
        |> json(error_payload)
    end
  end

  def responses(conn, params) do
    with {:ok, response} <- OpenAI.create_response(params) do
      render(conn, :response, response: response)
    else
      {:error, status, error_payload} ->
        conn
        |> put_status(status)
        |> json(error_payload)
    end
  end
end
