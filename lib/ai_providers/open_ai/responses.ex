defmodule AiProviders.OpenAI.Responses do
  @moduledoc false

  alias AiProviders.OpenAI.Error
  alias AiProviders.OpenAI.Models
  alias AiProviders.OpenAI.Utils

  def create(%{"model" => model_id, "input" => input} = params)
      when is_binary(model_id) and (is_binary(input) or is_list(input)) do
    if Models.chat_model?(model_id) do
      input_text = Utils.extract_text(input)
      output_text = build_output_text(input_text)

      {:ok,
       %{
         id: Utils.stable_id("resp-mock", params),
         object: "response",
         created: Utils.created_at(),
         status: "completed",
         model: model_id,
         output: [
           %{
             id: Utils.stable_id("msg-mock", %{model: model_id, input: input_text}),
             type: "message",
             role: "assistant",
             content: [
               %{
                 type: "output_text",
                 text: output_text,
                 annotations: []
               }
             ]
           }
         ],
         output_text: output_text,
         usage: Utils.response_usage(input_text, output_text)
       }}
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

  defp build_output_text(""),
    do: "This is a simulated response from the mock OpenAI Responses API."

  defp build_output_text(input_text) do
    normalized_input = String.downcase(input_text)

    if String.contains?(normalized_input, "capital of france") do
      "The capital of France is Paris."
    else
      "This is a simulated response to: #{input_text}"
    end
  end
end
