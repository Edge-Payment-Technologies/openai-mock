defmodule AiProvidersWeb.OpenAIControllerTest do
  use AiProvidersWeb.ConnCase, async: true

  test "GET /v1/models returns the model list", %{conn: conn} do
    conn = get(conn, ~p"/v1/models")
    response = json_response(conn, 200)

    assert response["object"] == "list"
    assert Enum.any?(response["data"], &(&1["id"] == "gpt-4o-mini"))
    assert Enum.any?(response["data"], &(&1["id"] == "text-embedding-3-small"))
  end

  test "GET /v1/models/:id returns a single model", %{conn: conn} do
    conn = get(conn, ~p"/v1/models/gpt-4o-mini")
    response = json_response(conn, 200)

    assert response["id"] == "gpt-4o-mini"
    assert response["object"] == "model"
  end

  test "GET /v1/models/:id returns a not found payload for an unknown model", %{conn: conn} do
    conn = get(conn, ~p"/v1/models/unknown-model")
    response = json_response(conn, 404)

    assert response["error"]["code"] == "model_not_found"
  end

  test "POST /v1/chat/completions returns a mock completion", %{conn: conn} do
    conn =
      post(conn, ~p"/v1/chat/completions", %{
        "model" => "gpt-4o-mini",
        "messages" => [
          %{"role" => "system", "content" => "You are a helpful assistant."},
          %{"role" => "user", "content" => "What's the capital of France?"}
        ]
      })

    response = json_response(conn, 200)

    assert response["object"] == "chat.completion"
    assert response["model"] == "gpt-4o-mini"

    assert get_in(response, ["choices", Access.at(0), "message", "content"]) ==
             "The capital of France is Paris."
  end

  test "POST /v1/embeddings returns one embedding per input", %{conn: conn} do
    conn =
      post(conn, ~p"/v1/embeddings", %{
        "model" => "text-embedding-3-small",
        "input" => ["OpenAI", "Phoenix"]
      })

    response = json_response(conn, 200)

    assert response["object"] == "list"
    assert response["model"] == "text-embedding-3-small"
    assert Enum.map(response["data"], & &1["index"]) == [0, 1]
  end

  test "POST /v1/responses returns a mock response payload", %{conn: conn} do
    conn =
      post(conn, ~p"/v1/responses", %{
        "model" => "gpt-5",
        "instructions" => "You are a helpful assistant.",
        "input" => "Say hello from the mock."
      })

    response = json_response(conn, 200)

    assert response["object"] == "response"
    assert response["model"] == "gpt-5"
    assert response["status"] == "completed"
    assert response["output_text"] == "This is a simulated response to: Say hello from the mock."
  end

  test "POST /v1/chat/completions validates required fields", %{conn: conn} do
    conn =
      post(conn, ~p"/v1/chat/completions", %{
        "model" => "gpt-4o-mini"
      })

    response = json_response(conn, 400)

    assert response["error"]["param"] == "messages"
  end
end
