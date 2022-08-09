json_file = "#{__DIR__}/seeds/permissions.json"

# @data
json_file
|> File.read!()
|> Jason.decode!
|> IO.inspect
# def data do
#   @data
# end
# with {:ok, body} <- File.read(json_file),
#      {:ok, json} <- Jason.decode(body, keys: :atom) do
#   IO.inspect(json)
#   # insert to db
# else
#   err ->
#       IO.inspect(err)
# end
