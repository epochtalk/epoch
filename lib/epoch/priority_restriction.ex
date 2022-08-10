defmodule Epoch.PriorityRestriction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Epoch.Repo
  alias Epoch.PriorityRestriction

  schema "priority_restrictions" do
    field :role_lookup, :string
    field :restrictions, {:array, :integer}
  end

  def changeset(priority_restrictions, attrs \\ %{}) do
    priority_restrictions
    |> cast(attrs, [:role_lookup, :restrictions])
    |> validate_required([:role_lookup, :restrictions])
  end
  def by_lookup(role_lookup)
      when is_binary(role_lookup) do
    Repo.get_by(PriorityRestriction, role_lookup: role_lookup)
  end
  def all() do
    Repo.all(PriorityRestriction)
  end
end
