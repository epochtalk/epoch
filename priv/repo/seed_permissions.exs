json_file = "#{__DIR__}/seeds/permissions.json"

alias Epoch.Permission
alias Epoch.Repo

insert_permission = fn(data) ->
  changeset = Permission.changeset(%Permission{}, %{path: data})
  Repo.insert!(changeset)
end

json_file
|> File.read!()
|> Jason.decode! # []
|> Enum.each(insert_permission)

# |> IO.inspect
