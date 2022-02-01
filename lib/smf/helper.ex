defmodule SMF.Helper do
  def enable_smf_fallback? do
    Application.fetch_env!(:epoch, Epoch)[:enable_smf_fallback]
  end

  def res_to_maps(%MyXQL.Result{columns: cols, rows: rows}) do
    rows
    |> Enum.map(fn row -> SMF.Helper.to_map(cols, row) end)
  end

  def to_map(cols, row) when is_list(cols) and is_list(row) do
    Enum.zip_reduce(cols, row, %{}, fn(col, val, acc) ->
      acc |> Map.put(col, val)
    end)
  end

  def to_pg_timestamp(timestamp) do
    epoch = :calendar.datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
    ts = Kernel.+(timestamp, epoch) |> :calendar.gregorian_seconds_to_datetime
    date = ts |> elem(0)
    time = ts |> elem(1)
    %NaiveDateTime{
      year: elem(date, 0),
      month: elem(date, 1),
      day: elem(date, 2),
      hour: elem(time, 0),
      minute: elem(time, 1),
      second: elem(time, 2),
      microsecond: {0, 0}}
  end

  def cs_cols(tbl_name) do
    Enum.join(Application.fetch_env!(:epoch, Epoch.SmfRepo)[:select_cols][tbl_name], ",")
  end
end