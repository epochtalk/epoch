defmodule EpochLegacyWeb.Router do
  use EpochLegacyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EpochLegacyWeb do
    pipe_through :api
    get "/motd", RootController, :motd
    get "/boards/:slug/id", BoardController, :id
    resources "/boards", BoardController, only: [:index, :show]
    resources "/threads", ThreadController, only: [:index, :show]
    resources "/posts", PostController, only: [:index, :show]
    resources "/users", UserController, only: [:show]
  end
end