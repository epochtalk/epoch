defmodule Epoch.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Epoch.Repo
  alias Epoch.Permission

  schema "permissions" do
    field :path, :string
  end

  def changeset(role, attrs \\ %{}) do
    role
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
  def insert(%Permission{} = permission) do
    Repo.insert(permission)
  end
  def by_path(path)
      when is_binary(path) do
    permission = Repo.get_by(Permission, path: path)
  end
  def all(path) do
    permissions = Repo.all(Permission)
  end
end
