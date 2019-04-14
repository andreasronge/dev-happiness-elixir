# LiveView

Not just a way to avoid writing Javascript

Source:
* [Github phoenix_live_view](https://github.com/phoenixframework/phoenix_live_view/blob/master/lib/phoenix_live_view.ex)
* [elixirschool.com](https://elixirschool.com/blog/phoenix-live-view/)


## What

1. GET /my-page
2. Controller (LiveView.Controller.live_render)
3. Live View mount (session, socket)
4. Live View render
5. Client receives  HTML rendered a tiny javascript library, 80K 
6. Client does a LiveView socket connect
7. A stateful connection is opened


## Endpoint

socket "/live", Phoenix.LiveView.Socket


## Controller

```elixir
def index(conn, _) do
  LiveView.Controller.live_render(conn, DemoWeb.HelloView, session: %{})
end
```


## View.mount

```elixir
defmodule DemoWeb.HelloView do
  use Phoenix.LiveView

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready")}
  end
```


## View.render

```elixir
defmodule DemoWeb.HelloView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <%= @deploy_step %>
    </div>
    """
  end
```


## app.js

```js
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live")
liveSocket.connect()
```

re-rendered anytime the socket updates, but
only the portions of the page that need updating


## EventHandlers

```html
<button phx-click="github_deploy">Deploy to GitHub</button>
```  

```elixir
def handle_event("github_deploy", _value, socket) do
  {:noreply, assign(socket, deploy_step: "Starting deploy...")}
end
```


## Template

form.html.leex:
```html
<%= form_for @changeset, "#", [phx_change: :validate, phx_submit: :save], fn f -> %>
  <%= text_input f, :username %>
  <%= error_tag f, :username %>
```

AppWeb.PageView.render("page.html", assigns)


## Routing

```elixir
scope "/", AppWeb do
  live "/thermostat", ThermostatLive
end
```

```html
<li><%= link "Thermostat", to: Routes.live_path(@conn, DemoWeb.ThermostatLive) %></li>
```


## Only render changes

If user changes:

<div id="user_<%= @user.id %>">
  <%= @user.name %>
</div>


## Why

- Massive developer simplification
- No need to write an API between client and server
- No need to write client Javascript code
- Avoid loading huge amount of javascript - initial page load.
- Can avoid duplicating code, e.g. validation
- No out of sync of client-server state
- Less Latency, avoid sending extra data, efficient serialization (soon Erlang Term Format)
- No need to authenticate and fetch database records on each request


# Roadmap

Page navigation and pagination Navigation history pushState


## Append/Prepend

To avoid keeping all data on server for growing data (logs, chat ...). for append/prepend is on the roadmap Currently have to keep all data


## latency simulator

which allows you to simulate how your application behaves on increased latency and guides you to provide meaningful feedback to users while they wait for events to be processed;


## Why not

- there is more memory usage on server side
- sometimes you have to use javascript
- offline support


## Usecases

- Autocomplete, form validations, receive live update Autocomplete, form validation, buttons that submit, receiving live updates, etc. 
