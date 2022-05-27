defmodule EpochWeb.Router do
  use EpochWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end
  pipeline :maybe_auth do
    plug Guardian.Plug.Pipeline, module: Epoch.Guardian,
                               error_handler: EpochWeb.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/api", EpochWeb do
    pipe_through [:api, :maybe_auth]
    get "/motd", RootController, :motd
    get "/boards/:slug/id", BoardController, :id
    get "/register/username/:username", AuthController, :username
    get "/register/email/:email", AuthController, :email
    post "/register", AuthController, :register
    post "/login", AuthController, :login
    resources "/boards", BoardController, only: [:index, :show]
    resources "/threads", ThreadController, only: [:index, :show]
    resources "/posts", PostController, only: [:index, :show]
    resources "/users", UserController, only: [:show]
  end
end
