defmodule Mix.Tasks.Epoch.Drop do
  use Mix.Task

  @shortdoc "Epoch Drop"

  def run(_args) do
    Mix.Task.run("ecto.drop")
  end
end
