defmodule OpenAIMock.OpenAI do
  @moduledoc """
  Deterministic mock OpenAI-compatible responses for local development.
  """

  alias OpenAIMock.OpenAI.ChatCompletions
  alias OpenAIMock.OpenAI.Embeddings
  alias OpenAIMock.OpenAI.Models
  alias OpenAIMock.OpenAI.Responses

  def list_models do
    Models.list()
  end

  def get_model(id) do
    Models.get(id)
  end

  def create_chat_completion(params) do
    ChatCompletions.create(params)
  end

  def create_embeddings(params) do
    Embeddings.create(params)
  end

  def create_response(params) do
    Responses.create(params)
  end
end
