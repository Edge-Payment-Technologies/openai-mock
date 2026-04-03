# AGENTS.md

## Project overview

This repository is a Phoenix 1.8 application named `OpenAIMock`.

Today it serves two purposes:

- a basic browser-facing Phoenix app at `/`
- a mock OpenAI-compatible JSON API under `/v1`

The mock API is intentionally deterministic and unauthenticated so local clients can test OpenAI integrations without calling the real OpenAI API.

## Stack

- Elixir `~> 1.15`
- Phoenix `~> 1.8.5`
- Phoenix LiveView `~> 1.1`
- Ecto SQL / PostgreSQL
- Bandit as the HTTP adapter
- Jason for JSON
- Req is the preferred HTTP client if outbound HTTP is ever needed

## Useful commands

- `mix setup` — install deps, create/migrate the database, and build assets
- `mix phx.server` — start the browser app on `https://openai.test:4900` and the mock API on `https://api.openai.test:4900`
- `mix test` — run tests
- `mix precommit` — required final validation (`compile --warnings-as-errors`, unlock unused deps, format, test)

Use `mix precommit` before wrapping up changes.

## Current HTTP surface

### Browser

- `GET /` — Phoenix starter home page

### Mock OpenAI API

Routes are defined in `lib/open_ai_mock_web/router.ex`.

- `GET /v1/models`
- `GET /v1/models/:id`
- `POST /v1/chat/completions`
- `POST /v1/embeddings`
- `POST /v1/responses`

There is currently no auth layer on these endpoints by design.

## Important modules

### Web layer

- `lib/open_ai_mock_web/router.ex`
  - Browser and API pipelines
  - `/v1` OpenAI-compatible routes

- `lib/open_ai_mock_web/controllers/open_ai_controller.ex`
  - Entry point for the mock OpenAI endpoints
  - Delegates behavior to `OpenAIMock.OpenAI`
  - Returns JSON errors with explicit status codes

- `lib/open_ai_mock_web/controllers/open_ai_json.ex`
  - Minimal Phoenix JSON renderer
  - Returns response maps as-is

### Mock OpenAI domain

- `lib/open_ai_mock/open_ai.ex`
  - Public facade for the mock OpenAI functionality

- `lib/open_ai_mock/open_ai/models.ex`
  - Declares the supported mock chat and embedding models
  - Backs both `/v1/models` and `/v1/models/:id`

- `lib/open_ai_mock/open_ai/chat_completions.ex`
  - Generates deterministic chat completion responses
  - Special-cases prompts about the capital of France

- `lib/open_ai_mock/open_ai/embeddings.ex`
  - Generates deterministic embedding vectors from input text
  - Supports a single string or a list of strings

- `lib/open_ai_mock/open_ai/responses.ex`
  - Generates deterministic Responses API payloads
  - Mirrors the same simple prompt behavior as chat completions

- `lib/open_ai_mock/open_ai/utils.ex`
  - Shared helpers for deterministic ids, token counts, input extraction, and embeddings

- `lib/open_ai_mock/open_ai/error.ex`
  - Standardized error payloads for invalid requests and unknown models

## Mock API behavior notes

- Responses are deterministic on purpose.
- IDs are derived from request payloads using a stable hash.
- Timestamps are fixed rather than real-time.
- Token usage is approximate and computed from simple word counts.
- The mock favors stable local testing over strict API completeness.

If you extend the mock, preserve that bias unless a task explicitly asks for higher fidelity.

## Supported models

Chat-style models:

- `gpt-4o`
- `gpt-4o-mini`
- `gpt-4.1-mini`
- `gpt-5`

Embedding models:

- `text-embedding-3-small`
- `text-embedding-3-large`

If you add or remove models, update:

- `lib/open_ai_mock/open_ai/models.ex`
- tests that assert model presence
- Bruno requests if they reference a changed model id

## Bruno collection

A Bruno collection for the mock API lives at:

- `bruno/open-ai-mock/`

Important files:

- `bruno/open-ai-mock/bruno.json`
- `bruno/open-ai-mock/environments/local.bru`

The local Bruno environment currently uses:

- `baseUrl: https://api.openai.test:4900`

The collection includes one request per implemented mock OpenAI endpoint.

If you add or change endpoints, keep the Bruno collection in sync.

## Tests

Primary test coverage for the mock API lives in:

- `test/open_ai_mock_web/controllers/open_ai_controller_test.exs`
- `test/open_ai_mock/open_ai_test.exs`

When changing the mock API:

- add or update controller tests for route/status/JSON shape changes
- add focused unit tests when behavior lives below the controller layer
- prefer asserting on key JSON structure over brittle full-response snapshots

## Project conventions

- Use the existing Phoenix controller + JSON module pattern for API work.
- Prefer small focused modules under `lib/open_ai_mock/open_ai/` over one large module.
- Keep error handling explicit; do not silently swallow invalid input.
- Do not add auth to the mock endpoints unless the task explicitly asks for it.
- Use `Req` for HTTP calls if outbound requests are ever introduced.
- Avoid unnecessary dependencies.

## Extension guidance

If you expand the mock API, likely touch points are:

- `lib/open_ai_mock_web/router.ex`
- `lib/open_ai_mock_web/controllers/open_ai_controller.ex`
- `lib/open_ai_mock_web/controllers/open_ai_json.ex`
- `lib/open_ai_mock/open_ai.ex`
- new modules under `lib/open_ai_mock/open_ai/`
- tests under `test/open_ai_mock_web/controllers/` and `test/open_ai_mock/`
- Bruno files under `bruno/open-ai-mock/`

Good additions would be:

- streaming support for chat/responses
- more OpenAI-compatible endpoints
- more canned scenarios for deterministic local testing

## Validation checklist for changes

At minimum:

1. Update tests for any changed behavior.
2. Update Bruno requests if endpoint behavior or sample payloads changed.
3. Run `mix test`.
4. Run `mix precommit`.

## Notes for future agents

- This repo started from a standard Phoenix skeleton, so some starter files still exist.
- The important non-boilerplate functionality is the mock OpenAI API and its Bruno collection.
- If `AGENTS.md` and the code disagree, trust the code first and update this file.
