defmodule SMF.Message do
  alias Epoch.Repo
  alias Epoch.Post

  alias SMF.Topic
  alias SMF.Member

  def migrate(id) do
    post_attrs = id
    |> find_message()
    |> to_post_attrs()

    case post_attrs do
      nil -> {:error, "post not found"}
      _ ->
        post_attrs.thread_id |> Topic.migrate()
        post_attrs.user_id |> Member.migrate()
        %Post{}
        |> Post.changeset(post_attrs)
        |> Repo.insert(conflict_target: :id, on_conflict: :replace_all)
    end
  end

  def find_message(id) when is_binary(id) do
    String.to_integer(id) |> find_message()
  end

  def find_message(id) when is_integer(id) and id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT m.ID_MSG, m.ID_MEMBER, m.ID_TOPIC, m.subject, m.body, m.posterTime, m.modifiedTime
      FROM smf_messages m
      WHERE ID_MSG  = ?
      LIMIT 1
      """,
      [id])
    |> SMF.Helper.res_to_maps()
    |> List.first()
  end

  def find_messages(id) when is_binary(id) do
    String.to_integer(id) |> find_messages()
  end

  def find_messages(topic_id) when is_integer(topic_id) and topic_id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT m.ID_MSG, m.ID_MEMBER, m.ID_TOPIC, m.subject, m.body, m.posterTime, m.modifiedTime
      FROM smf_messages m
      WHERE ID_TOPIC  = ?
      ORDER BY ID_MSG
      LIMIT 10
      """,
      [topic_id])
    |> SMF.Helper.res_to_maps()
  end

  def to_post_attrs(message) do
    %{
      thread_id: message["ID_TOPIC"],
      user_id: message["ID_MEMBER"],
      content: %{body: message["body"]},
      created_at: message["posterTime"]
      |> DateTime.from_unix!()
      |> DateTime.to_naive(),
      updated_at: message["modifiedTime"]
      |> DateTime.from_unix!()
      |> DateTime.to_naive(),
      smf_message: message
    }
  end

end