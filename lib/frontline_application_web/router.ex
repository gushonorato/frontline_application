defmodule FrontlineApplicationWeb.Router do
  use FrontlineApplicationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FrontlineApplicationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FrontlineApplicationWeb do
    pipe_through :browser

    live "/frontline_wildfire_application", FrontlineWildfireApplicationLive
    live "/about", AboutLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", FrontlineApplicationWeb do
  #   pipe_through :api
  # end
end
