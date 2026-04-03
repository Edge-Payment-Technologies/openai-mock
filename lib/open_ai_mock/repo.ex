defmodule OpenAIMock.Repo do
  use Ecto.Repo,
    otp_app: :open_ai_mock,
    adapter: Ecto.Adapters.Postgres
end
