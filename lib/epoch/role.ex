defmodule Epoch.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Epoch.Repo
  alias Epoch.Role

  schema "roles" do
    field :name, :string
    field :description, :string
    field :lookup, :string
    field :priority, :integer
    field :highlight_color, :string

    field :permissions, :map

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
end
