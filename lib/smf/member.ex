defmodule SMF.Member do
  alias SMF.Helper
  alias Epoch.Repo
  alias Epoch.Accounts.User

  @select_member """
  SELECT #{Helper.cs_cols(:smf_members)}
  FROM smf_members
  WHERE ID_MEMBER = ?
  ORDER BY ID_MEMBER
  LIMIT 1
  """
  
  # {:ok, user}
  def migrate(id) do
    user = id
    |> find_member()
    |> to_user()

    case user do
      nil -> {:error, "user not found"}
      _ ->
        %User{}
        |> User.changeset(user)
        |> Repo.insert(conflict_target: :id, on_conflict: :replace_all)
    end
  end

  def find_member(id) when is_binary(id) do
    String.to_integer(id)
    |> find_member()
  end

  def find_member(id) when is_integer(id) and id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(@select_member, [id])
    |> SMF.Helper.res_to_maps()
    |> List.first()
  end

  def to_user(member) when is_nil(member), do: nil
  def to_user(member) do
    %{
      id: member["ID_MEMBER"],
      email: member["emailAddress"],
      username: member["memberName"],
      created_at: member["dateRegistered"]
      |> DateTime.from_unix!()
      |> DateTime.to_naive(),
      imported_at: NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second),
      updated_at: member["lastUpdated"]
      |> DateTime.from_unix!()
      |> DateTime.to_naive(),
      smf_member: member
    }
  end
end
