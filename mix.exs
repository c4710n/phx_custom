defmodule PhxCustom.MixProject do
  use Mix.Project

  @version "4.0.0"
  @source_url "https://github.com/c4710n/phx_custom"

  def project do
    [
      app: :phx_custom,
      version: @version,
      description: "Opinioned code patcher for projects generated by `mix phx.new`.",
      homepage_url: @source_url,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      aliases: aliases(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      exclude_patterns: ["priv/example-projects"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url}
    ]
  end

  defp aliases do
    [publish: ["hex.publish", "tag"], tag: &tag_release/1]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as #{@version}")
    System.cmd("git", ["tag", @version])
    System.cmd("git", ["push", "--tags"])
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      source_ref: @version,
      extras: ["README.md"]
    ]
  end
end
