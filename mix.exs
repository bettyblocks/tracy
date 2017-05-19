defmodule Tracy.Mixfile do
  use Mix.Project

  def project do
    [app: :tracy,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Tracy.Application, []}]
  end

  defp deps do
    [
      {:plug, "~> 1.3.4"}
    ]
  end
end
