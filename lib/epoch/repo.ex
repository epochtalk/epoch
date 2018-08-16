defmodule Epoch.Repo do
  use Ecto.Repo, otp_app: :epoch
  
  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  @doc """
  Turns full-text search trigger off (for development or migration reasons).
  """
  def fts_trigger_off() do
    q = """
    DROP TRIGGER search_index_post ON posts
    """
    Ecto.Adapters.SQL.query!(Epoch.Repo, q)
  end

  @doc """
  Turns full-text search trigger on (for production).
  """
  def fts_trigger_on() do
    q = """
    CREATE TRIGGER search_index_post
    AFTER INSERT ON posts
    FOR EACH ROW EXECUTE PROCEDURE search_index_post()
    """
    Ecto.Adapters.SQL.query!(Epoch.Repo, q)
  end
end
