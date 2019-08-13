b = %Epoch.Board{
  name: "Tesing Board",
  description: "Testing grounds for discussion",
  created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
}

b |> Epoch.Repo.insert!

t = %Epoch.Thread{
  board: b,
  created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
}

t |> Epoch.Repo.insert!

Epoch.Repo.insert!(%Epoch.Post{
  thread: t,
  created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
  updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})
