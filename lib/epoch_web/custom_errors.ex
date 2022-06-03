defmodule EpochWeb.CustomErrors do
  defmodule InvalidCredentials do
    @moduledoc """
    Exception raised when user and password are not correct
    """
    defexception plug_status: 400, message: "Invalid username or password", conn: nil, router: nil
  end
end
