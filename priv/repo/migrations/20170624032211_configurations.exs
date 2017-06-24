defmodule Epoch.Repo.Migrations.Configurations do
  use Ecto.Migration

  def change do
    create table(:configurations, primary_key: false) do
      add :log_enabled, :boolean, null: false
      add :verify_registration, :boolean, null: false
      add :login_required, :boolean, null: false

      add :"website.title", :string, size: 255, null: false
      add :"website.description", :text, null: false
      add :"website.keywords", :text, null: false
      add :"website.logo", :string, size: 2000, null: false
      add :"website.favicon", :string, size: 2000, null: false

      add :"emailer.sender", :string, size: 255, null: false
      add :"emailer.host", :string, size: 2000, null: false
      add :"emailer.port", :integer, null: false
      add :"emailer.secure", :boolean, null: false

      add :"images.storage", :string, size: 255, null: false
      add :"images.max_size", :integer, null: false
      add :"images.expiration", :integer, null: false
      add :"images.interval", :integer, null: false
      add :"images.local.dir", :string, size: 255, null: false
      add :"images.local.path", :string, size: 255, null: false

      add :"images.s_3.root", :string, size: 2000, null: false
      add :"images.s_3.dir", :string, size: 255, null: false
      add :"images.s_3.bucket", :string, size: 255, null: false
      add :"images.s_3.region", :string, size: 255, null: false

      add :"rate_limiting.namespace", :string, default: "ept:", null: false
      add :"rate_limiting.get.interval", :integer, default: 1000, null: false
      add :"rate_limiting.get.max_in_interval", :integer, default: 10, null: false
      add :"rate_limiting.get.min_difference", :integer, default: 100, null: false
      add :"rate_limiting.post.interval", :integer, default: 1000, null: false
      add :"rate_limiting.post.max_in_interval", :integer, default: 2, null: false
      add :"rate_limiting.post.min_difference", :integer, default: 500, null: false
      add :"rate_limiting.put.interval", :integer, default: 1000, null: false
      add :"rate_limiting.put.max_in_interval", :integer, default: 2, null: false
      add :"rate_limiting.put.min_difference", :integer, default: 500, null: false
      add :"rate_limiting.delete.interval", :integer, default: 1000, null: false
      add :"rate_limiting.delete.max_in_interval", :integer, default: 2, null: false
      add :"rate_limiting.delete.min_difference", :integer, default: 500, null: false

      add :ga_key, :string
      add :"portal.enabled", :boolean, default: false, null: false
      add :"portal.board_id", :binary_id
      add :invite_only, :boolean, default: false, null: false
    end

    create unique_index(:configurations, [:log_enabled])
  end
end
