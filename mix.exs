defmodule Tracy.Mixfile do
  use Mix.Project

  def project do
    [app: :tracy,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     name: "Tracy",
     description: description(),
     package: package(),
     source_url: "https://github.com/bettyblocks/tracy"]
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

  defp description do
    """
    Library for visual Elixir function call tracing.
    """
  end

  defp package do
    [
      files: ["lib", "README*", "mix.exs"],
      maintainers: ["Arjan Scherpenisse"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bettyblocks/tracy"}
    ]
  end
end
