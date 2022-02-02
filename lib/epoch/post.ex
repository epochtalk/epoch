defmodule Epoch.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    belongs_to :thread, Epoch.Thread
    field :user_id, :integer
    field :content, :map
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :smf_message, :map, virtual: true
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:id, :thread_id, :user_id, :content, :created_at, :updated_at])
    |> unique_constraint(:id, name: :posts_pkey)
    |> foreign_key_constraint(:thread_id, name: :posts_thread_id_fkey)
  end
end