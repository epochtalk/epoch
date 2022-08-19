json_file = "#{__DIR__}/../../roles_permissions.json"

alias Epoch.RolePermission
alias Epoch.Role
# alias Epoch.Repo
# alias Ecto.Multi

create_role_permission_changeset = fn({role_lookup, permissions}) ->
  role = Role.by_lookup(role_lookup)
         |> IO.inspect

  permissions
  |> Iteraptor.to_flatmap
  |> Enum.map(fn {permission_path, _value} ->
    %{ role_id: role.id, permission_path: permission_path, value: true, modified: false}
  end)
end

## careful, we might need to use Multi here...
# these queries need to execute in order
RolePermission.maybe_init
|> IO.inspect

roles_permissions_changesets = json_file
|> File.read!()
|> Jason.decode! # []
|> Enum.map(create_role_permission_changeset) # changesets
|> Enum.each(fn roles_permissions_changesets ->
  RolePermission.upsert_value(roles_permissions_changesets)
end)

#pseudocode
Role.all
|> Enum.map(fn role -> {role, RolePermission.permissions_json_by_role_id(role.id)} end)
|> Enum.each(fn {role, permissions} -> Role.update_permissions_by_id(role.id, permissions) end)
|> IO.inspect
