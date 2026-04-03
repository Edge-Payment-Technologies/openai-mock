# OpenAIMock

OpenAIMock is a Phoenix application for mocking a small, deterministic subset of the OpenAI API for early local development. It is designed so client integrations can be exercised without calling the real OpenAI service.

## What It Serves

- Browser app: [`https://www.openai.test:4900`](https://www.openai.test:4900)
- Mock API: [`https://api.openai.test:4900/v1`](https://api.openai.test:4900/v1)

The API is intentionally unauthenticated and returns stable responses for repeatable testing.

## Supported Endpoints

- `GET /v1/models`
- `GET /v1/models/:id`
- `POST /v1/chat/completions`
- `POST /v1/embeddings`
- `POST /v1/responses`

Supported model IDs currently include:

- Chat models: `gpt-4o`, `gpt-4o-mini`, `gpt-4.1-mini`, `gpt-5`
- Embedding models: `text-embedding-3-small`, `text-embedding-3-large`

## Local Setup

1. Install dependencies and prepare the project with `mix setup`.
2. Install `mkcert`, trust its local CA, then run `mise run mkcert` to generate the local TLS certificates.
3. Start the app with `mix phx.server` or `iex -S mix phx.server`.

If `openai.test` or `api.openai.test` do not resolve locally, add both names to your hosts file so they point at `127.0.0.1`.

## Mock Behavior

- Responses are deterministic by design.
- IDs are derived from request payloads.
- Timestamps are fixed rather than real-time.
- Token usage is approximate and based on simple word counts.

This makes the app useful for local client development, smoke tests, and integration work where stable output is more important than full API fidelity.

## Bruno Collection

A Bruno collection for the mock API lives in [`bruno/open-ai-mock/`](bruno/open-ai-mock/).

The local Bruno environment is configured to use `https://api.openai.test:4900`.

## Phoenix Resources

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Deployment guide: https://hexdocs.pm/phoenix/deployment.html
