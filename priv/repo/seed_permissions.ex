json_file = "#{__DIR__}/seeds/permissions.json"

defmodule Epoch.SeedPermissions do
  def load_permissions do
    with {:ok, body} <- File.read(json_file),
        {:ok, json} <- Jason.decode(body) do
      IO.inspect(json)
    else
      err ->
          IO.inspect(err)
    end
  end
end
