defmodule DevLabelPlug.Mixfile do
  use Mix.Project

  def project do
    [app: :dev_label_plug,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [env: [css_path: Path.absname("./priv/css")]]
  end

  defp deps do
    [{:plug, "~> 1.0"}]
  end
end
