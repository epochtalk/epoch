defmodule Epoch.Permission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Epoch.Repo
  alias Epoch.Permission

  schema "permissions" do
    field :path, :string
  end

  def changeset(permission, attrs \\ %{}) do
    permission
    |> cast(attrs, [:path])
    |> validate_required([:path])
  end
  def by_path(path)
      when is_binary(path) do
    Repo.get_by(Permission, path: path)
  end
  def all() do
    Repo.all(Permission)
  end
end
