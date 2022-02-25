defmodule Epoch.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Epoch.Repo
  alias Epoch.Accounts.User

  schema "users" do
    field :email, :string
    field :username, :string
    field :passhash, :string
    field :confirmation_token, :string
    field :reset_token, :string
    field :reset_expiration, :string

    field :created_at, :naive_datetime
    field :imported_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :deleted, :boolean, default: false
    field :malicious_score, :integer

    field :smf_member, :map, virtual: true
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :email, :username, :created_at, :updated_at, :deleted, :malicious_score])
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  def with_username_exists?(username) do
    query = from u in User,
      where: u.username == ^username

    Repo.exists?(query)
  end
  def with_email_exists?(email) do
    query = from u in User,
      where: u.email == ^email

    Repo.exists?(query)
  end
  def insert(%User{} = user) do
    Repo.insert(user)
  end
end
