defmodule EtsHelper.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @elixir_version "~> 1.5"
  
  def project do
    [app: :ets_helper,
     version: @version,
     elixir: @elixir_version,
     package: package(),
     description: "ETS Wrapper to help in your Elixir projects.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     docs: [main: "EtsHelper", source_ref: "v#{@version}",
     source_url: "https://github.com/mendrugory/ets_helper"]]
  end
  
  def application(), do: [extra_applications: [:logger]]
  

  defp deps(), do: [{:earmark, ">= 0.0.0", only: :dev}, {:ex_doc, ">= 0.0.0", only: :dev}]
  
  defp package() do
    %{licenses: ["MIT"],
      maintainers: ["Gonzalo Jiménez Fuentes"],
      links: %{"GitHub" => "https://github.com/mendrugory/ets_helper"}}
  end

end
