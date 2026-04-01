defmodule AiProviders.OpenAI.ChatCompletions do
  @moduledoc false

  alias AiProviders.OpenAI.Error
  alias AiProviders.OpenAI.Models
  alias AiProviders.OpenAI.Utils

  def create(%{"model" => model_id, "messages" => messages} = params)
      when is_binary(model_id) and is_list(messages) and messages != [] do
    if Models.chat_model?(model_id) do
      prompt_text = extract_prompt_text(messages)
      completion_text = completion_text(prompt_text)

      {:ok,
       %{
         id: Utils.stable_id("chatcmpl-mock", params),
         object: "chat.completion",
         created: Utils.created_at(),
         model: model_id,
         choices: [
           %{
             index: 0,
             message: %{
               role: "assistant",
               content: completion_text
             },
             finish_reason: "stop"
           }
         ],
         usage: Utils.usage(prompt_text, completion_text)
       }}
    else
      Error.model_not_found(model_id)
    end
  end

  def create(%{"model" => _model_id}) do
    Error.invalid_request("`messages` is required and must be a non-empty array.", "messages")
  end

  def create(_params) do
    Error.invalid_request("`model` is required.", "model")
  end

  defp extract_prompt_text(messages) do
    messages
    |> Enum.reverse()
    |> Enum.find_value("", fn message ->
      case message do
        %{"role" => "user"} -> Utils.extract_text(message)
        %{role: "user"} -> Utils.extract_text(message)
        _other -> nil
      end
    end)
  end

  defp completion_text(prompt_text) do
    normalized_prompt = String.downcase(prompt_text)

    cond do
      String.contains?(normalized_prompt, "capital of france") ->
        "The capital of France is Paris."

      prompt_text == "" ->
        "This is a simulated response from the mock OpenAI API."

      true ->
        "This is a simulated response to: #{prompt_text}"
    end
  end
end
