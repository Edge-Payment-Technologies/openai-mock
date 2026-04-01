defmodule AiProviders.OpenAI.Utils do
  @moduledoc false

  @created_at 1_717_847_200
  @embedding_size 8

  def created_at, do: @created_at

  def stable_id(prefix, payload) do
    suffix =
      payload
      |> :erlang.term_to_binary()
      |> then(&:crypto.hash(:sha256, &1))
      |> Base.url_encode64(padding: false)
      |> binary_part(0, 12)

    "#{prefix}-#{suffix}"
  end

  def prompt_tokens(text) when is_binary(text) do
    text
    |> String.split(~r/\s+/, trim: true)
    |> length()
    |> max(1)
  end

  def prompt_tokens(items) when is_list(items) do
    items
    |> Enum.map(&extract_text/1)
    |> Enum.map(&prompt_tokens/1)
    |> Enum.sum()
    |> max(1)
  end

  def completion_tokens(text) when is_binary(text) do
    prompt_tokens(text)
  end

  def usage(prompt_text, completion_text) do
    prompt_tokens = prompt_tokens(prompt_text)
    completion_tokens = completion_tokens(completion_text)

    %{
      prompt_tokens: prompt_tokens,
      completion_tokens: completion_tokens,
      total_tokens: prompt_tokens + completion_tokens
    }
  end

  def response_usage(prompt_text, output_text) do
    input_tokens = prompt_tokens(prompt_text)
    output_tokens = completion_tokens(output_text)

    %{
      input_tokens: input_tokens,
      output_tokens: output_tokens,
      total_tokens: input_tokens + output_tokens
    }
  end

  def extract_text(content) when is_binary(content), do: content

  def extract_text(content) when is_list(content) do
    content
    |> Enum.map(fn part ->
      case part do
        %{"text" => text} when is_binary(text) -> text
        %{text: text} when is_binary(text) -> text
        %{"content" => text} when is_binary(text) -> text
        %{content: text} when is_binary(text) -> text
        _other -> ""
      end
    end)
    |> Enum.reject(&(&1 == ""))
    |> Enum.join(" ")
  end

  def extract_text(%{"content" => content}), do: extract_text(content)
  def extract_text(%{content: content}), do: extract_text(content)
  def extract_text(_other), do: ""

  def embedding_for(input) do
    input
    |> :erlang.term_to_binary()
    |> then(&:crypto.hash(:sha256, &1))
    |> :binary.bin_to_list()
    |> Enum.take(@embedding_size)
    |> Enum.map(fn byte_value -> Float.round(byte_value / 255, 6) end)
  end
end
