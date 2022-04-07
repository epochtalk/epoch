defmodule EpochWeb.Router do
  use EpochWeb, :router

  import EpochWeb.UserAuthController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_live_flash
    # plug :put_root_layout, {EpochWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EpochWeb do
    pipe_through :api
    get "/motd", RootController, :motd
    get "/boards/:slug/id", BoardController, :id
    # get "/register/username/:username", AuthController, :username
    # get "/register/email/:email", AuthController, :email
    # post "/register", AuthController, :register
    resources "/boards", BoardController, only: [:index, :show]
    resources "/threads", ThreadController, only: [:index, :show]
    resources "/posts", PostController, only: [:index, :show]
    resources "/users", UserController, only: [:show]
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes
  scope "/api/users", EpochWeb do
    pipe_through [:api, :redirect_if_user_is_authenticated]

    get "/register/username/:username", UserRegistrationController, :username
    get "/register/email/:email", UserRegistrationController, :email
    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create
    get "/log_in", UserSessionController, :new
    post "/log_in", UserSessionController, :create
    get "/reset_password", UserResetPasswordController, :new
    post "/reset_password", UserResetPasswordController, :create
    get "/reset_password/:token", UserResetPasswordController, :edit
    put "/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/api/users", EpochWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", UserSettingsController, :edit
    put "/settings", UserSettingsController, :update
    get "/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/api/users", EpochWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
    get "/confirm", UserConfirmationController, :new
    post "/confirm", UserConfirmationController, :create
    get "/confirm/:token", UserConfirmationController, :edit
    post "/confirm/:token", UserConfirmationController, :update
  end
end
