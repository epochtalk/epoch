defmodule Mix.Tasks.Epoch.Migrate do
  use Mix.Task

  @shortdoc "Epoch Migrate"

  def run(args) do
    Mix.Task.run("ecto.migrate")
  end
end
