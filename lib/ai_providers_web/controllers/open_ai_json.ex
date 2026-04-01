defmodule AiProvidersWeb.OpenAIJSON do
  @moduledoc false

  def models(%{response: response}), do: response
  def model(%{response: response}), do: response
  def chat_completion(%{response: response}), do: response
  def embeddings(%{response: response}), do: response
  def response(%{response: response}), do: response
end
