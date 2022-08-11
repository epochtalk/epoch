json_file = "#{__DIR__}/../../priority_restrictions.json"

alias Epoch.Role

## only insert priority restrictions if they have not been set already

roles_changeset = json_file
|> File.read!()
|> Jason.decode!
# for each priority_restriction, set in db
|> Enum.each(Role.set_priority_restrictions_by_lookup)
