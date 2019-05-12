defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RumblWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RumblWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]

    # resources is the same as:
    # get "/users", UserController, :index
    # get "/users/:id/edit", UserController, :edit
    # get "/users/new", UserController, :new
    # get "/users/:id", UserController, :show
    # post "/users", UserController, :create
    # patch "/users/:id", UserController, :update
    # put "/users/:id", UserController, :update
    # delete "/users/:id", UserController, :delete

    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/videos", VideoController
  end

  scope "/manage", RumblWeb do
    pipe_through [:browser, :authenticate_user]
    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end
end
