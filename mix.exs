defmodule Epoch.Mixfile do
  use Mix.Project

  def project do
    [app: :epoch,
     version: "0.0.1",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [applications: [:logger, :ecto, :postgrex]]
  end

  defp deps do
    [
      {:ecto, "~> 2.1.0-rc.5"},
      {:postgrex, "~> 0.13.0-rc"}
    ]
  end
end
