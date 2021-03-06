defmodule HrPortalWeb.Router do
  use HrPortalWeb, :router

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

  scope "/", HrPortalWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/employees/search", EmployeeController, :search

    resources "/employees", EmployeeController
    resources "/slips", SlipController#, only: [:show, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", HrPortalWeb do
  #   pipe_through :api
  # end
end
