# DevLabelPlug

> Elixir plug for adding an env label inspired by [rak-dev-mark](http://github.com/dtaniwaki/rack-dev-mark).

## Usage

add `{:dev_label_plug, "~> xxx"}` to `deps` of your `mix.exs`

```elixir
defp deps do
  [{:phoenix, "~> 1.0.2"},
   {:phoenix_ecto, "~> 1.1"},
   {:postgrex, ">= 0.0.0"},
   {:phoenix_html, "~> 2.1"},
   {:phoenix_live_reload, "~> 1.0", only: :dev},
   {:cowboy, "~> 1.0"},
   {:dev_label_plug, github: "ohr486/dev_label_plug"}] # Add it!
end
```

add `:dev_label_plug` to `application` of your `mix.exs`

```elixir
def application do
  [mod: {Sample, []},
   applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                  :phoenix_ecto, :postgrex,
                  :dev_label_plug]] # Add it!
end
```

add `plug DevLabelPlug` to `pipeline :browser` of your `web/router.ex`

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_flash
  plug :protect_from_forgery
  plug :put_secure_browser_headers
  plug DevLabelPlug # Add it!
end
```

## TODO

- [ ] add test
- [ ] support internationalization
- [ ] support IE
- [ ] support custom design
- [ ] support custom env text
- [ ] publish to hex.pm
- [ ] add example

