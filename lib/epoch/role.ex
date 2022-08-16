defmodule Epoch.Role do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias Epoch.Repo
  alias Epoch.Role

  schema "roles" do
    field :name, :string
    field :description, :string
    field :lookup, :string
    field :priority, :integer
    field :highlight_color, :string

    field :permissions, :map
    field :priority_restrictions, {:array, :integer}

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  def changeset(role, attrs \\ %{}) do
    role
    |> cast(attrs, [:name, :description, :lookup, :priority, :base_permissions, :custom_permissions])
    |> validate_required([:name, :description, :lookup, :priority, :base_permissions, :custom_permissions])
  end
  def insert([]), do: {:error, "Role list is empty"}
  def insert(%Role{} = role) do
    Repo.insert(role)
  end
  def insert([%{}|_] = roles) do
    Repo.insert_all(Role, roles)
  end
  def set_priority_restrictions_by_lookup({lookup, priority_restrictions}) do
    # only insert priority restrictions if they have not been set already
    from(r in Role, where: r.lookup == ^lookup and is_nil(r.priority_restrictions))
    |> Repo.update_all(set: [priority_restrictions: priority_restrictions])
  end
  def all() do
    Role
    |> Repo.all
  end
end
