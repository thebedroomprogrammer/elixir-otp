defmodule Ex7KeyvalOnWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex7_keyval_on_web,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger], mod: {KeyVal.Contractor , []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.0.0"},
      {:jason, "~> 1.1.2"},
    ]
  end
end
