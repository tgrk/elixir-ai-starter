defmodule ElixirAiStarter.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_ai_starter,
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [
        plt_add_apps: [:mix, :ex_unit],
        plt_local_path: "priv/plts",
        ignore_warnings: ".dialyzer_ignore.exs"
      ],
      releases: [elixir_ai_starter: [steps: [:assemble, :tar]]]
    ]
  end

  def cli do
    [preferred_envs: [quality: :test, "quality.check": :test, verify: :test]]
  end

  def application do
    [extra_applications: [:logger, :runtime_tools], mod: {ElixirAiStarter.Application, []}]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_slop, "~> 0.4.0", only: [:dev, :test], runtime: false},
      {:credo_results, "~> 0.1.0", only: [:dev, :test], runtime: false},
      {:credo_unnecessary_reduce, "~> 0.4.0", only: [:dev, :test], runtime: false},
      {:forge_credo_checks, "~> 0.4", only: [:dev, :test], runtime: false},
      {:ex_dna, "~> 1.5", only: [:dev, :test], runtime: false},
      {:rename_project, "~> 0.1.0", only: :dev, runtime: false},
      {:tidewave, "~> 0.1", only: :dev},
      {:bandit, "~> 1.0", only: :dev}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      "rename.project": "cmd bash scripts/rename-project.sh",
      quality: ["format", "quality.check"],
      "quality.check": [
        "format --check-formatted",
        "ex_dna",
        "credo --strict",
        "dialyzer",
        "sobelow --exit low"
      ],
      verify: ["compile --warnings-as-errors", "test", "quality.check"],
      "release.build": ["release"],
      tidewave: "run --no-halt scripts/tidewave.exs"
    ]
  end
end
