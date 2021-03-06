defmodule Mix.Tasks.Phx.Custom.Docker do
  @shortdoc "Patch project with a Dockerfile"

  @moduledoc """
  #{@shortdoc}.

      mix phx.custom.docker <project>

  """

  use Mix.Task

  alias PhxCustom.CLI
  alias PhxCustom.HandleDocker

  @impl Mix.Task
  def run(args) do
    CLI.parse(args)
    |> process
  end

  def process({project_root, _}) do
    HandleDocker.patch(project_root)
  end
end
