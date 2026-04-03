defmodule OpenAIMock.OpenAI.Models do
  @moduledoc false

  @created_at 1_717_847_200

  @chat_models ~w(gpt-4o gpt-4o-mini gpt-4.1-mini gpt-5)
  @embedding_models ~w(text-embedding-3-small text-embedding-3-large)

  @models Enum.map(@chat_models ++ @embedding_models, fn model_id ->
            %{
              id: model_id,
              object: "model",
              created: @created_at,
              owned_by: "openai",
              permission: []
            }
          end)

  def list do
    %{object: "list", data: @models}
  end

  def get(id) do
    Enum.find(@models, &(&1.id == id))
  end

  def chat_model?(id), do: id in @chat_models
  def embedding_model?(id), do: id in @embedding_models
end
