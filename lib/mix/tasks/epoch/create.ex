defmodule Mix.Tasks.Epoch.Create do
  use Mix.Task

  @shortdoc "Epoch Create"

  def run(args) do
    Mix.Task.run("ecto.create")
  end
end
