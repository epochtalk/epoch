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

    field :base_permissions, :map
    field :custom_permissions, :map

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  def changeset(role, attrs \\ %{}) do
    role
    |> cast(attrs, [:name, :description, :lookup, :priority, :highlight_color, :base_permissions, :custom_permissions, :created_at, :updated_at])
  end
end
