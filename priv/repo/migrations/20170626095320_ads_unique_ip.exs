defmodule Epoch.Repo.Migrations.CreateAdsUniqueIp do
  use Ecto.Migration
  @schema_prefix "ads"

  def change do
    create table(:unique_ip, [prefix: @schema_prefix, primary_key: false]) do
      add :ad_id, :binary_id, null: false
      add :unique_ip, :string, null: false
    end

    create index(:unique_ip, [:ad_id], prefix: @schema_prefix)
    create unique_index(:unique_ip, [:ad_id, :unique_ip], prefix: @schema_prefix)

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.unique_ip
    ADD CONSTRAINT unique_ip_ad_id_fkey
    FOREIGN KEY (ad_id)
    REFERENCES public.ads(id) ON DELETE CASCADE;
    """
  end
end
