defmodule AiProviders.Repo do
  use Ecto.Repo,
    otp_app: :ai_providers,
    adapter: Ecto.Adapters.Postgres
end
