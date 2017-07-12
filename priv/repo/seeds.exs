b = %Epoch.Board{
  name: "Tesing Board",
  description: "Testing grounds for discussion",
  created_at: Ecto.DateTime.utc(),
  updated_at: Ecto.DateTime.utc()
}

b |> Epoch.Repo.insert!

t = %Epoch.Thread{
  board: b,
  created_at: Ecto.DateTime.utc(),
  updated_at: Ecto.DateTime.utc()
}

t |> Epoch.Repo.insert!

Epoch.Repo.insert!(%Epoch.Post{
  thread: t,
  created_at: Ecto.DateTime.utc(),
  updated_at: Ecto.DateTime.utc()
})
