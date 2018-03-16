defmodule Epoch.Router do
  use Epoch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Epoch do
    pipe_through :browser # Use the default browser stack
    get "/", RootController, :index
    resources "/boards", BoardController, only: [:show]
    resources "/threads", ThreadController, only: [:index]
  end

  # Other scopes may use custom stacks.
  scope "/api", Epoch do
    pipe_through :api
    get "/version", MetaController, :version
  end
end

