defmodule EpochWeb.Router do
  use EpochWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", EpochWeb do
    pipe_through :api
    resources "/boards", BoardController, only: [:index]
    resources "/threads", ThreadController, only: [:index]
    resources "/posts", PostController, only: [:index]
  end
end