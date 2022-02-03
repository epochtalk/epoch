defmodule SMF.Category do
  @select_categories """
  SELECT ID_CAT, name, canCollapse, catOrder
  FROM smf_categories
  ORDER BY ID_CAT
  """

  def find_categories do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(@select_categories)
    |> SMF.Helper.res_to_maps()
  end

  def migrate do
    categories_attrs = find_categories() |> Enum.map(&to_category_attrs/1)
    Epoch.Repo.insert_all(Epoch.Category, categories_attrs, conflict_target: :id, on_conflict: :replace_all)
  end

  def to_category_attrs(smf_category) do
    %{
      id: smf_category["ID_CAT"],
      name: smf_category["name"],
      view_order: smf_category["catOrder"]
    }
  end
end