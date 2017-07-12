defmodule Epoch.Post do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "posts" do
    belongs_to :thread, Epoch.Thread, type: :binary_id
    field :user_id, :binary_id
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end
