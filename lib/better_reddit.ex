defmodule BetterReddit do
  use Application
  alias BetterReddit.Endpoint

  @moduledoc ~S"""
  The root module for BetterReddit. Calling start starts the entire application,
  including the websercer, and gatherer.
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(BetterReddit.Endpoint, []),
      
      worker(BetterReddit.Repo, []),
      worker(BetterReddit.Gather, [])
      # Start your own worker by calling:
      #   BetterReddit.Worker.start_link(arg1, arg2, arg3)
      # worker(BetterReddit.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
