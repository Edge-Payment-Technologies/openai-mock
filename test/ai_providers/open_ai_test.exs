defmodule AiProviders.OpenAITest do
  use ExUnit.Case, async: true

  alias AiProviders.OpenAI

  test "lists the mock models" do
    response = OpenAI.list_models()

    assert response.object == "list"
    assert Enum.any?(response.data, &(&1.id == "gpt-4o-mini"))
    assert Enum.any?(response.data, &(&1.id == "text-embedding-3-small"))
  end

  test "creates one embedding per input item" do
    {:ok, response} =
      OpenAI.create_embeddings(%{
        "model" => "text-embedding-3-small",
        "input" => ["alpha", "beta"]
      })

    assert response.object == "list"
    assert length(response.data) == 2
    assert Enum.map(response.data, & &1.index) == [0, 1]
  end
end
