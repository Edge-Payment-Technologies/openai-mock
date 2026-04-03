defmodule OpenAIMock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OpenAIMockWeb.Telemetry,
      OpenAIMock.Repo,
      {DNSCluster, query: Application.get_env(:open_ai_mock, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: OpenAIMock.PubSub},
      # Start a worker by calling: OpenAIMock.Worker.start_link(arg)
      # {OpenAIMock.Worker, arg},
      # Start to serve requests, typically the last entry
      OpenAIMockWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OpenAIMock.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OpenAIMockWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
