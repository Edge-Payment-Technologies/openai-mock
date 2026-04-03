defmodule OpenAIMock.OpenAI.Embeddings do
  @moduledoc false

  alias OpenAIMock.OpenAI.Error
  alias OpenAIMock.OpenAI.Models
  alias OpenAIMock.OpenAI.Utils

  def create(%{"model" => model_id, "input" => input})
      when is_binary(model_id) and (is_binary(input) or is_list(input)) do
    if Models.embedding_model?(model_id) do
      normalized_inputs =
        input
        |> List.wrap()
        |> Enum.map(&Utils.extract_text/1)

      if Enum.any?(normalized_inputs, &(&1 == "")) do
        Error.invalid_request("`input` must contain non-empty text values.", "input")
      else
        {:ok,
         %{
           object: "list",
           data:
             normalized_inputs
             |> Enum.with_index()
             |> Enum.map(fn {item, index} ->
               %{
                 object: "embedding",
                 index: index,
                 embedding: Utils.embedding_for(item)
               }
             end),
           model: model_id,
           usage: %{
             prompt_tokens: Utils.prompt_tokens(normalized_inputs),
             total_tokens: Utils.prompt_tokens(normalized_inputs)
           }
         }}
      end
    else
      Error.model_not_found(model_id)
    end
  end

  def create(%{"model" => _model_id}) do
    Error.invalid_request("`input` is required.", "input")
  end

  def create(_params) do
    Error.invalid_request("`model` is required.", "model")
  end
end
