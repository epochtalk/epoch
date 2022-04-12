defmodule Epoch.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Epoch.Repo
  alias Epoch.User

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true, redact: true
    field :password_confirmation, :string, virtual: true, redact: true
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
    |> cast(attrs, [:id, :email, :username, :created_at, :updated_at, :deleted, :malicious_score, :password])
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_password()
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
  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_confirmation(:password, message: "does not match password") # check that password matches password_confirmation
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> hash_password()
  end
  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    if password && changeset.valid? do
      changeset
      |> put_change(:passhash, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
