defmodule EpochWeb.Router do
  use EpochWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EpochWeb do
    pipe_through :api
    get "/motd", RootController, :motd
    get "/boards/:slug/id", BoardController, :id
    get "/register/username/:username", AuthController, :username
    get "/register/email/:email", AuthController, :email
    resources "/boards", BoardController, only: [:index, :show]
    resources "/threads", ThreadController, only: [:index, :show]
    resources "/posts", PostController, only: [:index, :show]
    resources "/users", UserController, only: [:show]
  end
end
