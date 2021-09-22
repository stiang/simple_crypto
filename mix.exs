defmodule SimpleCrypto.Mixfile do
  use Mix.Project

  @source_url "https://github.com/stiang/simple_crypto"
  @version "1.0.2"

  def project do
    [
      app: :simple_crypto,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [docs: :docs],
      description: description(),
      package: package(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:crypto]
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Simple crypto helpers for Elixir.
    """
  end

  defp package() do
    [
      maintainers: ["Stian Grytøyr"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "SimpleCrypto",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/simple_crypto",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"]
    ]
  end
end
