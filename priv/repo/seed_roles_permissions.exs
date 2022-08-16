json_file = "#{__DIR__}/../../roles_permissions.json"

alias Epoch.RolePermission
# alias Epoch.Repo
# alias Ecto.Multi

create_role_permission_changeset = fn({role, permissions}) ->
  # permissions
  # |> Enum.each()
  # role
  # |> IO.inspect
  # permissions
  # |> Iteraptor.to_flatmap
  # |> IO.inspect

end

RolePermission.maybe_init
|> IO.inspect

roles_permissions_changesets = json_file
|> File.read!()
|> Jason.decode! # []
|> Enum.map(create_role_permission_changeset)

# Multi.new()
# |> Repo.transaction()
