defmodule Epoch.RolePermission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Epoch.Repo
  alias Epoch.RolePermission
  alias Epoch.Role
  alias Epoch.Permission

  @primary_key false
  schema "roles_permissions" do
    belongs_to :role, Role, foreign_key: :role_id, type: :integer
    belongs_to :permission, Permission, foreign_key: :permission_path, type: :string
    # value XOR modified -> final value
    # (value || modified) && !(value && modified)
    # elixir is not as awesome as erlang because no XOR on booleans
    field :value, :boolean
    field :modified, :boolean
  end

  def changeset(role_permission, attrs \\ %{}) do
    role_permission
    |> cast(attrs, [:role_id, :permission_path, :value, :modified])
    |> validate_required([:role_id, :permission_path, :value, :modified])
  end
  def insert([]), do: {:error, "Role permission list is empty"}
  def insert(%RolePermission{} = role_permission) do
    Repo.insert(role_permission)
  end
  def insert([%{}|_] = roles_permissions) do
    Repo.insert_all(RolePermission, roles_permissions)
  end
  def by_role_id(role_id) do
    from(rp in RolePermission, where: rp.role_id == ^role_id)
    |> Repo.all
  end
  # no permissions to modify
  def modify_by_role(role, []), do: {:error, "No permissions to modify"}
  def modify_by_role(role, [%Permission{}|_] = permissions) do
    # change role permission for each permission
      # check default value
      # check new value
      # if new value is different, set modified true
      # if new value is same, set modified false
    # update roles table
  end
  def modify_by_role(role, %RolePermission{} = permission) do
    # change role permission
      # check default value
      # check new value
      # if new value is different, set modified true
      # if new value is same, set modified false
    # update roles table

  # check if roles permissions are initiated by checking if there are rows
  defp is_initiated?() do
    # if there is more than one role permission, repo has been initiated
    Repo.one(from rp in RolePermission, select: count(rp.value)) > 0
  end
end
