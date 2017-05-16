defmodule Tracy.TraceSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      worker(Tracy.Tracer, [])
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_tracer(pid, definition, upstream) do
    Supervisor.start_child(__MODULE__, [pid, definition, upstream])
  end

end
