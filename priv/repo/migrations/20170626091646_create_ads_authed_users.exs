defmodule Epoch.Repo.Migrations.CreateAdsAuthedUsers do
  use Ecto.Migration
  @schema_prefix "ads"

  def change do
    create table(:authed_users, [prefix: @schema_prefix, primary_key: false]) do
      add :ad_id, :binary_id, null: false
      add :user_id, :binary_id, null: false
    end

    create index(:authed_users, [:ad_id], prefix: @schema_prefix)
    create unique_index(:authed_users, [:ad_id, :user_id], prefix: @schema_prefix)
    
    execute """
    ALTER TABLE ONLY #{@schema_prefix}.authed_users
    ADD CONSTRAINT authed_users_ad_id_fkey
    FOREIGN KEY (ad_id)
    REFERENCES public.ads(id)
    ON DELETE CASCADE;
    """

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.authed_users
    ADD CONSTRAINT authed_users_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;
    """
  end
end
