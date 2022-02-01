defmodule Epoch.Post do
  use Ecto.Schema

  schema "posts" do
    belongs_to :thread, Epoch.Thread
    field :user_id, :integer
    field :content, :map
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :smf_message, :map
  end
end