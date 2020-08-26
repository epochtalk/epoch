defmodule Epoch.Board do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "boards" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :post_count, :integer
    field :thread_count, :integer
    field :viewable_by, :integer
    field :postable_by, :integer
    field :created_at, :naive_datetime
    field :imported_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :meta, :map
    many_to_many :categories, Epoch.Category, join_through: "board_mapping"
  end

  def from_row(cols, row, acc \\ %Epoch.Board{})
  def from_row([col | ctl], [val | rtl], acc) do
    from_row(ctl, rtl, acc |> Map.put(String.to_atom(col), val))
  end
  def from_row([], [], acc), do: acc

  def from_result(res), do: res.rows |> Enum.map(&(from_row(res.columns, &1)))
end
