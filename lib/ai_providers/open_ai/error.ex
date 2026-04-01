defmodule AiProviders.OpenAI.Error do
  @moduledoc false

  def invalid_request(message, param \\ nil, code \\ "invalid_request_error") do
    {:error, 400, error_payload(message, "invalid_request_error", param, code)}
  end

  def model_not_found(model_id) do
    {:error, 404,
     error_payload(
       "The model `#{model_id}` does not exist or is not available in this mock.",
       "invalid_request_error",
       "model",
       "model_not_found"
     )}
  end

  def not_found(message) do
    {:error, 404, error_payload(message, "invalid_request_error", nil, "not_found")}
  end

  defp error_payload(message, type, param, code) do
    %{
      error: %{
        message: message,
        type: type,
        param: param,
        code: code
      }
    }
  end
end
