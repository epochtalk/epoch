json_file = "#{__DIR__}/../../roles_permissions.json"

alias Epoch.RolePermission
alias Epoch.Role
# alias Epoch.Repo
# alias Ecto.Multi

create_role_permission_changeset = fn({role_lookup, permissions}) ->
  # permissions
  # |> Enum.each()
  # permissions
  # |> Iteraptor.to_flatmap
  # |> IO.inspect
  role = Role.by_lookup(role_lookup)
         |> IO.inspect

end

RolePermission.maybe_init
|> IO.inspect

roles_permissions_changesets = json_file
|> File.read!()
|> Jason.decode! # []
|> Enum.map(create_role_permission_changeset)

# Multi.new()
# |> Repo.transaction()
