defmodule Tracy.Application do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    children = [
      worker(Tracy.Starter, []),
      supervisor(Tracy.TraceSupervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
