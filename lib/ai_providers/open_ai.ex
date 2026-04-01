defmodule AiProviders.OpenAI do
  @moduledoc """
  Deterministic mock OpenAI-compatible responses for local development.
  """

  alias AiProviders.OpenAI.ChatCompletions
  alias AiProviders.OpenAI.Embeddings
  alias AiProviders.OpenAI.Models
  alias AiProviders.OpenAI.Responses

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
